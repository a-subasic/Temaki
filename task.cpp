#include "task.h"
#include <QSqlRecord>
#include <QMetaEnum>

Task::Task(QObject *parent) : QObject(parent)
{

}

QList<QVariant> Task::getForProjectByStatus(const int& projectId) {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT * FROM Task WHERE project_id = :projectId");
    query.bindValue(":projectId", projectId);
    query.exec();

    while (query.next()) {
        int id = query.value(0).toInt();
        int owner_id = query.value(1).toInt();
        int estimated_time = query.value(2).toInt();
        int spent_time = query.value(3).toInt();
        int status_id = query.value(5).toInt();
        QString title = query.value(6).toString();

        QVariantMap map;
        map.insert("id", id);
        map.insert("owner_id", owner_id);
        map.insert("estimated_time", estimated_time);
        map.insert("spent_time", spent_time);
        map.insert("status_id", status_id);
        map.insert("title", title);


        result.append(QVariant::fromValue(map));
    }
    m_project_tasks = result;
    emit projectTasksChanged();

    return result;
}

void Task::updateTaskStatus(const int& taskId, const int& statusId) {
    QSqlQuery query;
    query.prepare("UPDATE Task SET status_id = :statusId WHERE id = :taskId");
    query.bindValue(":taskId", taskId);
    query.bindValue(":statusId", statusId);
    query.exec();
}
