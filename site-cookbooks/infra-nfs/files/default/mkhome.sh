#!/bin/bash

getent passwd | while IFS=: read user pass uid gid full home shell
do
  if [ ! -e /oehome/${user} ] && [ "${uid}" -gt 6000 ] && [ "${uid}" -lt 35000 ]
    then
      echo "Creating homedir for user ${user} (${home})"
      mkdir /oehome/${user}
      chown ${user}:users /oehome/${user}
      install -o $user -g users /etc/skel/.* /oehome/${user}/
  fi
done
