#!/usr/bin/env bash -x

## For testing
 APP_VERSION="v1000"
 APP_ENVIRONMENT="default"

[ -z "$APP_ENVIRONMENT" ] && echo "APP_ENVIRONMENT is not set" && exit 1
[ -z "$APP_VERSION" ] && echo "APP_VERSION is not set" && exit 1
helm version || exit 1

if [[ "$DEBUG" == "true" ]]; then
  DEBUG_MODE=" --dry-run --debug "
fi

helm delete ${DEBUG_MODE} app-sample-${APP_VERSION} --namespace ${APP_ENVIRONMENT}
