app: SHELL:=/bin/bash
app:
	source systems/env.development && cabal run exe:non-stack-yesod

install:
	cabal sandbox init
	cabal install --only-dependencies --enable-tests

db:
	docker-compose -f systems/docker-compose.yml -f systems/docker-compose.host_dev.yml up -d postgres

migrate:
	docker-compose -f systems/docker-compose.yml run flyway
	docker-compose -f systems/docker-compose.yml run flyway_test

spec: SHELL:=/bin/bash
spec:
	cabal configure --enable-tests
	source systems/env.test && cabal test --show-details=always

spec-docker:
	docker-compose -f systems/docker-compose.yml up test

travis:
	docker-compose -f systems/docker-compose.yml up -d postgres
	docker-compose -f systems/docker-compose.yml run flyway_test
	mkdir -p cache/.cabal
	mkdir -p cache/.ghc
	docker-compose -f systems/docker-compose.yml -f systems/docker-compose.travis.yml up test

clean:
	docker-compose -f systems/docker-compose.yml down

deploy: SHELL:=/bin/bash
deploy:
	docker-compose -f systems/docker-compose.yml run --rm builder
	docker-compose -f systems/docker-compose.yml build distributor
	docker push registry.heroku.com/yesod-free-deploy/web

deploy-migrate: SHELL:=/bin/bash
deploy-migrate:
	docker-compose -f systems/docker-compose.yml run flyway_production
