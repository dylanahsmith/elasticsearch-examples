#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/products > /dev/null

curl -XPOST localhost:9200/products -d '{
  "mappings": {
    "product": {
      "_routing": { "required": true, "path": "shop_id" },
      "properties": { "shop_id": { "type": "long" } }
    }
  }
}'

curl -XPUT localhost:9200/products/product/1 -d '{ "shop_id": 42 }'

curl -POST localhost:9200/products/_refresh

curl -XGET localhost:9200/products/product/1?routing=42

curl -XDELETE localhost:9200/products/product/1?routing=42

curl -s -XDELETE localhost:9200/products > /dev/null
