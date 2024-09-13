#!/bin/bash
docker compose -f ./docker-compose-env.yaml down
rm -rf data
mkdir data
docker compose -f ./docker-compose-env.yaml up -d