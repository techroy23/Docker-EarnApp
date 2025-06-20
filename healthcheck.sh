#!/bin/sh

if curl -fs https://icanhazip.com > /dev/null; then
  exit 0
fi

# First failure – retry after 1 minute for up to 5 attempts
for i in 1 2 3 4 5; do
  sleep 60
  if curl -fs https://icanhazip.com > /dev/null; then
    exit 0
  fi
done

exit 1
