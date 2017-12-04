#ifndef PSTRINGLISTMODEL_H
#define PSTRINGLISTMODEL_H

#include <QObject>
#include <QStringList>
#include <QStringListModel>

class PStringListModel : public QStringListModel
{
    Q_OBJECT

public:
    enum SystemModel{
        ItemNum,            //行号
        ItemValue           //数据
    };

    struct ModelData{
        int     rowId;
        QString value;
    };

    PStringListModel(QObject *parent = Q_NULLPTR);
    PStringListModel(const QStringList &strings, QObject *parent = Q_NULLPTR);

    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void additem(int row, QString str);

    Q_INVOKABLE void removeRow(int row);

    Q_INVOKABLE void pasteItem(int row, QString str);

    Q_INVOKABLE void modifyItem(int row, QString str);

    Q_INVOKABLE void findItem(QString str);

    Q_INVOKABLE void sortItem();

    Q_INVOKABLE void move(int from, int to);

    Q_INVOKABLE void hide(int row);

    Q_INVOKABLE void show();


    QList<ModelData> m_modelList;
    QList<ModelData> tmpModelList;
    QList<ModelData> dataList;
};

#endif // PSTRINGLISTMODEL_H
