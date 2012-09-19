#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/products > /dev/null

curl -XPOST localhost:9200/products -d '{
  "mappings" : {
    "product" : {
      "properties" : {
        "tags" : {
          "type" : "string",
          "index" : "not_analyzed"
        }
      }
    }
  }
}'

curl -s -XDELETE localhost:9200/products > /dev/null
