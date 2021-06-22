#include "user.h"
#include <QSqlRecord>
#include <QMetaEnum>

User::User(QObject *parent) : QObject(parent)
{

}

QVariant User::login(const QString& username, const QString& password) {
    bool success = false;
    int user_id = 0;
    int role_id = 0;

    QSqlQuery query;
    query.prepare(QString("SELECT * FROM User WHERE username = :username AND password = :password"));
    query.bindValue(":username", username);
    query.bindValue(":password", password);

    if(!query.exec()) {
        success = false;
        qWarning() << "Failed to execute login query";
    }
    else {
        while(query.next()) {
            user_id = query.value(0).toInt();
            QString usernameFromDB = query.value(1).toString();
            QString passwordFromDB = query.value(3).toString();
            role_id = query.value(4).toInt();

            if(usernameFromDB == username && passwordFromDB == password) {
                success = true;
            }
            else {
                success = false;
            }
        }
    }

    QVariantMap response;
    response.insert("success", success);
    response.insert("user_id", user_id);
    response.insert("role_id", role_id);

    return QVariant::fromValue(response);
}

QVariant User::signUp(const QString& username, const QString& email, const QString& password, const int& roleId) {
    bool success = false;
    int user_id = 0;

    QSqlQuery query;
    query.prepare("INSERT INTO User (username, email, password, role_id) VALUES (:username, :email, :password, :role_id)");
    query.bindValue(":username", username);
    query.bindValue(":email", email);
    query.bindValue(":password", password);
    query.bindValue(":role_id", roleId);

    if(!query.exec()) {
        success = false;
        qWarning() << "Failed to execute register query";
    }
    else {
        success = true;
        user_id = query.lastInsertId().toInt();
    }

    QVariantMap response;
    response.insert("success", success);
    response.insert("user_id", user_id);

    return QVariant::fromValue(response);
}

QList<QVariant> User::search(const QString& entry, const QStringList& ignoreUserIds) { /* Note: ignoreUserIds is optional */
    qWarning() << entry;
    QList<QVariant> result;
    QString ignoreUserIdsString = QString("(%1)").arg(ignoreUserIds.join(","));
    QSqlQuery query;

    query.prepare(QString("SELECT id, username, email, role_id FROM User WHERE (username LIKE :entry OR email LIKE :entry) AND (id NOT IN %1)").arg(ignoreUserIdsString));
    query.bindValue(":entry", QString("%%1%").arg(entry));
    //query.bindValue(":ignoreUserIdsString", ignoreUserIdsString); // for some reason, this didnt work (parameter count mismatch)
    query.exec();

    while (query.next()) {
        QString id = query.value(0).toString();
        QString username = query.value(1).toString();
        QString email = query.value(2).toString();
        QString roleid = query.value(4).toString();

        UserRole roleEnum = static_cast<UserRole>(roleid.toInt());
        QString role = QMetaEnum::fromType<UserRole>().valueToKey(roleEnum);

        QVariantMap map;
        map.insert("id", id);
        map.insert("username", username);
        map.insert("email", email);
        map.insert("roleid", role);

        result.append(QVariant::fromValue(map));
    }
    return result;
}

bool User::create() {

    QSqlQuery query;
    query.prepare("INSERT INTO User (username, email, password, role_id) VALUES ('testt', 'testt@gmail.com', 'test', 1)");

    if(!query.exec()) {
        qWarning() << "Failed to execute login query";
    }
    else {
        qWarning() << "fdfdfd";

        while(query.next()) {
            qInfo() << "aaa";
            qWarning() << "fdfdfd";
            qInfo() << query.value(0).toInt();
        }
    }

    return true;
}

QList<QVariant> User::getProjectMembers(int projectId) {
    QList<QVariant> result;

    QSqlQuery query;
    query.prepare("SELECT id, username, email, role_id FROM User WHERE id IN (SELECT user_id FROM ProjectMembers WHERE project_id = :projectId)");
    query.bindValue(":projectId", projectId);
    query.exec();

    while (query.next()){
        QString id = query.value(0).toString();
        QString username = query.value(1).toString();
        QString email = query.value(2).toString();
        QString roleid = query.value(4).toString();

        UserRole roleEnum = static_cast<UserRole>(roleid.toInt());
        QString role = QMetaEnum::fromType<UserRole>().valueToKey(roleEnum);

        QVariantMap map;
        map.insert("id", id);
        map.insert("username", username);
        map.insert("email", email);
        map.insert("role_id", role);

        result.append(QVariant::fromValue(map));
    }
    m_project_members = result;
    projectMembersChanged();
    return result;
}

/* TODO: discuss: what happens if we delete all project members? */
bool User::removeProjectMember(int projectId, int userId) {
    QSqlQuery query;
    query.prepare("DELETE FROM ProjectMembers WHERE project_id = :projectId AND user_id = :userId");
    query.bindValue(":projectId", projectId);
    query.bindValue(":userId", userId);
    bool success = query.exec();

    return success;
}

bool User::addProjectMembers(int projectId, const QStringList& memberIds){
    bool success = false;

    // Prepare for transaction
    QSqlDatabase::database().transaction();

    foreach(const QString& memberId, memberIds){
        QSqlQuery query;
        query.prepare("INSERT INTO ProjectMembers (project_id, user_id) VALUES (:project_id, :user_id)");
        query.bindValue(":project_id", projectId);
        query.bindValue(":user_id", memberId);
        success = query.exec();

        if(!success) {
            qWarning() << QString("Rollback transaction!");
            QSqlDatabase::database().rollback(); // rollback if failed to insert ProjectMember
            return success;
        }
    }
    QSqlDatabase::database().commit();
    return success;
}
