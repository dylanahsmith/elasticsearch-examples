#!/bin/sh

# This shows it is feasible to use percolation to
# test if a created or updated record matches a query.
# This can be used to insert/move the updated record in
# an existing search result list.

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/test > /dev/null
curl -s -XDELETE localhost:9200/_percolator > /dev/null

# Setup

curl -XPOST localhost:9200/test

curl -XPOST localhost:9200/_percolator
curl -XPUT localhost:9200/_percolator/test/_mapping -d '{
  "test": {
    "_timestamp": { "enabled": true },
    "_ttl": { "enabled": true }
  }
}'
curl -XGET localhost:9200/_percolator/_mapping?pretty=true


# 2 requests to check if the doc matches the query

curl -XPUT 'localhost:9200/_percolator/test/kuku?ttl=1000&refresh=true' -d '{
  "query": {
    "term": {
      "field1": "value1"
    }
  }
}'

curl -XGET localhost:9200/test/type1/_percolate -d '{
  "doc" : {
    "field1" : "value1"
  },
  "query": {
    "ids": {
      "type": "test",
      "values": ["kuku"]
    }
  }
}'


# Confirm percolator query is deleted (could explicitly delete query)

curl localhost:9200/_percolator/test/kuku

sleep 60

curl localhost:9200/_percolator/test/kuku

curl -s -XDELETE localhost:9200/test > /dev/null
curl -s -XDELETE localhost:9200/_percolator > /dev/null
