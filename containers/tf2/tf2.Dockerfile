FROM team-brh/hl2:latest

# Link sourcemod directory
RUN mkdir -p $STEAM_GAME_DIR/tf/ \
    && ln -s /steam/addons $STEAM_GAME_DIR/tf/addons

# Load and build the dg plugin
# RUN mkdir /tmp/plugin \
#     && cd /tmp/plugin \
#     && curl -sL "https://github.com/jesseryoung/drinkinggame/archive/9751c3b41f66a75cb731787dc03e82ee5043fa7a.tar.gz" | tar -xz --strip-components 1 \
#     && mkdir -p $STEAM_GAME_DIR/tf/materials/dg/ \
#     && cp *.vmt $STEAM_GAME_DIR/tf/materials/dg/ \
#     && cp *.vtf $STEAM_GAME_DIR/tf/materials/dg/ \
#     && cd $SOURCEMOD_DIR/plugins \
#     && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/src/dgplugin.sp \
#     && rm -rf /tmp/plugin

# Heavyboxing plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/HeavyBoxing/archive/a04dc4823110ff68b655282570414ae8936a2657.tar.gz" | tar -xz --strip-components 1 \
    && mkdir -p $STEAM_GAME_DIR/tf/sound/suddendeath/ \
    && cp hbm.mp3 $STEAM_GAME_DIR/tf/sound/suddendeath/ \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/heavyboxing.sp \
    && rm -rf /tmp/plugin


ENV STEAM_APP_ID 232250

# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


# General game configs
ADD --chown=steam config/motd.txt $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/pure_server_whitelist.txt $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/server.cfg $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/mapcycle.txt $STEAM_GAME_DIR/tf/cfg/

# Sourcemod configs
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/
ADD --chown=steam config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/

ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]
