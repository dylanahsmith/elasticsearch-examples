#!/bin/sh

alias curl='./curl_wrapper.rb'

curl 'localhost:9200/_analyze?analyzer=standard&pretty=true' -d 'Tokenize then filter.'
