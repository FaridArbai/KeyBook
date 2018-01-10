/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logOutRep.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:27 PM
 */

#ifndef PM_LOGOUTREP_H
#define PM_LOGOUTREP_H
#include "ProtocolMessage.h"
#include <string>
using namespace std;

class PM_logOutRep : public ProtocolMessage{
public:
    static const string name;
    
    PM_logOutRep();
    PM_logOutRep(const PM_logOutRep& orig);
    virtual ~PM_logOutRep();
    
    string toString();
private:

};

#endif /* PM_LOGOUTREP_H */

