import QtQuick 2.7
import QtQuick.Controls 1.4

ToolButton{
    property alias flag: triangleBtn.visible

    id:triangleBtn
    x: 50
    y: listContent.currentIndex == 0 ? (listContent.currentItem.y + 5) : (listContent.currentItem.y - 25 + 5)
    width: 10
    height: 10
    visible: true
    checkable: false
    text: qsTr("三角")
    tooltip: text
    iconSource:{ source:"qrc:/images/triangle.png"}//指定按钮图标

    Component.onCompleted: {
//        console.log("ddd",x,y)
    }

    onClicked: {
        console.log("三角")
        visible = false
        modelValue.show(triangleBtn.y)
    }
}
