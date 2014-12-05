#!/bin/bash
#Wrap a suid script and call with a C program:
#this uses absolute path name to the script so that no one can affect
#the script or program run when the PATH variable is changed.
unalias which 2>/dev/null
if [ $# -ne 1 ] ; then
  echo "usage: $0 scriptname" >&2
  exit 1
fi
if [ ! -e .$1 ] ; then
  mv $1 .$1
else
  echo ".$1 exists! Please check your files." >&2
  exit 1
fi
prog=$(which ./.$1)
if [ $? = 1 ] ; then
  echo "program not found" >&2
  exit 1
fi
echo -e "#include <stdio.h>\n#include <unistd.h>\nmain(int argc, char * argv[]){setreuid(geteuid(), geteuid());execv(\"$prog\", argv);}" > $1.c
cc -o $1 $1.c
rm $1.c
chmod u+s,og-w $1
chmod 500 .$1
