# Build frontend
FROM node:16-alpine AS frontend
RUN mkdir /app
WORKDIR /app
ADD ./frontend/ /app/
RUN npm install --production
RUN npm run build

FROM crystallang/crystal:1.0.0 as backend

ADD ./backend /app
WORKDIR /app

RUN  apt-get update && apt-get -y install sqlite3 libsqlite3-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN shards install

COPY --from=frontend /app/public/ /app/public/
RUN crystal build ./src/main.cr

EXPOSE 80

CMD ./main
