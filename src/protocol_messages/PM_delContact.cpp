/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_delContact.cpp
 * Author: Faraday
 * 
 * Created on December 9, 2017, 10:56 PM
 */

#include "PM_delContact.h"

const string PM_delContact::name = "delContact";

PM_delContact::PM_delContact() {
}

PM_delContact::PM_delContact(const PM_delContact& orig) {
	this->setTo(orig.getTo());
	this->setFrom(orig.getFrom());
}

PM_delContact::PM_delContact(string code){
	string from;
	string to;
	string body;
	int pos_first_space;
	int pos_secnd_space;
	int i0, iF;
	
	pos_first_space = code.find(" ");
	
	i0 = pos_first_space + 1;
	iF = code.length() - i0;
	body = code.substr(i0,iF);
	
	pos_secnd_space = body.find(" ");
	
	i0 = 0;
	iF = pos_secnd_space;
	from = body.substr(i0,iF);
	
	i0 = pos_secnd_space + 1;
	iF = body.length()-i0;
	to = body.substr(i0,iF);
	
	this->setFrom(from);
	this->setTo(to);
}

PM_delContact::~PM_delContact() {
}

string PM_delContact::toString(){
	string code = "";
	string head = PM_delContact::name;
	string from = this->getFrom();
	string to = this->getTo();
	
	code += head + " ";
	code += from + " ";
	code += to + "\n";
	
	return code;
}

string PM_delContact::getFrom() const{
	return this->from;
}

void PM_delContact::setFrom(string from){
	this->from = from;
}

string PM_delContact::getTo() const{
	return to;
}

void PM_delContact::setTo(string to){
	this->to=to;
}

