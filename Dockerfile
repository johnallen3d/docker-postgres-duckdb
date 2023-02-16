FROM postgres:15.2

WORKDIR /tmp/duckdb

RUN \
  apt-get update && apt-get install -y \
    build-essential \
    g++ \
    libcurl4-openssl-dev \
    make \
    postgresql-server-dev-15 \
    unzip \
    wget \
  && wget https://github.com/duckdb/duckdb/releases/download/v0.7.0/duckdb_cli-linux-aarch64.zip \
  && unzip duckdb_cli-linux-aarch64.zip \
  && cp duckdb /usr/local/bin \
  && wget https://github.com/duckdb/duckdb/releases/download/v0.7.0/libduckdb-linux-aarch64.zip \
  && unzip libduckdb-linux-aarch64.zip \
  && cp libduckdb.so $(pg_config --libdir) \
  && wget https://github.com/alitrack/duckdb_fdw/archive/refs/heads/main.zip \
  && unzip main.zip \
  && cd duckdb_fdw-main \
  && export PATH="/usr/lib/postgresql/15/bin/:$PATH" \
  && cp ../duckdb.hpp . \
  && make USE_PGXS=1 \
  && make install USE_PGXS=1 \
  && mkdir -p /tmp/pgsql-http \
  && cd /tmp/pgsql-http \
  && wget https://github.com/pramsey/pgsql-http/archive/refs/heads/master.zip \
  && unzip master.zip \
  && cd pgsql-http-master \
  && make \
  && make install
