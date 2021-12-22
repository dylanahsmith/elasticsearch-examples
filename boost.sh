#!/bin/sh

host=shopify.railgun:9200

curl() {
    echo "$@"
    command curl -s -S "$@"
}

curl -XDELETE $host/test_idx > /dev/null

curl -XPOST $host/test_idx -d '{
  "mappings" : {
    "test" : {
      "properties" : {
        "title": {
          "type": "string",
          "boost": 2.0
        },
        "description": {
          "type": "string"
        }
      }
    }
  }
}'

# Store documents
curl -XPUT $host/test_idx/test/1 -d '{
    "title": "Apple",
    "description": "MH30"
}'
curl -XPUT $host/test_idx/test/2 -d '{
    "title": "MH30",
    "description": "Apple"
}'

# Explicit refresh (done automatically every second)
curl -XPOST $host/test_idx/_refresh

# Search for document
curl $host/test_idx/test/_search?pretty=true -d '{
   "query": {
      "query_string": {
        "query": "MH30"
      }
   }
}'

# Cleanup
curl -s -XDELETE $host/products > /dev/null
