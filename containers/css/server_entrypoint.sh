#!/bin/bash

# copy files into maps file
cp -r /fastdownload/cstrike $STEAM_GAME_DIR/

touch $STEAM_GAME_DIR/console.log

$STEAM_GAME_DIR/srcds_run \
    -game cstrike \
    -debug \
    -autoupdate \
    -steam_dir $STEAMCMD_DIR/ \
    -steamcmd_script /steam/game_update.txt \
    -consolelog $STEAM_GAME_DIR/console.log \
    +ip 0.0.0.0 \
    +net_public_address $IP_ADDRESS \
    +sv_pure 1 \
    +map de_dust \
    +maxplayers 24 \
    +fps_max 500 \
    & 

tail -F $STEAM_GAME_DIR/console.log