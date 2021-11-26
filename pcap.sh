#!/bin/sh

# QUestions to How are packages managed on RHEL. Linux OS breakdown
#

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1

# Future changes to implement
# -Fix Epoch time to human readable

runPCAP () {
  mkdir pcaps # check on -p
  cd pcaps
  currentDT=$(date "+%F_%s")
  hostname=$(hostname)
  filePath="${hostname}_${currentDT}"
  tcpdump -w $filePath.pcap &
  sleep 20; kill $!
}

os=$(uname) #check Kernel Name
if [[ $os = "Linux" ]]; # check if substring is better option
  then
    installed=$(dpkg -S /usr/sbin/tcpdump)
    if [[ $installed = "tcpdump: /usr/sbin/tcpdump" ]];
      then
        runPCAP
      else
        yum -y install tcpdump
        runPCAP
        yum -y remove tcpdump
      fi
  else
    runPCAP
fi
