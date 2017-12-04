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
    property int cnt: modelValue.rowCount()
    Rectangle{
        id:containerRec
        anchors.fill: parent
    }

    PStringListModel{
        id:modelValue
    }

    //列头组件
    ListHeader{
        id: idHeader
        anchors.top: containerRec.top
        width: containerRec.width
        height: 45
        color: headerColor
    }

    //列表
    MyListView{
        id: myList
        anchors.top: idHeader.bottom
        anchors.left: containerRec.left
        anchors.right: containerRec.right
        anchors.bottom: containerRec.bottom
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
