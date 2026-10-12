# Runtime startup and health

`entrypoint.sh` renders private runtime configuration into `/app/etc2`, then
executes the Bash supervisor `../bin/runall.sh` as PID 1. Keep credentials in
the server environment; generated configuration and logs are not source files.

The supervisor waits for etcd, Redis, MySQL, Kafka and MinIO TCP readiness. It
starts the shared RPC foundations first, then launches the mutually dependent
messenger/interface group before checking their listeners. Each of these 12
services has its own restart loop with a bounded backoff:

`idgen status authsession dfs media biz msg sync bff session httpserver gnetway`

`runall.sh --health` requires all 12 child processes and their TCP listeners.
The `sync` service is a Kafka consumer with no active gRPC listener, so its
health check requires the process only. Docker Compose invokes this check
after the startup grace period. SIGTERM shuts down and reaps the children.

For an isolated Linux regression check, run:

```sh
python3 pwm/docker/test_supervisor.py
```

This checks delayed dependency readiness, cross-service startup, CRLF configs,
all 12 processes, child crash/restart and clean shutdown using temporary mocks.

The deployed BFF combines the Telegram and PWM services and uses `bff.yaml`.
Build it with `make bff`, or equivalently:

```sh
go build -tags=jsoniter -o pwm/bin/bff ./app/bff/bff/cmd/bff
```

The standalone `app/bff/pwm/cmd/pwm` entry point expects a different
configuration and must not replace this combined BFF binary.

Accepted game answers persist their events/outbox transactionally. An immediate
metadata-only WebSocket hint wakes both connected players independently of
FCM delivery retries; each client replays its own durable event cursor. Typed
FCM registration-token failures disable the affected device, while transient
provider errors retain the existing retry behavior. Provider response bodies
are omitted from error messages to avoid logging device credentials.
