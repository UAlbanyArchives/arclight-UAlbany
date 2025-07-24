# arclight-UAlbany
UAlbany's Arclight instance

An instance of [https://github.com/projectblacklight/arclight](https://github.com/projectblacklight/arclight)

### For development

To develop locally, you also need the `grenander` engine, which has headers, footers, and site-wide styling for archives.albany.edu. To set this up, clone [git@github.com:UAlbanyArchives/grenander.git](https://github.com/UAlbanyArchives/grenander) alongside [git@github.com:UAlbanyArchives/arclight-UAlbany.git](https://github.com/UAlbanyArchives/arclight-UAlbany) and then edit the last two lines of the [Gemfile for arclight-UAlbany](https://github.com/UAlbanyArchives/arclight-UAlbany/blob/update_1.4/Gemfile#L79-L80) to use the local path for `grenander`.

```
gem 'grenander', path: '../grenander'
#gem 'grenander', git: 'https://github.com/UAlbanyArchives/grenander', branch: 'bootstrap_5'
```

Then run the app from the `arclight-UAlbany` directory:
```
docker compose up
```

Navigate to [http://localhost:3000/description](http://localhost:3000/description)

You should be able to edit code in real time, including both `arclight-UAlbany` and `grenander`.

### For production deployment

Building the `arclight` image for production:
```
make build
```

Restarting the service:
```
make restart
```

#### For Windows

These commands don't work on Windows. For that you have to use the full build command:
```
$env:DOCKER_BUILDKIT=1; docker build --secret id=master_key,src=config/master.key -t arclight .
```

Running the image:
```
docker-compose up -f docker-compose-prod.yml up -d
```
Navigate to [http://localhost:8080/description](http://localhost:8080/description)


To stop:
```
docker-compose down
```

### For a terminal

If you need another terminal:
```
docker exec -it arclight bash
```

## Solr Core

The Solr core is set in `config/blacklight.yml`

## Indexing EAD

_Solr core URLs are set within these scripts, not config/blacklight.yml_

### Running from inside the container

Index a single file:
```
./index.sh [collection_id] [collecting_area_code]
./index.sh apap199 ndpa
```

Index all files updated in the last day:
```
./indexNew.sh
```

Index all files in a collecting area:
```
./indexArea.sh ger
```

Index all files:
```
./indexAll.sh
```

### Running from outside the container

You can run any of the above commands after:
```
docker compose -f docker-compose-index.yml run arclight /bin/sh
```

This assumes you EADs are available in ``../collections`

For example:
```
docker compose -f docker-compose-index.yml run arclight /bin/sh /app/index.sh apap147 apap
```

There is also a compose file for indexing all newly updated files from the dev server:
```
docker compose -f docker-compose-update.yml run arclight
```

## Maintenance

### Logs

Log config for the app is set in `config/environment/production.rb`. This is set to:
* `warn` log level
* log to `stdout`

Docker manages logs sent to `stdout` and rotation is set with the `logging` key in `docker-compose.yml`.

Access logs:
```
docker logs arclight
```

See logs in real time
```
docker logs -f arclight
```

### Cron jobs

This app runs the cronjobs in config/arclight-cron. These:
* Clean Rails tmp folder every day at midnight
* Clear DB of user searches every month on the 1st day at midnight
