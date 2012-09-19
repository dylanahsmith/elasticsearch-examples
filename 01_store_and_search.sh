#!/bin/sh

alias curl='./curl_wrapper.rb'

# Store document
curl -XPUT localhost:9200/products/product/1 -d '{
  "title": "Cotton T-Shirt",
  "price": 9.99,
  "updated_at": "2012-09-18T10:04:54"
}'

# Explicit refresh (done automatically every second)
curl -XPOST localhost:9200/products/_refresh

# Search for document
curl localhost:9200/products/product/_search?pretty=true -d '{
  "query": {
    "text": {
      "_all": "shirt"
    }
  }
}'

# Cleanup
curl -s -XDELETE localhost:9200/products > /dev/null
