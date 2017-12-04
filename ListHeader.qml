import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle{
    ToolButton{
        id:addRec
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
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
        anchors.top: parent.top
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
        anchors.top: parent.top
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
        id: countRec
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: colorBtn.right
        anchors.leftMargin: 20
        font.pointSize: 12
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("共计 <font color=\"#4169E1\">") + cnt + qsTr("</font> 条记录")
    }
}
