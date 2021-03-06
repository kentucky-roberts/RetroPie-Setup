#!/usr/bin/env bash

#
#  (c) Copyright 2012-2014  Florian Müller (contact@petrockblock.com)
#
#  RetroPie-Setup homepage: https://github.com/petrockblog/RetroPie-Setup
#
#  Permission to use, copy, modify and distribute this work in both binary and
#  source form, for non-commercial purposes, is hereby granted without fee,
#  providing that this license information and copyright notice appear with
#  all copies and any derived work.
#
#  This software is provided 'as-is', without any express or implied
#  warranty. In no event shall the authors be held liable for any damages
#  arising from the use of this software.
#
#  RetroPie-Setup is freeware for PERSONAL USE only. Commercial users should
#  seek permission of the copyright holders first. Commercial use includes
#  charging money for RetroPie-Setup or software derived from RetroPie-Setup.
#
#  The copyright holders request that bug fixes and improvements to the code
#  should be forwarded to them so everyone can benefit from the modifications
#  in future versions.
#
#  Many, many thanks go to all people that provide the individual packages!!!
#

# global variables ==========================================================

# main retropie install location
rootdir="/opt/retropie"

home="$(eval echo ~$user)"
romdir="$home/RetroPie/roms"
emudir="$rootdir/emulators"
configdir="$rootdir/configs"

user="$SUDO_USER"
[ -z "$user" ] && user=$(id -un)

scriptdir=$(dirname $0)
scriptdir=$(cd $scriptdir && pwd)

__tmpdir="$scriptdir/tmp"
__builddir="$__tmpdir/build"
__swapdir="$__tmpdir"

# check, if sudo is used
if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root. Try 'sudo $0'"
    exit 1
fi

source "$scriptdir/scriptmodules/system.sh"
source "$scriptdir/scriptmodules/helpers.sh"
source "$scriptdir/scriptmodules/packages.sh"

setup_env

getDepends git dialog python-lxml gcc-$__default_gcc_version g++-$__default_gcc_version build-essential

# set default gcc version
gcc_version $__default_gcc_version

mkRootRomDir "$romdir"

rp_registerAllModules

[[ "$1" == "init" ]] && return

# load RetronetPlay configuration
source "$scriptdir/configs/retronetplay.cfg"

# ID scriptmode
if [[ $# -eq 1 ]]; then
    ensureRootdirExists
    rp_callModule $1

# ID Type mode
elif [[ $# -eq 2 ]]; then
    ensureRootdirExists
    rp_callModule $1 $2

# show usage information
else
    rp_printUsageinfo
fi

if [[ ! -z $__ERRMSGS ]]; then
    echo $__ERRMSGS >&2
fi

if [[ ! -z $__INFMSGS ]]; then
    echo $__INFMSGS
fi

