# arclight-UAlbany
UAlbany's Arclight instance

An instance of [https://github.com/sul-dlss/arclight](https://github.com/sul-dlss/arclight)


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
