#!/bin/bash

FWDIR=$HOME/gitee/xmacs/Xmacs

cd $FWDIR/texmacs
git apply $FWDIR/patches/1.diff
git apply $FWDIR/patches/2.diff

## Cleaning
### Autotools
rm -rf $FWDIR/texmacs/Makefile.in
rm -rf $FWDIR/texmacs/aclocal.m4   
rm -rf $FWDIR/texmacs/config.guess 
rm -rf $FWDIR/texmacs/config.sub   
rm -rf $FWDIR/texmacs/configure    
rm -rf $FWDIR/texmacs/configure.in 
rm -rf $FWDIR/texmacs/install-sh   

rm -rf $FWDIR/texmacs/misc/autotroll
rm -rf $FWDIR/texmacs/misc/m4
rm -rf $FWDIR/texmacs/misc/tm-devel-mac
rm -rf $FWDIR/texmacs/src/makefile.in
rm -rf $FWDIR/texmacs/COMPILE

### X11
rm -rf $FWDIR/texmacs/src/Plugins/X11
### Widkit
rm -rf $FWDIR/texmacs/src/Plugins/Widkit
### Cocoa Related
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa

cp -rf $FWDIR/xmacs/ $FWDIR/texmacs/

rm -rf /tmp/Xmacs
cp -r $FWDIR/texmacs /tmp/Xmacs
