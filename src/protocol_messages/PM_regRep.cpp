/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_regRep.cpp
 * Author: Faraday
 * 
 * Created on December 1, 2017, 6:42 PM
 */

#include "src/protocol_messages/PM_regRep.h"

const string PM_regRep::name = "regRep";

PM_regRep::PM_regRep() {
}

PM_regRep::PM_regRep(bool result, string err_msg){
	this->setResult(result);
	this->setErrMsg(err_msg);
}

PM_regRep::PM_regRep(string code){
	string body;
	string result_str;
	bool result;
	string err_msg;
	
	int pos_first_sp = code.find(" ");
	int l_code = code.length();
	
	body = code.substr(pos_first_sp+1, l_code);
	
	int pos_second_sp = body.find(" ");
	int l_body = body.length(); //Removing last \n
	
	result_str = body.substr(0, pos_second_sp);
	err_msg = body.substr(pos_second_sp+1, l_body);
	
	result = (result_str=="OK");
	
	this->setResult(result);
	this->setErrMsg(err_msg);
}

PM_regRep::PM_regRep(const PM_regRep& orig) {
	this->setResult(orig.getResult());
	this->setErrMsg(orig.getErrMsg());
}

PM_regRep::~PM_regRep() {
}

string PM_regRep::toString(){
	string str = "";
	string result_str = (this->getResult()) ? "OK":"NOK";
	
	
	str += PM_regRep::name + " ";
	str += result_str + " ";
	str += this->getErrMsg() + "\n";
	
	return str;
}


void PM_regRep::setResult(bool result){
	this->result = result;
	
 }

bool PM_regRep::getResult() const{
	return this->result;
}

void PM_regRep::setErrMsg(string err_msg){
	this->err_msg = err_msg;
}
		
string PM_regRep::getErrMsg() const{
	return this->err_msg;
}
