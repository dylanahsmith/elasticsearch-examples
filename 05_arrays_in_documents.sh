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

curl -XPUT localhost:9200/products/product/1 -d '{
  "tags": ["Summer Clothing", "T-Shirt"]
}'

curl -XPOST localhost:9200/products/_refresh

curl localhost:9200/products/product/_search -d '{
  "query": { "term": { "tags": "Summer Clothing" } }
}'

curl localhost:9200/products/product/_search -d '{
  "query": { "term": { "tags": "T-Shirt" } }
}'

curl -s -XDELETE localhost:9200/products > /dev/null
