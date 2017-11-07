import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import ListModel 1.0                //C++写的model, 1.0是在main函数里注册到Qml时写的版本号

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("列表组件")

    property var copyStr

    Rectangle{
        id:containerRec
        anchors.fill: parent
    }

    Rectangle{
        id:idHeader
        anchors.top: containerRec.top
        width: containerRec.width
        height: 45
        color: "#66CD00"

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
            color: "#66CD00"

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
            color: "#66CD00"
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
        Text {
            property int cnt: listContent.count
            id: countRec
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: findBtn.right
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
        ListView{
            id:rowNum
            anchors.top: listRec.top
            anchors.left: listRec.left
            anchors.bottom: listRec.bottom
            width: 50
            height: listRec.height

            model: modelValue
            activeFocusOnTab: true
            highlight: Rectangle{color: "lightsteelblue";radius: 5}
            focus: true
            delegate: Rectangle{
                height: 25
                width: 50
                color: "#00CD66"

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

        //列表整体
        ListView{
            id:listContent
            anchors.top: listRec.top
            anchors.bottom: listRec.bottom
            anchors.left: rowNum.right
            anchors.right: listRec.right
            currentIndex: 0

            model: modelValue
            delegate: Rectangle{
                width: listContent.width
                height: 25

                color: listContent.currentIndex == index ? "blue" : (index % 2 == 0 ? "#EEE8AA" : "#CDCDB4")

                TextInput{
                    id:listText
                    width: listContent.width
                    height: 25
                    selectByMouse: true         //可以选择文本
                    text: itemValue             //对应model里的角色是数据
                    color: listContent.currentIndex == index ? "#DAA520" : "black"
                    font.pointSize: 15
                    font.bold: index == listContent.currentIndex ? true : false
                    focus: true
                    z:10
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter

                    property bool flag: false
                    onActiveFocusChanged: {
                        console.log("index:",index,listText.focus)
                        if(!flag){
                            rowNum.currentIndex = index         //关联两个ListView 选中行同步
                            listContent.currentIndex = index
                        }
                        if(listText.focus){
                            flag = true
                        }
                    }
                    onEditingFinished: {
                        flag = false
                        listText.focus = false
                    }
                }
                MouseArea{
                    id:mouseArea
                    anchors.fill: parent

                    //响应右键 实现右键菜单
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onPressed: {
                        console.log("onPressed", mouse.button);
                        if(mouse.button == Qt.RightButton){
                            console.log("MouseArea RightButton");
                            menuState.popup()       //显示右键菜单
                            listContent.currentIndex = index
                            rowNum.currentIndex = index
                        }
                    }

                    onClicked: {
                        console.log("click:",index,listContent.currentIndex)
                        if(listContent.currentIndex != index){
                            listContent.currentIndex = index;
                            rowNum.currentIndex = index;
                        }
                    }
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
}
