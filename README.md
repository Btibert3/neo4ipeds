# About

Docker file is a subset of https://github.com/Btibert3/datasci-docker/blob/master/docker-compose.yml.

## R, Neo4j, and IPEDS Graph Database

1.  Parse all of the dataset into Neo4j, 

1.  Iterate the data model

1.  Add additional data

1.  Blog



## Fire up the initial docker compose file

```
Brocks-MacBook-Pro-2:neo4ipeds btibert$ docker-compose up -d
```

Which, by the way, can be run from the RStudio IDE, using the `terminal` tab.  The more I use terminal, the more I love this feature.

```
docker-compose stop
```

to tear down the container.

What do we have for files

```
list.files()
```

Let's manually put the apoc jars in the project's neo4j/plugins folder.  For example, at the time of this writing, the jar file is located at:

https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/tag/3.5.0.2


Start up the database via docker:


```
docker-compose up -d
```

