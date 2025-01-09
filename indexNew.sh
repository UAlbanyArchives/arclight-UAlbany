#! /bin/bash

echo "$(date) $line Indexing new EADs"

URL='https://solr2020.library.albany.edu:8984/solr/arclight-1.4'
#CONFIG='/usr/local/bundle/gems/arclight-1.4.0/lib/arclight/traject/ead2_config.rb'
CONFIG='lib/arclight/traject/ead2_config.rb'

for dir in /ead/*; do
    if [ -d "$dir" ]; then
        TYPE=$(basename "$dir") # Get the folder name as TYPE
        find "$dir" -type f -mtime -1 -name '*.xml' -exec sh -c '
            for file; do
                echo "Processing file: $file" # Print the file being processed
                env REPOSITORY_ID='"$TYPE"' bundle exec traject -u '"$URL"' -i xml -c '"$CONFIG"' "$file"
            done
        ' sh {} +
    fi
done
