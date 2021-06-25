#!/bin/bash

index_name='default_index'

# ES docker image doesn't support latest tag
latest_version='7.13.2'

# install jq if not already installed
if ! command -v jq &> /dev/null; then
    brew install jq
fi

# pull docker image if not already pulled
docker image inspect elasticsearch:$latest_version > /dev/null 2>&1 || docker pull elasticsearch:$latest_version

# run elasticsearch if not already running
container=$(docker ps -aqf "ancestor=elasticsearch:$latest_version")
if [ -z $container ]; then
    echo -e "starting up elasticsearch...\n"
    container=$(docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:$latest_version)
    echo -e "waiting for elasticsearch to be up...\n"
    while ! curl --silent --show-error --fail localhost:9200 > /dev/null 2>&1; 
        do sleep 0.5; 
    done
fi

if [[ $# -ge 1 ]]; then
    index_name=$1
fi

# create index if not already exists
code=$(curl -s -o /dev/null -w "%{http_code}\n" "localhost:9200/$index_name?pretty")
if [ $code -eq 404 ]; then 
    echo -e "creating index $index_name...\n"
    curl --silent --show-error --fail -X PUT "localhost:9200/$index_name?pretty" > /dev/null 2>&1
elif [ $code -ne 200 ]; then 
    echo "problem connecting to elasticsearch: status code $code"
    exit 1
fi

curl --silent --show-error --fail -X PUT "localhost:9200/$index_name/_settings?pretty" -H 'Content-Type: application/json' -d' 
    { "index.indexing.slowlog.threshold.index.warn": "0s",
      "index.indexing.slowlog.threshold.index.info": "0s", 
      "index.indexing.slowlog.threshold.index.debug": "0s", 
      "index.indexing.slowlog.threshold.index.trace": "0s", 
      "index.indexing.slowlog.level": "info", 
      "index.indexing.slowlog.source": "1000" } ' > /dev/null 2>&1

echo "checking index contents..."
docker logs $container --follow | jq -c "select( .type == \"index_indexing_slowlog\" ) | select( .message | test(\"\\\\[$index_name/\") ) | .source?"
