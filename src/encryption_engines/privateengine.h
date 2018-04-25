#ifndef PRIVATEENGINE_H
#define PRIVATEENGINE_H

#include "src/protocol_messages/encoding/base64.h"

#include <string.h>
#include <string>

using std::string;

class PrivateEngine{
public:
    PrivateEngine()=delete;

    static string decrypt(const string& encr);
    static string sign(const string& msg);

private:
    static const char PRIVATE_KEY[];

    static string sha256(const string& msg);
    static string encryptHash(const string& hash);
};

#endif // PRIVATEENGINE_H
