import QtQuick
import "../singletons" as Singletons

Item {
    id: root
    property var notification
    property int iconSize: Singletons.Style.iconSize
    property int rowSpacing: Singletons.Style.spacingSm

    width: parent ? parent.width : implicitWidth
    height: textColumn.implicitHeight
    implicitHeight: textColumn.implicitHeight

    Row {
        id: row
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        width: parent ? parent.width : implicitWidth
        height: textColumn.implicitHeight
        spacing: root.rowSpacing

        Image {
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            width: root.notification && root.notification.appIcon != "" ? height : 0
            source: root.notification ? root.notification.appIcon : ""
        }

        Column {
            id: textColumn
            width: parent ? parent.width : implicitWidth

            Text {
                text: root.notification ? root.notification.appName : ""
                font.weight: Font.Medium
            }
            Text {
                text: root.notification ? root.notification.body : ""
                visible: root.notification && root.notification.body != "" ? true : false
            }
            Text {
                text: root.notification ? root.notification.summary : ""
                visible: root.notification && root.notification.summary != "" ? true : false
            }
        }
    }
}
