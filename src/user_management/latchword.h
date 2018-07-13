#ifndef LATCHWORD_H
#define LATCHWORD_H

#include <string>
#include <src/encryption_engines/symmetricengine.h>
#include <src/encryption_engines/publicengine.h>
#include <src/user_management/message.h>
#include <src/user_management/signedtext.h>
#include <QDebug>

using namespace std;


class Latchword{
public:
    Latchword();
    Latchword(string password);

    string getPTPKey() const;
    void setPTPKey(string ptp_key);

    string encrypt(string message);
    SignedText decrypt(string& encr);

    Message* decrypt(Message* encr);

    string toString();
private:
    string ptp_key;
    SymmetricEngine ptp_engine;
    static const string HASH_SEPARATOR;
};

#endif // LATCHWORD_H
