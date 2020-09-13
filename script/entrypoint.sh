#!/usr/bin/env sh

: "${AIRFLOW_HOME:="/airflow"}"

envsubst < ${AIRFLOW_HOME}/airflow.cfg.tpl > ${AIRFLOW_HOME}/airflow.cfg

case "$1" in
  webserver)
    airflow initdb
    exec airflow webserver
    ;;
  worker|scheduler)
    # Give the webserver time to run initdb.
    sleep 10
    exec airflow "$@"
    ;;
  flower)
    sleep 10
    exec airflow "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    exec "$@"
    ;;
esac
