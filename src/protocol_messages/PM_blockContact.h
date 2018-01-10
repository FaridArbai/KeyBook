/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_blockContact.h
 * Author: Faraday
 *
 * Created on December 4, 2017, 11:18 PM
 */

#ifndef PM_BLOCKCONTACT_H
#define PM_BLOCKCONTACT_H

#include "ProtocolMessage.h"

#include <string>

using namespace std;


class PM_blockContact : public ProtocolMessage{
public:
    static const string name;
    
    PM_blockContact();
    PM_blockContact(const PM_blockContact& orig);
    
    PM_blockContact(string from, string contact);
    PM_blockContact(string code);
    
    
    virtual ~PM_blockContact();
    
    string toString();
    
    string getFrom() const;
    void setFrom(string from);
    
    string getContact() const;
    void setContact(string contact);
    
private:
    string from;
    string contact;
    
};

#endif /* PM_BLOCKCONTACT_H */

