#include "pstringlistmodel.h"

#include <QDebug>

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

void PStringListModel::additem(int row, QString str)
{
    ModelData tmpData;
    tmpData.rowId = row;
    tmpData.value = str;

    beginResetModel();
    m_modelList.append(tmpData);

    for(int i = row+1; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        ++modelValue.rowId;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::removeRow(int row)
{
    beginResetModel();
    m_modelList.removeAt(row);
    for(int i = row; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        --modelValue.rowId;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::pasteItem(int row, QString str)
{
    if(str.isEmpty())
        return;

    ModelData tmpData;
    tmpData.rowId = row;
    tmpData.value = str;

    beginResetModel();
    m_modelList.insert(row, tmpData);
    for(int i = row; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        ++modelValue.rowId;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::modifyItem(int row, QString str)
{
    ModelData tmpData;
    tmpData.rowId = row + 1;
    tmpData.value = str;

    m_modelList.replace(row, tmpData);
    qDebug() << "modify:::" << m_modelList.at(row).rowId << m_modelList.at(row).value;
}

void PStringListModel::findItem(QString str)
{
    if(str.isEmpty())
        return;

    tmpModelList = m_modelList;

    m_modelList.clear();
    beginResetModel();
    for(int m = 0; m < tmpModelList.count(); ++m){
        ModelData tmpData = tmpModelList.at(m);
        if(tmpData.value.contains(str)){
            m_modelList.append(tmpData);
        }
    }
    for(int i = 0; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        modelValue.rowId = i + 1;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::sortItem()
{
    beginResetModel();
    for(int m = 0; m < m_modelList.count(); ++m){
        for(int n = 0; n < m_modelList.count()-1; ++n){
            if(m_modelList.at(m).value.compare(m_modelList.at(n).value) > 0){
                ModelData tmpData = m_modelList.at(m);
                m_modelList.replace(m, m_modelList.at(n));
                m_modelList.replace(n, tmpData);
            }
        }
    }
    for(int i = 0; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        modelValue.rowId = i + 1;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::move(int from, int to)
{
    if(to < 0 || to >= m_modelList.count()){
        qDebug() << "out of the area!";
        return;
    }

    beginResetModel();
    m_modelList.move(from, to);

    for(int i = 0; i < m_modelList.count(); ++i){
        ModelData modelValue = m_modelList.at(i);
        modelValue.rowId = i + 1;
        m_modelList.replace(i, modelValue);
    }
    endResetModel();
}

void PStringListModel::hide(int yPos,int row)
{
    beginResetModel();
    ModelData tmpData = m_modelList.at(row);
    mapDataList.insert(yPos, tmpData);
    m_modelList.removeAt(row);
    QList<int> keyList;
    keyList.clear();
    QMap<int,ModelData>::iterator it = mapDataList.begin();
    for(; it != mapDataList.end(); ++it){
        if(it.key() > yPos){
            mapDataList.insert(it.key() - 25, it.value());
            keyList.append(it.key());
        }
    }
    for(int i = 0; i < keyList.count(); ++ i){
        mapDataList.remove(keyList.at(i));
    }
    it = mapDataList.begin();
    for(; it != mapDataList.end(); ++it){
        qDebug() << "it.key:" << it.key();
    }
    endResetModel();
}

void PStringListModel::show(int yPos)
{
    beginResetModel();
    QMap<int,ModelData>::iterator it = mapDataList.begin();     //遍历map
    for(; it != mapDataList.end(); ++it){
        if(it.key() == yPos){
            ModelData tmpData = it.value();
            m_modelList.insert(tmpData.rowId-1, tmpData);
            mapDataList.remove(it.key());
            break;
        }
    }

    QMap<int,ModelData> tmpList = mapDataList;
    mapDataList.clear();
    QMap<int,ModelData>::iterator ite = tmpList.begin();
    for(; ite != tmpList.end(); ++ite){
        if(ite.key() > yPos){
            mapDataList.insert(ite.key() + 25, ite.value());
            continue;
        }
        mapDataList.insert(ite.key(), ite.value());
    }

    //排序
    for(int i = 0; i < m_modelList.count(); ++i){
        for(int j = 0; j < m_modelList.count()-1; ++j){
            ModelData data1 = m_modelList.at(j);
            ModelData data2 = m_modelList.at(j+1);
            if(data1.rowId > data2.rowId){
                m_modelList.swap(j,j+1);
                qDebug() << data1.rowId << data2.rowId << "dafaeeef";
            }
        }
    }
    endResetModel();
}
