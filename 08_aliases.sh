#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -XPUT localhost:9200/test.1/doc/1 -d '{}'
curl -XPOST localhost:9200/_aliases -d '
{
    "actions" : [
        { "add" : { "index" : "test.1", "alias" : "test.search" } }
    ]
}'

curl -XPUT localhost:9200/test.2/doc/2 -d '{}'
curl -XPOST localhost:9200/_aliases -d '
{
    "actions" : [
        { "remove" : { "index" : "test.2", "alias" : "test.search" } },
        { "add" : { "index" : "test.1", "alias" : "test.search" } }
    ]
}'

curl localhost:9200/test.search/_search?pretty=true
curl -s -XDELETE localhost:9200/test.1,test.2 > /dev/null
