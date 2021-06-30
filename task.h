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
    Q_ENUM(TaskStatus);

signals:
    void projectTasksChanged();
private:
    QVariant m_project_tasks;

public slots:
    QList<QVariant> getForProjectByStatus(const int& projectId);
    void updateTaskStatus(const int& taskId, const int& statusId);
    QVariant create(const QString& title, const int& project_id, const int& estimatedTime, const int& spentTime = 0,const int& statusId = TaskStatus::Backlog, const int& labelTypeId = 0, const int& labelPriorityId = 0, const int& ownerId = 0);
    bool update(const int& project_id, const int& taskId, const QString& title, const int& estimatedTime, const int& spentTime, const int& labelTypeId = 0, const int& labelPriorityId = 0, const int& ownerId = 0);
    QList<QVariant> import(const QString& fileName);
    //bool exportToFile(const QList<QObject*> tasks, const QString projectName, const QString filePath);
    bool exportToFile(const QString& projectName, const QString& filePath, const QString& title, const QString& spent_time, const QString& estimated_time,
                      const QString& status, const QString& owner, const QString& label_type, const QString& label_priority);
    int statusExists(const QString& name);
};

#endif // TASK_H

