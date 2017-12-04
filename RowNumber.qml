import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle{
    id: rowRec
    property alias tBtn: triangleBtn.visible
    ScrollView{
        id: scrollBarId
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 50
        height: parent.height
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff


        ListView{
            id:rowNum
            anchors.fill: parent
            width: 50
            height: listRec.height

            model: modelValue
            activeFocusOnTab: true
            highlight: Rectangle{color: "lightsteelblue";radius: 5}
            focus: true
            delegate: Rectangle{
                height: 25
                width: 50
                color: headerColor

                Text {
                    id: idText
                    width: 45
                    text: itemNum       //对应model里的角色是行号
                    font.pointSize: 15
                    font.bold: index == rowNum.currentIndex ? true : false
                    color: index == rowNum.currentIndex ? "#EE0000" : "black"

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(rowNum.currentIndex != index){
                                rowNum.currentIndex = index;
                                listContent.currentIndex = index;
                            }
                        }
                    }
                }
            }
        }
    }
    ToolButton{
        id:triangleBtn
        x: parent.x + 50
        y: listContent.currentIndex == 0 ? (listContent.currentItem.y + 5) : (listContent.currentItem.y - 25 + 5)
        width: 10
        height: 10
        visible: false
        checkable: false
        text: qsTr("三角")
        tooltip: text
        iconSource:{ source:"qrc:/images/triangle.png"}//指定按钮图标

        onClicked: {
            console.log("三角")
            visible = false
            modelValue.show()
        }
    }

    function showTriangleBtn(){
        triangleBtn.visible = true
    }
}
