#!/bin/bash
# Must be run with root permissions

if [[ -z "$1" ]]; then
 echo 'You must provide the server IP address as the first argument.' >&2 && exit 1
fi

if [[ -z "$2" ]]; then
 echo 'You must provide the partition path as the second argument.' >&2 && exit 1
fi

SERVER_ADDR=$1
PARTITION=$2

asr restore --source "asr://$SERVER_ADDR" --target "$PARTITION" \
            --erase --noprompt --noverify \
  && bless -mount "$PARTITION" \
  && echo 'Restore completed. Rebooting to restored partition.' \
  && shutdown -r now
