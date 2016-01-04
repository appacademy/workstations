#!/bin/bash

PARTITION="/Volumes/AAStudent"
SERVER_ADDR=$1

if [[ -z "$1" ]]; then
 echo 'You must provide the server IP address as an argument.' >&2 && exit 1
fi

sudo asr restore --source asr://$SERVER_ADDR --target $PARTITION \
                 --erase --noprompt --noverify \
  && sudo bless -mount $PARTITION \
  && echo 'Restore completed. Rebooting to restored partition.' \
  && sudo shutdown -r now
