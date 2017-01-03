/**
* @licence app begin@
* SPDX-License-Identifier: MPL-2.0
*
* \copyright Copyright (C) 2013-2017, PSA GROUPE
*
* \file NavigationAppMain.qml
*
* \brief This file is part of the navigation hmi.
*
* \author Philippe Colliot <philippe.colliot@mpsa.com>
*
* \version 1.0
*
* This Source Code Form is subject to the terms of the
* Mozilla Public License (MPL), v. 2.0.
* If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/.
*
* For further information see http://www.genivi.org/.
*
* List of changes:
* <date>, <name>, <description of change>
*
* @licence end@
*/
import QtQuick 2.1
import "Core"
import "Core/genivi.js" as Genivi;
import "Core/style-sheets/style-constants.js" as Constants;
import "Core/style-sheets/NavigationAppMain-css.js" as StyleSheet;
import lbs.plugin.dbusif 1.0

HMIMenu {
	id: menu
    property string pagefile:"NavigationAppMain"
    pageBack: Genivi.entryback[Genivi.entrybackheapsize]
    next: navigation
    prev: quit
    DBusIf {
		id:dbusIf;
	}

	HMIBgImage {
        image:StyleSheet.navigation_app_main_background[Constants.SOURCE];
		anchors { fill: parent; topMargin: parent.headlineHeight}

        Text {
            x:StyleSheet.navigationText[Constants.X]; y:StyleSheet.navigationText[Constants.Y]; width:StyleSheet.navigationText[Constants.WIDTH]; height:StyleSheet.navigationText[Constants.HEIGHT];color:StyleSheet.navigationText[Constants.TEXTCOLOR];styleColor:StyleSheet.navigationText[Constants.STYLECOLOR]; font.pixelSize:StyleSheet.navigationText[Constants.PIXELSIZE];
            id:navigationText;
            style: Text.Sunken;
            smooth: true
            text: Genivi.gettext("Navigation")
             }

        StdButton {
            source:StyleSheet.select_navigation[Constants.SOURCE]; x:StyleSheet.select_navigation[Constants.X]; y:StyleSheet.select_navigation[Constants.Y]; width:StyleSheet.select_navigation[Constants.WIDTH]; height:StyleSheet.select_navigation[Constants.HEIGHT];
            id:navigation;  next:mapview; prev:quit; onClicked: {
                Genivi.preloadMode=true;
                Genivi.route_calculated = false;
                entryMenu("NavigationAppSearch",menu);
            }
        }

        Text {
            x:StyleSheet.mapviewText[Constants.X]; y:StyleSheet.mapviewText[Constants.Y]; width:StyleSheet.mapviewText[Constants.WIDTH]; height:StyleSheet.mapviewText[Constants.HEIGHT];color:StyleSheet.mapviewText[Constants.TEXTCOLOR];styleColor:StyleSheet.mapviewText[Constants.STYLECOLOR]; font.pixelSize:StyleSheet.mapviewText[Constants.PIXELSIZE];
            id:mapviewText;
            style: Text.Sunken;
            smooth: true
            text: Genivi.gettext("Mapview")
             }

        StdButton {
            source:StyleSheet.select_mapview[Constants.SOURCE]; x:StyleSheet.select_mapview[Constants.X]; y:StyleSheet.select_mapview[Constants.Y]; width:StyleSheet.select_mapview[Constants.WIDTH]; height:StyleSheet.select_mapview[Constants.HEIGHT];
            id:mapview;  next:poi; prev:navigation; onClicked: {
				Genivi.data["show_current_position"]=true;
                entryMenu("NavigationAppBrowseMap",menu);
			}
		}

        Text {
            x:StyleSheet.poiText[Constants.X]; y:StyleSheet.poiText[Constants.Y]; width:StyleSheet.poiText[Constants.WIDTH]; height:StyleSheet.poiText[Constants.HEIGHT];color:StyleSheet.poiText[Constants.TEXTCOLOR];styleColor:StyleSheet.poiText[Constants.STYLECOLOR]; font.pixelSize:StyleSheet.poiText[Constants.PIXELSIZE];
            id:poiText;
            style: Text.Sunken;
            smooth: true
            text: Genivi.gettext("Poi")
             }

        StdButton {
            source:StyleSheet.select_poi[Constants.SOURCE]; x:StyleSheet.select_poi[Constants.X]; y:StyleSheet.select_poi[Constants.Y]; width:StyleSheet.select_poi[Constants.WIDTH]; height:StyleSheet.select_poi[Constants.HEIGHT];
            id:poi;  next:trip; prev:mapview; onClicked: {
                entryMenu("NavigationAppPOI",menu);
            }
        }

        Text {
            x:StyleSheet.tripText[Constants.X]; y:StyleSheet.tripText[Constants.Y]; width:StyleSheet.tripText[Constants.WIDTH]; height:StyleSheet.tripText[Constants.HEIGHT];color:StyleSheet.tripText[Constants.TEXTCOLOR];styleColor:StyleSheet.tripText[Constants.STYLECOLOR]; font.pixelSize:StyleSheet.tripText[Constants.PIXELSIZE];
            id:tripText;
            style: Text.Sunken;
            smooth: true
            text: Genivi.gettext("Trip")
             }

        StdButton {
            source:StyleSheet.select_trip[Constants.SOURCE]; x:StyleSheet.select_trip[Constants.X]; y:StyleSheet.select_trip[Constants.Y]; width:StyleSheet.select_trip[Constants.WIDTH]; height:StyleSheet.select_trip[Constants.HEIGHT];
            id:trip;  next:quit; prev:poi;onClicked: {
                entryMenu("NavigationAppTripComputer",menu);
            }
        }

        StdButton {
            source:StyleSheet.quit[Constants.SOURCE]; x:StyleSheet.quit[Constants.X]; y:StyleSheet.quit[Constants.Y]; width:StyleSheet.quit[Constants.WIDTH]; height:StyleSheet.quit[Constants.HEIGHT];textColor:StyleSheet.quitText[Constants.TEXTCOLOR]; pixelSize:StyleSheet.quitText[Constants.PIXELSIZE];
            id:quit; text: Genivi.gettext("Quit");  next:navigation; prev:trip;
            onClicked:{
                Genivi.navigationcore_session_clear(dbusIf);
                Qt.quit(); //for the time being quit
            }
        }
    }

    Component.onCompleted: {
        // Test if the navigation server is connected
        var res=Genivi.navigationcore_session_GetVersion(dbusIf);
        if (res[0] != "error") {
            res=Genivi.navigationcore_session(dbusIf);
        } else {
            Genivi.dump("",res);
        }

    }

}