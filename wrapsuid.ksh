#!/bin/ksh

#Wrap a suid script and call with a C program:
#this uses absolute path name to the script so that no one can affect
#the script or program run when the PATH variable is changed.

if [ $# -ne 1 ] ; then
    print "usage: $0 scriptname"
    exit 1
fi
if [ ! -e .$1 ] ; then
    mv $1 .$1
else
    print -u2 ".$1 exists! Please check your files."
    exit 1
fi
prog=$(whence -p .$1)
if [ $? = 1 ] ; then
    print -u2 "program not found"
    exit 1
fi
print "main(int argc, char * argv[]){execv(\"$prog\", argv);}" > $1.c
cc -o $1 $1.c
rm $1.c
chmod u+s $1

