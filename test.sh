#!/usr/bin/env bash

[ -z "$APP_ENVIRONMENT" ] && echo "APP_ENVIRONMENT is not set" && exit 1
[ -z "$APP_VERSION" ] && echo "APP_VERSION is not set" && exit 1

echo "test..."
