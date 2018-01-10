/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logOutReq.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:27 PM
 */

#ifndef PM_LOGOUTREQ_H
#define PM_LOGOUTREQ_H

#include "src/protocol_messages/ProtocolMessage.h"

#include <string>
using namespace std;

class PM_logOutReq : public ProtocolMessage{
public:
    static const string name;
    PM_logOutReq();
    PM_logOutReq(const PM_logOutReq& orig);
    virtual ~PM_logOutReq();
    
    string toString();
    
private:

};

#endif /* PM_LOGOUTREQ_H */

