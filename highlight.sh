#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -XDELETE localhost:9200/test

curl -XPOST localhost:9200/test -d '{
  "mappings": {
    "user": {
      "properties": {
        "exact_name": {
          "type": "string",
          "index": "not_analyzed"
        },
        "active": {
          "type": "boolean"
        },
        "created_at": {
          "type": "date",
          "format": "dateOptionalTime"
        }
      }
    }
  }
}'

curl -XPUT localhost:9200/test/user/1 -d '{
  "id": 1,
  "name": "1 2 3",
  "exact_name": "1 2 3",
  "active": false,
  "created_at": "2012-01-01"
}'

curl -XPOST localhost:9200/test/_refresh

curl localhost:9200/test/user/_search?pretty=true -d '{
  "query": {
    "match": {
      "created_at": "2012-01-01"
    }
  },
  "highlight": {
    "require_field_match": true,
    "fields": {
      "created_at": {
        "require_field_match": true,
        "number_of_fragments": 10
      }
    }
  }
}'
