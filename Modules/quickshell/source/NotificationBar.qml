pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Services.Notifications
import Quickshell.Hyprland

import "singletons" as Singletons
import "widgets" as Widgets

Item {
    id: root
    required property string screen
    height: Singletons.Globals.notifBarTime != 0 && Singletons.Globals.doNotDisturb == false && Singletons.Globals.expanded == false && screen == Hyprland.focusedMonitor.name ? interiorItem.height + 40 : 0

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Singletons.Globals.notifBarTime = 0;
        }
    }
    Widgets.SquigglyBar {
        id: squiggly

        height: root.height
        width: root.width

        content: Item {
            id: interiorItem
            property var emptyNotif: ({
                    summary: "",
                    body: "",
                    appName: "",
                    appIcon: ""
                })
            property var currentNotif: Singletons.Notifications.trackedNotifs.values.length > 0 ? Singletons.Notifications.trackedNotifs.values[0] : emptyNotif
            width: parent.width
            height: intRect.height
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: intRect
                color: Singletons.Globals.primaryColor
                width: parent.width
                height: totalNotif.height + radius
                radius: totalNotif.height * 0.6

                Row {
                    id: totalNotif
                    anchors.verticalCenter: parent.verticalCenter
                    height: totalTextNotif.implicitHeight
                    width: parent.width
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: 10
                    }

                    spacing: 10
                    Image {
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        width: interiorItem.currentNotif.appIcon != "" ? height : 0
                        //source: Quickshell.iconPath(interiorItem.currentNotif?.appIcon, "image-missing")
                        source: interiorItem.currentNotif.appIcon
                    }

                    Column {
                        id: totalTextNotif
                        width: parent.width
                        Text {
                            text: interiorItem.currentNotif.appName
                            font.weight: Font.Medium
                        }
                        Text {
                            text: interiorItem.currentNotif.body
                            visible: interiorItem.currentNotif.body != "" ? true : false
                        }
                        Text {
                            text: interiorItem.currentNotif.summary
                            visible: interiorItem.currentNotif.summary != "" ? true : false
                        }
                    }
                }
            }
        }
    }
}
