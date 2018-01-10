#ifndef SERVERMESSAGE_H
#define SERVERMESSAGE_H


#include <src/protocol_messages/ProtocolMessage.h>

class ServerMessage{
public:
    ServerMessage();
    ServerMessage(ProtocolMessage* pm);

    void setProtocolMessage(ProtocolMessage* pm);
    ProtocolMessage* getProtocolMessage();

private:
    ProtocolMessage* pm;
};

#endif // SERVERMESSAGE_H
