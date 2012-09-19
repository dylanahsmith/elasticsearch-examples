#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -XPUT localhost:9200/products/product/1 -d '{
  "title": "Cotton T-Shirt",
  "price": 9.99,
  "updated_at": "2012-09-18T10:04:54"
}'

# Retrieve Document
curl localhost:9200/products/product/1

curl -s -XDELETE localhost:9200/products > /dev/null
