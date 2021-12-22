#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/test_product_variants > /dev/null

curl -XPOST localhost:9200/test_product_variants -d '{
  "mappings" : {
    "product_variant" : {
      "properties" : {
        "product.product_type" : {
          "type" : "string",
          "index" : "not_analyzed"
        }
      }
    }
  }
}'


curl -XPUT localhost:9200/product_variants/product_variant/1 -d '{
  "product": {
    "product_type": "foo bar"
  }
}'

curl localhost:9200/product_variants/product_variant/_mapping?pretty=true

curl localhost:9200/product_variants/product_variant/_search?pretty=true -d '{
  "facets" : {
    "my_terms" : {
      "terms" : {
        "size" : 50,
        "field": "product.product_type"
      }
    }
  }
}'

curl -s -XDELETE localhost:9200/product_variants > /dev/null
