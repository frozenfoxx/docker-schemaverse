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
The following will set up, install, and run the latest Schemaverse server.

```
docker run -d -p 5432:5432 --name=schemaverse_server \
  frozenfoxx/docker-schemaverse:latest
```

## Interactive
A good way to run for development and for continual monitoring is to attach to the terminal:

```
docker run -it -p 5432:5432 --name=schemaverse_server \
  frozenfoxx/docker-schemaverse:latest
```

# Configuration
## sqitch.conf
The primary configuration is handled in `conf/sqitch.conf`. Update this file prior to building to alter deployment.
