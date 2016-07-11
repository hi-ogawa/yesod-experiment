dev-app: SHELL:=/bin/bash
dev-app:
	source systems/env.development && cabal run exe:non-stack-yesod

dev-install:
	cabal sandbox init
	cabal install --only-dependencies --enable-tests

dev-docker-app:
	docker-compose -f systems/docker-compose.yml up app

dev-docker-db:
	docker-compose -f systems/docker-compose.yml up -d postgres

dev-docker-db-for-host:
	docker-compose -f systems/docker-compose.yml -f systems/docker-compose.host_dev.yml up -d postgres

dev-docker-migrate:
	docker-compose -f systems/docker-compose.yml run flyway
	docker-compose -f systems/docker-compose.yml run flyway_test

dev-test: SHELL:=/bin/bash
dev-test:
	cabal configure --enable-tests
	source systems/env.test && cabal test --show-details=always

dev-docker-test:
	docker-compose -f systems/docker-compose.yml up test

dev-docker-test-travis:
	mkdir -p cache/.cabal
	mkdir -p cache/.ghc
	docker-compose -f systems/docker-compose.yml -f systems/docker-compose.travis.yml up test

deploy: SHELL:=/bin/bash
deploy:
	source systems/env.production && docker-compose -f systems/docker-compose.yml run production_builder
	docker build -t registry.heroku.com/yesod-free-deploy/web -f systems/Dockerfile.dist systems
	docker push registry.heroku.com/yesod-free-deploy/web
