// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2026 c1ph3rC4t

import QtQuick

NumberAnimation {
    enum Type { Fast, Norm, Slow }
    property int type: NumAnim.Norm
    property real overshoot: 1.0

    readonly property var _base: type === NumAnim.Fast ? [0.42, 0.21]
                                : type === NumAnim.Slow ? [0.39, 0.35]
                                : [0.38, 0.22]

    duration: type === NumAnim.Fast ? 350
            : type === NumAnim.Slow ? 650
            : 500
    easing.type: Easing.BezierSpline
    easing.bezierCurve: [
        _base[0], 1.0 + 0.25 * overshoot,
        _base[1], 1.0 + (0.9 - 1.0) * overshoot,
        1.0, 1.0
    ]
}
