function createTriangleBtn(xPos, yPos) {
    if(rowRec.component == null){
        rowRec.component = Qt.createComponent("ToolBtnDefined.qml")
    }

    var tBtn
    if(rowRec.component.status == Component.Ready){
        tBtn = rowRec.component.createObject(rowRec,{"x": xPos,"y": yPos})
        toolBtnArr.push(tBtn)
    }
    tBtn.toolCliked.connect(showTooBtn)
}

function showTooBtn(yPos)
{
    console.log("jsGHJ",yPos)
    var index = -1
    for(var i = 0; i < toolBtnArr.length; ++i){
        if(toolBtnArr[i].y > yPos){
            toolBtnArr[i].y += 25
        }
        if(toolBtnArr[i].y == yPos){
            index = i;
        }
    }
    toolBtnArr.splice(index, 1)
}
