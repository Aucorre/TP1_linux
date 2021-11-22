#!/bin/bash
if [[ -d downloads && -d /var/log/yt ]]; then
        title=$(youtube-dl -e "$1" 2>&1)
        if [[ $title =~ "ERROR" ]]; then
                echo "The link is wrong dummie"
                sudo echo "[$(date "+%D %T")] Video $1 has an error : $title" >> /var/log/yt/download.log
                exit
        else
                mkdir downloads/"${title}"
                cd "downloads/${title}" && youtube-dl -q -f mp4 -o "${title}.mp4" "$1" 2>/dev/null
                echo "$1 was downloaded."
                youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o "desc" "$1" 2>/dev/null>mv desc.description description
                echo File Path : /srv/yt/downloads/"${title}"/"${title}"
                sudo echo "[$(date "+%D %T")] Video $1 was downloaded. File Path : /srv/yt/downloads/""${title}""/""${title}>> /var/log/yt/download.log        
        fi
else
        if [[ -d /var/log/yt ]]; then
                echo "Dossier downloads non existant, reessayez."
                exit
        elif [[ -d downloads ]]; then
                echo "Dossier /var/log/yt/downloads.log non existant, reessayez"
                exit
        else
                echo "Dossier /var/log/yt ou downloads non existant, reessayez"
                exit
