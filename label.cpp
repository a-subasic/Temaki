#include "label.h"
#include <QSqlRecord>
#include <QMetaEnum>

Label::Label(QObject *parent) : QObject(parent)
{
}

QList<QVariant> Label::getLabels() {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT id, name, label_type_id, color FROM Label");
    query.exec();

    while (query.next()){
        QString id = query.value(0).toString();
        QString name = query.value(1).toString();
        QString type_id = query.value(2).toString();
        QString color = query.value(3).toString();

        LabelType labelTypeEnum = static_cast<LabelType>(type_id.toInt());
        QString type = QMetaEnum::fromType<LabelType>().valueToKey(labelTypeEnum);

        QVariantMap map;
        map.insert("id", id);
        map.insert("name", name);
        map.insert("type_id", type_id);
        map.insert("type", type);
        map.insert("color", color);

        result.append(map);
    }

    m_all_labels = result;
    emit labelsChanged();

    return result;
}


QVariant Label::getProjectLabels(int projectId) {
    QVariant result;
    QList<QVariant> priorities;
    QList<QVariant> types;

    QSqlQuery query;
    query.prepare("SELECT Label.id, Label.name, Label.label_type_id, Label.color FROM Label "
                  "WHERE Label.id IN "
                  "(SELECT label_id FROM TaskLabels WHERE task_id IN "
                  "(SELECT Task.id FROM Task WHERE project_id = :projectId))");
    query.bindValue(":projectId", projectId);
    query.exec();

    while (query.next()){
        QString id = query.value(0).toString();
        QString name = query.value(1).toString();
        QString type_id = query.value(2).toString();
        QString color = query.value(3).toString();

        QVariantMap map;
        map.insert("id", id);
        map.insert("name", name);
        map.insert("color", color);

        if (type_id.toInt() == LabelType::Priority) {
            priorities.append(QVariant::fromValue(map));
        } else {
            types.append(QVariant::fromValue(map));
        }
    }

    QVariantMap mapResult;
    mapResult.insert("priorities", priorities);
    mapResult.insert("types", types);

    result = QVariant::fromValue(mapResult);
    m_project_labels = result;
    emit projectLabelsChanged();
    return result;
}

QVariant Label::getLabelById(int taskId, int typeId) {
    QVariant result;

    QSqlQuery query;
    query.prepare("SELECT id, name, color FROM Label WHERE label_type_id = :typeId AND id IN (SELECT label_id FROM TaskLabels WHERE task_id = :taskId)");
    query.bindValue(":taskId", taskId);
    query.bindValue(":typeId", typeId);
    query.exec();

    int id = 0;
    QString name = "Not selected";
    QString color = "";

    while (query.next()) {
        id = query.value(0).toInt();
        name = query.value(1).toString();
        color = query.value(2).toString();
    }

    QVariantMap mapResult;
    mapResult.insert("id", id);
    mapResult.insert("name", name);
    mapResult.insert("color", color);

    result = QVariant::fromValue(mapResult);

    return result;
}

bool Label::removeLabel(int projectId, int labelId) {
    QSqlQuery query;

    // Prepare for transaction
    QSqlDatabase::database().transaction();

    query.prepare("DELETE FROM Label WHERE id = :labelId");
    query.bindValue(":labelId", labelId);
    bool success = query.exec();

    if(!success) {
        qWarning() << QString("Rollback transaction!");
        qWarning() << QString("ERROR: %3").arg(query.lastError().text());
        QSqlDatabase::database().rollback(); // rollback if failed to remove from Label
        return success;
    }

    QSqlQuery taskQuery;
    taskQuery.prepare("DELETE FROM TaskLabels WHERE label_id = :labelId");
    taskQuery.bindValue(":labelId", labelId);
    success = taskQuery.exec();

    if(!success) {
        qWarning() << QString("Rollback transaction!");
        qWarning() << QString("ERROR: %3").arg(taskQuery.lastError().text());
        QSqlDatabase::database().rollback(); // rollback if failed to remove from TaskLabels
        return success;
    }

    if (success) QSqlDatabase::database().commit();

    getLabels();
    getProjectLabels(projectId);

    return success;
}

QList<QVariant> Label::getLabelTypesEnum() {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT id, name FROM LabelType");
    query.exec();

    while (query.next()) {
        QVariantMap mapResult;
        mapResult.insert("id", query.value(0).toString());
        mapResult.insert("name", query.value(1).toString());

        result.append(QVariant::fromValue(mapResult));
    }

    getLabels();
    return result;
}

QVariant Label::create(const QString& name, const int& labelTypeId, const QString& color) {
    bool success = false;
    int label_id = 0;

    QSqlQuery query;
    query.prepare("INSERT INTO Label (name, label_type_id, color) VALUES (:name, :label_type_id, :color)");
    query.bindValue(":name", name);
    query.bindValue(":label_type_id", labelTypeId);
    query.bindValue(":color", color);

    if(!query.exec()) {
        success = false;
        qWarning() << "Failed to execute create label query";
    }
    else {
        success = true;
        label_id = query.lastInsertId().toInt();
    }

    QVariantMap response;
    response.insert("success", success);
    response.insert("user_id", label_id);

    getLabels();

    return QVariant::fromValue(response);
}




