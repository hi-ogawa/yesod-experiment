FROM haskell:7.10.3

RUN apt-get update && apt-get install -y libpq-dev
RUN cabal user-config update

RUN mkdir -p /app
WORKDIR /app

CMD /bin/bash
