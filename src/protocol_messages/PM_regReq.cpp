/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_regReq.cpp
 * Author: Faraday
 * 
 * Created on December 1, 2017, 6:37 PM
 */

#include "src/protocol_messages/PM_regReq.h"


const string PM_regReq::name = "regReq";

PM_regReq::PM_regReq() {
}

PM_regReq::PM_regReq(string username, string password){
	this->setUsername(username);
	this->setPassword(password);
}

PM_regReq::PM_regReq(string code){
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

PM_regReq::PM_regReq(const PM_regReq& orig) {
	this->setUsername(orig.getUsername());
	this->setPassword(orig.getPassword());
}

PM_regReq::~PM_regReq() {
}

string PM_regReq::toString(){
	string str = "";
    string username_encr = RSA::encrypt(this->getUsername());
    string password_encr = RSA::encrypt((this->getPassword()));

	str += PM_regReq::name + " ";
    str += username_encr + " ";
    str += password_encr + "\n";
	
	return str;
}

void PM_regReq::setUsername(string username){
	this->username = username;
}

string PM_regReq::getUsername() const{
	return this->username;
}

void PM_regReq::setPassword(string password){
	this->password = password;
}
		
string PM_regReq::getPassword() const{
	return this->password;
}
