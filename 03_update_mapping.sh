#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -XPUT localhost:9200/products/product/1 -d '{
  "title": "Cotton T-Shirt",
  "price": 9.99,
  "updated_at": "2012-09-18T10:04:54"
}'

curl localhost:9200/products/product/_mapping?pretty=true

curl -XPUT localhost:9200/products/product/_mapping -d '{
    "product" : {
        "properties" : {
            "shop_id" : {"type" : "long"}
        }
    }
}'

curl localhost:9200/products/product/_mapping?pretty=true

curl -s -XDELETE localhost:9200/products > /dev/null
