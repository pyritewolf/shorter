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

RUN shards install
RUN crystal build ./src/main.cr

COPY --from=frontend /app/public/ /app/public/

EXPOSE 80

CMD ./main
