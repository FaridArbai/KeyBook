#ifndef PUBLICENGINE_H
#define PUBLICENGINE_H

#include "src/protocol_messages/encoding/base64.h"

#include <string.h>
#include <string>

using std::string;

class PublicEngine{
public:
    PublicEngine() = delete;

    static bool verifySignature(const string& payload, const string& signature);

private:
    static const char PUBLIC_KEY[];
};

#endif // PUBLICENGINE_H
