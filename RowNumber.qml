import QtQuick 2.7
import QtQuick.Controls 1.4

import "JsFunc.js" as MyJsFunc

Rectangle{
    property alias rowList: rowNum
    property Component component: null

    id: rowRec
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

    function showTriangleBtn(yPos){
        MyJsFunc.createTriangleBtn(rowNum.currentItem.x+50,yPos)
    }
}
