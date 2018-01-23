#ifndef PUBLICENGINE_H
#define PUBLICENGINE_H

#include "src/protocol_messages/encoding/base64.h"

#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/sha.h>

#include <string.h>
#include <string>

using std::string;

class PublicEngine{
public:
    PublicEngine() = delete;

    static string encrypt(const string& message);
    static bool verifySignature(const string& payload, const string& signature);

private:
    static const char PUBLIC_KEY[];

    static string sha256(const string& payload);
    static string decryptHash(const string& signature);
};

#endif // PUBLICENGINE_H
