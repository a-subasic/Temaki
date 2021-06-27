#ifndef TASK_H
#define TASK_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <project.h>

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant project_tasks READ project_tasks WRITE setProjectTasks NOTIFY projectTasksChanged)

public:
    explicit Task(QObject *parent = nullptr);
    QVariant project_tasks() const {
        return m_project_tasks;
    }
    void setProjectTasks(const QVariant& project_tasks) {
        if (project_tasks != m_project_tasks) {
            m_project_tasks = project_tasks;
            emit projectTasksChanged();
        }
    }
    enum TaskStatus {
      Backlog = 1,
      Active = 2,
      InReview = 3,
      Closed = 4
    };
    Q_ENUM(TaskStatus)

signals:
    void projectTasksChanged();
private:
    QVariant m_project_tasks;

public slots:
    QList<QVariant> getForProjectByStatus(const int& projectId);
    void updateTaskStatus(const int& taskId, const int& statusId);
    QVariant create(const QString& title, const int& project_id, const int& estimatedTime, const int& labelTypeId = NULL, const int& labelPriorityId = NULL, const int& ownerId = NULL);

};

#endif // TASK_H

