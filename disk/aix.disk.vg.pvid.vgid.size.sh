#!/bin/ksh
# -------------------------------------------------------------------------------------------
# Sasi Chand
# IBM NZ
# sasic@nz1.ibm.com
# 16/05/2012
# -------------------------------------------------------------------------------------------
while getopts "g" OPTION
  do
        case ${OPTION} in
          g) BLOCK_SIZE="GB";;
        esac
  done

set -A hdisk `lspv | awk '{ print $1 }'`
set -A pvid `lspv | awk '{ print $2 }'`
set -A vg `lspv | awk '{ print $3 }'`
set -A vgid `lsvg -o | awk '{ print $1 }'`

count=0
if [ "$BLOCK_SIZE" = "GB" ]; then
 while (( $count < ${#hdisk[*]} )); do
           hdisk_size_mb=`getconf DISK_SIZE /dev/${hdisk[$count]}`
           hdisk_size_gb=`expr $hdisk_size_mb / 1024`
           size[$count]=$hdisk_size_gb
        let count="count + 1"
 done
else
 while (( $count < ${#hdisk[*]} )); do
           size[$count]=`getconf DISK_SIZE /dev/${hdisk[$count]}`
        let count="count + 1"
 done
fi

count=0
while (( $count < ${#hdisk[*]} )); do
           serial[$count]=`lscfg -vl ${hdisk[$count]} | grep "Serial Number" | awk -F. '{print $NF}'`
        let count="count + 1"
 done

count=0
while (( $count < ${#hdisk[*]} )); do
           VGID[$count]=`lsvg ${vg[$count]} | grep "VG IDENTIFIER:" | awk '{print $NF}'`
        let count="count + 1"
 done

count=0
while (( $count < ${#hdisk[*]} )); do
           LUNID[$count]=`lsattr -El ${hdisk[$count]}| grep "lun_id" | awk '{print $2}'`
        let count="count + 1"
 done
count=0
printf "%-10s %-10s %-15s %-20s %-20s %-30s %s\n" Disk,Size,VG,PVID,VGID
#printf "%-10s %-10s %-15s %-20s %-20s %-30s %s\n" ---- ---- -- ---- ------ ----- -----
while (( $count < ${#hdisk[*]} )); do
           # printf "%-10s %-10s %-15s %-20s %-20s %-30s %s\n" ${hdisk[$count]} ${size[$count]} ${vg[$count]} ${pvid[$count]} ${serial[$count]} ${VGID[$count]} ${LUNID[$count]}
           printf "%-10s %-10s %-15s %-20s %-20s %-30s %s\n" ${hdisk[$count]},${size[$count]},${vg[$count]},${pvid[$count]},${VGID[$count]}
        let count="count + 1"
done
exit
