#!/bin/bash

###########################################################################
# @licence app begin@
# SPDX-License-Identifier: MPL-2.0
#
# \copyright Copyright (C) 2013-2017, PSA Group
#
# \file build.sh
#
# \brief This file is part of the Build System for navigation-application.
#
# \author Philippe Colliot <philippe.colliot@mpsa.com>
#
# \version 1.0
#
# This Source Code Form is subject to the terms of the
# Mozilla Public License (MPL), v. 2.0.
# If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# For further information see http://www.genivi.org/.
#
# List of changes:
# 
#
# @licence end@
###########################################################################

clean=0 #no clean (means no cmake) -> -c option
capi=0 #no common api -> -m option
commonapi_tools_option="-DWITH_PLUGIN_MIGRATION=OFF" 
navit=0 #no build of navit -> -n option
poi=0 #no build of poi -> -p option 
dlt_option="OFF" #no DLT -> -l option
debug="OFF" #no debug -> -d option
gateway="OFF" #no vehicle gateway -> -g option
theme_option="OFF" #no HMI theme -> -t option
pack_for_gdp=0 #no tar generated
html="OFF" #no html interface (draft)
speech=0 #no build of speech -> -s option
speech_option="OFF"

function check_path_for_capi
{
	echo 'check path for CommonAPI'
	if [ ! $COMMONAPI_TOOL_DIR ]
	then 
		echo 'Set the dir of the common api tools'
		echo 'export COMMONAPI_TOOL_DIR=<path>'
		exit 1
	fi

	if [ ! $COMMONAPI_DBUS_TOOL_DIR ]
	then 
		echo 'Set the dir of the common api dbus tools'
		echo 'export COMMONAPI_DBUS_TOOL_DIR=<path>'
		exit 1
	fi

	if [ ! $DBUS_LIB_PATH ]
	then 
		echo 'Set the dir of the patched dbus'
		echo 'export DBUS_LIB_PATH=<path>'
		exit 1
	fi
	commonapi_tools_option="-DDBUS_LIB_PATH="$DBUS_LIB_PATH" -DCOMMONAPI_DBUS_TOOL_DIR="$COMMONAPI_DBUS_TOOL_DIR" -DCOMMONAPI_TOOL_DIR="$COMMONAPI_TOOL_DIR""
}

while getopts cdghlmnpstw opt
do
	case $opt in
	c)
		clean=1
		;;
	d)
		debug="ON"
		;;
	g)
		gateway="ON"
		;;
	l)
		dlt_option="ON"
		;;
	m)
		capi=1
		#check commonapi settings
		check_path_for_capi
		;;
	n)
		navit=1
		;;
	p)
		pack_for_gdp=1
		;;
	s)
		speech=1
		speech_option="ON"
		;;
	t)
		theme_option="ON"
		;;
	w)
		html="ON"
		;;
	h)
		echo "Usage:"
		echo "$0 [-cdghlmnpstw]"
		echo "-c: Rebuild with clean"
		echo "-d: Enable the debug messages"
		echo "-g: Build the vehicle gateway"
		echo "-h: Help"
		echo "-l: Build with dlt (only with -c)"
		echo "-m: Build with commonAPI plugins (only with -c)"
		echo "-n: Build navit"
		echo "-p: Pack the hmi (for GDP)"
		echo "-s: Build with speech"
		echo "-t: Generate the HMI theme (only with -c)"
		echo "-w: Enable migration to the html based hmi"
		exit 1
	esac
done
set -e

#clean
if [ "$clean" = 1 ] && [ -d "./build" ]
then
	if [ "$navit" = 1 ]
	then
		echo 'clean up the build folder and regenerate all the stuff'
		find ./build ! -name '*.cbp' -type f -exec rm -f {} +
	else
		echo 'clean up the build folder and regenerate all the stuff except navit '
		rm -f ./build/CMakeCache.txt
		rm -f ./build/cmake_install.cmake
		rm -f ./build/Makefile
		rm -f ./build/hmi/cmake_install.cmake
		rm -f ./build/hmi/Makefile
		rm -f ./build/hmi/hmi-launcher/cmake_install.cmake
		rm -f ./build/hmi/hmi-launcher/Makefile
		rm -rf ./build/hmi/hmi-launcher/moc
	fi
fi

#prepare directory structure for build
mkdir -p build
cd build
mkdir -p navigation
cd navigation
mkdir -p navit
cd ../

if [ "$navit" = 1 ]
then
        cd navigation/navit
	echo 'build navit'
	if [ "$clean" = 1 ]
	then
		cmake -DDISABLE_QT=1 -DSAMPLE_MAP=0 -DBUILD_MAPTOOL=0 -Dvehicle/null=1 -Dgraphics/qt_qpainter=0 ../../../navigation/src/navigation/navit/
	fi
	make
	cd ../../
fi

if [ "$speech" = 1 ]
then
	mkdir -p speech-service
	cd speech-service
	echo 'build speech'
	if [ "$clean" = 1 ]
	then
		cmake -DWITH_DLT=$dlt_option -DWITH_DEBUG=$debug ../../navigation/src/speech-service
	fi
	make
	cd ../
fi


echo 'build fsa'

if [ "$clean" = 1 ]
then
	cmake -DWITH_DLT=$dlt_option $commonapi_tools_option -DWITH_DEBUG=$debug -DWITH_SPEECH=$speech_option -DWITH_STYLESHEET=$theme_option -DWITH_VEHICLE_GATEWAY=$gateway -DWITH_HTML_MIGRATION=$html  ../
	echo 'Allow to display Korean and Japanese by replacing a font in the configuration file of navit instances'
	sed -i -e 's/Liberation Sans/NanumGothic/' ./navigation/navit/navit/navit_genivi_mapviewer.xml
	sed -i -e 's/Liberation Sans/NanumGothic/' ./navigation/navit/navit/navit_genivi_navigationcore.xml
fi
make
cd ../

if [ "$pack_for_gdp" = 1 ]
then
	echo 'pack the hmi for gdp into a tarball'
	tar czf referenceHMI.tar.gz ./hmi/images/ ./hmi/style-sheets/ ./hmi/translations/
fi

