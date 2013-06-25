#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/test > /dev/null

curl -XPOST localhost:9200/test -d '{
  "mappings": {
    "order": {
      "properties": {
        "reference": {
          "type": "multi_field",
          "fields": {
            "reference": { "type": "string", "index": "analyzed" },
            "unanalyzed": { "type": "string", "index": "not_analyzed" }
          }
        }
      }
    }
  }
}'


curl -XPUT localhost:9200/test/order/1 -d '{
  "reference": "123-456"
}'

curl -XPOST localhost:9200/test/_refresh

curl localhost:9200/test/order/_search?pretty=true -d '{
  "query": {
    "text": {
      "reference": "456-123"
    }
  }
}' # hit

curl localhost:9200/test/order/_search?pretty=true -d '{
  "query": {
    "text": {
      "reference.unanalyzed": "456-123"
    }
  }
}' # miss

curl localhost:9200/test/order/_search?pretty=true -d '{
  "query": {
    "text": {
      "reference.unanalyzed": "123-456"
    }
  }
}' # hit

curl -s -XDELETE localhost:9200/test > /dev/null
