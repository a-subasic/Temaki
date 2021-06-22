#ifndef LABEL_H
#define LABEL_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>

class Label : public QObject
{
    Q_OBJECT
    Q_ENUMS(LabelType)
    Q_PROPERTY(QVariant project_labels READ project_labels WRITE setProjectLabels NOTIFY projectLabelsChanged)
public:
    explicit Label(QObject *parent = nullptr);
    enum LabelType {
      Priority = 1,
      Type = 2
    };
    Q_ENUM(LabelType)

    QVariant project_labels() const {
        return m_project_labels;
    }
    void setProjectLabels(const QVariant& project_labels) {
        if (project_labels != m_project_labels) {
            m_project_labels = project_labels;
            emit projectLabelsChanged();
        }
    }

signals:
    void projectLabelsChanged();
private:
    QVariant m_project_labels;

public slots:
    QVariant getProjectLabels(int projectId); /* get all labels from project_id */
};

#endif // LABEL_H
