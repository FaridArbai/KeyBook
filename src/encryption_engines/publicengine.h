#ifndef PUBLICENGINE_H
#define PUBLICENGINE_H

#include "src/protocol_messages/encoding/base64.h"
#include "src/user_management/stda.h"
#include <QDebug>

#ifndef ANDROID
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/bio.h>
#include <openssl/sha.h>
#else
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QString>
#endif

#include <string.h>
#include <string>


using std::string;

class PublicEngine{
public:
    PublicEngine() = delete;

    static string encrypt(string message);
    static bool verifySignature(const string& payload, const string& signature);

    static string sha256(string payload);
    static string computeBase64Hash(const string& payload);
private:
    static const char PUBLIC_KEY[];

    static string decryptHash(const string& signature);
    static string computeLog(string str);
};

#endif // PUBLICENGINE_H
