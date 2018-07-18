#include "publicengine.h"
#include <QDebug>
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QString>

const char PublicEngine::PUBLIC_KEY[] = "-----BEGIN PUBLIC KEY-----\n"
                            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA36F1ad/VQcnDRSuh95Lc\n"
                            "xaiaMFz9KSuSDQZTKZV5wq3N2BVMhzbWFZhCexwVbGZNwlOrSLxVAzGQlmT3nRD8\n"
                            "pef2gL90MSyuH9VRF+Wypq2XvKp48CScu6QruzeYkq9GJS/Ow55Ofei8TyKEz27j\n"
                            "r3EdFIBQpQfNAytdOEkDIZQFryZwrtsAQ7D/TAsXbIlpsYPQETnS9FeqFiuyey96\n"
                            "OnfDaiF0LgRaP44FyWPKh9PtTiMDAUVAapSNrK6mFZ29jfBNPKbOgRbS4CnxS6P6\n"
                            "tUZ/O1/sYrEymwgp9EBdx62I4wl5I+uvzbt0Nld2qkETwLyDweenjTdSiz2IlB2L\n"
                            "qwIDAQAB\n"
                            "-----END PUBLIC KEY-----";

void PublicEngine::logchars(string name, string str){
    const char* chars = str.c_str();
    int n_chars = strlen(chars);
    int n_str = str.length();
    int val;
    string logstr = "";

    qDebug() << endl;
    qDebug() << endl;

    qDebug() << "<<<<<<<<<" << QString::fromStdString(name) << ">>>>>>>>" << endl;
    qDebug() << "LONGITUD : [" << n_chars << "/" << n_str << "]" << endl;

    for(int i=0; i<n_chars; i++){
        val = (int)chars[i];
        qDebug() << i << " : " << val << endl;
    }

    qDebug() << endl;
    qDebug() << endl;
}


string PublicEngine::encrypt(string message){
    string encr;

#ifdef ANDROID
    string message_base64 = Base64::encode(message);
    QString qmessage_base64 = QString::fromStdString(message_base64);

    QAndroidJniObject obj = QAndroidJniObject::callStaticObjectMethod(
                                            "org/qtproject/example/EncrypTalkBeta3/AndroidEncryptionUtils",
                                            "rsaPublicEncrypt",
                                            "(Ljava/lang/String;)Ljava/lang/String;",
                                            QAndroidJniObject::fromString(qmessage_base64).object<jstring>());

    QString qstr = obj.toString();
    encr = qstr.toStdString();
#else
    int message_len = message.length();
    const char* message_c = message.c_str();
    char* encr_c;
    int encr_len;

    BIO* public_bio = BIO_new_mem_buf((char*)PUBLIC_KEY,(int)sizeof(PUBLIC_KEY));
    EVP_PKEY* public_key_evp = PEM_read_bio_PUBKEY(public_bio,NULL,NULL,NULL);
    RSA* public_key_rsa = EVP_PKEY_get1_RSA(public_key_evp);

    encr_c = (char*)malloc(RSA_size(public_key_rsa));

    encr_len = RSA_public_encrypt((message_len),
                                  (unsigned char*)message_c,
                                  (unsigned char*)encr_c,
                                  public_key_rsa,
                                  RSA_PKCS1_PADDING);

    encr = Base64::encode((unsigned char*)encr_c,encr_len);

    free(encr_c);
#endif

    return encr;
}

string PublicEngine::computeBase64Hash(const string& message){
    const char* hash = PublicEngine::sha256(message).c_str();
    string base64_hash = Base64::encode((unsigned char*)hash, strlen(hash));

    return base64_hash;
}

bool PublicEngine::verifySignature(const string &payload, const string &signature){
    bool is_correct;
    string expected_hash = PublicEngine::sha256(payload);
    string received_hash = PublicEngine::decryptHash(signature);

    is_correct = (expected_hash==received_hash);

    qDebug() << "HASH RECIBIDO  : {" << received_hash.c_str() << "}" << endl;
    qDebug() << "HASH CALCULADO : {" << expected_hash.c_str() << "}" << endl;

    return is_correct;
}

string PublicEngine::sha256(string msg){
    string hash_str;

#ifdef ANDROID
    string msg_b64 = Base64::encode(msg);
    QString qmessage = QString::fromStdString(msg_b64);

    QAndroidJniObject obj = QAndroidJniObject::callStaticObjectMethod(
                                            "org/qtproject/example/EncrypTalkBeta3/AndroidEncryptionUtils",
                                            "sha256",
                                            "(Ljava/lang/String;)Ljava/lang/String;",
                                            QAndroidJniObject::fromString(qmessage).object<jstring>());

    QString qstr = obj.toString();
    string hash_b64 = qstr.toStdString();
    hash_str = Base64::decode(hash_b64);
#else
    const char* msg_c = msg.c_str();
    int msg_len = msg.length();
    unsigned char hash[SHA256_DIGEST_LENGTH+1];
    SHA256_CTX sha256;

    SHA256_Init(&sha256);
    SHA256_Update(&sha256,msg_c,msg_len);
    SHA256_Final(hash,&sha256);
    hash[SHA256_DIGEST_LENGTH] = (unsigned char)'\0';

    hash_str = string((const char*)hash);
#endif
    return hash_str;
}

string PublicEngine::decryptHash(const string& signature_b64){
    string hash;

#ifdef ANDROID
    QString qmessage = QString::fromStdString(signature_b64);


    QAndroidJniObject obj = QAndroidJniObject::callStaticObjectMethod(
                                            "org/qtproject/example/EncrypTalkBeta3/AndroidEncryptionUtils",
                                            "rsaPublicDecrypt",
                                            "(Ljava/lang/String;)Ljava/lang/String;",
                                            QAndroidJniObject::fromString(qmessage).object<jstring>());

    QString qstr = obj.toString();
    string hash_b64 = qstr.toStdString();
    hash = Base64::decode(hash_b64);
#else
    string signature = Base64::decode(signature_b64);
    int encr_len = signature.length();
    const char* signature_c = signature.c_str();
    char* decr_c;

    BIO* public_bio = BIO_new_mem_buf((char*)PUBLIC_KEY,(int)sizeof(PUBLIC_KEY));
    EVP_PKEY* public_key_evp = PEM_read_bio_PUBKEY(public_bio,NULL,NULL,NULL);
    RSA* public_key_rsa = EVP_PKEY_get1_RSA(public_key_evp);

    decr_c = (char*)malloc(RSA_size(public_key_rsa));

    int decr_len = RSA_public_decrypt(encr_len,
                       (unsigned char*)signature_c,
                       (unsigned char*)decr_c,
                       public_key_rsa,
                       RSA_PKCS1_PADDING);

    decr_c[decr_len] = '\0';

    hash = string(decr_c);
    free(decr_c);
#endif

    return hash;
}










































