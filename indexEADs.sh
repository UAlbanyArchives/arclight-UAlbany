#! /bin/bash

TYPE="$1"

[ -s "/home/railsdev/.rvm/scripts/rvm" ] && . "/home/railsdev/.rvm/scripts/rvm"

export REPOSITORY_ID=$TYPE

rvm 2.6.5@arclight-test

echo "$(date) $line Export $TYPE" #>> /media/SPE/indexing-logs/index.log
cd /var/www/update/arclight-UAlbany

find /opt/lib/collections/$TYPE -type f -name '*.xml' -exec \
bundle exec traject -u https://solr2020.library.albany.edu:8984/solr/arclight2 -i xml -c /home/railsdev/.rvm/gems/ruby-2.6.5@arclight-test/bundler/gems/arclight-f9b61c2cf12c/lib/arclight/traject/ead2_config.rb {} ';'


