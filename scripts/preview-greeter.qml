// SPDX-FileCopyrightText: OmidenOS project
// SPDX-License-Identifier: BSD-3-Clause
//
// Layout preview for the SDDM theme. Loads Main.qml the way the greeter does
// and stands in for the context objects SDDM provides (`config`, `sddm`,
// `userModel`), then grabs the result to a PNG. It is a design check, not a
// boot check: the real objects, the autologin handoff and the greeter's own
// window only exist on the built medium.
//
// Run from the repository root:
//   qmlscene scripts/preview-greeter.qml
// Output: build/greeter-preview.png (1920x1080, build/ is not tracked).

import QtQuick 2.15

Item {
    id: root
    width: 1920
    height: 1080

    QtObject {
        id: config
        property string backdrop: Qt.resolvedUrl("../archiso/airootfs/usr/share/backgrounds/omidenos/greeter.png")
        property string logo: Qt.resolvedUrl("../archiso/airootfs/usr/share/icons/hicolor/256x256/apps/omidenos-logo.png")
        property string title: "OmidenOS"
    }

    QtObject {
        id: sddm
        property bool canReboot: true
        property bool canPowerOff: true
        property string hostName: "omidenos"
        signal loginFailed(string message)
        signal loginSucceeded()
        function login(user, password, session) { console.log("login:", user, session); }
        function reboot() {}
        function powerOff() {}
    }

    QtObject {
        id: userModel
        property string lastUser: "omiden"
    }

    Loader {
        id: themeLoader
        anchors.fill: parent
        source: Qt.resolvedUrl("../archiso/airootfs/usr/share/sddm/themes/omidenos/Main.qml")
    }

    Timer {
        interval: 1200
        running: true
        onTriggered: {
            (themeLoader.item as Item).grabToImage(function(result) {
                result.saveToFile("build/greeter-preview.png");
                Qt.quit();
            });
        }
    }
}
