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

// if ownerId is NULL, 0 is entered in db. (valid Ids start from 1)
QVariant Task::create(const QString& title, const int& project_id, const QList<int>& selectedLabelIds, const int& estimatedTime, const int ownerId) {
    bool success = false;
    int task_id = 0;

    // Prepare for transaction
    QSqlDatabase::database().transaction();

    QSqlQuery taskQuery;
    taskQuery.prepare("INSERT INTO Task (owner_id, estimated_time, spent_time, project_id, status_id, title) "
                         "VALUES (:owner_id, :estimated_time, :spent_time, :project_id, :status_id, :title)");

    taskQuery.bindValue(":owner_id", ownerId);
    taskQuery.bindValue(":estimated_time", estimatedTime);
    taskQuery.bindValue(":spent_time", 0);
    taskQuery.bindValue(":project_id", project_id);
    taskQuery.bindValue(":status_id", TaskStatus::Backlog);
    taskQuery.bindValue(":title", title);

    success = taskQuery.exec();

    if(success == false) {
        qWarning() << QString("Failed to execute 'Task.create' query. ERROR: %3").arg(taskQuery.lastError().text());
    }
    else {
        task_id = taskQuery.lastInsertId().toInt();
        qWarning() << "ID: " << task_id;

        foreach(const int& labelId, selectedLabelIds){
            QSqlQuery taskLabelsQuery;
            taskLabelsQuery.prepare("INSERT INTO TaskLabels (task_id, label_id) VALUES (:task_id, :label_id)");
            taskLabelsQuery.bindValue(":task_id", task_id);
            taskLabelsQuery.bindValue(":label_id", labelId);

            if(!taskLabelsQuery.exec()) {
                qWarning() << QString("Failed to execute 'Task.create' query. ERROR: %3").arg(taskLabelsQuery.lastError().text());
                qWarning() << QString("Rollback transaction!");
                success = false;
                QSqlDatabase::database().rollback(); // rollback if failed to insert TaskLabels
                break;
            }
        }
    }

    if (success) QSqlDatabase::database().commit();
    QVariantMap response;
    response.insert("success", success);
    response.insert("task_id", task_id);

    getForProjectByStatus(project_id);

    return QVariant::fromValue(response);
}
