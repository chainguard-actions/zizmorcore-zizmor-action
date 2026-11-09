#!/bin/sh
# Mock docker: record arguments (one per line) and simulate a clean zizmor run
: > /tmp/mock-docker-args.txt
for arg in "$@"; do
  printf '%s\n' "$arg" >> /tmp/mock-docker-args.txt
done
echo "mock zizmor: running scan"
exit 0
