#!/bin/sh

# by Jakukyo Friel <weakish@gmail.com>
# under Apache License, Version 2.0, <http://www.apache.org/licenses/LICENSE-2.0.html>

### Submit offline download tasks to Baidu Pan.

## Requires:
#
# - [jq](http://stedolan.github.io/jq/)
# - curl

## Usage:
#
#     BaiduPanToken=1234aoeu BaiduPanPath='/apps/appname/your-dir' ./baidupan-offline-dl urls.list
#
#  `urls.list` is a text file, containing urls to download. with one url per line.

Baidupan_api_base='https://pcs.baidu.com/rest/2.0/pcs/services/cloud_dl?method='
URL_list=$1

while true; do
  current_downloads=`curl -s -X POST -k -L -d "" "${Baidupan_api_base}list_task&access_token=$BaiduPanToken" | jq '.total'`
  if [ $current_downloads -lt 5 ] ; then
    download_source=`head -1 $URL_list`
    curl -X POST -k -L -d "" "${Baidupan_api_base}add_task&access_token=$BaiduPanToken&save_path=$BaiduPanPath/`basename $download_source`&source_url=$download_source" |
    jq '.'
    echo 'Downloading' `basename $download_source` 'to BaiduPan'
    sed -i 1p $URL_list
  else
    sleep 6m
  fi
done
