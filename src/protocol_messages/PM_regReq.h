/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_regReq.h
 * Author: Faraday
 *
 * Created on December 1, 2017, 6:37 PM
 */

#ifndef PM_REGREQ_H
#define PM_REGREQ_H

#include "src/protocol_messages/ProtocolMessage.h"
#include <string>

using std::string;
using std::cout;
using std::endl;


class PM_regReq: public ProtocolMessage{
public:
    static const string name;
    
    PM_regReq();
    PM_regReq(const PM_regReq& orig);
    PM_regReq(string username, string password);
    PM_regReq(string code);
    virtual ~PM_regReq();
    
    string getUsername() const;
    string getPassword() const;
    void setUsername(string username);
    void setPassword(string password);
    
    string toString();

private:
    string username;
    string password;
    
};

#endif /* PM_REGREQ_H */

