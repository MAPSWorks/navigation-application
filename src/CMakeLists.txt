###########################################################################
# @licence app begin@
# SPDX-License-Identifier: MPL-2.0
#
# Component Name: fuel stop advisor application
#
# Author: Philippe Colliot
#
# Copyright (C) 2014, PCA Peugeot Citroën
# Copyright (C) 2018, PSA Groupe
#
# License:
# This Source Code Form is subject to the terms of the
# Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with
# this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# @licence end@
###########################################################################
project(fuel-stop-advisor)
cmake_minimum_required(VERSION 2.8)
find_package(PkgConfig)

option(WITH_DEBUG
        "Enable the debug messages" OFF)
option(WITH_PLUGIN_MIGRATION
        "Enable navit plugins and fuel-stop-advisor migration to commonapi" OFF)
option(AMB_ON_DBUS_SESSION
        "Run amb on dbus session" ON)
option(WITH_HTML_MIGRATION
        "Enable migration to the html based hmi" OFF)
option(WITH_STYLESHEET
        "Generate the style sheet" OFF)
option(WITH_VEHICLE_GATEWAY
        "Use of vehicle gateway" OFF)
option(WITH_DLT
        "Enable DLT logging" OFF)

message(STATUS "WITH_STYLESHEET = ${WITH_STYLESHEET}")
message(STATUS "WITH_DEBUG = ${WITH_DEBUG}")
message(STATUS "WITH_PLUGIN_MIGRATION = ${WITH_PLUGIN_MIGRATION}")
message(STATUS "AMB_ON_DBUS_SESSION = ${AMB_ON_DBUS_SESSION}")
message(STATUS "WITH_HTML_MIGRATION = ${WITH_HTML_MIGRATION}")
message(STATUS "WITH_VEHICLE_GATEWAY = ${WITH_VEHICLE_GATEWAY}")
message(STATUS "WITH_DLT = ${WITH_DLT}")

set(TOP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(NAVIGATION_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/navigation/api")
set(POSITIONING_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/navigation/src/navigation/positioning/enhanced-position-service/dbus/api")
set(FUEL_STOP_ADVISOR_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/fuel-stop-advisor")
set(NAVIGATION_COMMON_DIR "${CMAKE_CURRENT_SOURCE_DIR}/navigation/src/navigation/navigation-common")

set(AUTOMOTIVE_MESSAGE_BROKER "automotive-message-broker")
set(AUTOMOTIVE_MESSAGE_BROKER_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${AUTOMOTIVE_MESSAGE_BROKER}")
set(AUTOMOTIVE_MESSAGE_BROKER_SRC_DIR "${AUTOMOTIVE_MESSAGE_BROKER_DIR}/src/${AUTOMOTIVE_MESSAGE_BROKER}")
set(AUTOMOTIVE_MESSAGE_BROKER_BIN_DIR "${AUTOMOTIVE_MESSAGE_BROKER_DIR}/src/${AUTOMOTIVE_MESSAGE_BROKER}-build")
set(AUTOMOTIVE_MESSAGE_BROKER_LIB_DIR "${AUTOMOTIVE_MESSAGE_BROKER_BIN_DIR}/lib")
set(PATCH_DIR "${CMAKE_CURRENT_SOURCE_DIR}/patches")
set(NAVIT_PNG_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/navigation/navit/navit/icons")
set(TRIPCOMPUTER_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tripcomputer")
set(COMMONAPI_GEN_DIR_POSITIONING "${CMAKE_CURRENT_BINARY_DIR}/enhanced-position-service/franca/api")

if(NOT EXISTS ${AUTOMOTIVE_MESSAGE_BROKER_DIR})
    if(NOT ${AMB_ON_DBUS_SESSION})
        include(ExternalProject)
        ExternalProject_Add(${AUTOMOTIVE_MESSAGE_BROKER}
        PREFIX ${AUTOMOTIVE_MESSAGE_BROKER_DIR}
        GIT_REPOSITORY  https://github.com/otcshare/automotive-message-broker.git
        GIT_TAG 8af1cc9a502cb85736b7afb37dc9073a168aa605
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        INSTALL_COMMAND sudo make install
        )
    else()
        include(ExternalProject)
        ExternalProject_Add(${AUTOMOTIVE_MESSAGE_BROKER}
        PREFIX ${AUTOMOTIVE_MESSAGE_BROKER_DIR}
        GIT_REPOSITORY  https://github.com/otcshare/automotive-message-broker.git
        GIT_TAG c216955d16ca275159891cad296217094d972390
        UPDATE_COMMAND ""
        PATCH_COMMAND patch -p1 -i "${PATCH_DIR}/amb_allow_sessionbus.patch"
        INSTALL_COMMAND sudo make install
        )
    endif()
endif()

if(${WITH_DLT})
    add_definitions("-DDLT_ENABLED=1")
    pkg_check_modules(DLT REQUIRED automotive-dlt)
    include_directories( ${DLT_INCLUDE_DIRS} )
    set(LIBRARIES ${LIBRARIES} ${DLT_LIBRARIES})
endif()

add_subdirectory(navigation/src/navigation "${CMAKE_CURRENT_BINARY_DIR}/navigation")
set(DBUS_GENERATED_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/navigation/dbus-include")

if (WITH_PLUGIN_MIGRATION)
    add_subdirectory(fuel-stop-advisor-capi)
else()
    add_subdirectory(fuel-stop-advisor)
endif()

set(ENHANCED_POSITION_SERVICE_GEN_DIR "${CMAKE_BINARY_DIR}/enhanced-position-service/dbus/api")
set(GNSS_SERVICE_API_DIR "${PROJECT_SOURCE_DIR}/navigation/src/navigation/positioning/gnss-service/api")
set(GNSS_SERVICE_LIBRARY_DIR "${TOP_DIR}/lib")
set(GNSS_SERVICE_LIBRARIES "gnss-service")
set(SENSORS_SERVICE_API_DIR "${PROJECT_SOURCE_DIR}/navigation/src/navigation/positioning/sensors-service/api")
set(SENSORS_SERVICE_LIBRARY_DIR "${TOP_DIR}/lib")
set(SENSORS_SERVICE_LIBRARIES "sensors-service")

add_subdirectory(sensors-service)

add_subdirectory(gnss-service)

add_subdirectory(dead-reckoning)

add_subdirectory(log-replayer-server)

add_subdirectory(genivilogreplayer)

add_subdirectory(hmi)

add_subdirectory(navigation/src/poi-service "${CMAKE_CURRENT_BINARY_DIR}/poi-service")

if(WITH_HTML_MIGRATION)
    add_subdirectory(hmi/html)
endif()

if(WITH_VEHICLE_GATEWAY)
    add_subdirectory(vehicle-gateway)
endif()
