#!/bin/bash

export COMPOSE_PROJECT_NAME=drupal

project-docker-compose () {
    docker compose --file dev.yml --env-file ../../.env $@
}
