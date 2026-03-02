pragma Singleton
import QtQuick
import "." as Singletons

QtObject {
    readonly property color backgroundColor: Qt.rgba(15 / 255, 14 / 255, 14 / 255, 0.5)
    readonly property color primaryColor: Qt.rgba(255 / 255, 218 / 255, 182 / 255, 1)

    readonly property int spacingXs: Singletons.Globals.px(5)
    readonly property int spacingSm: Singletons.Globals.px(10)
    readonly property int spacingMd: Singletons.Globals.px(20)

    readonly property int radiusSm: Singletons.Globals.px(10)
    readonly property int radiusMd: Singletons.Globals.px(20)

    readonly property int panelHeight: Singletons.Globals.px(300)
    readonly property int footerHeight: Singletons.Globals.px(30)

    readonly property int barHeight: Singletons.Globals.px(50)
    readonly property int barContentHeight: Singletons.Globals.px(30)
    readonly property int notifBarPadding: Singletons.Globals.px(40)

    readonly property int iconSize: Singletons.Globals.px(32)

    readonly property int splitTextHeight: Singletons.Globals.px(20)

    readonly property int textSm: Singletons.Globals.sp(10)
    readonly property int textMd: Singletons.Globals.sp(14)

    readonly property int invertCornerWidth: Singletons.Globals.px(100)
}
