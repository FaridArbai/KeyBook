#ifndef CONNECTION_H
#define CONNECTION_H

#include <algorithm>
#include <cstdlib>
#include <ctime>
#include "src/encryption_engines/publicengine.h"
#include "src/encryption_engines/privateengine.h"
#include "src/encryption_engines/symmetricengine.h"
#include "src/protocol_messages/ProtocolMessage.h"
#include "src/protocol_messages/PM_logRep.h"
#include "src/protocol_messages/PM_msg.h"
#include "src/protocol_messages/PM_updateStatus.h"
#include "src/protocol_messages/PM_addContactCom.h"
#include "src/protocol_messages/PM_addContactRep.h"
#include "src/protocol_messages/encoding/base64.h"
#include "src/user_management/stda.h"
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <thread>
#include <stdlib.h>
#include <valarray>
#include <mutex>

#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
#else
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <netdb.h>
#endif

#include <string>
using namespace std;

class Connection{
public:
    Connection();
    Connection(const Connection& orig);
    Connection( int socket );

    virtual ~Connection();

    void sendPM(ProtocolMessage* pm);
    ProtocolMessage* recvPM();

    void close();

    bool err();
    string getErrMsg();

    int getSocket() const;

private:
    static const string R_IP;
    static const string R_PORT;
    static const int BUFFER_SIZE; //1MB
    static const char END_DELIM;
    static const char SIGNATURE_DELIM;
    static const int SERVER_EXCHANGE_SIZE;

    int socket;
    bool conn_err = false;
    string err_msg;

    SymmetricEngine encryption_engine;
    void initEngine();

    void clearDelims(string& orig);

    void setErrMsg(string err_msg);
    void activateConnErr();
    void setSocket(int socket);

    static string generateRandomString(int length);
    static unsigned int generateSeed();

    static string getSignature(const string& signed_message);
    static string clearSignature(const string& signed_message);
};

#endif // CONNECTION_H
