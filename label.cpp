#include "label.h"
#include <QSqlRecord>
#include <QMetaEnum>

Label::Label(QObject *parent) : QObject(parent)
{
}

QVariant Label::getProjectLabels(int projectId) {
    QVariant result;
    QList<QVariant> priorities;
    QList<QVariant> types;

    QSqlQuery query;
    query.prepare("SELECT Label.id, Label.name, Label.label_type_id, Label.color FROM Label "
                  "INNER JOIN LabelType ON Label.label_type_id = LabelType.id WHERE Label.id IN "
                  "(SELECT label_id FROM TaskLabels WHERE task_id IN "
                  "(SELECT Task.id FROM Task WHERE project_id = :projectId))");
    query.bindValue(":projectId", projectId);
    query.exec();

    //SELECT Label.id, Label.name, LabelType.name, Label.color FROM Label INNER JOIN LabelType ON Label.label_type_id = LabelType.id WHERE Label.id IN (SELECT label_id FROM TaskLabels WHERE task_id IN (SELECT Task.id FROM Task WHERE project_id = 5))

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
    projectLabelsChanged();
    return result;
}
