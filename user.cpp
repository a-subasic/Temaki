#include "user.h"

User::User(QObject *parent) : QObject(parent)
{

}

bool User::login(const QString& username, const QString& password) {
    bool success = false;

    QSqlQuery query;
    query.prepare(QString("SELECT * FROM User WHERE username = :username AND password = :password"));
    query.bindValue(":username", username);
    query.bindValue(":password", password);

    if(!query.exec()) {
        qWarning() << "Failed to execute login query";
    }
    else {
        while(query.next()) {
            QString usernameFromDB = query.value(1).toString();
            QString passwordFromDB = query.value(3).toString();

            if(usernameFromDB == username && passwordFromDB == password) {
                success = true;
            }
            else {
                success = false;
            }
        }
    }

    return success;
}
