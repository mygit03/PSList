import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle{
    id:listRec
    anchors.top: idHeader.bottom
    anchors.left: containerRec.left
    anchors.right: containerRec.right
    anchors.bottom: containerRec.bottom

    property alias textList: listContent
    property alias rowList: rowid

    //行号组件
    RowNumber{
        id: rowid
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 60
        color: headerColor
    }

    //列表整体
    ScrollView{
        id: scrollBarList
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: rowid.right
        anchors.right: parent.right

        onYChanged: {
            console.log("top changed")
            console.log(scrollBarList.height,scrollBarList.top,scrollBarList.y)
        }

        ListView{
            id:listContent
            anchors.fill: parent
            currentIndex: 0

            model: modelValue
            delegate: Rectangle{
                id: wrapper
                width: listContent.width
                height: 25
                border.color: "black"
                color: listContent.currentIndex == index ? "blue" : rowColor

                TextInput{
                    id:listText
                    anchors.fill: parent
                    selectByMouse: true         //可以选择文本
                    text: itemValue             //对应model里的角色是数据
                    color: listContent.currentIndex == index ? "#DAA520" : "black"
                    font.pointSize: 15
                    font.bold: index == listContent.currentIndex ? true : false
                    focus: true
                    z:10
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter

                    onEditingFinished: {
                        listText.focus = false
                        modelValue.modifyItem(index, text)
                    }
                    //菜单
                    Menu {
                        id: menuState;
                        MenuItem{
                            text: "复制";
                            iconName: "copy";
                            iconSource: "qrc:/images/copy.png";
                            shortcut: StandardKey.Copy
                            onTriggered: {
                                console.log("right copy")
                                copyStr = listText.text
                            }
                        }
                        MenuItem{
                            text: "粘贴";
                            iconName: "paste";
                            iconSource: "qrc:/images/paste.png";
                            shortcut: StandardKey.Paste
                            onTriggered: {
                                console.log("right paste", copyStr)
                                modelValue.pasteItem(listContent.currentIndex,copyStr)
                            }
                        }
                        MenuItem{
                            text: "删除";
                            iconName: "del";
                            iconSource: "qrc:/images/del.png";
                            shortcut: StandardKey.Delete
                            onTriggered: {
                                msgBoxDel.open()        //调用对话框
                            }
                        }
                        MenuItem{
                            text: "注释";
                            iconName: "hide";
                            iconSource: "qrc:/images/del.png";
                            onTriggered: {
                                console.log(listContent.currentIndex)
                                rowid.showTriangleBtn()     //显示三角按钮
                                modelValue.hide(listContent.currentIndex,1)
                            }
                        }
                    }
                    MouseArea{
                        id:mouseArea
                        anchors.fill: parent

                        //响应右键 实现右键菜单
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: {
                            console.log("click:",index,listContent.currentIndex)
                            if(listContent.currentIndex != index){
                                listContent.currentIndex = index;
                                rowid.rowList.currentIndex = index
                            }
                            if(mouse.button == Qt.RightButton){
                                console.log("MouseArea RightButton");
                                menuState.popup()       //显示右键菜单
                            }
                            listText.focus = false
                        }
                        onDoubleClicked: {
                            listText.forceActiveFocus()
                        }
                        onMouseXChanged: {
                            var pore = listContent.indexAt(mouseArea.mouseX + wrapper.x, mouseArea.mouseY + wrapper.y);
                            if( index != pore ) {
                                modelValue.move(index, pore)
                            }
                            console.log("moveX")
                        }
                        onMouseYChanged: {
                            var pore = listContent.indexAt(mouseArea.mouseX + wrapper.x, mouseArea.mouseY + wrapper.y);
                            if(index != pore) {
                                modelValue.move(index, pore)
                            }
                            console.log("moveY")
                        }
                    }
                }
            }
        }
    }
}
