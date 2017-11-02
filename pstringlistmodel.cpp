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
    tmpData.rowId = row;
    tmpData.value = str;

    beginResetModel();
    m_modelList.replace(row, tmpData);
    endResetModel();
}

void PStringListModel::findItem(QString str)
{
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
