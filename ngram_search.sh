#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE http://localhost:9200/shops > /dev/null

curl -XPOST http://localhost:9200/shops -d '{
  "settings": {
    "analysis" : {
      "filter" : {
        "ngram" : {
          "type" : "nGram",
          "min_gram" : 2,
          "max_gram" : 4
        }
      },
      "analyzer" : {
        "ngram_analyzer" : {
          "type" : "custom",
          "tokenizer" : "standard",
          "filter" : ["lowercase", "asciifolding", "ngram"]
        }
      }
    }
  },
  "mappings" : {
    "shop" : {
      "properties" : {
        "name" : {
          "type" : "string",
          "analyzer" : "ngram_analyzer"
        }
      }
    }
  }
}'

curl -XPUT 'http://localhost:9200/shops/shop/1?&pretty=true' -d '{ "name": "snowdevil" }'

curl -XPOST 'http://localhost:9200/shops/_refresh'

curl 'http://localhost:9200/shops/shop/_search?pretty=true' -d '{
  "query": {
    "text": {
      "name": "d"
    }
  }
}' # miss

curl 'http://localhost:9200/shops/shop/_search?pretty=true' -d '{
  "query": {
    "text": {
      "name": "devil"
    }
  }
}' # hit

curl -s -XDELETE 'http://localhost:9200/shops' > /dev/null
