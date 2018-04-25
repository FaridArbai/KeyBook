#include "imagepickerandroid.h"

imagePickerAndroid::imagePickerAndroid()
{

}

void imagePickerAndroid::buscaImagem()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_PICK", "Ljava/lang/String;");
    QAndroidJniObject EXTERNAL_CONTENT_URI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$Images$Media", "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");

    QAndroidJniObject intent=QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V", ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

    if (ACTION_PICK.isValid() && intent.isValid())
    {
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 101, this);
        qDebug() << "OK";
    }
    else
    {
        qDebug() << "ERRO";
    }
}

void imagePickerAndroid::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data){
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
    QString imagemCaminho;

    if (receiverRequestCode == 101 && resultCode == RESULT_OK){
        QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
        QAndroidJniObject dadosAndroid = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
        QAndroidJniEnvironment env;
        jobjectArray projecao = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
        jobject projacaoDadosAndroid = env->NewStringUTF(dadosAndroid.toString().toStdString().c_str());
        env->SetObjectArrayElement(projecao, 0, projacaoDadosAndroid);
        QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
        QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), projecao, NULL, NULL, NULL);
        jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I", dadosAndroid.object<jstring>());
        cursor.callMethod<jboolean>("moveToFirst", "()Z");
        QAndroidJniObject resultado = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
        imagemCaminho =  resultado.toString();
        //emit imagemCaminhoSignal(imagemCaminho);

        qDebug() << imagemCaminho << endl;
    }
    else{
        imagemCaminho = "";
        qDebug() << "Caminho errado";
    }

    this->image_path = imagemCaminho;

    qDebug() << "notifying" << endl;
    this->IMAGE_PICKED.notify_all();
    qDebug() << "notified" << endl;
}
