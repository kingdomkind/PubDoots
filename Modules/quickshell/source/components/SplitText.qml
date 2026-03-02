import QtQuick
import QtQuick.Layouts
import "../singletons" as Singletons

Rectangle {
    color: "transparent"
    height: Singletons.Globals.px(20)
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
            color: Singletons.Globals.primaryColor
            font.pointSize: Singletons.Globals.sp(10)
        }
       
        Item {
            Layout.fillWidth: true   // pushes right text to the side
        }

        Rectangle {
            color: Singletons.Globals.primaryColor
            Layout.preferredWidth: rightText.width + Singletons.Globals.px(10)
            Layout.preferredHeight: rightText.height
            radius: height

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                id: rightText
                font.pointSize: Singletons.Globals.sp(10)
                font.bold: true
            }
        }
    }
}
