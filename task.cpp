#include "task.h"
#include "label.h"
#include <QSqlRecord>
#include <QMetaEnum>

Task::Task(QObject *parent) : QObject(parent)
{

}

QList<QVariant> Task::getForProjectByStatus(const int& projectId) {
    QList<QVariant> result;
    bool success = false;

    QSqlQuery query;
    QString querystring =
          QString("SELECT Task.id, Task.owner_id, Task.estimated_time, Task.spent_time, Task.status_id, priority, type, priority_id, type_id, priority_color, type_color, Task.title, User.username "
          "FROM Task "
          "LEFT JOIN User ON User.id = Task.owner_id "
          "LEFT JOIN("
          "(SELECT Label.name as priority, Label.id as priority_id, Label.color as priority_color, Task.id as tid1 FROM Label"
          "   INNER JOIN TaskLabels on Label.id = TaskLabels.label_id"
          "   INNER JOIN Task on TaskLabels.task_id = Task.id"
          "   WHERE Label.label_type_id = %1))"
          "on (Task.id = tid1)"
          "LEFT JOIN((SELECT Label.name as type, Label.id as type_id, Label.color as type_color, Task.id as tid2 FROM Label"
          "   INNER JOIN TaskLabels on Label.id = TaskLabels.label_id"
          "   INNER JOIN Task on TaskLabels.task_id = Task.id"
          "   WHERE Label.label_type_id = %2)"
          ") on (Task.id = tid2)"
          "WHERE Task.project_id = %3").arg(Label::LabelType::Priority).arg(Label::LabelType::Type).arg(projectId);

    qWarning() << querystring;

    success = query.exec(querystring);

    while (query.next()) {
        int id = query.value(0).toInt();
        int owner_id = query.value(1).toInt();
        int estimated_time = query.value(2).toInt();
        int spent_time = query.value(3).toInt();
        int status_id = query.value(4).toInt();
        QString label_priority = query.value(5).toString();
        QString label_type = query.value(6).toString();
        int label_priority_id = query.value(7).toInt();
        int label_type_id = query.value(8).toInt();
        QString label_priority_color = query.value(9).toString();
        QString label_type_color = query.value(10).toString();
        QString title = query.value(11).toString();
        QString owner = query.value(12).toString();

        QVariantMap map;
        map.insert("id", id);
        map.insert("owner_id", owner_id);
        map.insert("estimated_time", estimated_time);
        map.insert("spent_time", spent_time);
        map.insert("status_id", status_id);
        map.insert("label_priority", label_priority);
        map.insert("label_type", label_type);
        map.insert("label_priority_id", label_priority_id);
        map.insert("label_type_id", label_type_id);
        map.insert("label_priority_color", label_priority_color);
        map.insert("label_type_color", label_type_color);
        map.insert("title", title);
        map.insert("owner", owner);

        result.append(QVariant::fromValue(map));
    }

    if (!success) qWarning() << QString("Failed to execute 'Task.getForProjectByStatus' query. ERROR: %3").arg(query.lastError().text());
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
QVariant Task::create(const QString& title, const int& project_id, const int& estimatedTime, const int& labelTypeId, const int& labelPriorityId, const int& ownerId) {
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

        QSqlQuery taskLabelTypeQuery;
        taskLabelTypeQuery.prepare("INSERT INTO TaskLabels (task_id, label_id) VALUES (:task_id, :label_id)");
        taskLabelTypeQuery.bindValue(":task_id", task_id);
        taskLabelTypeQuery.bindValue(":label_id", labelTypeId);

        QSqlQuery taskLabelPriorityQuery;
        taskLabelPriorityQuery.prepare("INSERT INTO TaskLabels (task_id, label_id) VALUES (:task_id, :label_id)");
        taskLabelPriorityQuery.bindValue(":task_id", task_id);
        taskLabelPriorityQuery.bindValue(":label_id", labelPriorityId);

        if(!taskLabelTypeQuery.exec() || !taskLabelPriorityQuery.exec()) {
            qWarning() << QString("Failed to execute 'Task.create' query. ERROR: %1, %2").arg(taskLabelTypeQuery.lastError().text(), taskLabelPriorityQuery.lastError().text());
            qWarning() << QString("Rollback transaction!");
            success = false;
            QSqlDatabase::database().rollback(); // rollback if failed to insert TaskLabels
        }
    }

    if (success) QSqlDatabase::database().commit();
    QVariantMap response;
    response.insert("success", success);
    response.insert("task_id", task_id);

    getForProjectByStatus(project_id);

    return QVariant::fromValue(response);
}

