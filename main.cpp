#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QtSql>
#include <QSqlDatabase>
#include <QDebug>
#include <QQmlContext>
#include <QFileInfo>

#include "user.h"
#include "project.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    app.setWindowIcon(QIcon(":/images/temaki.png"));

    // Database connection
    // Adjust projectFolder name if necessary
    QString projectFolder = "/Temaki";
    QString path = QFileInfo(".").absolutePath() + projectFolder + "/TaskManager.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(path);

    if(!db.open()) {
      qWarning() << "Database not connected.";
    }

    // Class declarations
    User user;
    Project project;

    engine.rootContext()->setContextProperty("user", &user);
    engine.rootContext()->setContextProperty("project", &project);

    return app.exec();
}
