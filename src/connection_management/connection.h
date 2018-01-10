#ifndef CONNECTION_H
#define CONNECTION_H

#include "src/protocol_messages/protocolmessage.h"
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <thread>
#include <stdlib.h>
#include <valarray>
#include <winsock2.h>
#include <ws2tcpip.h>

#define R_IP "faridarbai.ddns.net"
#define R_PORT "25"

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
    static const int BUFFER_SIZE = 1048576; //1MB(max image size)
    int socket;
    bool conn_err = false;
    string err_msg;

    void setErrMsg(string err_msg);
    void activateConnErr();
    void setSocket(int socket);
};

#endif // CONNECTION_H
