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

    Q_INVOKABLE QString rdata(int row)
    {
        if(stringList().size()>row){
            return stringList().at(row);
        }
        return QString("");
    }

    Q_INVOKABLE void additem(int row, QString str){
        ModelData tmpData;
        tmpData.rowId = row;
        tmpData.value = str;

        m_modelList.append(tmpData);
    }

    Q_INVOKABLE void removeRow(int row){
        m_modelList.removeAt(row);
    }

    QList<ModelData> m_modelList;
};

#endif // PSTRINGLISTMODEL_H
