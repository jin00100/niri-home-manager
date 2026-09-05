pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: root

    property string pose: ""
    property bool previewMode: false
    property bool playAnimation: false
    property string surface: ""
    property string fallbackSurface: ""
    property string rotatingPose: ""
    readonly property bool active: false

    visible: false
    width: 0
    height: 0
}
