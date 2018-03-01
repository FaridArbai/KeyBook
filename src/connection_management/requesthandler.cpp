#include "requesthandler.h"

RequestHandler::RequestHandler(){
}

RequestHandler::RequestHandler(Connection* server_conn, ServerMessage* server_message, QWaitCondition* RESPONSE_CONDITION){
    this->setServerConn(server_conn);
    this->setServerMessage(server_message);
    this->setResponseCondition(RESPONSE_CONDITION);
}

void RequestHandler::sendTrap(ProtocolMessage* trap){
    this->server_conn->sendPM(trap);
}

ProtocolMessage* RequestHandler::recvResponseFor(ProtocolMessage* request){
    ProtocolMessage* response;

    server_conn->sendPM(request);

    this->response_mutex.lock();
        this->RESPONSE_CONDITION->wait(&(this->response_mutex));
    this->response_mutex.unlock();

    response = this->server_message->getProtocolMessage();

    return response;
}

void RequestHandler::setServerConn(Connection* server_conn){
    this->server_conn = server_conn;
}

void RequestHandler::setServerMessage(ServerMessage* server_message){
    this->server_message = server_message;
}

void RequestHandler::setResponseCondition(QWaitCondition* RESPONSE_CONDITION){
    this->RESPONSE_CONDITION = RESPONSE_CONDITION;
}

