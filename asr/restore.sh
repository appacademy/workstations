#!/bin/bash

fail() {
  echo "$(basename $0) failed: $1" >&2
  exit 1
}

[[ $USER == 'root' ]] || fail "must be run as root"
[[ -n "$1" ]] || fail 'You must provide the server IP address as the argument.'

cd "$(dirname $0)"

root="$(./get_volume.rb root)"
restore="$(./get_volume.rb restore)"

diskutil rename "$restore" "AAStudentRestoring"
diskutil rename "$root" "AAStudentBackup"

asr restore --source "asr://$SERVER_ADDR" \
            --target "$restore" --erase --noprompt \
  && diskutil rename "$restore" "AAStudent" \
  && bless --mount "/Volumes/AAStudent" --setBoot \
  && echo 'Restore completed. Rebooting to restored partition...' \
  && shutdown -r now
