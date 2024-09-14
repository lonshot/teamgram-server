#!/usr/bin/env bash

echo "run idgen ..."
nohup ./idgen -f=../etc2/idgen.yaml
sleep 1

echo "run status ..."
nohup ./status -f=../etc2/status.yaml
sleep 1

echo "run authsession ..."
nohup ./authsession -f=../etc2/authsession.yaml
sleep 1

echo "run dfs ..."
nohup ./dfs -f=../etc2/dfs.yaml
sleep 1

echo "run media ..."
nohup ./media -f=../etc2/media.yaml
sleep 1

echo "run biz ..."
nohup ./biz -f=../etc2/biz.yaml
sleep 1

echo "run msg ..."
nohup ./msg -f=../etc2/msg.yaml
sleep 1

echo "run sync ..."
nohup ./sync -f=../etc2/sync.yaml
sleep 1

echo "run bff ..."
nohup ./bff -f=../etc2/bff.yaml
sleep 5

echo "run session ..."
nohup ./session -f=../etc2/session.yaml
sleep 1

#echo "run gateway ..."
#nohup ./gateway -f=../etc2/gateway.yaml >> ../logs/gateway.log  2>&1 &
#sleep 1

echo "run gnetway ..."
nohup ./gnetway -f=../etc/gnetway.yaml
sleep 1

#echo "run httpserver ..."
#nohup ./httpserver -f=../etc/httpserver.yaml >> ../logs/httpserver.log  2>&1 &
#sleep 1
