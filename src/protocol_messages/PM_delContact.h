/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_delContact.h
 * Author: Faraday
 *
 * Created on December 9, 2017, 10:56 PM
 */

#ifndef PM_DELCONTACT_H
#define PM_DELCONTACT_H

#include<string>
#include "ProtocolMessage.h"

using namespace std;

class PM_delContact : public ProtocolMessage{
public:
    static const string name;
    
    PM_delContact();
    PM_delContact(const PM_delContact& orig);
    
    PM_delContact(string code);
    
    virtual ~PM_delContact();
    
    string toString();
    
    string getFrom() const;
    void setFrom(string from);
    
    string getTo() const;
    void setTo(string to);
    
private:
    string from;
    string to;
    
};

#endif /* PM_DELCONTACT_H */

