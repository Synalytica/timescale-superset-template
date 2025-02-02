#!/bin/sh

PGPASSWORD="$POSTGRES_PASSWORD" psql --username "$POSTGRES_USER" <<EOF
CREATE database $POSTGRES_DB WITH OWNER $POSTGRES_USER;
GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;

\c $POSTGRES_DB
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
CREATE TABLE IF NOT EXISTS ticker (
  timestamp TIMESTAMP           NOT NULL,
  mark      DOUBLE PRECISION    NOT NULL,
  ask       DOUBLE PRECISION    NOT NULL,
  bid       DOUBLE PRECISION    NOT NULL,
  vol       DOUBLE PRECISION    NOT NULL
);
CREATE TABLE IF NOT EXISTS ohlc (
  timestamp TIMESTAMP           NOT NULL,
  open      DOUBLE PRECISION    NOT NULL,
  high      DOUBLE PRECISION    NOT NULL,
  low       DOUBLE PRECISION    NOT NULL,
  close     DOUBLE PRECISION    NOT NULL,
  volume    DOUBLE PRECISION    NOT NULL
);
SELECT create_hypertable('ticker', 'timestamp');
SELECT create_hypertable('ohlc', 'timestamp');
EOF

