#ifndef PROJECT_H
#define PROJECT_H

#include <QObject>

class Project : public QObject
{
    Q_OBJECT
public:
    explicit Project(QObject *parent = nullptr);

signals:

public slots:
    bool create(const QString& name, const QList<int>& memberIds);
};

#endif // PROJECT_H

