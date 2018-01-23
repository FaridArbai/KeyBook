#ifndef SYMMETRICENGINE_H
#define SYMMETRICENGINE_H


#include "src/encryption_engines/encryption/aes.h"
#include "src/protocol_messages/encoding/base64.h"

#include <string>
#include <algorithm>

using std::string;

class SymmetricEngine{
public:
    static const int KEY_LENGTH = 16;
    static const char PAD_TOKEN;

    SymmetricEngine();

    string encrypt(const string& orig);
    string decrypt(const string& encr);

    void init(string key_send, string iv_send, string key_recv, string iv_recv);
    void setKeys(string key_send, string key_recv);
    void refresh();

private:
    uint8_t initial_key_send[KEY_LENGTH];
    uint8_t initial_iv_send[KEY_LENGTH];
    uint8_t initial_key_recv[KEY_LENGTH];
    uint8_t initial_iv_recv[KEY_LENGTH];

    AES::AES_ctx ctx_send;
    AES::AES_ctx ctx_recv;

    static void copyBytes(string from, uint8_t* to);
    static void copyBytes(uint8_t* from, uint8_t* to);

    void initCtxSend();
    void initCtxRecv();

    static string pad(const string& orig);
    static string unpad(const string& orig);
};

#endif // SYMMETRICENGINE_H
