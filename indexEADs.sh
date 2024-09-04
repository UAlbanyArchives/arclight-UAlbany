#! /bin/bash

TYPE="$1"

export REPOSITORY_ID=$TYPE

echo "$(date) $line Indexing $TYPE..."

URL='https://solr2020.library.albany.edu:8984/solr/arclight-1.4'
CONFIG='/usr/local/bundle/gems/arclight-1.4.0/lib/arclight/traject/ead2_config.rb'

find /ead/$TYPE -type f -name '*.xml' -exec \
bundle exec traject -u $URL -i xml -c $CONFIG {} ';'
