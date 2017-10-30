#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "pstringlistmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//    QStringList dataList;
//    for(int i = 0; i < 20; ++i){
//        dataList.append(QString("%1").arg(i+1));
//    }

//    PStringListModel modelData;
//    modelData.setStringList(dataList);

    qmlRegisterType<PStringListModel>("MyData",1,0,"PStringListModel");     //注册到Qml

    QQmlApplicationEngine engine;
    QQmlContext *ctxt = engine.rootContext();
//    ctxt->setContextProperty("exlistContent", QVariant::fromValue(dataList)/*&modelData*/);
//    ctxt->setContextProperty("idlistContent", QVariant::fromValue(dataList)/*&modelID*/);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
