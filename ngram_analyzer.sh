#!/bin/sh

alias curl='./curl_wrapper.rb'

curl -s -XDELETE localhost:9200/shops > /dev/null

curl -XPOST localhost:9200/shops -d '{
  "settings": {
    "analysis" : {
      "tokenizer" : {
        "ngram_tokenizer" : {
          "type" : "nGram",
          "min_gram" : 3,
          "max_gram" : 15
        }
      },
      "analyzer" : {
        "ngram_analyzer" : {
          "tokenizer" : "ngram_tokenizer",
          "filter" : ["lowercase", "asciifolding"]
        }
      }
    }
  },
  "mappings" : {
    "shop" : {
      "properties" : {
        "email" : {
          "type" : "string",
          "analyzer" : "ngram_analyzer"
        }
      }
    }
  }
}' > /dev/null

curl 'localhost:9200/shops/_analyze?field=shop.email&pretty=true' -d 'email@snowdevil.com'

curl -s -XDELETE localhost:9200/shops > /dev/null
