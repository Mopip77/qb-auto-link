#!/bin/bash

###########################################################
# Author        : Mopip77
# Email         : mopip77@qq.com
# Last modified : 2022-10-22 10:55
# Filename      : auto_symbollink.sh
# Description   : auto link downloaded file to media folder
###########################################################
set -euo pipefail
IFS=$'\n\t'

echo "========== Start to link file by [$0] =========== "

set -x

shadowSuffix="${SHADOW_SUFFIX:=shadow}"
includeLinkPath="${INCLUDE_LINK_PATH:=}"

torrentName="$1"
contentPath="$2"
savePath="$3"
fileCount="$4"
rootPath="$5"

# remove last / for savePath
if [ "${savePath: -1}" = "/" ]; then
    savePath="${savePath%?}"
fi

# filter by whitelist
if [ -n "$includeLinkPath" ]; then
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

if [ -f "$rootPath" ]; then
    shadowFolder="${shadowFolder}/${torrentName}"
    fileName="${contentPath##*/}"
    mkdir -p "$shadowFolder"
    cd "$shadowFolder"
    ln -s "../../${originFolderName}/${fileName}" .
else
    cd "$shadowFolder"
    ln -s "../${originFolderName}/${torrentName}" .
fi
