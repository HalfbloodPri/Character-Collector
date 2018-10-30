import QtQuick 2.7
import QtQml 2.2
/*使用Canvas，实现一个像素风的画图区域
 */
Rectangle {
    id: drawBoardRoot;
    width: totalSize
    height: totalSize+totalSize/5
    color: "transparent"
    property int pixelSize: 14           //28x28的网格，每一格的边长
    property int pixelNum: 28
    property int totalSize: pixelNum*pixelSize          //网格总大小，14x28=392

    Rectangle{
        id: personNameBg
        width: drawBoardRoot.totalSize
        height: drawBoardRoot.totalSize/15
        color: "snow"
        anchors.left: drawBoardRoot.left
        anchors.top:drawBoardRoot.top
        anchors.leftMargin: drawBoardRoot.totalSize/9
        anchors.topMargin: height/2
        TextInput{
            id: personName
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: drawBoardRoot.totalSize/40
            width: parent.width-2*anchors.leftMargin
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            font.pointSize: drawBoardRoot.totalSize*0.0357
            selectByMouse: true
            wrapMode: TextInput.WordWrap
            verticalAlignment: TextInput.AlignVCenter
            text: "姓名"
        }
    }

    Rectangle{
        id:clearBtn
        color:"transparent"
        width: drawBoardRoot.totalSize/3
        height: drawBoardRoot.totalSize/10
        anchors.left: drawBoardRoot.left
        anchors.top:personNameBg.bottom
        anchors.leftMargin: drawBoardRoot.totalSize/9
        anchors.topMargin: height/2
        border.color: "lightgray"
        border.width: 2
        Text {
            text: "清除"
            anchors.centerIn: parent
            color: "whitesmoke"
            font.pixelSize: drawBoardRoot.totalSize/20
            font.bold: true
        }
        MouseArea{
            id: clearBtnMouseArea
            anchors.fill:parent
            onClicked: {
                drawBoard.clearCanvas()
                pixelateImage.visible = false
            }
        }
    }

    Rectangle{
        id:sendBtn
        color:"transparent"
        width: drawBoardRoot.totalSize/3
        height: drawBoardRoot.totalSize/10
        anchors.right: drawBoardRoot.right
        anchors.top:personNameBg.bottom
        anchors.rightMargin: drawBoardRoot.totalSize/9
        anchors.topMargin: height/2
        border.color: "lightgray"
        border.width: 2
        Text {
            id: sendBtnText
            text: "保存"
            anchors.centerIn: parent
            color: "whitesmoke"
            font.pixelSize: drawBoardRoot.totalSize/20
            font.bold: true
        }

        MouseArea{
            id: sendBtnMouseArea
            anchors.fill:parent
            onPressed: {
                parent.color = "lightgray"
            }
            onReleased: {
                parent.color = "transparent"
            }
            onClicked: {
                drawBoard.save("mnistImage.bmp")
                mnistHandler.setImageData(mnistTestRoot.label,personName.text)
                pixelateImage.sourceSize.width = 0
                pixelateImage.sourceSize.height = 0
                pixelateImage.sourceSize.width = drawBoardRoot.totalSize
                pixelateImage.sourceSize.height = drawBoardRoot.totalSize
                pixelateImage.visible = true
            }
        }
    }

    Rectangle {
        id: drawAreaRec
        width: drawBoardRoot.totalSize
        height: drawBoardRoot.totalSize
        anchors.top: clearBtn.bottom
        anchors.left: drawBoardRoot.left
        anchors.topMargin: drawBoardRoot.totalSize/20
        anchors.leftMargin: drawBoardRoot.totalSize/9
        border.color: "black"
        border.width: 1
        color: "transparent"
        Canvas{
            id:drawBoard
            width: drawBoardRoot.totalSize
            height: drawBoardRoot.totalSize
            anchors.bottom: drawAreaRec.bottom
            anchors.left: drawAreaRec.left
            property real lastX: 0
            property real lastY: 0

            function clearCanvas(){
                var ctx = getContext('2d')
                ctx.lineWidth = 1
                ctx.strokeStyle = "#DADADA"
                ctx.fillStyle = "white"
                ctx.beginPath()
                ctx.fillRect(0,0,drawBoard.width,drawBoard.height)
                ctx.stroke()
                drawBoard.requestPaint()
            }

            onPaint: {
                var ctx = getContext('2d')
                ctx.lineWidth = 2*drawBoardRoot.pixelSize
                ctx.lineCap = "round"
                ctx.strokeStyle = "black"
                ctx.beginPath()
                ctx.moveTo(lastX,lastY)
                lastX = drawArea.mouseX
                lastY = drawArea.mouseY
                ctx.lineTo(drawArea.mouseX,drawArea.mouseY)
                ctx.stroke()
            }
            Component.onCompleted: {
                canvasInit.start()
            }
            Timer {
                id: canvasInit
                interval: 50
                onTriggered: {
                    drawBoard.clearCanvas()     //将画布画成白底的
                }
            }
        }
        MouseArea {
            id: drawArea
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            onPressed: {
                mouseIcon.visible = true
                pixelateImage.visible = false
                drawBoard.lastX = mouseX
                drawBoard.lastY = mouseY
            }
            onReleased: {
                mouseIcon.visible = false
            }
            onPositionChanged: {
                drawBoard.requestPaint()
            }
        }
        Image {
            id: mouseIcon;
            source: "./icons/mouseIcon.png"
            width: 2.3*drawBoardRoot.pixelSize
            height: 2.3*drawBoardRoot.pixelSize
            visible: false
            x: drawArea.mouseX - width/2
            y: drawArea.mouseY - height/2
        }
    }

    Image {
        id:pixelateImage
        source:"mnistImagePixelate.bmp"
        visible : false
        width: drawBoardRoot.totalSize
        height: drawBoardRoot.totalSize;
        anchors.left: drawAreaRec.left
        anchors.bottom: drawAreaRec.bottom
        cache: false
    }

    Grid {
        width: drawBoardRoot.totalSize
        height: drawBoardRoot.totalSize;
        anchors.left: drawAreaRec.left
        anchors.bottom: drawAreaRec.bottom
        columns: drawBoardRoot.pixelNum;
        rows: drawBoardRoot.pixelNum;
        Repeater {
            model: parent.columns*parent.rows;      //28x28
            Rectangle {
                width: drawBoardRoot.pixelSize;
                height: drawBoardRoot.pixelSize;
                border.color: "#DADADA";
                border.width: 1;
                color: "transparent"
            }
        }
    }
}
