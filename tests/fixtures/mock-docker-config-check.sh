#!/bin/sh
# Mock docker: simulate zizmor running and verify --config flag is present
for arg in "$@"; do
  case "$arg" in
    --config=*)
      echo "mock zizmor: found config flag: $arg"
      exit 0
      ;;
  esac
done
echo "mock zizmor: ERROR: --config flag not found in args: $*"
exit 1
