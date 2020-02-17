#!/usr/bin/ksh
#
# Sasi Chand
# NTT New Zealand Limited
# 17/02/2020
# sasi.chand@gloabl.ntt
# set -x
# Shell script to monitor or watch the disk space
# It will send an email to $ADMIN, if the (free available) percentage of space is >= 98%.
# -------------------------------------------------------------------------
# Set admin email so that you can get email.
ADMIN="sasi.chand@global.ntt eyetnz@gmail.com"
# set alert level 90% is default
ALERT=98
# Exclude list of unwanted monitoring, if several partions then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/proc|/dump" etc.etc
EXCLUDE_LIST="/proc"
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
function main_prog() {
while read output;
do
#echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $ALERT ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date)" | \
     mail -s "Alert: Almost out of disk space $usep%" $ADMIN
  fi
done
}

if [ "$EXCLUDE_LIST" != "" ] ; then
  df -P | grep -vE "^Filesystem|${EXCLUDE_LIST}" | awk '{print $5 " " $1}' | main_prog
else
  df -H | grep -vE "^Filesystem|proc" | awk '{print $5 " " $1}' | main_prog
fi
