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

void PStringListModel::hide(int row)
{
    beginResetModel();
    ModelData tmpData = m_modelList.at(row);
    dataList.clear();
    dataList.append(tmpData);
    m_modelList.removeAt(row);
    qDebug() << "hide:" << dataList.at(0).value << tmpData.rowId;;
    endResetModel();
}

void PStringListModel::show()
{
    beginResetModel();
    for(int i = 0; i < dataList.count(); ++i){
        ModelData tmpData = dataList.at(i);
        m_modelList.insert(tmpData.rowId-1, tmpData);
        qDebug() << tmpData.rowId;
    }
    qDebug() << "show:" << dataList.at(0).value;
    endResetModel();
}
