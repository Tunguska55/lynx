#!/usr/bin/env bash

######current potential flags
# remove-config -> removes current config
# generate -> creates new config file based on display

configFile="/u/$USER/.config/reset_display.conf"
flag=$1 #capture the flag into a script variable rather than leaving as special

#This is a flag to allow the user to remove the config without admin intervention
#need to turn this into a try at some point
if [[ $flag = "remove-config" ]]
then
  rm -f ${configFile}
  printf "config file removed successfully \n"
  printf "exiting script \n"
  exit 2
fi

#Create a config file based on current settings (don't run when monitor is messed up)
if [[ ! -e $configFile ]] && [[ $flag = "generate" ]]
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

exit 3
fi

#array to store values read from conf file
declare -A disparray

#read the conf file and store value in array
IFS="="
printf "Resetting display based on config file (${configFile}) \n"
while read -r key value
do
#printf "Content of $key is ${value//\"/} \n" #for debugging
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

#code execution to reset display
if [[ -e $configFile ]] && [[ ! -z $disparray["PRIMARYDISPLAY"] ]]
then
  #printf "successfully executing \n" #debugging line
  xrandr --output ${disparray["PRIMARYDISPLAY"]} --auto --pos ${disparray["PRIMARYPOSITION"]} --primary \
  --output ${disparray["SECONDARYDISPLAY"]} --auto --pos ${disparray["SECONDARYPOSITION"]}
fi


#debugging and logging
#printf "Primary Display = ${disparray['PRIMARYDISPLAY']} \n"
#printf "Secondary Display = ${SecDisplay}\n"
