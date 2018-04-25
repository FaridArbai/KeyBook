/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_msg.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:21 PM
 */

#ifndef PM_MSG_H
#define PM_MSG_H

#include "src/protocol_messages/ProtocolMessage.h"
#include "src/protocol_messages/encoding/base64.h"

#include <ctime>
#include <string>
using namespace std;

class PM_msg : public ProtocolMessage{
public:
    static const string name;
    
    PM_msg();
    PM_msg(const PM_msg& orig);
    
    PM_msg(string code);
    PM_msg(string from, string to, string msg);
    
    virtual ~PM_msg();
    
    virtual string toString();
    
    string getFrom() const;
    void setFrom(string from);
    
    string getTo() const;
    void setTo(string to);
    
    string getMsg() const;
    void setMsg(string msg);
    
    string getDate() const;
    void setDate(string date);
    
    void encode();
    void decode();
private:
    string from;
    string to;
    string msg;
    string date;
};

#endif /* PM_MSG_H */

