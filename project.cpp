#include "project.h"
#include <QSqlRecord>
#include <QMetaEnum>

Project::Project(QObject *parent) : QObject(parent)
{

}

QVariant Project::create(const QString& name, const QList<int>& memberIds, const int& currentUserId) {
    bool success = false;
    int project_id = 0;

    // Prepare for transaction
    QSqlDatabase::database().transaction();

    QSqlQuery projectQuery;
    projectQuery.prepare("INSERT INTO Project (name, owner_id) VALUES (:name, :owner_id)");
    projectQuery.bindValue(":name", name);
    projectQuery.bindValue(":owner_id", currentUserId);

    success = projectQuery.exec();

    if(success == false) {
        qWarning() << QString("Failed to execute 'Project.create' query. ProjectName:%1, OwnerID:%2. ERROR: %3").arg(name, QString::number(currentUserId), projectQuery.lastError().text());
    }
    else {
        project_id = projectQuery.lastInsertId().toInt();
        qWarning() << "ID: " << project_id;

        foreach(const int& memberId, memberIds){
            QSqlQuery projectmembersQuery;
            projectmembersQuery.prepare("INSERT INTO ProjectMembers (project_id, user_id) VALUES (:project_id, :user_id)");
            projectmembersQuery.bindValue(":project_id", project_id);
            projectmembersQuery.bindValue(":user_id", memberId);

            if(!projectmembersQuery.exec()) {
                qWarning() << QString("Failed to execute 'Project.create' query. Project ID:%1, Members count:%2. ERROR: %3").arg(QString::number(project_id), QString::number(memberIds.count()), projectmembersQuery.lastError().text());
                qWarning() << QString("Rollback transaction!");
                success = false;
                QSqlDatabase::database().rollback(); // rollback if failed to insert ProjectMembers
                break;
            }
        }
    }

    if (success) QSqlDatabase::database().commit();
    QVariantMap response;
    response.insert("success", success);
    response.insert("project_id", project_id);

    return QVariant::fromValue(response);
}

QList<QVariant> Project::getAllForUser(int userId) {
    QList<QVariant> result;
    qInfo() << userId;

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
