[![Build Status](https://travis-ci.org/hi-ogawa/yesod-experiment.svg?branch=master)](https://travis-ci.org/hi-ogawa/yesod-experiment)

# Yesod Experiment

## Features

- Postgresql integration
- Development with cabal sandbox
- Database schema migration with Flyway
- cabal.config from stackage-lts without Stack
- Restful JSON api server
  - Swagger UI is available: http://swaggers.hiogawa.net/ui/?url=/doc/yesod-experiment.swagger.json#/default
- Testing all api routes on Travis CI and with Docker
- Heroku container deployment (image size is 197.1 MB)
  - simpler version can be found here: https://github.com/hi-ogawa/haskell-heroku-docker

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

Development:

```
$ make install # prepare cabal sandbox and install dependencies
$ make db      # prepare postgresql
$ make migrate # run schema migration
$ cp systems/env.development.example systems/env.development
$ make app     # run server from local cabal sandbox
```

Testing:

```
$ make db
$ make migrate
$ make spec
```

Testing in Docker (in the same way on Travis CI):

```
$ make db
$ make migrate
$ make spec-docker
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
$ make deploy-migrate # if necessary
$ heroku open -a yesod-free-deploy
```

- References for deployment
  - 2 step production image creation: https://blog.codeship.com/continuous-integration-and-delivery-with-docker/
  - Heroku container deployment: https://devcenter.heroku.com/articles/container-registry-and-runtime
