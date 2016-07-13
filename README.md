[![Build Status](https://travis-ci.org/hi-ogawa/yesod-experiment.svg?branch=master)](https://travis-ci.org/hi-ogawa/yesod-experiment)

# Yesod Experiment

## Features

- Postgresql integration
- Development with docker or cabal sandbox
- Database schema migration with Flyway
- cabal.config from stackage-lts without Stack
- Restful JSON api server
  - Swagger UI is available: http://swaggers.hiogawa.net/ui/?url=/doc/yesod-experiment.swagger.json#/default
- Testing all api routes on Travis CI
- Heroku container deployment (image size is around 800MB)

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

$ heroku version
heroku-toolbelt/3.43.5 (x86_64-darwin10.8.0) ruby/1.9.3
heroku-cli/5.2.24-4b7e305 (darwin-amd64) go1.6.2
=== Installed Plugins
heroku-container-registry@4.0.0
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

Deployment (on Heroku):

```
-- First Time --
$ heroku plugins:install heroku-container-registry
$ heroku login
$ docker login --email=<heroku account email> --username=<heroku account email> --password=$(heroku auth:token) registry.heroku.com
$ heroku apps:create yesod-free-deploy
$ heroku addons:create heroku-postgresql --app yesod-free-deploy
$ heroku config -s -a yesod-free-deploy # copy the output into systems/env.production

-- Continuous Update --
$ make deploy
$ make deploy_migrate # if necessary
$ heroku open -a yesod-free-deploy
```

- References for deployment
  - 2 step production image creation: https://blog.codeship.com/continuous-integration-and-delivery-with-docker/
  - Heroku container deployment: https://devcenter.heroku.com/articles/container-registry-and-runtime
