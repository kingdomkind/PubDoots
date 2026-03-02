pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.UPower

import "tools" as Tools
import "singletons" as Singletons
import "widgets" as Widgets

Item {
    id: root
    height: Singletons.Globals.expanded ? 50 : 0
    readonly property Rectangle mainPanel: squiggly.mainPanel

    Widgets.SquigglyBar {
        id: squiggly

        height: root.height
        width: root.width

        content: Item {
            anchors.verticalCenter: parent.verticalCenter
            height: 30
            width: parent.width

            Rectangle {
                anchors.left: parent.left
                width: parent.width * 0.15
                height: parent.height

                radius: height
                color: Singletons.Globals.primaryColor

                Text {
                    id: dateText
                    text: Singletons.Globals.getDate()
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 14
                    font.bold: true
                }
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.65
                height: parent.height

                radius: height
                color: Singletons.Globals.primaryColor
                Text {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pointSize: 14
                    text: Singletons.Globals.getTime()
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.15
                height: parent.height
                radius: height
                color: Singletons.Globals.primaryColor

                Text {
                    id: powerText
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: Singletons.Globals.getBatteryPercent()
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 14
                    font.bold: true
                }
            }

            Connections {
                target: Singletons.SecTimer
                function onTick() {
                    timeText.text = Singletons.Globals.getTime();
                    powerText.text = Singletons.Globals.getBatteryPercent();
                    dateText.text = Singletons.Globals.getDate();
                }
            }
        }
    }
}
