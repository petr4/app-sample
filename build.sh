#!/usr/bin/env bash

## Variables must be defined in pipeline
## Uncomment for testing
#
# APP_VERSION=v1000
# MY_FLASK_PORT=9999

[ -z "$APP_VERSION" ] && echo "APP_VERSION is not set" && exit 1
[ -z "$MY_FLASK_PORT" ] && echo "MY_FLASK_PORT is not set" && exit 1

docker build . -t docker.example.com/app-sample:${APP_VERSION} --build-arg MY_FLASK_PORT=${MY_FLASK_PORT}
