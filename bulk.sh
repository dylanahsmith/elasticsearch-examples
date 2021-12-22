#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/products > /dev/null

curl -XGET localhost:9200/products/product/1

sleep 1

curl -XPOST localhost:9200/_bulk?pretty=true -d \
'{ "index": { "_index": "products", "_type": "product", "_id": 1 } }
{ "title": "Cotton T-Shirt", "price": 9.99, "updated_at": "2012-09-18T10:04:54" }
{ "update": { "_index": "products", "_type": "product", "_id": 1 } }
{ "doc": { "title": "Fleece Shirt", "updated_at": "2013-09-18T10:04:54" } }
{ "update": { "_index": "products", "_type": "product", "_id": 2 } }
{ "doc": { "title": "Cotton Sweater", "price": 10.00, "updated_at": "2013-09-18T11:04:54" } }
{ "update": { "_index": "products", "_type": "product", "_id": 3 } }
{ "doc": { "title": "Wool Sweater", "price": 15.00, "updated_at": "2013-09-18T12:04:54" }, "doc_as_upsert": true }
'

curl -XPOST localhost:9200/_bulk?pretty=true -d \
'{ "index": { "_index": "products", "_type": "product", "_id": 3, "_routing": 2 } }
{ "doc": { "price": 20.00 } }
'

sleep 1

curl -XGET localhost:9200/products/product/1
curl -XGET localhost:9200/products/product/2
curl -XGET localhost:9200/products/product/3?routing=1
curl -XGET localhost:9200/products/product/3?routing=7

curl -s -XDELETE localhost:9200/products > /dev/null
