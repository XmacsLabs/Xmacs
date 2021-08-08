#!/bin/bash

FWDIR=$HOME/gitee/XmacsLabs/Xmacs

function clean_source_dir(){
  echo "==> Cleaning Source Code Directory"
  cd $FWDIR/texmacs
  git checkout -- .
  git clean -df -q
  rm -rf plugins/quiver
}

cd $FWDIR
git submodule update --init --recursive

clean_source_dir

echo "==> Git Apply prepared patches"
git apply $FWDIR/patches/1.diff
git apply $FWDIR/patches/2.diff
git apply $FWDIR/patches/3.diff
git apply $FWDIR/patches/4.diff

echo "==> Cleaning Unused Code"
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
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/TMButtonsController.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/TMButtonsController.m
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/TMView.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_basic_widgets.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_dialogues.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_dialogues.mm
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_gui.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_gui.mm
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_menu.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_menu.mm
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_other_widgets.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_renderer.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_renderer.mm
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_simple_widget.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_utilities.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_utilities.mm
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_widget.h
rm -rf $FWDIR/texmacs/src/Plugins/Cocoa/aqua_widget.mm

## Using the latest Plugins and remove some of them
rm -rf $FWDIR/texmacs/plugins
cp -r $FWDIR/plugins $FWDIR/texmacs/
rm -rf $FWDIR/texmacs/plugins/axiom
rm -rf $FWDIR/texmacs/plugins/maple
rm -rf $FWDIR/texmacs/plugins/mathematica
rm -rf $FWDIR/texmacs/plugins/matlab

echo "==> Overwirte using Xmacs-only files"
cp -rf $FWDIR/xmacs/* $FWDIR/texmacs/

echo "==> Output to /tmp/Xmacs"
rm -rf /tmp/Xmacs
cp -r $FWDIR/texmacs /tmp/Xmacs
find /tmp/Xmacs -iname ".git" | xargs -I% rm -f %
find /tmp/Xmacs -iname ".gitignore" | xargs -I% rm -f %

clean_source_dir

