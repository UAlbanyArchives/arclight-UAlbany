#! /bin/bash

ID="$1"
TYPE="$2"

echo "$(date) $line Indexed $TYPE/$ID.xml"

export REPOSITORY_ID=$TYPE

URL='https://solr2020.library.albany.edu:8984/solr/arclight-1.4'
CONFIG='/usr/local/bundle/gems/arclight-1.4.0/lib/arclight/traject/ead2_config.rb'

traject -u $URL -i xml -c $CONFIG /ead/$TYPE/$ID.xml
