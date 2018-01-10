/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactRep.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:22 PM
 */

#ifndef PM_ADDCONTACTREP_H
#define PM_ADDCONTACTREP_H

#include "ProtocolMessage.h"
#include <string>

using namespace std;

class PM_addContactRep : public ProtocolMessage{
public:
    static const string name;
    
    PM_addContactRep();
    PM_addContactRep(const PM_addContactRep& orig);
    
    PM_addContactRep(bool result, string err_msg);
    PM_addContactRep(string status, string status_date, string image, string presence, string presence_date);
    PM_addContactRep(string code);
    
    virtual ~PM_addContactRep();
    
    string toString();
    
    bool getResult() const;
    void setResult(bool result);
    
    string getErrMsg() const;
    void setErrMsg(string err_msg);
    
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
    bool result;
    string err_msg;
    string status;
    string status_date;
    string image;
    string presence;
    string presence_date;
};

#endif /* PM_ADDCONTACTREP_H */

