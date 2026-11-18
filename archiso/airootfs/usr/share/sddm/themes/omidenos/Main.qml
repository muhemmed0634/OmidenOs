// SPDX-FileCopyrightText: OmidenOS project
// SPDX-License-Identifier: BSD-3-Clause
//
// SDDM greeter theme. QtQuick primitives only: no QtQuick.Controls and no
// `SddmComponents` import, so the theme loads with the modules SDDM
// already depends on (qt6-base, qt6-declarative) and nothing else.
//
// One session exists in v1.0 (ADR-0010), so there is no session picker;
// the greeter hands SDDM the last used session index and lets SDDM fall
// back to its own default when that is unknown.
//
// Colours come from theme.conf (keys mirrored from branding/palette.toml,
// see ADR-0012). Every lookup falls back to the same literal, so a theme
// file without the palette keys still paints a complete screen.

import QtQuick 2.15
import QtQuick.Window 2.15

Rectangle {
    id: root

    width: (parent && parent.width > 0) ? parent.width : Screen.width
    height: (parent && parent.height > 0) ? parent.height : Screen.height

    // `config` is SDDM's theme.conf object. `typeof` keeps the binding from
    // throwing when the file is loaded outside the greeter.
    function setting(key, fallback) {
        if (typeof config === "undefined" || config === null)
            return fallback;
        var value = config[key];
        if (value === undefined || value === null || value === "")
            return fallback;
        return value;
    }

    property color colorInk: setting("ink", "#06020F")
    property color colorSurface: setting("surface", "#120A2B")
    property color colorSurfaceRaised: setting("surface_raised", "#1B123E")
    property color colorLine: setting("line", "#2C1F55")
    property color colorForeground: setting("foreground", "#EDE9FE")
    property color colorMuted: setting("muted", "#9C90C4")
    property color colorAccent: setting("accent", "#8B5CF6")
    property color colorAccentBright: setting("accent_bright", "#A78BFA")
    property color colorDanger: setting("danger", "#FF8A8A")

    color: colorInk

    // Backdrop: the project artwork, cropped to the screen.
    Image {
        id: backdrop
        anchors.fill: parent
        source: root.setting("backdrop", "/usr/share/backgrounds/omidenos/greeter.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        smooth: true
    }

    // Scrim on the right: the card sits over the artwork's dark side and
    // stays readable on any replacement backdrop.
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.46
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop {
                position: 1.0
                color: Qt.rgba(root.colorInk.r, root.colorInk.g, root.colorInk.b, 0.92)
            }
        }
    }

    // Clock: the only element on the artwork's side, so the crest is not
    // crowded.
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: Math.round(root.height * 0.07)
        spacing: 4

        Text {
            id: clock
            color: root.colorForeground
            font.pixelSize: Math.round(root.height * 0.062)
            font.weight: Font.Light
            text: Qt.formatTime(new Date(), "HH:mm")
        }
        Text {
            id: dateLine
            color: root.colorMuted
            font.pixelSize: Math.round(root.height * 0.019)
            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            clock.text = Qt.formatTime(new Date(), "HH:mm");
            dateLine.text = Qt.formatDate(new Date(), "dddd, d MMMM yyyy");
        }
    }

    // Login card.
    Rectangle {
        id: card
        width: Math.min(440, Math.round(root.width * 0.34))
        height: cardColumn.implicitHeight + 72
        anchors.right: parent.right
        anchors.rightMargin: Math.round(root.width * 0.05)
        anchors.verticalCenter: parent.verticalCenter
        radius: 20
        color: Qt.rgba(root.colorSurface.r, root.colorSurface.g, root.colorSurface.b, 0.94)
        border.width: 1
        border.color: Qt.rgba(root.colorAccent.r, root.colorAccent.g, root.colorAccent.b, 0.35)
        opacity: 0

        Component.onCompleted: opacity = 1
        Behavior on opacity { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }

        Column {
            id: cardColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 36
            spacing: 12

            Image {
                width: Math.round(card.width * 0.2)
                height: width
                source: root.setting("logo", "/usr/share/icons/hicolor/256x256/apps/omidenos-logo.png")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                text: root.setting("title", "OmidenOS")
                color: root.colorForeground
                font.pixelSize: 26
                font.weight: Font.DemiBold
            }

            Item { width: 1; height: 6 }

            Text {
                text: "Username"
                color: root.colorMuted
                font.pixelSize: 12
            }

            Rectangle {
                id: userBox
                width: parent.width
                height: 50
                radius: 10
                color: root.colorSurfaceRaised
                border.width: 1
                border.color: userInput.activeFocus ? root.colorAccent : root.colorLine

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    visible: userInput.text.length === 0
                    color: root.colorMuted
                    font.pixelSize: 16
                    text: "Username"
                }

                TextInput {
                    id: userInput
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    verticalAlignment: TextInput.AlignVCenter
                    color: root.colorForeground
                    font.pixelSize: 16
                    selectByMouse: true
                    text: (typeof userModel !== "undefined" && userModel.lastUser)
                          ? userModel.lastUser : "omiden"
                    KeyNavigation.tab: passwordInput
                    KeyNavigation.backtab: passwordInput
                    onAccepted: passwordInput.forceActiveFocus()
                }
            }

            Text {
                text: "Password"
                color: root.colorMuted
                font.pixelSize: 12
            }

            Rectangle {
                id: passwordBox
                width: parent.width
                height: 50
                radius: 10
                color: root.colorSurfaceRaised
                border.width: 1
                border.color: passwordInput.activeFocus ? root.colorAccent : root.colorLine

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    visible: passwordInput.text.length === 0
                    color: root.colorMuted
                    font.pixelSize: 16
                    text: "Password"
                }

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    verticalAlignment: TextInput.AlignVCenter
                    color: root.colorForeground
                    font.pixelSize: 16
                    echoMode: TextInput.Password
                    passwordCharacter: "\u2022"
                    selectByMouse: true
                    KeyNavigation.tab: userInput
                    KeyNavigation.backtab: userInput
                    onAccepted: root.attemptLogin()

                    Component.onCompleted: forceActiveFocus()
                }
            }

            Text {
                id: hint
                width: parent.width
                text: "Caps Lock is on"
                color: root.colorMuted
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                visible: (typeof keyboard !== "undefined") && keyboard.capsLock === true
            }

            Text {
                id: errorLabel
                width: parent.width
                text: ""
                color: root.colorDanger
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                visible: text.length > 0
            }

            Rectangle {
                id: loginButton
                width: parent.width
                height: 50
                radius: 10
                color: loginArea.containsMouse ? root.colorAccentBright : root.colorAccent

                Text {
                    anchors.centerIn: parent
                    text: "Sign in"
                    color: root.colorInk
                    font.pixelSize: 16
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: loginArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.attemptLogin()
                }
            }

            Item { width: 1; height: 12 }

            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "Reboot"
                    color: powerReboot.containsMouse ? root.colorForeground : root.colorMuted
                    font.pixelSize: 12
                    visible: (typeof sddm !== "undefined") && sddm.canReboot === true

                    MouseArea {
                        id: powerReboot
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: sddm.reboot()
                    }
                }

                Text {
                    text: "Power off"
                    color: powerOff.containsMouse ? root.colorForeground : root.colorMuted
                    font.pixelSize: 12
                    visible: (typeof sddm !== "undefined") && sddm.canPowerOff === true

                    MouseArea {
                        id: powerOff
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: sddm.powerOff()
                    }
                }
            }
        }
    }

    function attemptLogin() {
        if (passwordInput.text.length === 0) {
            passwordInput.forceActiveFocus();
            return;
        }

        errorLabel.text = "";

        var session = -1;
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex !== undefined)
            session = sessionModel.lastIndex;

        sddm.login(userInput.text, passwordInput.text, session);
    }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null

        function onLoginFailed(message) {
            errorLabel.text = (message && message.length > 0) ? message : "Login failed";
            passwordInput.text = "";
            passwordInput.forceActiveFocus();
        }

        function onLoginSucceeded() {
            errorLabel.text = "";
        }
    }
}
