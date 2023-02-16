FROM postgres:15.2

ARG PLATFORM

ENV DUCKDB_VERSION 0.7.0
ENV DUCKDB_DIR_NAME duckdb-${DUCKDB_VERSION}

ENV DUCKDB_FDW_VERSION main
ENV DUCKDB_FDW_DIR_NAME duckdb_fdw-${DUCKDB_FDW_VERSION}

ENV PGSQL_HTTP_VERSION 1.5.0
ENV PGSQL_HTTP_DIR_NAME pgsql-http-${PGSQL_HTTP_VERSION}

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
  && wget https://github.com/duckdb/duckdb/releases/download/v${DUCKDB_VERSION}/duckdb_cli-${PLATFORM}.zip \
  && unzip duckdb_cli-${PLATFORM}.zip \
  && cp duckdb /usr/local/bin \
  && wget https://github.com/duckdb/duckdb/releases/download/v${DUCKDB_VERSION}/libduckdb-${PLATFORM}.zip \
  && unzip libduckdb-${PLATFORM}.zip \
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
  && wget https://github.com/pramsey/pgsql-http/archive/refs/tags/v${PGSQL_HTTP_VERSION}.zip \
  && unzip v${PGSQL_HTTP_VERSION}.zip \
  && cd ${PGSQL_HTTP_DIR_NAME} \
  && make \
  && make install \
  && rm -rf /var/lib/apt/lists/* \
  && cd / \
  && rm -rf /tmp/duckdb

WORKDIR /
