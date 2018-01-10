/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactReq.cpp
 * Author: Faraday
 * 
 * Created on December 2, 2017, 7:22 PM
 */

#include "PM_addContactReq.h"

const string PM_addContactReq::name = "addContactReq";

PM_addContactReq::PM_addContactReq() {
}

PM_addContactReq::PM_addContactReq(const PM_addContactReq& orig) {
	this->setFrom(orig.getFrom());
	this->setContact(orig.getContact());
}

PM_addContactReq::PM_addContactReq(string from, string contact){
	this->setFrom(from);
	this->setContact(contact);
}

PM_addContactReq::~PM_addContactReq() {
}

PM_addContactReq::PM_addContactReq(string code){
	string from;
	string contact;
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
	from = code.substr(i0,iF);
	
	i0 = pos_secnd_space + 1;
	iF = l_code - i0;
	contact = code.substr(i0,iF);
	
    this->setFrom(from);
    this->setContact(contact);
}

string PM_addContactReq::toString(){
	string code = "";
	string name = PM_addContactReq::name;
	string from = this->getFrom();
	string contact = this->getContact();
	
	code += name + " ";
	code += from + " ";
	code += contact + "\n";
	
	return code;
}

string PM_addContactReq::getFrom() const{
	return this->from;
}

void PM_addContactReq::setFrom(string from){
	this->from = from;
}
    
string PM_addContactReq::getContact() const{
	return this->contact;
}

void PM_addContactReq::setContact(string contact){
	this->contact = contact;
}
