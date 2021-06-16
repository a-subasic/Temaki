#include "task.h"
#include <QSqlRecord>
#include <QMetaEnum>

Task::Task(QObject *parent) : QObject(parent)
{

}

QList<QVariant> Task::getForProjectByStatus(const int& projectId, const int& statusId) {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT * FROM Task WHERE project_id = :projectId");
    query.bindValue(":projectId", projectId);
    query.bindValue(":statusId", statusId);
    query.exec();

    while (query.next()) {
        int id = query.value(0).toInt();
        int owner_id = query.value(1).toInt();
        int estimated_time = query.value(2).toInt();
        int spent_time = query.value(3).toInt();
        int status_id = query.value(5).toInt();
        QString title = query.value(6).toString();

        qInfo() << owner_id;
        qInfo() << estimated_time;
        qInfo() << spent_time;
        qInfo() << status_id;

        QVariantMap map;
        map.insert("id", id);
        map.insert("owner_id", owner_id);
        map.insert("estimated_time", estimated_time);
        map.insert("spent_time", spent_time);
        map.insert("status_id", status_id);
        map.insert("title", title);


        result.append(QVariant::fromValue(map));
    }
    return result;
}
