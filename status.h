#ifndef STATUS_H
#define STATUS_H

#include <QtGlobal>
#include <QQmlEngine>

class Status : public QObject
{
    Q_OBJECT

public:
    Status() : QObject() {}

    enum TaskStatus
    {
        BACKLOG = 1,
        ACTIVE = 2,
        IN_REVIEW = 3,
        CLOSED = 4
    };
    Q_ENUMS(TaskStatus)

    static void declareQML() {
        qmlRegisterType<Status>("MyQMLEnums", 13, 37, "Status");
    }
};

#endif
// STYLE_HPP
