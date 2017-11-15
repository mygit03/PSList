import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import ListModel 1.0                //C++写的model, 1.0是在main函数里注册到Qml时写的版本号

Window {
    visible: true
    width: 680
    height: 500
    title: qsTr("列表组件")

    //变量定义
    property var copyStr                        //复制文本
    property color headerColor: "#14ca2c"       //表头背景色
    property color rowColor: "#EEE8AA"          //Item背景色
    property int colorFlag: -1                  //表头或Item背景色标识
    property int xBtn: rowRec.x + 50            //三角按钮的x坐标
    property int yBtn: rowNum.currentItem.y + 5 //三角按钮的y坐标

    Rectangle{
        id:containerRec
        anchors.fill: parent
    }

    Rectangle{
        id:idHeader
        anchors.top: containerRec.top
        width: containerRec.width
        height: 45
        color: headerColor

        ToolButton{
            id:addRec
            anchors.top: idHeader.top
            anchors.topMargin: 5
            anchors.left: idHeader.left
            width: 35
            height: 35
            checkable: false
            text: qsTr("添加")
            tooltip: text
            iconSource:{ source:"qrc:/images/add.png"}//指定按钮图标

            onClicked: {
                console.log("添加:",listContent.count)
                modelValue.additem(listContent.count+1, "new item");
                listContent.currentIndex = listContent.count-1
                rowNum.currentIndex = listContent.count-1
            }
        }

        ToolButton{
            id:sort
            anchors.top: idHeader.top
            anchors.topMargin: 5
            anchors.left: addRec.right
            width: 35
            height: 35
            checkable: false
            text: qsTr("排序")
            tooltip: text
            iconSource:{ source:"qrc:/images/sort.png"}//指定按钮图标

            onClicked: {
                console.log("排序")
                modelValue.sortItem();
            }
        }

        Rectangle{
            id:filterRec
            anchors.top: idHeader.top
            anchors.left: sort.right

            width: 120
            height: 45
            color: headerColor

            ComboBox{
                id:comBox
                width: 80
                anchors.top: filterRec.top
                anchors.topMargin: 10
                anchors.left: filterRec.left
                anchors.leftMargin: 3
                editable: false

                model: [ "Banana","Apple", "Coconut" ]
                currentIndex: 1
                onCurrentIndexChanged: {
                    console.log("index changed:",comBox.currentIndex,comBox.currentText)
                }
            }
            ToolButton{
                id:filter
                anchors.top: filterRec.top
                anchors.topMargin: 7
                anchors.left: comBox.right
                anchors.leftMargin: 0
                width: 30
                height: 30
                checkable: false
                text: qsTr("筛选")
                tooltip: text
                iconSource:{ source:"qrc:/images/filter.png"}//指定按钮图标

                onClicked: {
                    console.log("筛选")
                }
            }
        }

        CheckBox{
            id:checkValid
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: filterRec.right
            checked: false

            text: qsTr("仅显示有效元件")

            onCheckedStateChanged: {
                if(checked){
                    console.log("checked!")
                }else{
                    console.log("unChecked!")
                }
            }
        }

        Rectangle{
            id:findRec
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: checkValid.right
            anchors.leftMargin: 10
            width: 130
            height: 25
            color: "white"
            border.color: "black"

            TextEdit{
                id:findText
                anchors.fill: parent
                font.pointSize: 10
                selectByMouse: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Enter the text...")
            }
        }
        ToolButton{
            id:findBtn
            anchors.top: parent.top
            anchors.topMargin: 7
            anchors.left: findRec.right
            width: 30
            height: 30
            checkable: false
            text: qsTr("查找")
            tooltip: text
            iconSource:{ source:"qrc:/images/find.png"}//指定按钮图标

            onClicked: {
                console.log("查找",findText.text)
                modelValue.findItem(findText.text)
            }
        }
        ToolButton{
            id:colorBtn
            anchors.top: parent.top
            anchors.topMargin: 7
            anchors.left: findBtn.right
            anchors.leftMargin: 5
            width: 30
            height: 30
            checkable: false
            text: qsTr("颜色")
            tooltip: text
            menu: colorMenu
            iconSource:{ source:"qrc:/images/color.png"}//指定按钮图标
        }
        Text {
            property int cnt: listContent.count
            id: countRec
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: colorBtn.right
            anchors.leftMargin: 20
            font.pointSize: 12
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("共计 ") + cnt + qsTr(" 条记录")
        }
    }

    //列表
    Rectangle{
        id:listRec
        anchors.top: idHeader.bottom
        anchors.left: containerRec.left
        anchors.right: containerRec.right
        anchors.bottom: containerRec.bottom

        PStringListModel{
            id:modelValue
        }
        //行号
        Rectangle{
            id: rowRec
            anchors.top: listRec.top
            anchors.left: listRec.left
            anchors.bottom: listRec.bottom
            width: 60
            color: headerColor

            ScrollView{
                id: scrollBarId
                anchors.top: rowRec.top
                anchors.left: rowRec.left
                anchors.bottom: rowRec.bottom
                width: 50
                height: rowRec.height
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
                x: xBtn
                y: yBtn
                width: 10
                height: 10
                checkable: false
                text: qsTr("三角")
                tooltip: text
                iconSource:{ source:"qrc:/images/triangle.png"}//指定按钮图标

                onClicked: {
                    console.log("三角")
                    visible = false
                }
            }
        }

        //列表整体
        ScrollView{
            id: scrollBarList
            anchors.top: listRec.top
            anchors.bottom: listRec.bottom
            anchors.left: rowRec.right
            anchors.right: listRec.right

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
                                iconName: "Comments";
                                iconSource: "qrc:/images/del.png";
                                onTriggered: {
                                    triangleBtn.visible = true
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
                                    rowNum.currentIndex = index;
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

    //警告对话框
    MessageDialog
    {
        id:msgBoxDel
        standardButtons: StandardButton.Yes | StandardButton.No
        modality: Qt.ApplicationModal
        title: qsTr("警告：")
        text: qsTr("确定要删除当前记录？")
        onYes:
        {
            console.log("right delete",listContent.count,listContent.currentIndex)
            modelValue.removeRow(listContent.currentIndex)
            if(listContent.currentIndex >= listContent.count-1){
                listContent.currentIndex = listContent.count-1
                rowNum.currentIndex = listContent.count-1
            }
        }
    }

    ColorDialog{
        id: colorDialog
        title: qsTr("颜色对话框")
        currentColor: headerColor
        onAccepted: {
            console.log("选定颜色: " +colorDialog.color)
            switch(colorFlag){
            case 0:
                rowColor = colorDialog.color
                break
            case 1:
                headerColor = colorDialog.color
                break
            default:
                break
            }
        }
        onRejected: {
            console.log("取消")
        }
        Component.onCompleted: visible = false          //默认不显示颜色对话框
    }

    Menu {
        id: colorMenu;
        MenuItem{
            text: "Item背景色";
            onTriggered: {
                console.log(text)
                colorFlag = 0
                colorDialog.open()
            }
        }
        MenuItem{
            text: "表头背景色";
            onTriggered: {
                console.log(text)
                colorFlag = 1
                colorDialog.open()
            }
        }
    }
}
