import QtQuick

import "../singletons" as Singletons

Rectangle {
    id: button
    readonly property alias text: buttonText
    property color baseColor: Singletons.Globals.primaryColor

    radius: height
    signal clicked

    color: mouseArea.pressed ? Qt.darker(baseColor, 1.05) : (mouseArea.containsMouse ? Qt.lighter(baseColor, 1.05) : baseColor)

    Behavior on color {
        ColorAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    Text {
        id: buttonText
        text: button.text
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
