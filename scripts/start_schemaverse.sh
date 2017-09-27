#!/usr/bin/env bash
####################################################
# Author: FrozenFOXX
# Description: this script launches the Schemaverse
####################################################

# Variables
PORT=5432

# Logic

## Start database
/etc/init.d/postgresql start

## Watch log
tail -f /var/log/postgresql/postgresql-9.5-main.log