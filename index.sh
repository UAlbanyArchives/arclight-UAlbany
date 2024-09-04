#! /bin/bash

CORE="$1"
TYPE="$2"

[ -s "/usr/local/rvm/scripts/rvm" ] && . "/usr/local/rvm/scripts/rvm"

rvm 2.6.5@arclight-test

echo "$(date) $line Export $TYPE"
cd /var/www/update/arclight-UAlbany

export REPOSITORY_ID='ndpa'

traject -u https://solr2020.library.albany.edu:8984/solr/arclight-new -i xml -c /home/railsdev/.rvm/gems/ruby-2.6.5@arclight-test/bundler/gems/arclight-f9b61c2cf12c/lib/arclight/traject/ead2_config.rb /media/SPE/collections/ndpa/apap347.xml

#traject -u https://solr2020.library.albany.edu:8984/solr/arclight-0.4.0 -i xml -c /home/railsdev/.rvm/gems/ruby-2.6.5@arclight-test/gems/arclight-0.4.0/lib/arclight/traject/ead2_config.rb /media/SPE/collections/ua/ua935.xml

#find /media/SPE/collections/$TYPE -type f -name '*.xml' -exec \
#traject -u https://solr2020.library.albany.edu:8984/solr/$CORE -i xml -c /home/railsdev/.rvm/gems/ruby-2.6.5@arclight-test/gems/arclight-0.4.0/lib/arclight/traject/ead2_config.rb {} ';'
