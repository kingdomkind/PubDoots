pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Services.Notifications
import Quickshell.Hyprland

import "singletons" as Singletons
import "components" as Components
import "widgets" as Widgets

Item {
    id: root
    required property string screen
    height: Singletons.Globals.notifBarTime != 0 && Singletons.Globals.doNotDisturb == false && Singletons.Globals.expanded == false && screen == Hyprland.focusedMonitor.name ? interiorItem.height + Singletons.Style.notifBarPadding : 0

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
                color: Singletons.Style.primaryColor
                width: parent.width
                height: totalNotif.height + radius
                radius: totalNotif.height * 0.6

                Row {
                    id: totalNotif
                    anchors.verticalCenter: parent.verticalCenter
                    height: notifRow.implicitHeight
                    width: parent.width
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Singletons.Style.spacingSm
                    }

                    Components.NotificationRow {
                        id: notifRow
                        width: parent.width
                        notification: interiorItem.currentNotif
                    }
                }
            }
        }
    }
}
