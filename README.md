# PostgreSQL + DuckDB + HTTP

A PostgreSQL (15) image with [DuckDB (CLI)](https://duckdb.org) pre-installed along with the [`duckdb_fdw`](https://github.com/alitrack/duckdb_fdw) and the [`pgsql-http`](https://github.com/pramsey/pgsql-http) extensions.

```bash
docker network create pg
docker run --name pg --network pg -d -e POSTGRES_PASSWORD=password postgres-duckdb
docker run -it --rm --network pg -e PGPASSWORD=password postgres-duckdb psql -h pg -U postgres
```

...

```psql
psql (15.2 (Debian 15.2-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE EXTENSION http;
CREATE EXTENSION
postgres=# CREATE EXTENSION duckdb_fdw;
CREATE EXTENSION
```

## Usage

This image has been pushed to the GitHub Container Registry (ghcr.io). In order to pull it you will first need to log into ghcr.io with your username and an access token that has `package:read` permission.

```bash
echo "TOKEN" | docker login ghcr.io -u GITHUB_USERNAME --password-stdin
```

Once logged in you can use `docker pull` as usual (not domain prefix).

```bash
docker pull ghcr.io/johnallen3d/postgres-duckdb:latest
```
