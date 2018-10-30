import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4

Rectangle {
    id: mnistTestRoot
    width: 730
    height: 600
    color: "gray"
    border.color: "gray"
    border.width: 1
    property string label: "X"

    WritingPad {
        id: handwrittenArea
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 50
    }

    Text {
        id: trainLabel
        anchors.left: handwrittenArea.right
        anchors.leftMargin: 160
        anchors.top: parent.top
        anchors.topMargin: 100
        font.pointSize: 96
        text: mnistTestRoot.label
        color: "whitesmoke"
    }

    Grid {
        id: numGrid
        anchors.top: trainLabel.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: trainLabel.horizontalCenter
        columns: 3
        rows: 4
        spacing: 10
        Component {
            id: labelCheckBoxStyle
            CheckBoxStyle {
                spacing: 5
                indicator: Rectangle{
                    implicitHeight: 40
                    implicitWidth: 40
                    border.width: 2
                    border.color: "lightgrey"
                    color: "transparent"
                    Image {
                        width: parent.width-5
                        height: parent.height-5
                        anchors.centerIn: parent
                        source: "./icons/checked.png"
                        visible: control.checked
                    }
                }
                label: Text{
                    text: control.text
                    font.pointSize: 11.2
                    color: "whitesmoke"
                }
            }
        }
        ExclusiveGroup { id: numChosen }
        CheckBox {
            id: num7
            text: "7"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "7" }
            }
        CheckBox {
            id: num8
            text: "8"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "8" }
            }
        CheckBox {
            id: num9
            text: "9"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "9" }
        }
        CheckBox {
            id: num4
            text: "4"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "4" }
            }
        CheckBox {
            id: num5
            text: "5"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "5" }
            }
        CheckBox {
            id: num6
            text: "6"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "6" }
        }
        CheckBox {
            id: num1
            text: "1"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "1" }
            }
        CheckBox {
            id: num2
            text: "2"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "2" }
            }
        CheckBox {
            id: num3
            text: "3"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "3" }
        }
        Rectangle {
            width: 40
            height: 40
            color: "transparent"
        }
        CheckBox {
            id: num0
            text: "0"
            exclusiveGroup: numChosen
            style: labelCheckBoxStyle
            onClicked: { mnistTestRoot.label = "0" }
            }
        Rectangle {
            width: 40
            height: 40
            color: "transparent"
        }
    }
}
