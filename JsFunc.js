function createTriangleBtn(xPos, yPos) {
    if(rowRec.component == null){
        rowRec.component = Qt.createComponent("ToolBtnDefined.qml")
    }

    var tBtn
    if(rowRec.component.status == Component.Ready){
        tBtn = rowRec.component.createObject(rowRec,{"x": xPos,"y": yPos})
    }
}
