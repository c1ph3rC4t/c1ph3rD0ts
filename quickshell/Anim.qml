import QtQuick

NumberAnimation {
    enum Type { Fast, Norm, Slow }
    property int type: Anim.Norm

    duration: type === Anim.Fast ? 350
        : type === Anim.Slow ? 650
        : 500

    easing.type: Easing.BezierSpline
    easing.bezierCurve: type === Anim.Fast ? [0.42, 1.67, 0.21, 0.9, 1.0, 1.0]
        : type === Anim.Slow ? [0.39, 1.29, 0.35, 0.98, 1.0, 1.0]
        : [0.38, 1.21, 0.22, 1.0, 1.0, 1.0]
}
