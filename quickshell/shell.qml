// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

//@ pragma ComponentBehavior Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import C1ph3r.Blobs

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            // Vars
            readonly property int topH: 50
            readonly property int leftW: 60
            readonly property int border: 10
            readonly property int rounding: 25
            readonly property int smoothing: 5
            readonly property int bleed: 50
            readonly property double deform: 0.00002

            // Pallet
            readonly property color panelBg: "#1c192d"
            readonly property color widgetBg: '#2c2842'
            readonly property color accent: "#8caaee"
            readonly property color accentDim: Qt.alpha(accent, 0.4)
            readonly property color textOn: "#ffffff"

            // Mut Vars
            property bool powerPopupOpen: false

            anchors { top: true; bottom: true; left: true; right: true }
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            mask: Region {
                Region {
                    x: 0
                    y: 0
                    width: win.width
                    height: win.topH
                    intersection: Intersection.Combine
                }
                Region {
                    x: 0
                    y: win.topH
                    width: win.leftW
                    height: win.height - win.topH
                    intersection: Intersection.Combine
                }
                Region {
                    x: win.width - win.border
                    y: win.topH
                    width: win.border
                    height: win.height - win.topH
                    intersection: Intersection.Combine
                }
                Region {
                    x: win.leftW
                    y: win.height - win.border
                    width: win.width - win.leftW - win.border
                    height: win.border
                    intersection: Intersection.Combine
                }
                Region {
                    x: win.leftW; y: win.topH
                    width: powerPopupOpen ? win.width - win.leftW - win.border : 0
                    height: powerPopupOpen ? win.height - win.topH - win.border : 0
                    intersection: Intersection.Combine
                }
            }

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Qt.alpha(accent, 0.7)
                }

                BlobGroup {
                    id: bg
                    color: win.panelBg
                    smoothing: win.smoothing
                }
                BlobInvertedRect {
                    anchors.fill: parent
                    anchors.margins: -win.bleed
                    group: bg
                    radius: win.rounding
                    borderLeft: win.leftW + win.bleed
                    borderTop: win.topH + win.bleed
                    borderRight: win.border + win.bleed
                    borderBottom: win.border + win.bleed
                }

                RowLayout {
                    id: topBar
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    height: win.topH
                    spacing: 5

                    Item { Layout.preferredWidth: 18 }

                    Text {
                        text: ""
                        color: win.accent
                        font.family: "Fira Code Nerd Font Mono"
                        font.pixelSize: 24
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.preferredWidth: 12 }

                    Item { Layout.fillWidth: true }

                    Rectangle{
                        width: 400
                        height: parent.height - 20
                        radius: parent.height / 2
                        color:win.widgetBg

                        Cava {
                            width: parent.width - 20
                            height: parent.height - 5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            barColor: win.accent
                            barCount: 50
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                ColumnLayout {
                    id: leftBar
                    anchors {
                        top: topBar.bottom
                        left: parent.left
                        bottom: parent.bottom
                    }
                    width: win.leftW
                    spacing: 5

                    Repeater {
                        model: 12

                        BallButton {
                            readonly property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                            readonly property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                            Layout.preferredWidth: win.leftW
                            Layout.preferredHeight: 30
                            Layout.alignment: Qt.AlignHCenter

                            text: ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "", "󰪥", "●"][index]
                            textSize: 14
                            ballRatio: 0.5
                            active: isActive
                            expandOnHover: false

                            textColor: ws ? win.accent : win.accentDim
                            textActiveColor: win.textOn
                            ballColor: win.accentDim
                            ballActiveColor: win.accent

                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        id: clock
                        color: win.accent
                        font.family: "Fira Code Nerd Font Mono"
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                        Layout.rightMargin: 14
                        Timer {
                            interval: 1000; repeat: true; running: true; triggeredOnStart: true
                            onTriggered: clock.text = new Date().toLocaleTimeString(Qt.locale(), " HH:mm:ss")
                            .split(":")
                            .map((v, i) => v + "hms"[i])
                            .join("\n ")
                        }
                    }

                    Text {
                        text: ""
                        color: win.accent
                        font.family: "Fira Code Nerd Font Mono"
                        font.pixelSize: 24
                        Layout.alignment: Qt.AlignHCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: powerPopupOpen = !powerPopupOpen
                        }
                    }

                    Item { Layout.preferredHeight: 5 }
                }

                BlobRect {
                    id: powerPopup
                    deformScale: win.deform
                    group: bg
                    z: 50

                    readonly property double scale: 0.5
                    readonly property double textSize: 100 * scale

                    anchors.right: parent.right
                    anchors.rightMargin: powerPopupOpen ? 0 : -(width - win.border)
                    y: parent.height / 2 - 300 * scale
                    width: 125 * scale
                    height: 600 * scale
                    radius: win.rounding

                    Behavior on anchors.rightMargin { Anim {} }

                    ColumnLayout {
                        id: powerPopupBar
                        anchors {
                            top: parent.top
                            left: parent.left
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: parent.width
                        spacing: 0

                        Repeater {
                            model: 5

                            BallButton {
                                text: ["", "", "", "󰤄", ""][index]
                                textSize: powerPopup.textSize
                                ballRatio: 0.95
                                textColor: win.accent
                                textActiveColor: win.textOn
                                ballColor: Qt.alpha(win.accent, 0.4)
                                ballActiveColor: win.accent

                                Layout.preferredWidth: powerPopup.textSize
                                Layout.preferredHeight: powerPopup.textSize

                                onClicked: {
                                    powerPopupOpen = false
                                    Quickshell.execDetached(["sh", "-c", "sleep 0.15 && " + ["systemctl poweroff", "systemctl reboot", "hyprlock", "hyprlock & systemctl suspend", "hyprctl dispatch exit"][index]])
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                x: win.leftW; y: win.topH
                width: win.width - win.leftW - win.border
                height: win.height - win.topH - win.border
                color: Qt.alpha(panelBg, 0.75)
                visible: powerPopupOpen
                z: -50

                MouseArea {
                    anchors.fill: parent
                    onClicked: powerPopupOpen = false
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors { bottom: true; right: true }
            implicitWidth: dayText.implicitWidth + 32
            implicitHeight: dayText.implicitHeight + 24
            margins.right: 30
            margins.bottom: 30

            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            mask: Region {}

            Text {
                id: dayText
                anchors.centerIn: parent
                color: "#8caaee"
                font.pixelSize: 100
                font.family: "Anurati"
                Timer {
                    interval: 1000; repeat: true; running: true; triggeredOnStart: true
                    onTriggered: dayText.text = new Date().toLocaleDateString(Qt.locale(), "dddd").toUpperCase().split("").join(" ")
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            readonly property int panelH: 180
            readonly property int peek: 5
            readonly property int dwellMs: 500

            property bool revealed: false

            anchors { left: true; bottom: true; right: true }
            implicitHeight: panelH

            margins.bottom: revealed ? 0 : -(panelH - peek)

            Behavior on margins.bottom {
                NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
            }

            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusionMode: ExclusionMode.Normal
            exclusiveZone: panelH - 10

            HoverHandler {
                id: hover
                onHoveredChanged: {
                    if (hovered) {
                        dwell.restart()
                    } else {
                        dwell.stop()
                        panel.revealed = false
                    }
                }
            }

            Timer {
                id: dwell
                interval: panel.dwellMs
                onTriggered: panel.revealed = true
            }

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: peek
                color: "#1c192d"
                opacity: 0
                radius: 0

                Row {
                    anchors.centerIn: parent
                    spacing: 20
                }
            }
        }
    }
}
