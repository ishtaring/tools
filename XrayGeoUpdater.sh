#!/usr/bin/env bash

set -e

# set geodata files' directory through argument 1
geo_folder="$1"

YELLOW='\033[33m'
GREEN='\033[0;32m'
RedBG='\033[41;37m'
GreenBG='\033[42;37m'
NC='\033[0m'

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

GEOIP="geoip.dat"
GEOSITE="geosite.dat"

# argument 2 must be <empty> or "cn"
if [[ $# -gt 2 ]]; then
    echo -e "${RedBG}>>> only accept 2 argument!${NC}"
    exit 1
fi

# validation check of argument 2
if [[ $2 == "cn" ]]; then
    # set different URL for downloading assets
    GEOIP_URL="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat"
    GEOSITE_URL="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat"
elif [[ $# -eq 2 && $2 != "cn" ]]; then
    echo -e "${RedBG}>>> arguments 2 only accept \"cn\"!${NC}"
    exit 1
fi

# 1. Start downloading
echo -e "${GREEN}>>> downloading geoip.dat files...${NC}"
echo -e "${YELLOW}geoip URL: $GEOIP_URL${NC}"
curl -L $GEOIP_URL --output /tmp/$GEOIP

echo -e "${GREEN}>>> downloading geosite.dat files...${NC}"
echo -e "${YELLOW}geosite URL: $GEOSITE_URL${NC}"
curl -L $GEOSITE_URL --output /tmp/$GEOSITE

# 2. Clean old assets
echo -e "${GREEN}>>> delete old dat files...${NC}"
rm -f $geo_folder/$GEOIP $geo_folder/$GEOSITE

# 3. Replace old assets
echo -e "${GREEN}>>> Replacing new geoip/geosite...${NC}"
mv /tmp/$GEOIP $geo_folder/
mv /tmp/$GEOSITE $geo_folder/

echo -e "${GREEN}Finished!${NC}"

echo -e "${GREEN}Finished for geoip/geosite!${NC}"

# 4. Restart server
echo -e "${GREEN}>>> Restart xray servers..${NC}"
systemctl restart xray
echo -e "${GREEN}All Finished!!${NC}"
