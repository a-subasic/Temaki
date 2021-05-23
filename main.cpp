#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QtSql>
#include <QSqlDatabase>
#include <QDebug>

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

    QString path = qApp->applicationDirPath() + "/TaskManager.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName("127.0.0.1");
    db.setDatabaseName(path);
    if(!db.open()) {
      qWarning() << "Database not connected.";
    };

    return app.exec();
}
