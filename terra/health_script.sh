#!/bin/bash
sleep 10
WORKSPACE=$1
PORT=$2
MAX_RETRIES=5
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    result=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${PORT})
    
    if [ "$result" -eq 200 ]; then
        echo "SUCCESS: Instance on port $PORT is UP!"
        echo "Health check passed! :)"
        exit 0
    fi
    
    echo "Attempt $((COUNT+1)): Port $PORT not ready yet Retrying..."
    sleep 3
    COUNT=$((COUNT+1))
done
echo "FAIL: Instance on port $PORT is DOWN!"
echo "Health check failed! :("
exit 1
