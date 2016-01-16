#!/bin/bash
# Must be run with root permissions

if [[ -n "$1" ]]; then
  SERVER_ADDR=$1
else
  SERVER_ADDR='192.168.2.195'
fi

PARTITION_INFO="$(dirname $0)/../partition_info.rb"

root="$($PARTITION_INFO type root)"
restore="$($PARTITION_INFO type restore)"

diskutil rename "$restore" "AAStudentRestoring"
diskutil rename "$root" "AAStudentBackup"

asr restore --source "asr://$SERVER_ADDR" \
            --target "$restore" --erase --noprompt \
  && diskutil rename "$restore" "AAStudent" \
  && bless --mount "/Volumes/AAStudent" --setBoot \
  && echo 'Restore completed. Rebooting to restored partition...' \
  && shutdown -r now
