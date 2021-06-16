#ifndef PROJECT_H
#define PROJECT_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

class Project : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
public:
    explicit Project(QObject *parent = nullptr);
    void setId(const int id) {
        if (id != m_id) {
            m_id = id;
            emit idChanged(id);
        }
    }
    int id() const {
        return m_id;
    }

    void setName(const QString& name) {
        if (name != m_name) {
            m_name = name;
            emit nameChanged();
        }
    }
    QString name() const {
        return m_name;
    }

signals:
    void idChanged(int id);
    void nameChanged();

private:
    int m_id;
    QString m_name;

public slots:
//    bool create(const QString& name, const QList<int>& memberIds);
    QList<QVariant> getAllForUser(int userId);
};

#endif // PROJECT_H
