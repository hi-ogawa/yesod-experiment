dev-app: SHELL:=/bin/bash
dev-app:
	source systems/env.development
	cabal run exe:non-stack-yesod

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
	source systems/env.test
	cabal configure --enable-tests
	cabal test --show-details=always

dev-docker-test:
	docker-compose -f systems/docker-compose.yml up test

dev-docker-test-travis:
	mkdir -p cache/.cabal
	mkdir -p cache/.ghc
	docker-compose -f systems/docker-compose.yml -f systems/docker-compose.travis.yml up test
