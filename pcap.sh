#!/bin/sh

runPCAP () {
  mkdir pcaps
  cd pcaps
  currentDT=$(date "+%F_%s")
  hostname=$(hostname)
  filePath="${hostname}_${currentDT}"
  tcpdump -w $filePath.pcap &
  sleep 5; kill $!
}

os=$(uname) #check Kernel Name
if [[ $os = "Linux" ]];
  then
    installed=$(dpkg -S /usr/sbin/tcpdump)
    if [[ $installed = "tcpdump: /usr/sbin/tcpdump" ]];
      then
        runPCAP
      else
        yum install tcpdump
        runPCAP
        yum remove tcpdump
      fi
  else
    runPCAP
fi
