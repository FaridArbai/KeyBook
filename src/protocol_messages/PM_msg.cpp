/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_msg.cpp
 * Author: Faraday
 * 
 * Created on December 2, 2017, 7:21 PM
 */

#include "src/protocol_messages/PM_msg.h"

const string PM_msg::name = "msg";

PM_msg::PM_msg() {
}

PM_msg::PM_msg(const PM_msg& orig) {
	this->setFrom(orig.getFrom());
	this->setTo(orig.getTo());
	this->setDate(orig.getDate());
	this->setMsg(orig.getMsg());
}

PM_msg::~PM_msg() {
}

PM_msg::PM_msg(string from, string to, string msg){
	string date = ProtocolMessage::getGenerationDate();
	
	this->setFrom(from);
	this->setTo(to);
	this->setDate(date);
	this->setMsg(msg);
}

PM_msg::PM_msg(string code){
	string from;
	string to;
	string date;
	string msg;
	int i0, iF;
	int pos_first_space;
	int pos_secnd_space;
	int pos_third_space;
	int pos_fourth_space;
	int l_code;
	
	l_code = code.length();
	
	pos_first_space = code.find(" ");
	
	i0 = pos_first_space + 1;
	iF = l_code - i0;
	pos_secnd_space = (code.substr(i0,iF)).find(" ") + pos_first_space + 1;
	
	i0 = pos_secnd_space + 1;
	iF = l_code - i0;
	pos_third_space = (code.substr(i0,iF)).find(" ") + pos_secnd_space + 1;
	
	i0 = pos_third_space + 1;
	iF = l_code - i0;
	pos_fourth_space = (code.substr(i0,iF)).find(" ") + pos_third_space + 1;
			  
	i0 = pos_first_space + 1;
	iF = pos_secnd_space - i0;
	from = code.substr(i0, iF);
	
	i0 = pos_secnd_space + 1;
	iF = pos_third_space - i0;
	to = code.substr(i0, iF);
	
	i0 = pos_third_space + 1;
	iF = pos_fourth_space - i0;
	date = code.substr(i0, iF);
	
	i0 = pos_fourth_space + 1;
	iF = l_code - i0;
	msg = code.substr(i0, iF);
	
    this->setFrom(from);
    this->setTo(to);
    this->setDate(date);
    this->setMsg(msg);
}
	
string PM_msg::toString(){
	string code = "";
	string head = PM_msg::name;
	string from = this->getFrom();
	string to = this->getTo();
	string date = this->getDate();
	string msg = this->getMsg();
	
	code += head	+ " ";
	code += from	+ " ";
	code += to		+ " ";
	code += date	+ " ";
	code += msg		+ "\n";
	
	return code;
}
    
string PM_msg::getFrom() const{
	return this->from;
}

void PM_msg::setFrom(string from){
	this->from = from;
}
    
string PM_msg::getTo() const{
	return this->to;
}

void PM_msg::setTo(string to){
	this->to = to;
}

string PM_msg::getDate() const{
	return this->date;
}

void PM_msg::setDate(string date){
	this->date = date;
}

string PM_msg::getMsg() const{
	return this->msg;
}

void PM_msg::setMsg(string msg){
	this->msg = msg;
}
