#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -XDELETE localhost:9200/products
curl -XPUT localhost:9200/products

curl -XPUT -H 'Content-Type: application/json' localhost:9200/products/product/1 -d '{
  "title": "Cotton T-Shirt",
  "price": 9.99,
  "updated_at": "2012-09-18T10:04:54"
}'

# Retrieve Document
curl -H 'Content-Type: application/json' localhost:9200/_mget?realtime=false -d '{
    "docs" : [
        {
            "_index" : "products",
            "_type" : "product",
            "_id" : "1"
        }
    ]
}'

#curl localhost:9200/products/product/1?realtime=false

curl -s -XDELETE localhost:9200/products > /dev/null
