#include "servermessage.h"

ServerMessage::ServerMessage()
{

}

ServerMessage::ServerMessage(ProtocolMessage* pm){
    this->setProtocolMessage(pm);
}

void ServerMessage::setProtocolMessage(ProtocolMessage* pm){
    this->pm = pm;
}

ProtocolMessage* ServerMessage::getProtocolMessage(){
    return this->pm;
}

