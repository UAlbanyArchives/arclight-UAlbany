# arclight-UAlbany
UAlbany's Arclight instance

An instance of [https://github.com/projectblacklight/arclight](https://github.com/projectblacklight/arclight)

### For development

Run the app:
```
docker-compose -f docker-compose-dev.yml up
```

Navigate to [http://localhost:3000/description](http://localhost:3000/description)

You should be able to edit code in real time.

When you're done:
```
docker-compose down
```

### For deployment

First build the `arclight` image locally:
```
DOCKER_BUILDKIT=1 docker build --secret id=master_key,src=config/master.key -t arclight .
```
On Windows
```
$env:DOCKER_BUILDKIT=1; docker build --secret id=master_key,src=config/master.key -t arclight .
```

Running the image:
```
docker-compose up -d
```
Navigate to [http://localhost:8080/description](http://localhost:8080/description)

&#8594; In production, this should be set up to run as a service.

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
docker-compose -f docker-compose-dev.yml run arclight /bin/sh
```

This assumes you EADs are available in ``../collections`

For example:
```
docker-compose -f docker-compose-dev.yml run arclight /bin/sh /app/index.sh apap147 apap
```

There is also a compose file for indexing all newly updated files:
```
docker-compose -f indexNew.yml run arclight
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
