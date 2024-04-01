#!/bin/bash

rc=1
cpu=""

sleep 2

echo "Starting polling for CPU at" `date`
for i in `seq 1 120`
do
    cpu=$(cat $CPUFILE 2>/dev/null)
    echo "Current CPU value $cpu"
    if [ "$cpu" == "$EXPECTEDCPU" ]; then
        echo "CPU is set to expected value of $EXPECTEDCPU at" `date`
        rc=0
        break
    fi
    if [ $( expr $i % 6 ) == "0" ]; then
	echo "Still waiting after" $( expr $i \* 5 ) "seconds . . ."
    fi
    sleep 5
done

if [ "$rc" == "1" ]; then
    echo "CPU never switched to expected value; giving up at" `date`
    echo "Current CPU $cpu expected CPU $EXPECTEDCPU"
    exit 1
fi

sleep 10

echo "Attempting to set CPUChangeCondition - this will cause the pod Ready condition to change also"
export APISERVER=https://kubernetes.default.svc
export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
export NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
export TOKEN=$(cat ${SERVICEACCOUNT}/token)
export CACERT=${SERVICEACCOUNT}/ca.crt
curl -v -k -X PATCH -H 'content-type: application/strategic-merge-patch+json' --data '{ "status": { "conditions": [ { "type": "CPUChangeCondition", "status": "True" } ] } }' --header "Authorization: Bearer ${TOKEN}" ${APISERVER}/api/v1/namespaces/ace-demo/pods/ace-burst-test/status
