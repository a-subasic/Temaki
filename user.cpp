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

bool User::signUp(const QString& username, const QString& email, const QString& password, const int& roleId) {
    bool success = false;

    QSqlQuery query;
    query.prepare("INSERT INTO User (username, email, password, role_id) VALUES (:username, :email, :password, :role_id)");
    query.bindValue(":username", username);
    query.bindValue(":email", email);
    query.bindValue(":password", password);
    query.bindValue(":role_id", roleId);

    if(query.exec()) {
        success = true;
    }
    else {
        success = false;
    }


    return success;
}

QList<User> User::search(const QString& entry) {
    QList<User> result;

    QSqlQuery query;
    query.prepare("SELECT username, email, password, role_id FROM User WHERE username LIKE %:entry% OR email LIKE %:entry%");
    query.bindValue(":entry", entry);

    // TODO
}

