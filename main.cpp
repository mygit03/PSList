#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "pstringlistmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<PStringListModel>("ListModel",1,0,"PStringListModel");     //注册到Qml

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
