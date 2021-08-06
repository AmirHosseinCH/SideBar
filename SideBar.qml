import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Item {
    id: sideBar

    width: 105
    height: 700
    state: 'close'
    anchors.centerIn: parent

    states: [
        State {
            name: 'open'

            PropertyChanges {
                target: sideBar
                width: 270
            }

            PropertyChanges {
                target: timer
                index: 0
            }
        },
        State {
            name: 'close'

            PropertyChanges {
                target: sideBar
                width: 105
            }

            PropertyChanges {
                target: timer
                index: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: 'close'
            to: 'open'

            NumberAnimation {
                properties: 'width'
                duration: 300
                easing.type: Easing.OutCubic
            }

            ScriptAction {
                script: {
                    timer.start();
                }
            }
        },
        Transition {
            from: 'open'
            to: 'close'

            SequentialAnimation {

                ScriptAction {
                    script: {
                        timer.start();
                    }
                }

                PauseAnimation {
                    duration: 600
                }

                NumberAnimation {
                    properties: 'width'
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    ]

    Timer {
        id: timer

        property int index: 0

        interval: 10

        onTriggered: {
            if (sideBar.state == 'open')
                columnItems.itemAt(index).state = 'left';
            else
                columnItems.itemAt(index).state = 'middle';

            if (++index != 9)
                timer.start();
        }
    }

    Rectangle {
        id: body

        radius: 10
        color: '#FFFFFF'
        anchors.fill: parent

        ColumnLayout {
            id: buttonColumn

            width: parent.width
            spacing: 20
            anchors { top: parent.top; topMargin: 30 }

            Repeater {
                id: columnItems

                model: ['Menu', 'Search', 'Home', 'Explore', 'Notifications', 'Bookmarks', 'Messages', 'Profile', 'Setting']
                delegate: Rectangle {
                    id: button

                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    radius: 10
                    color: buttonMouseArea.containsMouse ? '#f0f0f0' : '#ffffff'
                    Layout.alignment: Qt.AlignLeft
                    Layout.topMargin: model.index === 1 ? 20 : 0
                    state: 'middle'

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    states: [
                        State {
                            name: 'left'

                            PropertyChanges {
                                target: button
                                Layout.leftMargin: 10
                                Layout.preferredWidth: model.index !== 0 ? 240 : 50
                            }

                            PropertyChanges {
                                target: title
                                opacity: 1
                            }
                        },
                        State {
                            name: 'middle'

                            PropertyChanges {
                                target: button
                                Layout.leftMargin: Math.ceil((sideBar.width - 50) / 2)
                                Layout.preferredWidth: 50
                            }

                            PropertyChanges {
                                target: title
                                opacity: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            from: 'middle'
                            to: 'left'

                            NumberAnimation {
                                properties: 'Layout.leftMargin, Layout.preferredWidth, opacity'
                                duration: 300
                                easing.type: Easing.InOutSine
                            }
                        },
                        Transition {
                            from: 'left'
                            to: 'middle'

                            NumberAnimation {
                                properties: 'Layout.leftMargin, Layout.preferredWidth, opacity'
                                duration: 300
                                easing.type: Easing.InOutSine
                            }
                        }
                    ]

                    MouseArea {
                        id: buttonMouseArea

                        hoverEnabled: true
                        anchors.fill: parent

                        onClicked: {
                            if (model.index === 0) {
                                if (sideBar.state == 'close')
                                    sideBar.state = 'open';
                                else
                                    sideBar.state = 'close';
                            }
                        }
                    }

                    Image {
                        id: icon

                        source: 'icons/' + modelData + '.svg'
                        sourceSize: Qt.size(30, 30)
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 10 }
                    }

                    Text {
                        id: title

                        text: model.index === 0 ? '' : modelData
                        font.family: sourceSansProFont.name
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 55 }

                    }
                }
            }
        }
    }

    DropShadow {
        id: shadow

        anchors.fill: body
        source: body
        radius: 20
        samples: radius * 2 + 1
        color: Qt.rgba(0, 0, 0, 0.05)
    }
}
