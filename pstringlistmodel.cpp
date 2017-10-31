#include "pstringlistmodel.h"

PStringListModel::PStringListModel(QObject *parent):QStringListModel(parent)
{
    ModelData tmp;
    for(int i = 0; i < 20; ++i){
        tmp.rowId = i + 1;
        tmp.value = QString("Item%1").arg(i + 1);
        m_modelList.append(tmp);
    }
}

PStringListModel::PStringListModel(const QStringList &strings, QObject *parent):QStringListModel(strings,parent)
{

}

QVariant PStringListModel::data(const QModelIndex &index, int role) const
{
    ModelData tmp = m_modelList.at(index.row());
    switch(role)
    {
    case ItemNum:
        return tmp.rowId;
        break;
    case ItemValue:
        return tmp.value;
        break;
    }
    return QVariant();
}

int PStringListModel::rowCount(const QModelIndex &parent) const
{
    return m_modelList.count();
}

QHash<int, QByteArray> PStringListModel::roleNames() const
{
    QHash<int, QByteArray> roleName;
    roleName.insert(ItemNum, "itemNum");
    roleName.insert(ItemValue, "itemValue");

    return roleName;
}
