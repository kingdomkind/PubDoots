import QtQuick
import "../singletons" as Singletons

Rectangle {
    id: panel
    property color panelColor: Singletons.Style.backgroundColor
    property int panelRadius: Singletons.Style.radiusMd

    color: panelColor
    radius: panelRadius
}
