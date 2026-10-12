#!/usr/bin/env python3
"""Linux integration check: delayed dependencies, child crash, shutdown."""
import os
from pathlib import Path
import signal
import socket
import subprocess
import tempfile
import time

SERVICES = 'idgen status authsession dfs media biz msg sync bff session httpserver gnetway'.split()
RUNALL = Path(__file__).resolve().parents[1] / 'bin' / 'runall.sh'
MOCK = '''#!/usr/bin/env python3
import socket, sys, signal, os
from pathlib import Path
if Path(sys.argv[0]).name=='bff':
 # Exercise a cross-service discovery dependency. A sequential readiness
 # barrier before starting session would deadlock here.
 session=Path(os.environ['PWM_CONFIG_DIR'])/'session.yaml'
 try:
  c=socket.create_connection(('127.0.0.1',int(session.read_text().split(':')[-1])),timeout=.2);c.close()
 except OSError:
  sys.exit(1)
port=int(Path(sys.argv[1][3:]).read_text().split(':')[-1])
s=socket.socket(); s.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
s.bind(('127.0.0.1',port)); s.listen()
signal.signal(signal.SIGTERM, lambda *_:sys.exit(0))
while True:
 c,_=s.accept(); c.close()
'''

def free_port():
    with socket.socket() as sock:
        sock.bind(('127.0.0.1', 0))
        return sock.getsockname()[1]

def until(predicate, timeout=25):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if predicate():
            return
        time.sleep(0.1)
    raise AssertionError('Supervisor did not reach expected state')

with tempfile.TemporaryDirectory(prefix='pwm-supervisor-test-') as temp:
    root = Path(temp)
    for name in ['bin', 'etc', 'run', 'logs']:
        (root / name).mkdir()
    for service in SERVICES:
        binary = root / 'bin' / service
        binary.write_text(MOCK)
        binary.chmod(0o700)
        configuration = ('Http:\r\n  Port: ' if service == 'httpserver' else 'ListenOn: 127.0.0.1:')
        (root / 'etc' / (service + '.yaml')).write_text(configuration + str(free_port()) + '\r\n')
    dependency = socket.socket()
    dependency.bind(('127.0.0.1', 0))
    dependency_port = dependency.getsockname()[1]
    env = dict(os.environ, PWM_BIN_DIR=str(root / 'bin'), PWM_CONFIG_DIR=str(root / 'etc'),
        PWM_RUN_DIR=str(root / 'run'), PWM_LOG_DIR=str(root / 'logs'),
        PWM_DEPENDENCY_ENDPOINTS='kafka=127.0.0.1:' + str(dependency_port), PWM_STARTUP_TIMEOUT='20')
    with (root / 'supervisor.log').open('w') as log:
        parent = subprocess.Popen(['bash', str(RUNALL)], env=env, stdout=log, stderr=log)
        children = []
        try:
            time.sleep(0.5)
            assert not list((root / 'run').glob('*.pid')), 'Services started before dependency readiness'
            dependency.listen()
            def healthy():
                return subprocess.run(['bash', str(RUNALL), '--health'], env=env,
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
            until(healthy)
            assert len(list((root / 'run').glob('*.pid'))) == 12
            pid_file = root / 'run' / 'session.pid'
            old_pid = int(pid_file.read_text())
            os.kill(old_pid, signal.SIGKILL)
            until(lambda: pid_file.exists() and int(pid_file.read_text()) != old_pid and healthy())
            children = [int(p.read_text()) for p in (root / 'run').glob('*.pid')]
            parent.terminate()
            assert parent.wait(timeout=10) == 0
            assert not list((root / 'run').glob('*.pid')), 'PID files retained after shutdown'
            for pid in children:
                try:
                    os.kill(pid, 0)
                except ProcessLookupError:
                    continue
                raise AssertionError('Orphan service process after shutdown')
            print('PASS: delayed dependency, cross-service startup, all 12 processes, crashed child restart, graceful shutdown')
        finally:
            if parent.poll() is None:
                parent.terminate()
                parent.wait(timeout=10)
            dependency.close()
