# Yesod Experiments

## Features

- Postgresql
- Development/Deployment with Docker (or cabal sandbox)
- Database schema migration with Flyway
- cabal.config from stackage-lts without Stack
- Restful JSON api server
- Testing all routes

## Notes

Tools version:

```
$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 7.10.2

$ cabal --version
cabal-install version 1.22.6.0
using version 1.22.4.0 of the Cabal library

$ docker -v
Docker version 1.11.1, build 5604cbe

$ docker-compose -v
docker-compose version 1.7.0, build 0d7bf73
```

Development in cabal sandbox:

```
$ make dev-install               # prepare cabal sandbox and install dependencies
$ make dev-docker-db             # prepare postgresql
$ make dev-docker-migrate        # run schema migration
$ cp systems/env.development.example systems/env.development
$ source systems/env.development # load a couple of parameters (port number, database connection)
$ make dev-docker-db-for-host    # open port for host
$ make dev-app                   # run server from local cabal sandbox
```

Or Development in Docker:

```
$ make dev-docker-db             # same as above
$ make dev-docker-migrate        # save as above
$ make dev-docker-app            # run server in docker
```

Testing in cabal sandbox:

```
$ make dev-docker-db
$ make dev-docker-migrate
$ make dev-docker-db-for-host # open port for host as above
$ make dev-test
```

Or Testing in Docker (in the same way on Travis CI):

```
$ make dev-docker-db
$ make dev-docker-migrate
$ make dev-docker-test
```

Deployment: TODO
