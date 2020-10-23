#!/usr/bin/env bash -x

## For testing
# APP_VERSION="v1000"
# APP_ENVIRONMENT="default"
# MY_FLASK_PORT=9999

[ -z "$APP_ENVIRONMENT" ] && echo "APP_ENVIRONMENT is not set" && exit 1
[ -z "$APP_VERSION" ] && echo "APP_VERSION is not set" && exit 1
[ -z "$MY_FLASK_PORT" ] && echo "MY_FLASK_PORT is not set" && exit 1
helm version || exit 1

if [[ "$DEBUG" == "true" ]]; then
  DEBUG_MODE=" --dry-run --debug "
fi

helm upgrade ${DEBUG_MODE} --install app-sample-${APP_VERSION} ./helm/app-sample \
      --set-string namespace=${APP_ENVIRONMENT} \
      --namespace ${APP_ENVIRONMENT} \
      --set-string image.tag=${APP_VERSION} \
      --set-string service.internalPort=${MY_FLASK_PORT} \
      --set replicaCount=3 \
      --force --wait