bool Task::update(const int& projectId, const int& taskId, const QString& title, const int& estimatedTime, const int& spentTime, const int& labelTypeId, const int& labelPriorityId, const int& ownerId) {
    bool success = false;

    // Prepare for transaction
    QSqlDatabase::database().transaction();

    QSqlQuery taskQuery;
    taskQuery.prepare("UPDATE Task SET owner_id = :ownerId, estimated_time = :estimatedTime, spent_time = :spentTime, title = :title WHERE id = :taskId");
    taskQuery.bindValue(":ownerId", ownerId);
    taskQuery.bindValue(":estimatedTime", estimatedTime);
    taskQuery.bindValue(":spentTime", spentTime);
    taskQuery.bindValue(":title", title);
    taskQuery.bindValue(":taskId", taskId);

    success = taskQuery.exec();

    if(success == false) {
        qWarning() << QString("Failed to execute 'Task.update' query. ERROR: %3").arg(taskQuery.lastError().text());
    }
    else {
        QSqlQuery taskLabelTypeQuery;
        taskLabelTypeQuery.prepare("UPDATE TaskLabels SET label_id = :labelId WHERE task_id = :taskId AND label_id IN (SELECT id FROM Label WHERE label_type_id = :typeId)");
        taskLabelTypeQuery.bindValue(":taskId", taskId);
        taskLabelTypeQuery.bindValue(":labelId", labelTypeId);
        taskLabelTypeQuery.bindValue(":typeId", Label::LabelType::Type);

        QSqlQuery taskLabelPriorityQuery;
        taskLabelPriorityQuery.prepare("UPDATE TaskLabels SET label_id = :labelId WHERE task_id = :taskId AND label_id IN (SELECT id FROM Label WHERE label_type_id = :typeId)");
        taskLabelPriorityQuery.bindValue(":taskId", taskId);
        taskLabelPriorityQuery.bindValue(":labelId", labelPriorityId);
        taskLabelPriorityQuery.bindValue(":typeId", Label::LabelType::Priority);

        if(!taskLabelTypeQuery.exec() || !taskLabelPriorityQuery.exec()) {
            qWarning() << QString("Failed to execute 'Task.update' query. ERROR: %1, %2").arg(taskLabelTypeQuery.lastError().text(), taskLabelPriorityQuery.lastError().text());
            qWarning() << QString("Rollback transaction!");
            success = false;
            QSqlDatabase::database().rollback(); // rollback if failed to update TaskLabels
        }

        QSqlQuery taskLabelTypeInsertQuery;
        taskLabelTypeInsertQuery.prepare("INSERT INTO TaskLabels(task_id, label_id) SELECT :taskId, :labelId WHERE NOT EXISTS(SELECT 1 FROM TaskLabels WHERE task_id = :taskId AND label_id = :labelId)");
        taskLabelTypeInsertQuery.bindValue(":taskId", taskId);
        taskLabelTypeInsertQuery.bindValue(":labelId", labelTypeId);

        QSqlQuery taskLabelPriorityInsertQuery;
        taskLabelPriorityInsertQuery.prepare("INSERT INTO TaskLabels(task_id, label_id) SELECT :taskId, :labelId WHERE NOT EXISTS(SELECT 1 FROM TaskLabels WHERE task_id = :taskId AND label_id = :labelId)");
        taskLabelPriorityInsertQuery.bindValue(":taskId", taskId);
        taskLabelPriorityInsertQuery.bindValue(":labelId", labelPriorityId);

        if(!taskLabelTypeInsertQuery.exec() || !taskLabelPriorityInsertQuery.exec()) {
            qWarning() << QString("Failed to execute 'Task.update' query. ERROR: %1, %2").arg(taskLabelTypeInsertQuery.lastError().text(), taskLabelPriorityInsertQuery.lastError().text());
            qWarning() << QString("Rollback transaction!");
            success = false;
            QSqlDatabase::database().rollback(); // rollback if failed to update TaskLabels
        }
    }

    if (success) QSqlDatabase::database().commit();

    getForProjectByStatus(projectId);

    return success;
}

