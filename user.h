#ifndef USER_H
#define USER_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

class User : public QObject
{
    Q_OBJECT
    Q_ENUMS(UserRole)
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(int role_id READ role_id WRITE setRoleId NOTIFY roleIdChanged)
public:
    explicit User(QObject *parent = nullptr);
    enum UserRole {
      Editor,
      Viewer
    };
    Q_ENUM(UserRole)
    void setId(const int id) {
        if (id != m_id) {
            m_id = id;
            emit idChanged();
        }
    }
    int id() const {
        return m_id;
    }

    void setUsername(const QString& username) {
        if (username != m_username) {
            m_username = username;
            emit usernameChanged();
        }
    }
    QString username() const {
        return m_username;
    }

    void setRoleId(const int role_id) {
        if (role_id != m_role_id) {
            m_role_id = role_id;
            emit roleIdChanged();
        }
    }
    int role_id() const {
        return m_role_id;
    }

signals:
    void idChanged();
    void usernameChanged();
    void roleIdChanged();

private:
    int m_id;
    QString m_username;
    int m_role_id;

public slots:
    QVariant login(const QString& username, const QString& password);
    QVariant signUp(const QString& username, const QString& email, const QString& password, const int& roleId);
    QList<QVariant> search(const QString& entry); /* search users by username/email and return User list */
    QList<QVariant> getProjectMembers(int projectId); /* get all users (project members) from project_id */
};

#endif // USER_H
