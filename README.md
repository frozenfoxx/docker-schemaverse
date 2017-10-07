# docker-schemaverse
Docker container for running Schemaverse
[Schemaverse](https://schemaverse.com/) for [Docker](https://www.docker.com).

Docker Hub: [https://hub.docker.com/r/frozenfoxx/docker-schemaverse/](https://hub.docker.com/r/frozenfoxx/docker-schemaverse/)

# How to Build
```
git clone git@github.com:frozenfoxx/docker-schemaverse.git
cd docker-schemaverse
docker build .
```

# How to Use this Image
## Quickstart
The following will run the latest Schemaverse server.

```
docker run -d --rm -p 5432:5432 --name=schemaverse_server frozenfoxx/docker-schemaverse:latest
```

## Interactive
A good way to run for development and for continual monitoring is to attach to the terminal:

```
docker run -it --rm -p 5432:5432 --name=schemaverse_server frozenfoxx/docker-schemaverse:latest
```

## Persistent volume
This image provides a persistent volume for `/var/lib/postgresql` if desired. If you wish to maintain the volume after the container is destroyed simply don't tell Docker to remove it with `--rm`. You can also override it:

```
docker run -d -p 5432:5432 -v /some/persistent/path:/var/lib/postgresql --name=schemaverse_server frozenfoxx/docker-schemaverse:latest
```

## Connect to the database
Connecting to the running database is a lot like connecting to any other database. Assuming you're connecting to your docker-schemaverse container on the same machine:

```
psql -U [some player] -h localhost schemaverse
```

# Administration
Administering the database must be done from within the container. After starting the container you can perform the following to attach to its terminal and access the database:

```
docker ps
[note container id of the docker-schemaverse container]
docker exec -it [container id] /bin/bash
su schemaverse -c "psql schemaverse"
```

## Add a Player
Adding a player is very similar to administering the database. A script has been included to make this easier, `add_player.sh`. Invoke it as such:

```
docker ps
[note container id of the docker-schemaverse container]
docker exec -it [container id] /src/schemaverse/scripts/add_player.sh [player name] [password]
```

# Configuration
## sqitch.conf
The primary configuration is handled in `conf/sqitch.conf`. Update this file prior to building to alter deployment.
