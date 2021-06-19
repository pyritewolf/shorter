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

COPY --from=frontend /app/public/ /app/public/
RUN crystal build ./src/main.cr

EXPOSE 80

CMD ./main
