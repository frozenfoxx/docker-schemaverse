#!/usr/bin/env bash
####################################################
# Author: FrozenFOXX
# Description: this script adds a player to the game
####################################################

# Variables
PLAYERNAME=${1}
PASSWORD=${2}

# Logic
if [ $# -lt 2 ]; then
  echo "Not enough arguments"
  echo "Usage: add_player.sh USERNAME PASSWORD"
fi

su schemaverse -c "psql -d schemaverse -c \"INSERT INTO player(username, password) VALUES('${PLAYERNAME}', '${PASSWORD}');\"