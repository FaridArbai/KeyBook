#ifndef LATCHWORD_H
#define LATCHWORD_H

#include <string>
#include <src/encryption_engines/symmetricengine.h>
#include <src/user_management/message.h>

using namespace std;


class Latchword{
public:
    Latchword();
    Latchword(string password);

    string getPTPKey() const;
    void setPTPKey(string ptp_key);

    string encrypt(string message);
    string decrypt(string encr);

    Message* decrypt(Message* encr);

    string toString();
private:
    string ptp_key;
    SymmetricEngine ptp_engine;
};

#endif // LATCHWORD_H
