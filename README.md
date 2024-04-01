# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
In Development, Sheetstr uses Postgres in Docker. 
```
docker pull postgres:16.2-alpine3.19
```

It is always better to have a volume for Postgres in Docker, to ensure data doesn't disappear each time you stop the Docker container. 
```
docker volume create sheetsr_pg_database >/dev/null
```

Start the docker container: 
```
docker run \
	--rm \
	--name sheetstr_postgres \
	-d \
	-p 5555:5432 \
	-e POSTGRES_HOST_AUTH_METHOD=trust \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v sheetsr_pg_database:/var/lib/postgresql/data \
	postgres:16.2-alpine3.19 >/dev/null
```

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
