/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_undefined.h
 * Author: Faraday
 *
 * Created on December 3, 2017, 9:53 PM
 */

#ifndef PM_UNDEFINED_H
#define PM_UNDEFINED_H

#include "src/protocol_messages/ProtocolMessage.h"

#include <string>
using std::string;

class PM_undefined : public ProtocolMessage{
public:
    static const string name;
    
    PM_undefined();
    PM_undefined(const PM_undefined& orig);
    virtual ~PM_undefined();
    
    string toString();
private:

};

#endif /* PM_UNDEFINED_H */

