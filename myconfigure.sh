#! /bin/sh
# Replace the version string in $1 by the current git hash.
# Then run configure.

srcdir=`dirname $1`
H=`(cd $srcdir && git log -1 --pretty=%H)`
perl -e '$H=shift;' \
     -e 'while(<>){' \
     -e '  s/^PACKAGE_VERSION=..*.$/PACKAGE_VERSION="$H"/;' \
     -e '  s/^PACKAGE_STRING=.FriCAS .*.$/PACKAGE_STRING="FriCAS $H"/;' \
     -e '  print;' \
     -e '}' \
     $H $1
