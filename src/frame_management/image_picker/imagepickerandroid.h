#ifndef IMAGEPICKERANDROID_H
#define IMAGEPICKERANDROID_H

#include <QObject>
#include <QtAndroidExtras>
#include <QWaitCondition>
#include <QDebug>

class imagePickerAndroid : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT

public:
    QWaitCondition IMAGE_PICKED;
    QString image_path;

    imagePickerAndroid();
    void buscaImagem();
    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

signals:
    void imagemCaminhoSignal(QString);
};

#endif // IMAGEPICKERANDROID_H
