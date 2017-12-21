#!/bin/sh

# start the Instana agent first
./bin/run.sh &

CONFIG=/opt/config/configuration.yaml
INSTANA=/opt/instana/agent/etc/instana/configuration.yaml

CHECK=$(md5 $CONFIG)

while true
do
    TEST=$(md5 $CONFIG)
    if [ "$TEST" != "$CHECK" ]
    then
        echo "!!!!"
        echo "configuration changed"
        echo "!!!!"
        CHECK="$TEST"
        cp $CONFIG $INSTANA
    fi
    sleep 1
done

