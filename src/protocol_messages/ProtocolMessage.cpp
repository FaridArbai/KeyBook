/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   ProtocolMessage.cpp
 * Author: Faraday
 * 
 * Created on November 30, 2017, 8:38 PM
 */

#include "src/protocol_messages/ProtocolMessage.h"
#include "src/protocol_messages/PM_logReq.h"
#include "src/protocol_messages/PM_logRep.h"
#include "src/protocol_messages/PM_regReq.h"
#include "src/protocol_messages/PM_regRep.h"
#include "src/protocol_messages/PM_addContactReq.h"
#include "src/protocol_messages/PM_addContactCom.h"
#include "src/protocol_messages/PM_addContactRep.h"
#include "src/protocol_messages/PM_updateStatus.h"
#include "src/protocol_messages/PM_undefined.h"
#include "src/protocol_messages/PM_blockContact.h"
#include "src/protocol_messages/PM_msg.h"
#include "src/protocol_messages/PM_logOutReq.h"
#include "src/protocol_messages/PM_logOutRep.h"
#include "src/protocol_messages/PM_logOutCom.h"
#include "src/protocol_messages/PM_delContact.h"

ProtocolMessage::ProtocolMessage() {
}

ProtocolMessage::ProtocolMessage(const ProtocolMessage& orig) {
}

ProtocolMessage::~ProtocolMessage() {
}

ProtocolMessage* ProtocolMessage::decode(string str){
	ProtocolMessage* pm;
	ProtocolMessage::MessageType m_type;
	
	m_type = ProtocolMessage::getMessageTypeOf(str);
	
	switch (m_type){
		case(ProtocolMessage::MessageType::logReq):{
			pm =  new PM_logReq(str);
			break;
		}
		case(ProtocolMessage::MessageType::logRep):{
			pm =  new PM_logRep(str);
			break;
		}
		case(ProtocolMessage::MessageType::regReq):{
			pm =  new PM_regReq(str);
			break;
		}
		case(ProtocolMessage::MessageType::regRep):{
            pm =  new PM_regRep(str);
			break;
		}
		case(ProtocolMessage::MessageType::addContactReq):{
			pm =  new PM_addContactReq(str);
			break;
		}
		case(ProtocolMessage::MessageType::addContactRep):{
			pm =  new PM_addContactRep(str);
			break;
		}
		case(ProtocolMessage::MessageType::addContactCom):{
			pm =  new PM_addContactCom(str);
			break;
		}
		case(ProtocolMessage::MessageType::updateStatus):{
			pm =  new PM_updateStatus(str);
			break;
		}
		case(ProtocolMessage::MessageType::blockContact):{
			pm =  new PM_blockContact(str);
			break;
		}
		case(ProtocolMessage::MessageType::msg):{
			pm =  new PM_msg(str);
			break;
		}
		case(ProtocolMessage::MessageType::logOutReq):{
			pm =  new PM_logOutReq();
			break;
		}
		case(ProtocolMessage::MessageType::logOutRep):{
			pm =  new PM_logOutRep();
			break;
		}
		case(ProtocolMessage::MessageType::logOutCom):{
			pm =  new PM_logOutCom(str);
			break;
		}
		case(ProtocolMessage::MessageType::delContact):{
			pm =  new PM_delContact(str);
			break;
		}
		default :{ 
			pm = new PM_undefined();
			break;
		}
	}
	
	return pm;
}

ProtocolMessage::MessageType ProtocolMessage::getMessageTypeOf(string str){
	string header = str.substr(0, str.find(' '));
	ProtocolMessage::MessageType m_type;
	
	if(header==PM_logReq::name){
        m_type = ProtocolMessage::MessageType::logReq;
	}
	else if (header==PM_logRep::name){
        m_type = ProtocolMessage::MessageType::logRep;
	}
	else if (header==PM_regReq::name){
        m_type = ProtocolMessage::MessageType::regReq;
	}
	else if (header==PM_regRep::name){
        m_type = ProtocolMessage::MessageType::regRep;
	}
	else if (header==PM_addContactReq::name){
        m_type = ProtocolMessage::MessageType::addContactReq;
	}
	else if (header==PM_addContactRep::name){
        m_type = ProtocolMessage::MessageType::addContactRep;
	}
	else if (header==PM_addContactCom::name){
        m_type = ProtocolMessage::MessageType::addContactCom;
	}
	else if (header==PM_updateStatus::name){
        m_type = ProtocolMessage::MessageType::updateStatus;
	}
	else if (header==PM_blockContact::name){
        m_type = ProtocolMessage::MessageType::blockContact;
	}
	else if (header==PM_msg::name){
        m_type = ProtocolMessage::MessageType::msg;
	}
	else if (header==PM_logOutReq::name){
        m_type = ProtocolMessage::MessageType::logOutReq;
	}
	else if (header==PM_logOutRep::name){
        m_type = ProtocolMessage::MessageType::logOutRep;
	}
	else if (header==PM_logOutCom::name){
        m_type = ProtocolMessage::MessageType::logOutCom;
	}
	else if (header==PM_delContact::name){
        m_type = ProtocolMessage::MessageType::delContact;
	}
	else{
        m_type = ProtocolMessage::MessageType::undefined;
	}
	
	return m_type;
}

ProtocolMessage::MessageType ProtocolMessage::getMessageTypeOf(ProtocolMessage* pm){
	string pm_str;
	MessageType m_type;
	
	pm_str = pm->toString();
	m_type = ProtocolMessage::getMessageTypeOf(pm_str);
	
	return m_type;
}

string ProtocolMessage::getGenerationDate(){
	time_t t = time(0);
	struct tm* todays_date = localtime(&t);
	
	string day = std::to_string(todays_date->tm_mday);
	string month = std::to_string(todays_date->tm_mon + 1);
	string year = std::to_string((todays_date->tm_year + 1900)%2000);
	string hour = std::to_string(todays_date->tm_hour);
	string minute = std::to_string(todays_date->tm_min);
	string weekday = std::to_string(todays_date->tm_wday);
	
	if(hour.length()==1){
		hour = "0" + hour;
	}
		
	if(minute.length()==1){
		minute = "0" + minute;
	}
	
	string date = weekday + "-" + day+"/"+month+"/"+year+"-"+hour+":"+minute;
	
	return date;
}

bool ProtocolMessage::isResponse(){
    bool is_response;
    MessageType m_type = getMessageTypeOf(this);

    is_response = !((m_type==MessageType::updateStatus)||(m_type==MessageType::addContactCom)||(m_type==MessageType::msg));

    return is_response;
}

ProtocolMessage::MessageType ProtocolMessage::getType(){
    MessageType type = ProtocolMessage::getMessageTypeOf(this);

    return type;
}
