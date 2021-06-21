FROM crystallang/crystal:1.0.0
WORKDIR /app

RUN  apt-get update && apt-get -y install sqlite3 libsqlite3-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /app/
RUN shards install
