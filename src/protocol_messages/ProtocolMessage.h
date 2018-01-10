/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   ProtocolMessage.h
 * Author: Faraday
 *
 * Created on November 30, 2017, 8:38 PM
 */



#ifndef PROTOCOLMESSAGE_H
#define PROTOCOLMESSAGE_H

#include <string>
#include <iostream>
#include <ctime>

using std::string;
using std::cout;
using std::endl;


class ProtocolMessage {
public:
    
    enum class MessageType{
	logReq,
	logRep,
	regReq,
	regRep,
	updateStatus,
	addContactReq,
	addContactRep,
    addContactCom,
	delContact,
    blockContact,
	msg,
	logOutReq,
	logOutRep,
    logOutCom,
    undefined
    };
    
    ProtocolMessage();
    ProtocolMessage(const ProtocolMessage& orig);
    virtual ~ProtocolMessage();
    
    virtual string toString() = 0;
    
    static ProtocolMessage* decode(string str);
    static MessageType getMessageTypeOf(string str);
    static MessageType getMessageTypeOf(ProtocolMessage* pm);
    static string getGenerationDate();

    MessageType getType();

    bool isResponse();
private:
    
    
};

#endif /* PROTOCOLMESSAGE_H */

