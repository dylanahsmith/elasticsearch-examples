#!/bin/sh

ES_HOST=${ES_HOST:-localhost:9200}
alias curl='./curl_wrapper.rb'

curl -XDELETE $ES_HOST/test

curl -XPOST $ES_HOST/test -d '{
  "settings": {
    "analysis" : {
      "tokenizer" : {
        "ngram_tokenizer" : {
          "type" : "nGram",
          "min_gram" : 1,
          "max_gram" : 2
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
    "user" : {
      "properties" : {
        "email" : {
          "type" : "string",
          "analyzer" : "ngram_analyzer"
        }
      }
    }
  }
}'
curl -XPUT $ES_HOST/test/user/1 -d '{
  "email": "email@snowdevil.ca"
}'

curl -XPOST $ES_HOST/test/_refresh

curl $ES_HOST/test/_search?pretty=true -d '{
  "query": {
    "match_phrase": {
      "email": "email@snowdevil.ca"
    }
  }
}' # hit

curl $ES_HOST/test/_search?pretty=true -d '{
  "query": {
    "match_phrase": {
      "email": "mail@snowdevil.ca"
    }
  }
}' # miss in 0.20.6, hit in 0.90.2

curl $ES_HOST/test/_search?pretty=true -d '{
  "query": {
    "match_phrase": {
      "email": "ema"
    }
  }
}' # hit
