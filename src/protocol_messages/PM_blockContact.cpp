/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_blockContact.cpp
 * Author: Faraday
 * 
 * Created on December 4, 2017, 11:18 PM
 */

#include "PM_blockContact.h"

const string PM_blockContact::name = "blockContact";

PM_blockContact::PM_blockContact() {
}

PM_blockContact::PM_blockContact(const PM_blockContact& orig) {
	this->setFrom(orig.getFrom());
	this->setContact(orig.getContact());
}

PM_blockContact::PM_blockContact(string from, string contact){
	this->setFrom(from);
	this->setContact(contact);
}

PM_blockContact::~PM_blockContact() {
}

PM_blockContact::PM_blockContact(string code){
	string from;
	string contact;
	int pos_first_space;
	int pos_secnd_space;
	int l_code;
	int i0, iF;
	
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

string PM_blockContact::toString(){
	string code = "";
	string name = PM_blockContact::name;
	string from = this->getFrom();
	string contact = this->getContact();
	
	code += name + " ";
	code += from + " ";
	code += contact + "\n";
	
	return code;
}

string PM_blockContact::getFrom() const{
	return this->from;
}

void PM_blockContact::setFrom(string from){
	this->from = from;
}
    
string PM_blockContact::getContact() const{
	return this->contact;
}

void PM_blockContact::setContact(string contact){
	this->contact = contact;
}
