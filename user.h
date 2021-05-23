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
    bool signUp(const QString& username, const QString& email, const QString& password, const int& roleId);
    QList<User> search(const QString& entry); /* search users by username/email and return User list */
};

#endif // USER_H
