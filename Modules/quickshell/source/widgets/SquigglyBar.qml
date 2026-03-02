pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.UPower

import "../tools" as Tools
import "../singletons" as Singletons

Item {
    id: topBar
    property alias mainPanel: topPanel
    property Item content
    property int invertCornerWidth: 100

    onContentChanged: {
        if (content) {
            content.parent = topPanel
        }
    }

    Rectangle {
        id: topPanel

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        width: 0.8 * topBar.width
        color: Singletons.Globals.backgroundColor
        height: topBar.height
        clip: true

        Behavior on height {
            NumberAnimation {
                duration: !Singletons.Globals.expanded ? 1000 : 100
                easing.type: !Singletons.Globals.expanded ? Easing.OutElastic : Easing.Bezier
                easing.amplitude: 1.0
                easing.period: 0.5

            }
        }
    }

    Rectangle {
        id: leftPanel

        anchors {
            top: topPanel.top
            bottom: topPanel.bottom
            right: topPanel.left
        }
        width: topBar.invertCornerWidth
        color: "transparent"

        Tools.Rounder {
            cornerType: "cubic"
            cornerHeight: parent.height
            cornerWidth: parent.width
            color: Singletons.Globals.backgroundColor
            corners: [0]
        }
    }

    Rectangle {
        id: rightPanel
        anchors {
            top: topPanel.top
            bottom: topPanel.bottom
            left: topPanel.right   
        }
        width: topBar.invertCornerWidth
        color: "transparent"

        Tools.Rounder {
            cornerType: "cubic"
            cornerHeight: parent.height
            cornerWidth: parent.width
            color: Singletons.Globals.backgroundColor
            corners: [1]
        }
    }
}
