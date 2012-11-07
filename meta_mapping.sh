#!/bin/sh

# This test shows that the Update Mapping API replaces the meta field
# in the mapping rather than only adding/updating the provided fields.

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/test > /dev/null

curl -XPOST localhost:9200/test -d '{
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


curl -XPUT localhost:9200/test/product/_mapping -d '{
    "product" : {
        "_meta" : {
            "obj": {
              "field1" : 1
            }
        }
    }
}'

curl localhost:9200/test/product/_mapping?pretty=true

curl -XPUT localhost:9200/test/product/_mapping -d '{
    "product" : {
        "_meta" : {
            "field2" : 2
        }
    }
}'

curl localhost:9200/test/product/_mapping?pretty=true


curl -s -XDELETE localhost:9200/test > /dev/null
