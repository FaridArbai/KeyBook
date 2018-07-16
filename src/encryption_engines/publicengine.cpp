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

string PublicEngine::encrypt(const string& message){
    string encr;
#ifdef ANDROID
    QAndroidJniObject obj = QAndroidJniObject::callStaticMethod<jclass>("org/qtproject/example/EncrypTalkBeta3/AndroidEncryptionUtils",
                                              "rsaPublicEncrypt",
                                              "(Ljava/lang/String;)Ljava/lang/String",
                                              QAndroidJniObject::fromString(QString::fromStdString(message)).object<jstring>());
    QString qstr = obj.toString();
    encr = qstr.toStdString();

    qDebug() << "HERE IS THE ENCRYPTED STRING : " << qstr << endl;
#else
    int message_len = message.length();
    const char* message_c = message.c_str();
    char* encr_c;
    int encr_len;

    BIO* public_bio = BIO_new_mem_buf((char*)PUBLIC_KEY,(int)sizeof(PUBLIC_KEY));
    EVP_PKEY* public_key_evp = PEM_read_bio_PUBKEY(public_bio,NULL,NULL,NULL);
    RSA* public_key_rsa = EVP_PKEY_get1_RSA(public_key_evp);

    encr_c = (char*)malloc(RSA_size(public_key_rsa));

    encr_len = RSA_public_encrypt((message_len+1),
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

    return is_correct;
}

string PublicEngine::sha256(const string& msg){
    string hash_str;
    const char* msg_c = msg.c_str();
    int msg_len = msg.length();
    unsigned char hash[SHA256_DIGEST_LENGTH+1];
    SHA256_CTX sha256;

    SHA256_Init(&sha256);
    SHA256_Update(&sha256,msg_c,msg_len);
    SHA256_Final(hash,&sha256);
    hash[SHA256_DIGEST_LENGTH] = (unsigned char)'\0';

    hash_str = string((const char*)hash);

    return hash_str;
}

string PublicEngine::decryptHash(const string& signature_b64){
    string signature = Base64::decode(signature_b64);
    int encr_len = signature.length();
    const char* signature_c = signature.c_str();
    char* decr_c;
    string hash;

    BIO* public_bio = BIO_new_mem_buf((char*)PUBLIC_KEY,(int)sizeof(PUBLIC_KEY));
    EVP_PKEY* public_key_evp = PEM_read_bio_PUBKEY(public_bio,NULL,NULL,NULL);
    RSA* public_key_rsa = EVP_PKEY_get1_RSA(public_key_evp);

    decr_c = (char*)malloc(RSA_size(public_key_rsa));

    RSA_public_decrypt(encr_len,
                       (unsigned char*)signature_c,
                       (unsigned char*)decr_c,
                       public_key_rsa,
                       RSA_PKCS1_PADDING);

    hash = string(decr_c);
    free(decr_c);

    return hash;
}
