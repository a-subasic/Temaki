#ifndef TASK_H
#define TASK_H


#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

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
    QVariant create(const QString& title, const int& project_id, const QList<int>& selectedLabelIds, const int& estimatedTime, const int ownerId = NULL);
};

#endif // TASK_H

