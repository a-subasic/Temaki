#ifndef TASK_H
#define TASK_H


#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

class Task : public QObject
{
    Q_OBJECT
public:
    explicit Task(QObject *parent = nullptr);

signals:

private:

public slots:
    QList<QVariant> getForProjectByStatus(const int& projectId, const int& statusId);
};

#endif // TASK_H

