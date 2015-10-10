#!/bin/bash

# These are usually known at the time when building the image
DIRECTORY=/var/lib/go-server
OWNER_USERNAME=go
OWNER_GROUPNAME=go

if [ -z "$DIRECTORY" ]; then
  echo "Directory not specified"
  exit 1;
fi

if [ -z "$OWNER_USERNAME" ]; then
  echo "Username not specified"
  exit 1;
fi
if [ -z "$OWNER_GROUPNAME" ]; then
  echo "Groupname not specified"
  exit 1;
fi
if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does not exist"
  exit 1;
fi

ret=false
getent passwd $OWNER_USERNAME >/dev/null 2>&1 && ret=true

if ! $ret; then
    echo "User $OWNER_USERNAME does not exist"
    exit 1;
fi
ret=false
getent passwd $OWNER_GROUPNAME >/dev/null 2>&1 && ret=true
if ! $ret; then
    echo "Group $OWNER_GROUPNAME does not exist"
    exit 1;
fi

# we want to keep /etc/go in /var/lib/go-server/etc
if [ ! -d "$DIRECTORY/etc" ]; then
  # /var/lib/go-server/etc does not exist yet, we use the default one from image to initialize
  mv /etc/go /var/lib/go-server/etc
  ln -s /var/lib/go-server/etc /etc/go
fi
# /var/lib/go-server/etc exists, make sure there is a link to it
if [[ -L "/etc/go" && -d "/etc/go" ]]; then
    echo "/etc/go is a symlink to a directory"
else
  mv /etc/go /etc/go.original
  ln -s /var/lib/go-server/etc /etc/go
fi

OLDUID=$(id -u go)

NEWUID=$(ls --numeric-uid-gid -d $DIRECTORY | awk '{ print $3 }')
NEWGID=$(ls --numeric-uid-gid -d $DIRECTORY | awk '{ print $4 }')

usermod -u $NEWUID $OWNER_USERNAME
groupmod -g $NEWGID $OWNER_GROUPNAME
# fix other Go files
find /etc/go -user $OLDUID -exec chown go:go {} \;
find /var/log/go-server/ -user $OLDUID -exec chown go:go {} \;
chown go:go /etc/default/go-server
chown go:go /var/lib/go-server/addons

/sbin/my_init
