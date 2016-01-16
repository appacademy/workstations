#!/bin/bash
USAGE="\
This script is designed to be invoked remotely.
It opens the script in a terminal window so that
the ASR can be monitored on that computer as it runs.
It must be invoked as the root user."

fail() {
  echo "$(basename $0) failed: $1" >&2
  echo "" >&2
  echo "$USAGE" >&2
  exit 1
}

[[ $USER == 'root' ]] || fail "must be run as root"
[[ -n "$1" ]] || fail 'You must provide the server IP address as the argument.'

SERVER_ADDR=$1

cd "$(dirname $0)" # go to the script's dir

echo "--------------- $(date '+%D %T') ---------------" >> .restore.log
sudo -u appacademy open -a Terminal log_reader.sh

./restore.sh "$SERVER_ADDR" >> .restore.log 2>&1
