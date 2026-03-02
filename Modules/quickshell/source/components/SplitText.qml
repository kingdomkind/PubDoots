import QtQuick
import QtQuick.Layouts
import "../singletons" as Singletons

Rectangle {
    color: "transparent"
    height: Singletons.Style.splitTextHeight
    property alias leftText: leftText
    property alias rightText: rightText
    anchors.left: parent.left
    anchors.right: parent.right

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
        }

        Text {
            id: leftText
            color: Singletons.Style.primaryColor
            font.pointSize: Singletons.Style.textSm
        }
       
        Item {
            Layout.fillWidth: true   // pushes right text to the side
        }

        Rectangle {
            color: Singletons.Style.primaryColor
            Layout.preferredWidth: rightText.width + Singletons.Style.spacingSm
            Layout.preferredHeight: rightText.height
            radius: height

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                id: rightText
                font.pointSize: Singletons.Style.textSm
                font.bold: true
            }
        }
    }
}
