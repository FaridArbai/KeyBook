/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactReq.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:22 PM
 */

#ifndef PM_ADDCONTACTREQ_H
#define PM_ADDCONTACTREQ_H

#include "ProtocolMessage.h"

#include <string>

using namespace std;


class PM_addContactReq : public ProtocolMessage{
public:
    static const string name;
    
    PM_addContactReq();
    PM_addContactReq(const PM_addContactReq& orig);
    
    PM_addContactReq(string from, string contact);
    PM_addContactReq(string code);
    
    
    virtual ~PM_addContactReq();
    
    string toString();
    
    string getFrom() const;
    void setFrom(string from);
    
    string getContact() const;
    void setContact(string contact);
    
private:
    string from;
    string contact;
    
};

#endif /* PM_ADDCONTACTREQ_H */

