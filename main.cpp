#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "CipherLogic.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

        // Регистрируем тип CipherLogic для QML
    qmlRegisterType<CipherLogic>("CryptAlgorithm", 1, 0, "CipherLogic");
    
    // Создаем экземпляр CipherLogic
    CipherLogic cipher;

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/CryptAlgorithm/Main.qml"));

     QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);
    
    return app.exec();
}
