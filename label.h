#ifndef LABEL_H
#define LABEL_H

#include <QObject>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <QQmlEngine>

class Label : public QObject
{
    Q_OBJECT
    Q_ENUMS(LabelType)
    Q_PROPERTY(QVariant project_labels READ project_labels WRITE setProjectLabels NOTIFY projectLabelsChanged)
    Q_PROPERTY(QVariant all_labels READ all_labels WRITE setAllLabels NOTIFY labelsChanged)
public:
    explicit Label(QObject *parent = nullptr);
    enum LabelType {
        Priority = 1,
        Type = 2
    };
    Q_ENUM(LabelType)

    static void declareQML() {
        qmlRegisterType<Label>("MyQMLEnums", 13, 37, "Label");
    }

    QVariant project_labels() const {
        return m_project_labels;
    }

    void setProjectLabels(const QVariant& project_labels) {
        if (project_labels != m_project_labels) {
            m_project_labels = project_labels;
            emit projectLabelsChanged();
        }
    }

    QVariant all_labels() const {
        return m_all_labels;
    }

    void setAllLabels(const QVariant& all_labels) {
        if (all_labels != m_all_labels) {
            m_all_labels = all_labels;
            emit labelsChanged();
        }
    }

signals:
    void projectLabelsChanged();
    void labelsChanged();

private:
    QVariant m_project_labels;
    QVariant m_all_labels;

public slots:
    QVariant getProjectLabels(int projectId); /* get all labels from project_id */
    QVariant getLabelById(int taskId, int typeId);
    QList<QVariant> getLabels();
    QList<QVariant> getLabelTypesEnum();
    bool removeLabel(int projectId, int labelId);
    QVariant create(const QString& name, const int& labelTypeId, const QString& color);
};

#endif // LABEL_H
