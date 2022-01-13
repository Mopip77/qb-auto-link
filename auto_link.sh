#!/bin/bash

###########################################################
# Author        : Mopip77
# Email         : mopip77@qq.com
# Last modified : 2022-01-12 21:55
# Filename      : auto_symbollink.sh
# Description   : auto link downloaded file to media folder
###########################################################
set -euo pipefail
IFS=$'\n\t'

shadowSuffix="${SHADOW_SUFFIX:=shadow}"
includeLinkPath="${INCLUDE_LINK_PATH:=}"

torrentName="$1"
contentPath="$2"
savePath="$3"

# filter by whitelist
if [ -n $includeLinkPath ]; then
    IFS=","
    included=""
    for keyword in ${includeLinkPath[@]}; do
        [[ "$savePath" =~ "$keyword" ]] && included="yes"
    done
    [[ -z "$included" ]] && exit 0
    IFS=$'\n\t'
fi

# hard link to shadow folder
shadowFolder="${savePath}-${shadowSuffix}"
mkdir -p "$shadowFolder"
originFolderName="${savePath##*/}"

if [ -f "$contentPath" ]; then
    shadowFolder="${shadowFolder}/${torrentName}"
    fileName="${contentPath##*/}"
    mkdir -p "$shadowFolder"
    cd "$shadowFolder"
    ln -s "../../${originFolderName}/${fileName}" .
else
    cd "$shadowFolder"
    ln -s "../${originFolderName}/${torrentName}" .
fi