#!/bin/bash
#
# http://localhost/qgis?SERVICE=WMS&VERSION=1.3.1&REQUEST=GetMap&LAYERS=communes,communes,communes,communes&TRANSPARENT=true&CRS=EPSG:4326&BBOX=-8.19762666,35.91688556,13.02618498,55.30241430&HEIGHT=1974&WIDTH=3841&STYLES=&FILTER=
# http://localhost/qgis?SERVICE=WMS&VERSION=1.3.1&REQUEST=GetMap&LAYERS=communes,communes,communes,communes&TRANSPARENT=true&CRS=EPSG:4326&BBOX=1.979373,46.251440,2.931070,46.704882&HEIGHT=1974&WIDTH=3841&STYLES=&FILTER=

N=$1
OUTPUT=$2

error=0
success=0

start=$(date +%s)

i=1
until [[ $i -gt $N ]]; do
    i=$(expr $i + 1)
    resp=$(curl -s -4 -o $OUTPUT -w "%{http_code} %{content_type}" 'http://localhost:8080/qgis?SERVICE=WMS&VERSION=1.3.1&REQUEST=GetMap&LAYERS=communes,communes,communes,communes&TRANSPARENT=true&CRS=EPSG:4326&BBOX=-8.19762666,35.91688556,13.02618498,55.30241430&HEIGHT=1974&WIDTH=3841&STYLES=&FILTER=')
    http_code=$(cut -f 1 -d " " <(echo $resp))
    content_type=$(cut -f 2 -d " " <(echo $resp))
    if [[ $http_code != "200" ]] || [[ $content_type != "image/png" ]]; then
        echo "Error"
        echo "$http_code $content_type"
        if [[ $content_type != "image/png" ]]; then
            if [[ -f $OUTPUT ]]; then
                cat $OUTPUT
            else
                echo "Pas de fichier output"
            fi
        fi
        error=$(expr $error + 1)
    else
        success=$(expr $success + 1)
    fi
    rm -f $OUTPUT
done

stop=$(date +%s)
diff=$(echo "$stop - $start" | bc)

if [[ $success -gt 0 ]]; then
    printf "$(echo "$diff / $success" | bc), "
fi
