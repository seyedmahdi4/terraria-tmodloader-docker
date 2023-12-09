FROM ubuntu:jammy


ENV BASE_PATH=/home/tmod
ENV MODS_DIR=${BASE_PATH}/Mods
ENV WORLDS_DIR=${BASE_PATH}/Worlds



ARG UID=1001
ARG GID=1001

# install dependency
RUN apt-get update && \
    apt-get install gosu netcat iputils-ping net-tools wget curl zlib1g libc6 libgcc1 libgssapi-krb5-2 libicu66 libssl1.1 libstdc++6 -y && \
    chmod +s /usr/sbin/gosu && \
    rm -rf /var/lib/apt/lists/*

# creating and changing to non-root user. (-mr: creating a HOME directory)
RUN groupadd -g $GID -o tmod && \
    useradd -g $GID -u $UID -mr -d /home/tmod -o -s /bin/bash tmod && \

WORKDIR /home/tmod
USER tmod

COPY  --chown=1001:1001 ./scripts /tmod/scripts

RUN echo "185.199.111.133 objects.githubusercontent.com" >> /etc/hosts \
    && wget https://github.com/tModLoader/tModLoader/releases/download/v2023.10.3.0/tModLoader.zip \
    && unzip tModLoader.zip -d ${BASE_PATH}/ \
    && rm tModLoader.zip \
    && chmod +x ${BASE_PATH}/start-tModLoaderServer.sh

RUN echo "185.199.111.133 objects.githubusercontent.com" >> /etc/hosts \
   && mkdir -pv ${MODS_DIR} && ls -alh ${MODS_DIR}\
   && get-mod.sh https://github.com/VVV101/AlchemistNPC ${MODS_DIR} AlchemistNPC \
   && get-mod.sh https://github.com/VVV101/AlchemistNPCLite ${MODS_DIR} AlchemistNPClite \
   && get-mod.sh https://github.com/JavidPack/BossChecklist ${MODS_DIR} BossChecklist \
   && get-mod.sh https://github.com/MountainDrew8/CalamityMod ${MODS_DIR} CalamityMod \
   && get-mod.sh https://github.com/CalamityTeam/CalamityModMusicPublic ${MODS_DIR} CalamityMusicMod \
   && get-mod.sh https://github.com/hamstar0/tml-extensibleinventory-mod ${MODS_DIR} ExtensibleInventory \
   && get-mod.sh https://github.com/Fargowilta/Fargowiltas ${MODS_DIR} Fargowiltas \
   && get-mod.sh https://github.com/Fargowilta/FargowiltasSouls ${MODS_DIR} FargowiltasSouls \
   && get-mod.sh https://github.com/Fargowilta/FargowiltasSoulsDLC ${MODS_DIR} FargowiltasSoulsDLC \
   && get-mod.sh https://github.com/ExterminatorX99/MagicStorageExtra ${MODS_DIR} MagicStorageExtra \
   && get-mod.sh https://github.com/JavidPack/RecipeBrowser ${MODS_DIR} RecipeBrowser\
   && get-mod.sh https://github.com/PhoenixBladez/SpiritMod ${MODS_DIR} SpiritMod \
   && get-mod.sh https://github.com/Mirsario/TerrariaOverhaul ${MODS_DIR} TerrariaOverhaul \
   && get-mod.sh https://github.com/SamsonAllen13/ThoriumMod ${MODS_DIR} ThoriumMod \
   && get-mod.sh https://github.com/IAmBatby/Tremor ${MODS_DIR} Tremor \
   && get-mod.sh https://github.com/abluescarab/tModLoader-WingSlot ${MODS_DIR} WingSlot \
   && get-mod.sh https://github.com/gardenappl/WMITF ${MODS_DIR} WMITF

ENV worldpath=${WORLDS_DIR}/

ENTRYPOINT [ "./init-tModLoaderServer.sh" ]
