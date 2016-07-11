dev-app:
	cabal run non-stack-yesod

dev-install:
	cabal sandbox init
	cabal install --only-dependencies --enable-tests

dev-docker-app:
	docker-compose -f systems/docker-compose.yml up app

dev-docker-db:
	docker-compose -f systems/docker-compose.yml up -d postgres

dev-docker-migrate:
	docker-compose -f systems/docker-compose.yml run flyway

test:
	cabal test --show-details=always
