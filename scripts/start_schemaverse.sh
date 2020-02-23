#!/usr/bin/env bash

# launch the Schemaverse

# Variables
PORT=5432

# Logic

## Start database
/etc/init.d/postgresql start

## Start tic.pl
su schemaverse -c '/src/schemaverse/tic.pl | tee /src/schemaverse/tic.log 2>&1 &'

## Watch log
tail -f /var/log/postgresql/postgresql-*.log
