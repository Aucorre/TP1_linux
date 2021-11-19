*#!/bin/sh
nom_machine=$(hostname)
echo "Machine name :  $nom_machine"
Kernel=$(cat /proc/version | cut -d' ' -f1-3)
Os=$(cat /etc/os-release | head -2)
echo "OS $Os and Kernel version is $Kernel"
Ip=$(ip a | grep inet | grep 192.168 | cut -d' ' -f6)
echo "IP $Ip"
Ram=$(free -mh | grep Mem | cut -d' ' -f11)
free=$(free -mh | grep Mem | cut -d' ' -f46)
echo "RAM : $free RAM remaining of $Ram"
Remaining_space=$( df -H | grep /dev/sda5 | cut -d' ' -f13)
echo "Disque $Remaining_space remaining"
Top_5=$(top -n 1 | head -12 | tail -5)
echo "Top 5 Process by RAM usage\n$Top_5"
Listening_ports=$(ss -tulw | grep LISTEN)
echo "Listening ports : \n$Listening_ports"
CHAT=$(curl https://api.thecatapi.com/v1/images/search | jq -r ".[].url")
echo "Here's your random cat $CHAT"
