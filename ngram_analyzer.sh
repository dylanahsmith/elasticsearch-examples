#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/shops > /dev/null

curl -XPOST localhost:9200/shops -d '{
  "settings": {
    "analysis" : {
      "filter" : {
        "ngram" : {
          "type" : "nGram",
          "min_gram" : 2,
          "max_gram" : 255
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

curl 'localhost:9200/shops/_analyze?field=shop.name&pretty=true' -d 'tokenize'

curl -s -XDELETE localhost:9200/shops > /dev/null
