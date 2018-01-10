/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logReq.cpp
 * Author: Faraday
 * 
 * Created on December 1, 2017, 1:32 AM
 */

#include "src/protocol_messages/PM_logReq.h"

const string PM_logReq::ENCR_BLOCK_SEP = "/";
const string PM_logReq::name = "logReq";

PM_logReq::PM_logReq() {
}

PM_logReq::PM_logReq(string username, string password){
	this->setUsername(username);
	this->setPassword(password);
}

PM_logReq::PM_logReq(string code){
    string username;
    string password;
	int i0,iF;
	int pos_first_space;
	int pos_secnd_space;
	int l_code;

	l_code = code.length();
	
	pos_first_space = code.find(" ");
	
	i0 = pos_first_space + 1;
	iF = l_code - i0;
	pos_secnd_space = (code.substr(i0,iF)).find(" ") + pos_first_space + 1;
	
	i0 = pos_first_space + 1;
	iF = pos_secnd_space - i0;
    username = code.substr(i0,iF);
	
	i0 = pos_secnd_space + 1;
	iF = l_code - i0;
    password = code.substr(i0,iF);

    this->setUsername(username);
    this->setPassword(password);
}

PM_logReq::PM_logReq(const PM_logReq& orig) {
	this->setUsername(orig.getUsername());
	this->setPassword(orig.getPassword());
}

PM_logReq::~PM_logReq() {
}

string PM_logReq::toString(){
	string str = "";
    string username = this->getUsername();
    string username_encr = RSA::encrypt(username);
    string password = this->getPassword();
    string password_encr = RSA::encrypt(password);

	str += PM_logReq::name + " ";
    str += username_encr + " ";
    str += password_encr + "\n";
	
	return str;
}

void PM_logReq::setUsername(string username){
	this->username = username;
}

string PM_logReq::getUsername() const{
	return this->username;
}

void PM_logReq::setPassword(string password){
	this->password = password;
}
		
string PM_logReq::getPassword() const{
	return this->password;
}












































