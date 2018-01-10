/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_regRep.h
 * Author: Faraday
 *
 * Created on December 1, 2017, 6:42 PM
 */

#ifndef PM_REGREP_H
#define PM_REGREP_H

#include "src/protocol_messages/ProtocolMessage.h"
#include <string>
using std::string;


class PM_regRep: public ProtocolMessage{
public:
    static const string name;
    
    PM_regRep();
    PM_regRep(const PM_regRep& orig);
    PM_regRep(bool result, string err_msg);
    PM_regRep(string code);
    virtual ~PM_regRep();
    
    bool getResult() const;
    string getErrMsg() const;
    
    void setResult(bool result);
    void setErrMsg(string err_msg);
    
    string toString();

private:
    bool result;
    string err_msg;
    
};

#endif /* PM_REGREP_H */

