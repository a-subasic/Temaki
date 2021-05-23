#ifndef USER_H
#define USER_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

class User : public QObject
{
    Q_OBJECT
public:
    explicit User(QObject *parent = nullptr);

signals:

public slots:
    bool login(const QString& username, const QString& password);

};

#endif // USER_H
