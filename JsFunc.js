function createTriangleBtn(xPos, yPos) {
    if(rowRec.component == null){
        rowRec.component = Qt.createComponent("ToolBtnDefined.qml")
    }

    var tBtn
    if(rowRec.component.status == Component.Ready){
        tBtn = rowRec.component.createObject(rowRec,{"x": xPos,"y": yPos})
        tooBtnArr.push(tBtn)
    }
    tBtn.toolCliked.connect(showTooBtn)
}

function showTooBtn(yPos)
{
    console.log("jsGHJ",yPos)
    var index = -1
    for(var i = 0; i < tooBtnArr.length; ++i){
        if(tooBtnArr[i].y > yPos){
            tooBtnArr[i].y += 25
        }
        if(tooBtnArr[i].y == yPos){
            index = i;
        }
    }
    tooBtnArr.splice(index, 1)
}
