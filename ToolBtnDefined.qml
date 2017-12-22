import QtQuick 2.7
import QtQuick.Controls 1.4

ToolButton{
    property alias flag: triangleBtn.visible

    signal toolCliked(var yPos);

    id:triangleBtn
    x: 50
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
        console.log("三角",triangleBtn.y)
        visible = false
        modelValue.show(triangleBtn.y)

        //发射信号
        toolCliked(triangleBtn.y);
    }
}
