// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import C1ph3r.Blobs

ShellRoot {
    id: root

    property real volume: (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
    property real diskUsage: 0
    property real ramUsage: 0
    property real gpuLoad: 0
    property real cpuLoad: 0
    property string _gpuPath: ""
    property string _gpuType: ""

    FileView {
        id: statFile
        path: "/proc/stat"
        blockLoading: true
    }
    FileView {
        id: memFile
        path: "/proc/meminfo"
        blockLoading: true
    }
    FileView {
        id: gpuFile
        path: ""
        blockLoading: true
    }
    PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}
    Process {
        id: diskUsagePoll
        command: ["sh", "-c", "df --output=pcent /"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.diskUsage = this.text.replace(/[^0-9]/g, "")
            }
        }
    }
    Process {
        id: gpuDetect
        command: ["sh", "-c", "for f in /sys/class/drm/card*/device/gpu_busy_percent; do echo amd:$f; exit; done; which nvidia-smi >/dev/null 2>&1 && echo nvidia"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const out = this.text.trim()
                if (out.startsWith("amd:")) {
                    root._gpuType = "amd"
                    root._gpuPath = out.slice(4)
                    gpuFile.path = root._gpuPath
                } else if (out === "nvidia") {
                    root._gpuType = "nvidia"
                }
            }
        }
    }
    Process {
        id: nvidiaPoll
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.gpuLoad = parseFloat(this.text())
        }
    }
    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        property var _prev: null

        onTriggered: {
            statFile.reload()

            const f = statFile.text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
            const idle = f[3] + f[4]
            const total = f.reduce((a, b) => a + b, 0)
            if (_prev) {
                const dTotal = total - _prev.total
                const dIdle = idle - _prev.idle
                root.cpuLoad = dTotal > 0 ? 100 * (1 - dIdle / dTotal) : 0
            }
            _prev = { idle, total }

            memFile.reload()
            const lines = memFile.text().split("\n")
            let memTotal = 0, memAvail = 0
            for (const l of lines) {
                if (l.startsWith("MemTotal:")) memTotal = parseInt(l.split(":")[1])
                else if (l.startsWith("MemAvailable:")) memAvail = parseInt(l.split(":")[1])
            }
            if (memTotal > 0) root.ramUsage = 100 * (1 - memAvail / memTotal)

            if (_gpuType === "amd") {
                gpuFile.reload()
                root.gpuLoad = parseInt(gpuFile.text())
            } else if (_gpuType === "nvidia") {
                nvidiaPoll.running = true
            }
            
            diskUsagePoll.running = true
        }
    }


    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            // Vars
            readonly property int topH: 50
            readonly property int leftW: 50
            readonly property int border: 10
            readonly property int rounding: 25
            readonly property int smoothing: 32
            readonly property int bleed: 50
            readonly property real deform: 0.00002

            // Pallet
            readonly property color panelBg: "#1c192d"
            readonly property color widgetBg: '#2c2842'
            readonly property color accent: "#8caaee"
            readonly property color accentDim: Qt.alpha(accent, 0.4)
            readonly property color accentDark: "#525c87"
            readonly property color warn: '#f0d395'
            readonly property color warnDark: '#9b8861'
            readonly property color crit: "#d67a82"
            readonly property color critDark: '#864f53'
            readonly property color textOn: "#ffffff"

            // Mut Vars
            property int popupOpen: Popup.None

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
                    x: win.leftW
                    y: win.topH
                    width: popupOpen ? win.width - win.leftW - win.border : 0
                    height: popupOpen ? win.height - win.topH - win.border : 0
                    intersection: Intersection.Combine
                }
                Region {
                    x: win.width - win.border - notifRoot.width
                    y: win.topH
                    width: notifRoot.width
                    height: notifRoot.height
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
                z: 2

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
                    z: -20
                }

                RowLayout {
                    id: topBar
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    height: win.topH
                    spacing: 0

                    Item {
                        width: win.leftW
                        height: win.topH

                        Text {
                            text: ""
                            color: win.accent
                            font.family: "Fira Code Nerd Font Mono"
                            font.pixelSize: 28
                            anchors.centerIn: parent
                        }
                    }

                    Item {
                        Layout.preferredWidth: topLeftBar.implicitHeight
                        Layout.preferredHeight: win.topH

                        Rectangle {
                            anchors.centerIn: topLeftBar
                            width: topLeftBar.implicitWidth
                            height: win.topH - 16
                            radius: height / 2
                            color: win.widgetBg
                        }

                        RowLayout {
                            id: topLeftBar
                            anchors {
                                top: parent.top
                                left: parent.left
                            }
                            height: win.topH
                            spacing: 5

                            Item { Layout.preferredWidth: 7.5 }

                            Text {
                                text: "󰏗"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                id: pkgCount
                                text: "0"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }
                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: pkgCounter.running = true
                            }
                            Process {
                                id: pkgCounter
                                command: ["sh", "-c", "checkupdates && yay -Qua"]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        let count = 0;
                                        for (let i = 0; i < this.text.length; i++) {
                                            if (this.text[i] === '\n') count++;
                                        }
                                        pkgCount.text = count
                                    }
                                }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }

                            Svg {
                                source: "./assets/tailscale.svg"
                                Layout.preferredWidth: 12
                                Layout.preferredHeight: 12
                            }
                            Text {
                                id: tailscaleNodesOnline
                                text: "0"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                                visible: text != "0"
                            }
                            Text {
                                id: tailscaleStatus
                                text: "󰖟"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Timer {
                                interval: 500
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: tailscale.running = true
                            }
                            Process {
                                id: tailscale
                                command: ["tailscale", "status", "--json"]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        let parsed = JSON.parse(this.text)
                                        let count = Object.values(parsed.Peer).filter(n => n.Online).length + parsed.Self.Online
                                        let labels = {
                                            Running: "󰖟",
                                            Stopped: "󰪎",
                                            NeedsLogin: "󰕑",
                                            NeedsMachineAuth: "󱉊",
                                            Starting: "󱉊",
                                            NoState: "󱉊",
                                        }
                                        tailscaleStatus.text = labels[parsed.BackendState] ?? "󰕑"
                                        tailscaleNodesOnline.text = count
                                    }
                                }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }

                            Text {
                                text: "WARP"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }
                            Text {
                                id: warpStatus
                                text: "󰖟"
                                color: win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: couldflareWarp.running = true
                            }
                            Process {
                                id: couldflareWarp
                                command: ["warp-cli", "-j", "status"]
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        let parsed = JSON.parse(this.text)
                                        let labels = {
                                            Connected: "󰖟",
                                            Connecting: "󱉊",
                                            Disconnected: "󰪎",
                                            Paused: "",
                                        }
                                        warpStatus.text = labels[parsed.status] ?? "󰕑"
                                    }
                                }
                            }

                            Item { Layout.preferredWidth: 7.5 }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        width: 400
                        height: win.topH - 16
                        radius: height / 2
                        color: win.widgetBg

                        Cava {
                            width: parent.width - 25
                            height: parent.height - 5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            barColor: win.accent
                            barCount: 50
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Item {
                        Layout.preferredWidth: topRightBar.implicitHeight
                        Layout.preferredHeight: win.topH

                        Rectangle {
                            anchors.centerIn: topRightBar
                            width: topRightBar.implicitWidth
                            height: win.topH - 16
                            radius: height / 2
                            color: win.widgetBg
                        }

                        RowLayout {
                            id: topRightBar
                            anchors {
                                top: parent.top
                                right: parent.right
                            }
                            height: win.topH
                            spacing: 5

                            Item { Layout.preferredWidth: 0 }

                            CircleBar {
                                val: root.cpuLoad
                                valDisplayFormat: ""
                                barBgColor: val >= 80 ? win.critDark : val >= 60 ? win.warnDark : win.accentDark
                                barFgColor: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent

                                size: parent.height - 24
                                thickness: 40
                                Text {
                                    text: ""
                                    color: parent.val >= 80 ? win.crit : parent.val >= 60 ? win.warn : win.accent
                                    font.family: "Fira Code Nerd Font Mono"
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                    transform: Translate { x: 0.5; y: 1 }
                                }
                            }
                            Text {
                                property real val: root.cpuLoad
                                Behavior on val { NumAnim { type: NumAnim.Slow; duration: 2000; overshoot: 0.0 } }
                                text: val.toFixed(0) + "%"
                                color: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }
                            
                            CircleBar {
                                val: root.gpuLoad
                                valDisplayFormat: ""
                                barBgColor: val >= 80 ? win.critDark : val >= 60 ? win.warnDark : win.accentDark
                                barFgColor: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent

                                size: parent.height - 24
                                thickness: 40
                                Text {
                                    text: "󰢮"
                                    color: parent.val >= 80 ? win.crit : parent.val >= 60 ? win.warn : win.accent
                                    font.family: "Fira Code Nerd Font Mono"
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                    transform: Translate { x: 0.5; y: 1 }
                                }
                            }
                            Text {
                                property real val: root.gpuLoad
                                Behavior on val { NumAnim { type: NumAnim.Slow; duration: 2000; overshoot: 0.0 } }
                                text: val.toFixed(0) + "%"
                                color: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }

                            CircleBar {
                                val: root.ramUsage
                                valDisplayFormat: ""
                                barBgColor: val >= 80 ? win.critDark : val >= 60 ? win.warnDark : win.accentDark
                                barFgColor: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent

                                size: parent.height - 24
                                thickness: 40
                                Text {
                                    text: ""
                                    color: parent.val >= 80 ? win.crit : parent.val >= 60 ? win.warn : win.accent
                                    font.family: "Fira Code Nerd Font Mono"
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                    transform: Translate { x: 0.5; y: 1 }
                                }
                            }
                            Text {
                                property real val: root.ramUsage
                                Behavior on val { NumAnim { type: NumAnim.Slow; duration: 2000; overshoot: 0.0 } }
                                text: val.toFixed(0) + "%"
                                color: val >= 80 ? win.crit : val >= 60 ? win.warn : win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }

                            CircleBar {
                                val: root.diskUsage
                                valDisplayFormat: ""
                                barBgColor: val >= 90 ? win.critDark : val >= 80 ? win.warnDark : win.accentDark
                                barFgColor: val >= 90 ? win.crit : val >= 80 ? win.warn : win.accent

                                size: parent.height - 24
                                thickness: 40
                                Text {
                                    text: "󰋊"
                                    color: parent.val >= 90 ? win.crit : parent.val >= 80 ? win.warn : win.accent
                                    font.family: "Fira Code Nerd Font Mono"
                                    font.pixelSize: 16
                                    anchors.centerIn: parent
                                }
                            }
                            Text {
                                property real val: root.diskUsage
                                Behavior on val { NumAnim { type: NumAnim.Slow; duration: 2000; overshoot: 0.0 } }
                                text: val.toFixed(0) + "%"
                                color: val >= 90 ? win.crit : val >= 80 ? win.warn : win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }

                            Item {
                                Layout.preferredWidth: 7
                                Layout.preferredHeight: parent.height - 35
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 2
                                    height: parent.height
                                    radius: width / 2
                                    color: win.accent
                                }
                            }

                            CircleBar {
                                val: root.volume
                                valDisplayFormat: ""
                                dur: 1000
                                barBgColor: val >= 120 ? win.critDark : val > 100.1 ? win.warnDark : win.accentDark
                                barFgColor: val >= 120 ? win.crit : val > 100.1 ? win.warn : win.accent

                                size: parent.height - 24
                                thickness: 40
                                Text {
                                    text: parent.val >= 70 ? "" : parent.val >= 30 ? "" : parent.val >= 0.1 ? "" : ""
                                    color: parent.val >= 120 ? win.crit : parent.val > 100.1 ? win.warn : win.accent
                                    font.family: "Fira Code Nerd Font Mono"
                                    font.pixelSize: 16
                                    anchors.centerIn: parent
                                    transform: Translate { y: 0.5 }
                                }
                            }
                            Text {
                                property real val: root.volume
                                Behavior on val { NumAnim { type: NumAnim.Slow; duration: 1000; overshoot: 0.0 } }
                                text: val.toFixed(0) + "%"
                                color: val >= 120 ? win.crit : val > 100.1 ? win.warn : win.accent
                                font.family: "Fira Code Nerd Font Mono"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                                transform: Translate { y: 1 }
                            }

                            Item { Layout.preferredWidth: 2.5 }
                        }
                    }

                    Item { Layout.preferredWidth: 10 }
                }

                ColumnLayout {
                    id: leftBar
                    anchors {
                        top: topBar.bottom
                        left: parent.left
                        bottom: parent.bottom
                    }
                    width: win.leftW
                    spacing: 0

                    Item {
                        Layout.preferredWidth: win.leftW
                        Layout.preferredHeight: hyprlandWorkspaces.implicitHeight

                        Rectangle {
                            anchors.centerIn: hyprlandWorkspaces
                            width: win.leftW - 16
                            height: hyprlandWorkspaces.height
                            radius: width / 2
                            color: win.widgetBg
                        }

                        ColumnLayout {
                            id: hyprlandWorkspaces
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: 12

                                BallButton {
                                    readonly property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                                    readonly property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                                    Layout.preferredWidth: win.leftW - 16
                                    Layout.preferredHeight: win.leftW - 16
                                    Layout.alignment: Qt.AlignHCenter

                                    text: ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "", "󰪥", "●"][index]
                                    textSize: 14
                                    ballRatio: 0.75
                                    active: isActive
                                    expandOnHover: false

                                    textColor: ws ? win.accent : win.accentDim
                                    textActiveColor: win.textOn
                                    ballColor: win.accentDim
                                    ballActiveColor: win.accent

                                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                                }
                            }
                        }
                    }

                    Item {
                        Layout.preferredWidth: win.leftW
                        Layout.fillHeight: true

                        Text {
                            id: currentWin
                            text: " Desktop"
                            color: win.accent
                            font.family: "Fira Code Nerd Font Mono"
                            font.pixelSize: 14
                            anchors.centerIn: parent

                            transform: Rotation {
                                angle: -90
                                origin.x: currentWin.width / 2
                                origin.y: currentWin.height / 2
                            }

                            Timer {
                                interval: 100; repeat: true; running: true; triggeredOnStart: true
                                onTriggered: {
                                    let title = Hyprland.activeToplevel?.title ?? " Desktop"
                                    currentWin.text = title.length > 53 ? title.slice(0, 50).trim() + "..." : title
                                }
                            }
                        }
                    }

                    Text {
                        id: clock
                        color: win.accent
                        font.family: "Fira Code Nerd Font Mono"
                        font.pixelSize: 14

                        Layout.alignment: Qt.AlignHCenter

                        Timer {
                            interval: 1000; repeat: true; running: true; triggeredOnStart: true
                            onTriggered: clock.text = new Date().toLocaleTimeString(Qt.locale(), "HH:mm:ss")
                            .split(":")
                            .map((v, i) => v + "hms"[i])
                            .join("\n")
                        }
                    }

                    Item { Layout.preferredHeight: 5 }

                    Item {
                        Layout.preferredWidth: win.leftW
                        Layout.preferredHeight: leftBottomBar.implicitHeight

                        Rectangle {
                            anchors.centerIn: leftBottomBar
                            width: win.leftW - 16
                            height: leftBottomBar.height
                            radius: width / 2
                            color: win.widgetBg
                        }

                        ColumnLayout {
                            id: leftBottomBar
                            width: parent.width
                            spacing: 0

                            BallButton {
                                text: ""
                                textSize: 18
                                ballRatio: 0.75
                                textColor: win.accent
                                textActiveColor: win.textOn
                                ballColor: Qt.alpha(win.accent, 0.4)
                                ballActiveColor: win.accent

                                Layout.preferredWidth: win.leftW - 16
                                Layout.preferredHeight: win.leftW - 16

                                onClicked: popupOpen = !popupOpen * Popup.Screen
                            }

                            BallButton {
                                text: ""
                                textSize: 18
                                ballRatio: 0.75
                                textColor: win.accent
                                textActiveColor: win.textOn
                                ballColor: Qt.alpha(win.accent, 0.4)
                                ballActiveColor: win.accent

                                Layout.preferredWidth: win.leftW - 16
                                Layout.preferredHeight: win.leftW - 16

                                onClicked: popupOpen = !popupOpen * Popup.Power
                            }
                        }
                    }

                    Item { Layout.preferredHeight: 10 }
                }

                BlobRect {
                    id: notifRoot
                    deformScale: win.deform
                    group: bg
                    z: -10
                    clip: true

                    readonly property real scale: 0.5
                    readonly property real textSize: 50 * scale

                    property real targetHeight: notifsWrapper.implicitHeight

                    y: win.topH
                    height: targetHeight >= 1 ? targetHeight : 0
                    x: parent.width - width - win.border
                    width: notifsWrapper.width
                    radius: win.rounding

                    Behavior on targetHeight { NumAnim { overshoot: 2.0 } }

                    property list<Notification> popups: []

                    NotificationServer {
                        id: notifServer
                        imageSupported: true
                        keepOnReload: false
                        onNotification: (n) => {
                            n.tracked = true;
                            notifRoot.popups = [n, ...notifRoot.popups];
                        }
                    }

                    ColumnLayout {
                        id: notifsWrapper
                        anchors {
                            top: parent.top
                            left: parent.left
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: 600 * notifRoot.scale
                        spacing: 0

                        RectangleButton {
                            text: "Clear all notifications"
                            textSize: 28 * notifRoot.scale
                            textColor: win.accent
                            textActiveColor: win.textOn
                            rectColor: Qt.alpha(win.accent, 0.4)
                            rectActiveColor: win.accent
                            visible: notifRoot.popups.length > 0

                            onClicked: notifRoot.popups = []
                        }

                        Item { Layout.preferredHeight: 10 * notifRoot.scale * (notifRoot.popups.length > 0) }

                        Repeater {
                            model: notifRoot.popups.slice(0, 5)

                            Item {
                                id: card
                                required property Notification modelData

                                property bool dismissing: false

                                Layout.fillWidth: true
                                height: content.implicitHeight

                                clip: true

                                transform: Translate { id: slide; x: 0 }

                                Behavior on y { NumAnim {} }

                                ParallelAnimation {
                                    id: slideOut
                                    NumAnim {
                                        target: slide
                                        property: "x"
                                        to: notifRoot.width
                                        type: NumAnim.Fast
                                        overshoot: 2.0
                                    }
                                    NumAnim {
                                        target: card
                                        property: "height"
                                        to: 0
                                        type: NumAnim.Fast
                                        overshoot: 2.0
                                    }
                                    onFinished: {
                                        card.modelData.expire();
                                        notifRoot.popups = notifRoot.popups.filter(x => x !== card.modelData);
                                    }
                                }

                                Item { Layout.preferredHeight: 10 * notifRoot.scale }

                                ColumnLayout {
                                    id: content
                                    anchors {
                                        top: parent.top
                                        left: parent.left
                                    }
                                    width: notifsWrapper.width
                                    spacing: 10 * notifRoot.scale

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 10 * notifRoot.scale

                                        Item { Layout.preferredWidth: 10 * notifRoot.scale }

                                        Image {
                                            source: card.modelData.image
                                            Layout.preferredWidth: 60 * notifRoot.scale
                                            Layout.preferredHeight: 60 * notifRoot.scale
                                            visible: card.modelData.image !== ""
                                        }

                                        Text {
                                            text: modelData.summary
                                            color: {
                                                if (modelData.urgency === NotificationUrgency.Critical) {
                                                    return win.crit
                                                }
                                                return win.accent
                                            }
                                            font.family: "Fira Code Nerd Font Mono"
                                            font.pixelSize: 28 * notifRoot.scale
                                            wrapMode: Text.Wrap
                                            Layout.fillWidth: true
                                            Layout.preferredWidth: 0
                                        }

                                        Item { Layout.preferredWidth: 10 * notifRoot.scale }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 10 * notifRoot.scale

                                        Item { Layout.preferredWidth: 20 * notifRoot.scale }

                                        Text {
                                            text: modelData.body
                                            color: {
                                                if (modelData.urgency === NotificationUrgency.Critical) {
                                                    return win.crit
                                                }
                                                return win.accent
                                            }
                                            font.family: "Fira Code Nerd Font Mono"
                                            font.pixelSize: 24 * notifRoot.scale
                                            wrapMode: Text.Wrap
                                            Layout.fillWidth: true
                                            Layout.preferredWidth: 0
                                        }

                                        Item { Layout.preferredWidth: 20 * notifRoot.scale }
                                    }

                                    Item { Layout.preferredHeight: 0 }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: slideOut.start()
                                }
                            }
                        }

                        Text {
                            text: "And " + (notifRoot.popups.length - 5) + " more"
                            color: win.accent
                            font.family: "Fira Code Nerd Font Mono"
                            font.pixelSize: 28 * notifRoot.scale
                            wrapMode: Text.Wrap
                            Layout.alignment: Qt.AlignHCenter
                            visible: notifRoot.popups.length > 5
                        }

                        Item { Layout.preferredHeight: 10 * notifRoot.scale * (notifRoot.popups.length > 5) }

                        Item { Layout.fillHeight: true }
                    }
                }

                BlobRect {
                    id: powerPopout
                    deformScale: win.deform
                    group: bg
                    z: -10
                    clip: true

                    readonly property real scale: 0.75
                    readonly property real textSize: 100 * scale

                    property real targetWidth: popupOpen == Popup.Power ? 125 * scale : -1

                    y: parent.height / 2 - 300 * scale
                    width: targetWidth >= 1 ? targetWidth : 0
                    x: parent.width - width - win.border
                    height: 600 * scale
                    radius: win.rounding

                    Behavior on targetWidth { NumAnim { overshoot: 2.0 } }

                    ColumnLayout {
                        anchors {
                            top: parent.top
                            left: parent.left
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: 125 * powerPopout.scale
                        spacing: 0

                        Repeater {
                            model: 5

                            BallButton {
                                text: ["", "", "", "󰤄", ""][index]
                                textSize: powerPopout.textSize
                                ballRatio: 0.95
                                textColor: win.accent
                                textActiveColor: win.textOn
                                ballColor: Qt.alpha(win.accent, 0.4)
                                ballActiveColor: win.accent

                                onClicked: {
                                    popupOpen = Popup.None
                                    Quickshell.execDetached(["sh", "-c", "sleep 0.15 && " + ["systemctl poweroff", "systemctl reboot", "hyprlock", "hyprlock & systemctl suspend", "hyprctl dispatch exit"][index]])
                                }
                            }
                        }
                    }
                }

                BlobRect {
                    id: screenPopout
                    deformScale: win.deform
                    group: bg
                    z: -10
                    clip: true

                    readonly property real scale: 0.5
                    readonly property real textSize: 32 * scale

                    property real targetWidth: popupOpen == Popup.Screen ? content.implicitWidth + 20 * scale : -1

                    x: win.leftW
                    y: parent.height - 250 * scale
                    width: targetWidth >= 1 ? targetWidth : 0
                    height: 250 * scale
                    radius: win.rounding

                    Behavior on targetWidth { NumAnim { overshoot: 2.0 } }

                    ColumnLayout {
                        id: content
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: content.implicitWidth + 10 * scale
                        spacing: 0

                        Item { Layout.preferredHeight: 7.5 * scale }

                        Repeater {
                            model: 4

                            RectangleButton {
                                text: ["Caf", "Decaf", "Caf 1 min", "Caf 5 min"][index]
                                textSize: screenPopout.textSize
                                textColor: win.accent
                                textActiveColor: win.textOn
                                rectColor: Qt.alpha(win.accent, 0.4)
                                rectActiveColor: win.accent
                                Layout.alignment: Qt.AlignLeft

                                onClicked: {
                                    popupOpen = Popup.None
                                    Quickshell.execDetached(["sh", "-c", "sleep 0.15 && " + ["echo 'hai :3'"][index]])
                                }
                            }
                        }

                        Item { Layout.preferredHeight: 7.5 * scale + win.border }
                    }
                }
            }

            Rectangle {
                x: win.leftW; y: win.topH
                width: win.width - win.leftW - win.border
                height: win.height - win.topH - win.border
                color: Qt.alpha(panelBg, 0.75)
                visible: popupOpen
                z: -50

                Item {
                    id: scanLines
                    anchors.fill: parent

                    property real offset: 0.0
                    readonly property int barSize: 3

                    Repeater {
                        model: Math.ceil(parent.height / (scanLines.barSize * 2))

                        Rectangle {
                            width: parent.width
                            height: scanLines.barSize
                            color: Qt.alpha(win.accent, 0.1)
                            y: index * (scanLines.barSize * 2) + scanLines.offset
                            z: -100
                        }
                    }

                    Timer {
                        interval: 10; repeat: true; running: popupOpen; triggeredOnStart: true
                        onTriggered: scanLines.offset = (scanLines.offset + 0.25) % (scanLines.barSize * 2)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: popupOpen = Popup.None
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
            implicitWidth: content.implicitWidth + 32
            implicitHeight: content.implicitHeight + 24
            margins.right: 30
            margins.bottom: 30

            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            mask: Region {}

            RowLayout {
                id: content
                spacing: 50

                Gauge {
                    labelText: "RAM"
                    val: root.ramUsage

                    size: 150

                    transform: Translate { y: 15 }
                }

                Gauge {
                    labelText: "CPU"
                    val: root.cpuLoad

                    size: 150

                    transform: Translate { y: 15 }
                }

                Text {
                    id: dayText
                    anchors.right: parent.right
                    color: "#8caaee"
                    font.pixelSize: 100
                    font.family: "Anurati"
                    Layout.preferredWidth: implicitWidth
                    Layout.preferredHeight: implicitHeight

                    Timer {
                        interval: 1000; repeat: true; running: true; triggeredOnStart: true
                        onTriggered: dayText.text = new Date().toLocaleDateString(Qt.locale(), "dddd").toUpperCase().split("").join(" ")
                    }
                }
            }
        }
    }
}
