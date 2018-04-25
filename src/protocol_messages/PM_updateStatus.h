/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_updateStatus.h
 * Author: Faraday
 *
 * Created on December 2, 2017, 7:24 PM
 */

#ifndef PM_UPDATESTATUS_H
#define PM_UPDATESTATUS_H

#include <string>
#include <ctime>
#include "src/protocol_messages/ProtocolMessage.h"
#include "src/user_management/avatar.h"
#include "src/protocol_messages/encoding/base64.h"

using namespace std;

class PM_updateStatus : public ProtocolMessage{
public:
    static const string name;
    
    enum class StatusType{
        status,
        image,
        presence,
        unknown
    };
    
    PM_updateStatus();
    PM_updateStatus(const PM_updateStatus& orig);
    PM_updateStatus(string username, StatusType type, string new_status);
    PM_updateStatus(string username, Avatar avatar);
    PM_updateStatus(string code);
    
    virtual ~PM_updateStatus();
    
    string getUsername() const;
    void setUsername(string username);
    
    string getNewStatus() const;
    void setNewStatus(string new_status);
    
    string getDate() const;
    void setDate(string date);
    
    StatusType getType() const;
    void setType(StatusType type);
    
    string toString();
    
    Avatar getAvatar();

    void encode();
    void decode();

    static StatusType typeOf(string str_type);
    static string stringOf(StatusType type);
    
private:
    string username;
    string new_status;
    string date;
    StatusType type;
    
    string encodeAvatar(Avatar avatar);

    string decodeAvatarFormat();
    string decodeAvatarBinary();
};

#endif /* PM_UPDATESTATUS_H */

