#include "caminhoimagens.h"

caminhoImagens::caminhoImagens()
{

}

void caminhoImagens::buscaImagem()
{
    imagePickerAndroid *imagePicker = new imagePickerAndroid();
    connect(imagePicker, SIGNAL(imagemCaminhoSignal(QString)), this, SLOT(retornaImagem(QString)));

    imagePicker->buscaImagem();
}

void caminhoImagens::retornaImagem(QString path)
{
    qDebug() << path;

    m_imagemCaminho = path;

    emit imagemCaminhoChanged();
}

QString caminhoImagens::imagemCaminho()
{
    return m_imagemCaminho;
}
