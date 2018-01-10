/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logRep.h
 * Author: Faraday
 *
 * Created on December 1, 2017, 4:05 PM
 */

#ifndef PM_LOGREP_H
#define PM_LOGREP_H

#include "src/protocol_messages/ProtocolMessage.h"
#include <string>
using std::string;


class PM_logRep: public ProtocolMessage{
public:
    static const string name;
    
    PM_logRep();
    PM_logRep(const PM_logRep& orig);
    PM_logRep(bool result, string err_msg);
    PM_logRep(string code);
    virtual ~PM_logRep();
    
    bool getResult() const;
    string getErrMsg() const;
    
    void setResult(bool result);
    void setErrMsg(string err_msg);
    
    string toString();

private:
    bool result;
    string err_msg;
    
};

#endif /* PM_LOGREP_H */

