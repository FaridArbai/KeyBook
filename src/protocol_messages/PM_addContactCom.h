/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactCom.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:23 PM
 */

#ifndef PM_ADDCONTACTCOM_H
#define PM_ADDCONTACTCOM_H

#include "ProtocolMessage.h"
#include <string>

using namespace std;

class PM_addContactCom : public ProtocolMessage{
public:
    static const string name;
    
    PM_addContactCom();
    PM_addContactCom(const PM_addContactCom& orig);
    PM_addContactCom(string contact, string status, string status_date, string image, string presence, string presence_date);
    PM_addContactCom(string code);
    
    virtual ~PM_addContactCom();
    
    string toString();
    
    string getContact() const;
    void setContact(string contact);
    
    string getStatus() const;
    void setStatus(string status);
    
    string getStatusDate() const;
    void setStatusDate(string status_date);
    
    string getImage() const;
    void setImage(string image);
    
    string getPresence() const;
    void setPresence(string presence);
    
    string getPresenceDate() const;
    void setPresenceDate(string presence_date);
private:
    string contact;
    string status;
    string status_date;
    string image;
    string presence;
    string presence_date;
};

#endif /* PM_ADDCONTACTCOM_H */

