pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.UPower

import "components" as Components
import "singletons" as Singletons

Rectangle {
    color: "transparent"
    height: Singletons.Globals.expanded ? widgets.implicitHeight : 0
    clip: true
    required property Rectangle anchorTo

    Behavior on height {
        NumberAnimation {
            duration: 100
            easing.type: Easing.Bezier
        }
    }

    RowLayout {
        id: widgets
        anchors.fill: parent

        Components.Panel {
            Layout.preferredWidth: parent.width * 0.25
            Layout.preferredHeight: Singletons.Style.panelHeight

            Flickable {
                anchors.fill: parent
                clip: true
                contentHeight: statsColumn.implicitHeight

                Column {
                    id: statsColumn
                    x: Singletons.Style.spacingSm
                    y: Singletons.Style.spacingSm
                    width: parent.width - Singletons.Style.spacingMd
                    spacing: Singletons.Style.spacingXs

                    Components.SplitText {
                        id: uptimeText
                        leftText.text: "Uptime"
                        rightText.text: Singletons.Globals.getUptime()
                    }

                    Components.SplitText {
                        id: wattsText
                        leftText.text: "Watts"
                        rightText.text: Singletons.Globals.getBatteryWatts()
                    }
                    Components.SplitText {
                        id: chargingText
                        leftText.text: "Charging"
                        rightText.text: Singletons.Globals.getBatteryCharging()
                    }
                    Components.SplitText {
                        id: finishTimeText
                        leftText.text: "Time Left"
                        rightText.text: Singletons.Globals.getBatteryTimeLeft()
                    }
                    Components.SplitText {
                        id: networkText
                        leftText.text: "Network"
                        rightText.text: Singletons.Globals.getNetworkState()
                    }

                    Connections {
                        target: Singletons.SecTimer
                        function onTick() {
                            var now = new Date();
                            Singletons.Globals.setUptimeAsync(uptimeText.rightText);
                            wattsText.rightText.text = Singletons.Globals.getBatteryWatts();
                            chargingText.rightText.text = Singletons.Globals.getBatteryCharging();
                            finishTimeText.rightText.text = Singletons.Globals.getBatteryTimeLeft();
                            networkText.rightText.text = Singletons.Globals.getNetworkState();
                        }
                    }
                }
            }
        }

        ColumnLayout {
            spacing: Singletons.Style.spacingSm
            Layout.preferredWidth: parent.width * 0.75
            Layout.preferredHeight: Singletons.Style.panelHeight
            Components.Panel {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.86

                ListView {
                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }

                    remove: Transition {
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: 300
                        }
                    }

                    addDisplaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 1000
                            easing.type: Easing.OutElastic
                            easing.amplitude: 1.0
                            easing.period: 0.8
                        }

                        // Ensure that any notifications that were previously being added
                        // but were interrupted by a new notification are full opacity
                        NumberAnimation {
                            property: "opacity"
                            to: 1
                            duration: 0
                        }
                    }

                    clip: true
                    anchors {
                        topMargin: Singletons.Style.spacingMd
                        bottomMargin: Singletons.Style.spacingMd
                        leftMargin: Singletons.Style.spacingSm
                        rightMargin: Singletons.Style.spacingSm
                    }
                    anchors.fill: parent
                    model: Singletons.Notifications.trackedNotifs
                    spacing: Singletons.Style.spacingSm
                    delegate: Rectangle {
                        id: notif
                        required property var modelData

                        color: Singletons.Style.primaryColor
                        radius: Singletons.Style.radiusSm

                        height: content.height
                        width: parent.width

                        Item {
                            id: content
                            height: notifRow.implicitHeight + Singletons.Style.spacingMd
                            anchors {
                                left: parent.left
                                right: parent.right
                                leftMargin: Singletons.Style.spacingSm
                                rightMargin: Singletons.Style.spacingSm
                            }

                            Components.NotificationRow {
                                id: notifRow
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                notification: notif.modelData
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: Singletons.Style.footerHeight
                color: "transparent"

                RowLayout {
                    spacing: Singletons.Style.spacingSm
                    anchors.fill: parent
                    Components.Button {
                        id: doNotDisturb
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.height
                        color: Singletons.Globals.doNotDisturb ? Singletons.Style.backgroundColor : Singletons.Style.primaryColor
                        radius: height
                    }

                    Connections {
                        target: doNotDisturb
                        function onClicked() {
                            Singletons.Globals.doNotDisturb = !Singletons.Globals.doNotDisturb;
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: notifNum.implicitWidth + Singletons.Style.spacingMd
                        color: Singletons.Style.primaryColor
                        radius: height

                        Text {
                            id: notifNum
                            text: Singletons.Notifications.trackedNotifs.values.length
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                    }

                    Components.Button {
                        id: clear
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.height * 3
                        text.text: "Clear All"
                        text.font.bold: true
                    }

                    Connections {
                        target: clear
                        function onClicked() {
                            var notifs = Singletons.Notifications.rawNotifs.values;
                            // Iterate backwards as the array is modified as we iterate over it
                            for (var i = notifs.length - 1; i >= 0; i--) {
                                notifs[i].tracked = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
