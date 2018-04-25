#ifndef CAMINHOIMAGENS_H
#define CAMINHOIMAGENS_H

#include <QObject>

#include "imagepickerandroid.h"

#include <QDebug>
#include <QWaitCondition>

class caminhoImagens : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString imagemCaminho READ imagemCaminho NOTIFY imagemCaminhoChanged)

public slots:
    void buscaImagem();
    void retornaImagem(QString path);

public:
    caminhoImagens();
    QString imagemCaminho();

private:
    QString m_imagemCaminho = "";


signals:
    void imagemCaminhoChanged();
};

#endif // CAMINHOIMAGENS_H
