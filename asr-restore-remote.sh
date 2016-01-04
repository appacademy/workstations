if [[ -z "$1" ]]; then
 echo 'You must provide the server IP address as an argument.' >&2 && exit 1
fi

SERVER_ADDR=$1
PARTITION="/Volumes/AAStudent"
USAGE="\
This script is designed to be invoked remotely.
It opens the script in a terminal window so that
the ASR can be monitored on that computer as it runs.
It must be invoked as the root user."

cd "$(dirname $0)" # go to the script's dir

echo "--------------- $(date '+%D %T') ---------------" >> .asr-restore.log
sudo -u appacademy open -a Terminal asr-log-reader.sh

./asr-restore.sh $SERVER_ADDR $PARTITION >> .asr-restore.log 2>&1
