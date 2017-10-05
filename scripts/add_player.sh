#!/usr/bin/env bash
####################################################
# Author: FrozenFOXX
# Description: this script adds a player to the game
####################################################

# Variables
PLAYERNAME=${1}
PASSWORD=${2}
BALANCE=${3:-10000}
FUELRESERVE=${4:-100000}

# Logic
if [ $# -lt 2 ]; then
  echo "Not enough arguments"
  echo "Usage: add_player.sh [USERNAME] [PASSWORD] [BALANCE] [FUEL RESERVE]"
  echo "  Note: only username and password are required"
  exit 1
fi

su schemaverse -c "psql -d schemaverse -c \"INSERT INTO player(username, password, balance, fuel_reserve) \
  VALUES('${PLAYERNAME}', 'md5' || MD5('${PASSWORD}' || '${PLAYERNAME}'), ${BALANCE}, ${FUELRESERVE});\""