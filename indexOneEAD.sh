#! /bin/bash

TYPE="$1"


AREA=${TYPE//[0-9.]/}
echo $AREA/$TYPE.xml

bundle exec rake arclight:index FILE=../collections/$AREA/$TYPE.xml REPOSITORY_ID=$AREA SOLR_URL=https://solr.library.albany.edu:8984/solr/arclight-testing
