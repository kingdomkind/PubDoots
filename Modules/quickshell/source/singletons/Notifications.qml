pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "." as Singletons

Singleton {
    property ScriptModel trackedNotifs: ScriptModel {
        values: {
            [...server.trackedNotifications.values].reverse();
        }
    }
    property alias rawNotifs: server.trackedNotifications

    NotificationServer {
        id: server

        onNotification: function (notification) {
            notification.tracked = true;
            Singletons.Globals.notifBarTime = 5;

            Qt.callLater(function () {
                var timer = Qt.createQmlObject('import QtQuick; Timer { interval: 6000000; running: true; repeat: false }', server);
                timer.triggered.connect(function () {
                    notification.tracked = false;
                    timer.destroy();
                });
            });
        }
    }

    Connections {
        target: Singletons.SecTimer
        function onTick() {
            Singletons.Globals.notifBarTime = Math.max(Singletons.Globals.notifBarTime - 1, 0);
        }
    }
}
