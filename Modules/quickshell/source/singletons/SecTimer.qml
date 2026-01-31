pragma Singleton
import Quickshell
import QtQuick 2.15
import QtQuick.Controls 2.15

Singleton {
    id: timerSingleton

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timerSingleton.tick();
        }
    }

    signal tick()
}
