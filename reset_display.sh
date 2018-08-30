#!/usr/bin/env bash
configFile="/u/$USER/.config/reset_display.conf"
if [ ! -e $configFile ]
then
  #printf "in the if statement \n" #debug statement
  PrimDisplay=$(xrandr -q | grep -e "\bprimary\b" | awk '{print $1}')
  SecDisplay=$(xrandr -q | grep -e "\bconnected\b" | grep -v "primary" | awk '{print $1}')
  PrimPosition=$(xrandr -q | grep -e "\bprimary\b" | awk '{print $4}' | cut -d+ -f2- | sed 's/+/\x/g')
  SecPosition=$(xrandr -q | grep -e "\bconnected\b" | grep -v "primary" | awk '{print $3}'| cut -d+ -f2- | sed 's/+/\x/g')
  #The indentation of EOF from top to bottom is intentional, spacing it would break it
cat <<EOF > $configFile
#This file is created for the reset_display script
#If this file gets corrupted please remove it as the script will recreate it
#Do not modify!
#Talk to Jon, Hector or Jack for any questions
PRIMARYDISPLAY=$PrimDisplay
SECONDARYDISPLAY=$SecDisplay
PRIMARYPOSITION=$PrimPosition
SECONDARYPOSITION=$SecPosition
EOF

fi

declare -A disparray

IFS="="
printf "Resetting display based config file (${configFile})"
while read -r key value
do
printf "Content of $key is ${value//\"/} \n"
  case $key in
    "PRIMARYDISPLAY")
      disparray+=(["PRIMARYDISPLAY"]=$value)
      ;;
    "SECONDARYDISPLAY")
      disparray+=(["SECONDARYDISPLAY"]=$value)
      ;;
    "PRIMARYPOSITION")
      disparray+=(["PRIMARYPOSITION"]=$value)
      ;;
    "SECONDARYPOSITION")
      disparray+=(["SECONDARYPOSITION"]=$value)
      ;;
  esac
done < $configFile

printf "Primary Display = ${disparray['PRIMARYDISPLAY']} \n"
printf "Secondary Display = ${SecDisplay}\n"
