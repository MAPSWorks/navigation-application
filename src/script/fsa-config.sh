#!/bin/bash

###########################################################################
# @licence app begin@
# SPDX-License-Identifier: MPL-2.0
#
# Component Name: fuel stop advisor application
# Author: Philippe Colliot <philippe.colliot@mpsa.com>
#
# Copyright (C) 2013-2014, PCA Peugeot Citroen
# 
# License:
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with
# this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# @licence end@
###########################################################################

#settings and path used by the build.sh and run
#these settings are related to TOP_DIR and TOP_BIN_DIR defined into the parent script
NAVIGATION_SERVICE=navigation
NAVIGATION_SERVICE_SRC_DIR=$TOP_DIR/$NAVIGATION_SERVICE
NAVIGATION_SERVICE_BIN_DIR=$TOP_BIN_DIR/$NAVIGATION_SERVICE
NAVIGATION_SERVICE_API_DIR=$NAVIGATION_SERVICE_SRC_DIR/api
NAVIGATION_SERVICE_BUILD_SCRIPT_DIR=$NAVIGATION_SERVICE_SRC_DIR/src/navigation/script

NAVIT=navit
NAVIT_BIN_DIR=$NAVIGATION_SERVICE_BIN_DIR/navit/navit

POI_SERVER=poi-server
POI_SERVER_SRC_DIR=$NAVIGATION_SERVICE_SRC_DIR/src/poi-service/$POI_SERVER
POI_SERVER_BIN_DIR=$TOP_BIN_DIR/$POI_SERVER

FUEL_STOP_ADVISOR=fuel-stop-advisor
FUEL_STOP_ADVISOR_SRC_DIR=$TOP_DIR/$FUEL_STOP_ADVISOR
FUEL_STOP_ADVISOR_BIN_DIR=$TOP_BIN_DIR/$FUEL_STOP_ADVISOR

POSITIONING=positioning
POSITIONING_SRC_DIR=$TOP_DIR/$POSITIONING
#the binaries of positioning are located into the navigation-service binaries
POSITIONING_BIN_DIR=$NAVIGATION_SERVICE_BIN_DIR/$POSITIONING

GNSS_SERVICE=gnss-service
GNSS_SERVICE_SRC_DIR=$POSITIONING_SRC_DIR/$GNSS_SERVICE
GNSS_SERVICE_BIN_DIR=$POSITIONING_BIN_DIR/$GNSS_SERVICE

SENSORS_SERVICE=sensors-service
SENSORS_SERVICE_SRC_DIR=$POSITIONING_SRC_DIR/$SENSORS_SERVICE
SENSORS_SERVICE_BIN_DIR=$POSITIONING_BIN_DIR/$SENSORS_SERVICE

ENHANCED_POSITION_SERVICE=enhanced-position-service
ENHANCED_POSITION_SERVICE_SRC_DIR=$POSITIONING_SRC_DIR/$ENHANCED_POSITION_SERVICE
ENHANCED_POSITION_SERVICE_BIN_DIR=$POSITIONING_BIN_DIR/$ENHANCED_POSITION_SERVICE
ENHANCED_POSITION_SERVICE_API_DIR=$ENHANCED_POSITION_SERVICE_SRC_DIR/api

POSITIONING_LOG_REPLAYER=log-replayer
POSITIONING_LOG_REPLAYER_SRC_DIR=$POSITIONING_SRC_DIR/$POSITIONING_LOG_REPLAYER
POSITIONING_LOG_REPLAYER_BIN_DIR=$POSITIONING_BIN_DIR/$POSITIONING_LOG_REPLAYER

AUTOMOTIVE_MESSAGE_BROKER=automotive-message-broker
AUTOMOTIVE_MESSAGE_BROKER_SRC_DIR=$TOP_DIR/$AUTOMOTIVE_MESSAGE_BROKER
AUTOMOTIVE_MESSAGE_BROKER_BIN_DIR=$TOP_BIN_DIR/$AUTOMOTIVE_MESSAGE_BROKER

LOG_REPLAYER=log-replayer
LOG_REPLAYER_SRC_DIR=$TOP_DIR/$LOG_REPLAYER
LOG_REPLAYER_BIN_DIR=$TOP_BIN_DIR/$LOG_REPLAYER

GENIVI_LOGREPLAYER=genivilogreplayer
GENIVI_LOGREPLAYER_SRC_DIR=$TOP_DIR/$GENIVI_LOGREPLAYER
GENIVI_LOGREPLAYER_BIN_DIR=$TOP_BIN_DIR/$GENIVI_LOGREPLAYER

HMI_LAUNCHER=hmi-launcher
HMI_LAUNCHER_SRC_DIR=$TOP_DIR/hmi/qml/$HMI_LAUNCHER
HMI_LAUNCHER_BIN_DIR=$TOP_BIN_DIR/$HMI_LAUNCHER

HMI_QML_DIR=$TOP_DIR/hmi/qml

STYLE_SHEETS_GENERATED_INDICATOR=$HMI_QML_DIR/Core/style-sheets/the-style-sheets-have-been-generated-css.js


