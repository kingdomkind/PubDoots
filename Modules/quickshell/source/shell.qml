pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
//@ pragma IconTheme kora

import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Hyprland

import "." as Primary
import "singletons" as Singletons

Scope {
    id: root

    // First call to Hyprland.focusedMonitor is always null (couldn't tell you why), so get that out of the way
    // so notifications in future already have this ready to use
    Component.onCompleted: {
        Hyprland.focusedMonitor;
    }

    GlobalShortcut {
        name: "shellToggle"
        onPressed: {
            Singletons.Globals.expanded = !Singletons.Globals.expanded;
            Singletons.Globals.notifBarTime = 0;
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                id: rootPanel
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                WlrLayershell.layer: WlrLayer.Overlay
                color: "transparent"

                mask: Region {
                    item: topBar.mainPanel
                    Region {
                        item: bottomBar
                    }
                    Region {
                        item: notificationBar
                    }
                }

                Primary.TopBar {
                    id: topBar
                    width: rootPanel.width * 0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Primary.BottomBar {
                    id: bottomBar
                    anchorTo: topBar.mainPanel
                    x: topBar.x + anchorTo.x
                    y: anchorTo.y + anchorTo.height + 10
                    width: anchorTo.width
                }

                Primary.NotificationBar {
                    id: notificationBar
                    width: rootPanel.width * 0.5
                    screen: rootPanel.screen.name
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
