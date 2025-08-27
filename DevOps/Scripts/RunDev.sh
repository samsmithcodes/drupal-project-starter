#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f ".env" ]
then
    rm .env
fi

cp DevOps/EnvTemplates/.env.dev .env

cd $SCRIPT_DIR
source __global.sh

cd ../DockerCompose

project-docker-compose up -d --pull always

sleep 30

project-docker-compose exec app composer update
