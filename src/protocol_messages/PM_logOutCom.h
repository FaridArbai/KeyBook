/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logOutCom.h
 * Author: Faraday
 *
 * Created on December 9, 2017, 1:43 AM
 */

#ifndef PM_LOGOUTCOM_H
#define PM_LOGOUTCOM_H

#include "ProtocolMessage.h"
#include <string>

using namespace std;

class PM_logOutCom : public ProtocolMessage{
public:
    static const string name;
    
    PM_logOutCom();
    PM_logOutCom(const PM_logOutCom& orig);
    PM_logOutCom(string code_or_ErrMsg);
    virtual ~PM_logOutCom();
    
    string getErrMsg() const;
    void setErrMsg(string err_msg);
    
    string toString();
    
private:
    string err_msg;
    
};

#endif /* PM_LOGOUTCOM_H */

