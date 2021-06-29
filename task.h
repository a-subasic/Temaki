#ifndef TASK_H
#define TASK_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <project.h>

class TaskExportObj
{
public:
    QString title;
    int spent_time;
    int estimated_time;
    QString status;
    QString owner;
    QString label_type;
    QString label_priority;

    QVariantMap getVariantMap() {
      QVariantMap result;
      result["title"] = QVariant(title);
      result["spent_time"] = QVariant(spent_time);
      result["estimated_time"] = QVariant(estimated_time);
      result["status"] = QVariant(status);
      result["owner"] = QVariant(owner);
      result["label_type"] = QVariant(label_type);
      result["label_priority"] = QVariant(label_priority);

      return result;
    }

};
Q_DECLARE_METATYPE(TaskExportObj);

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
    QVariant create(const QString& title, const int& project_id, const int& estimatedTime, const int& labelTypeId = 0, const int& labelPriorityId = 0, const int& ownerId = 0);
    bool update(const int& project_id, const int& taskId, const QString& title, const int& estimatedTime, const int& spentTime, const int& labelTypeId = 0, const int& labelPriorityId = 0, const int& ownerId = 0);
    bool exportToFile(const QList<QVariantMap> tasks, const QString projectName, const QString filePath);
};

#endif // TASK_H

