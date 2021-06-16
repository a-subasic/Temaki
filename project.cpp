#include "project.h"
#include <QSqlRecord>
#include <QMetaEnum>

Project::Project(QObject *parent) : QObject(parent)
{

}

//bool Project::create(const QString& name, const QList<int>& memberIds) {
//    bool success = false;
//    return success;
//}

QList<QVariant> Project::getAllForUser(int userId) {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT id, name FROM Project WHERE id IN (SELECT project_id FROM ProjectMembers WHERE user_id = :userId)");
    query.bindValue(":userId", userId);
    query.exec();

    while (query.next()) {
        int id = query.value(0).toInt();
        QString name = query.value(1).toString();

        QVariantMap map;
        map.insert("id", id);
        map.insert("name", name);

        result.append(QVariant::fromValue(map));
    }
    return result;
}
