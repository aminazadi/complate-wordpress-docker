#!/bin/bash

case "$1" in
  d)
    docker-compose down
    ;;
  u)
    NO_CACHE=$(date +%s) docker-compose up --build
    ;;
  a)
    docker-compose down
    NO_CACHE=$(date +%s) docker-compose up --build
    ;;
  *)
    echo "Usage: $0 {d|u|a}"
    exit 1
    ;;
esac

exit 0

