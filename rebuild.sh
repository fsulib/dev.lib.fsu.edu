#!/bin/sh

#if [ "$(id -u)" != "0"  ]; then
#  echo "Don't forget to sudo!" 1>&2
#  exit 1
#fi

U=`basename $( echo $HOME )`
CURDIR=`pwd`

echo "\nClean up old files..."
vagrant destroy -f
sudo rm -rf $CURDIR/dependencies/FSULibraries_backrest $CURDIR/dependencies/backup.tar

echo "\nGetting backup file..."
sudo /usr/bin/su - backrest -c "scp backrest@lib-srv-phobos.lib.fsu.edu:~/backhand/FSULibraries_backrest.sitearchive.tar.gz /tmp/backup.tar.gz"
gunzip /tmp/backup.tar.gz
mv /tmp/backup.tar $CURDIR/dependencies/

echo "\nExtracting backup file..."
tar -xvzf $CURDIR/dependencies/backup.tar -C $CURDIR/dependencies &> /dev/null

echo "\nSpinning up new VM..."
vagrant up

echo "\033[0;31;5mDone! dev.lib.fsu.edu now live @ localhost:9999\033[0m"
