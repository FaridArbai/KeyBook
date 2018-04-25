#ifndef REQUESTHANDLER_H
#define REQUESTHANDLER_H

#include "src/protocol_messages/ProtocolMessage.h"
#include "src/protocol_messages/PM_logReq.h"
#include "servermessage.h"
#include "connection.h"

#include <QWaitCondition>
#include <QMutex>

class RequestHandler{
public:
    RequestHandler();
    RequestHandler(const RequestHandler& orig);

    RequestHandler(Connection* server_conn, ServerMessage* server_message, QWaitCondition* RESPONSE_CONDITION);

    ProtocolMessage* recvResponseFor(ProtocolMessage* request);
    void sendTrap(ProtocolMessage* trap);

    void setServerConn(Connection* server_conn);
    void setServerMessage(ServerMessage* server_message);
    void setResponseCondition(QWaitCondition* RESPONSE_CONDITION);

private:
    Connection* server_conn;
    ServerMessage* server_message;
    QWaitCondition* RESPONSE_CONDITION;
    QMutex response_mutex;
};

#endif // REQUESTHANDLER_H
