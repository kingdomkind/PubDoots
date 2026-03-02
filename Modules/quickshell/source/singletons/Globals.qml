pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland

Singleton {
    readonly property color backgroundColor: Qt.rgba(15 / 255, 14 / 255, 14 / 255, 0.5)
    readonly property color primaryColor: Qt.rgba(255 / 255, 218 / 255, 182 / 255, 1)

    property bool expanded: false
    property int notifBarTime: 0
    property bool doNotDisturb: false

    function readFile(fileUrl, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", fileUrl, false);
        xhr.send();
        return xhr.responseText;
    }

    function readFileAsync(fileUrl, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", fileUrl);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                callback(xhr.responseText);
            }
        };
        xhr.send();
    }

    function formatSeconds(initial) {
        let seconds = Math.floor(initial);

        const d = Math.floor(seconds / 86400);
        seconds %= 86400;

        const h = Math.floor(seconds / 3600);
        seconds %= 3600;

        const m = Math.floor(seconds / 60);
        const s = seconds % 60;

        if (d > 0)
            return `${d}d ${h}h ${m}m ${s}s`;

        if (h > 0)
            return `${h}h ${m}m ${s}s`;

        if (m > 0)
            return `${m}m ${s}s`;

        return `${s}s`;
    }

    function formatUptime(uptime) {
        return parseFloat(uptime.split(" ")[0])
    }

    function getUptime() {
        return formatSeconds(formatUptime(readFile("/proc/uptime")))
    }

    function setUptimeAsync(text) {
        readFileAsync("/proc/uptime", function(uptime) {
            text.text = formatSeconds(formatUptime(uptime))
        })
    }

    function getBatteryPercent() {
        return (UPower.displayDevice.percentage * 100).toFixed(1) + "%";
    }

    function getBatteryWatts() {
        return UPower.displayDevice.changeRate.toFixed(2) + "W" + " / " + UPower.displayDevice.energy.toFixed(2) + "W";
    }

    function getBatteryCharging() {
        if (UPower.displayDevice.timeToEmpty == 0) {
            return "Yes"
        } else {
            return "No"
        }
    }

    function getBatteryTimeLeft() {
        if (UPower.displayDevice.timeToEmpty == 0) {
            return formatSeconds(UPower.displayDevice.timeToFull)
        } else {
            return formatSeconds(UPower.displayDevice.timeToEmpty)
        }
    }

    function getTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss");
    }

    function getDate() {
        return Qt.formatDateTime(new Date(), "dd MMM");
    }
}
