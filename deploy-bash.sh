#!/usr/bin/env bash

hostsPersonal="host1"
hostsTeam1="host2 host3.aws.cloud.com"
hostsTeam2="host4"

if [ "$#" -eq "0" ]
  then
  # no args so send to all hosts
  
  for host in $hostsPersonal;do
    echo "Deploying .bashrc to $USER@${host}"
    scp .bashrc ${USER}@${host}:/home/${USER}
  done
  
  for host in $hostsTeam1;do
    echo "Deploying .bashrc to ${UserTeam1}@${host}"
    scp .bashrc ${UserTeam1}@${host}:/home/${UserTeam1}
  done
  
  for host in $hostsTeam2;do
    echo "Deploying .bashrc to ${UserTeam2}@${host}"
    scp .bashrc ${UserTeam2}@${host}:/home/${UserTeam2}
  done  
  
else

  # hostname provided as arg #1 so send to that host only
  echo "Deploying to host: ${1}"
  scp .bashrc ${USER}@${host}:/home/${USER}

fi

echo "Completed deployment of .bashrc"
