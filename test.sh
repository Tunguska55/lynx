#!/usr/bin/env bash
#sed "s/metamodes/${value}/"
jon=0
filer="/etc/xorg.conf"
first= grep "metamodes" ${filer} | cut -d: -f1 | grep -o -e "DP-[0-9]"
second=grep "metamodes" ${filer} | cut -d, -f2 | grep -o -e "DP-[0-9]"
nvConf="/etc/xorg.confffff"
printf "${nvConf}"
printf "value of: $1 \n"
if [[ $1 = "" ]]
then
  printf "here I am \n"
  jon=1
fi
printf $jon
