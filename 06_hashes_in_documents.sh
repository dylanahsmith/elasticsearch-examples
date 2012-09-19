#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/products > /dev/null

curl -XPUT localhost:9200/products/product/1 -d '{
  "title": "T-Shirt",
  "variants": [{
    "price": 9.99,
    "title": "Large"
  }, {
    "price": 9.49,
    "title": "Medium"
  }]
}'

curl -XPOST localhost:9200/products/_refresh

curl localhost:9200/products/product/_search?pretty=true -d '{
  "query": { "text": { "variants.title": "Large" } }
}'

curl localhost:9200/products/product/_search?pretty=true -d '{
  "query": { "text": { "price": 9.49 } }
}'

curl -s -XDELETE localhost:9200/products > /dev/null
