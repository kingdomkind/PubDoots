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

        Rectangle {
            Layout.preferredWidth: parent.width * 0.25
            Layout.preferredHeight: 300
            color: Singletons.Globals.backgroundColor
            radius: 20

            Flickable {
                anchors.fill: parent
                clip: true
                contentHeight: statsColumn.implicitHeight

                Column {
                    id: statsColumn
                    x: 10
                    y: 10
                    width: parent.width - 20
                    spacing: 5

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

                    Connections {
                        target: Singletons.SecTimer
                        function onTick() {
                            var now = new Date();
                            Singletons.Globals.setUptimeAsync(uptimeText.rightText);
                            wattsText.rightText.text = Singletons.Globals.getBatteryWatts();
                            chargingText.rightText.text = Singletons.Globals.getBatteryCharging();
                            finishTimeText.rightText.text = Singletons.Globals.getBatteryTimeLeft();
                        }
                    }
                }
            }
        }

        ColumnLayout {
            spacing: 10
            Layout.preferredWidth: parent.width * 0.75
            Layout.preferredHeight: 300
            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.86
                color: Singletons.Globals.backgroundColor
                radius: 20

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
                        topMargin: 20
                        bottomMargin: 20
                        leftMargin: 10
                        rightMargin: 10
                    }
                    anchors.fill: parent
                    model: Singletons.Notifications.trackedNotifs
                    spacing: 10
                    delegate: Rectangle {
                        id: notif
                        required property var modelData

                        color: Singletons.Globals.primaryColor
                        radius: 10

                        height: content.height
                        width: parent.width

                        Item {
                            id: content
                            height: totalNotif.height + 20
                            anchors {
                                left: parent.left
                                right: parent.right
                                leftMargin: 10
                                rightMargin: 10
                            }

                            Row {
                                id: totalNotif
                                anchors.verticalCenter: parent.verticalCenter
                                height: totalTextNotif.implicitHeight
                                width: parent.width
                                spacing: 10

                                Image {
                                    height: 32
                                    anchors.verticalCenter: parent.verticalCenter

                                    width: notif.modelData.appIcon != "" ? height : 0
                                    //source: Quickshell.iconPath(notif.modelData?.appIcon, "image-missing")
                                    source: notif.modelData.appIcon
                                }

                                Column {
                                    id: totalTextNotif
                                    width: parent.width
                                    Text {
                                        text: notif.modelData.appName
                                        font.weight: Font.Medium
                                    }
                                    Text {
                                        text: notif.modelData.body
                                        visible: notif.modelData.body != "" ? true : false
                                    }
                                    Text {
                                        text: notif.modelData.summary
                                        visible: notif.modelData.summary != "" ? true : false
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 30
                color: "transparent"

                RowLayout {
                    spacing: 10
                    anchors.fill: parent
                    Components.Button {
                        id: doNotDisturb
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.height
                        color: Singletons.Globals.doNotDisturb ? Singletons.Globals.backgroundColor : Singletons.Globals.primaryColor
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
                        Layout.preferredWidth: notifNum.implicitWidth + 30
                        color: Singletons.Globals.primaryColor
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
