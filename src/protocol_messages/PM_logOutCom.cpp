/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logOutCom.cpp
 * Author: Faraday
 * 
 * Created on December 9, 2017, 1:43 AM
 */

#include "PM_logOutCom.h"

const string PM_logOutCom::name = "logOutCom";

PM_logOutCom::PM_logOutCom() {
}

PM_logOutCom::PM_logOutCom(const PM_logOutCom& orig) {
	this->setErrMsg(orig.getErrMsg());
}

PM_logOutCom::PM_logOutCom(string code_or_errMsg){
	string err_msg;
	size_t pos_head = code_or_errMsg.find(PM_logOutCom::name);
	bool is_code = (pos_head!=string::npos); 
	
	if(is_code){
		string code = code_or_errMsg;
		int l_code = code.length();
		int pos_split = code.find(" ");
		err_msg = code.substr(pos_split+1, l_code-pos_split-1);
	}
	else{
		err_msg = code_or_errMsg;
	}
	
	this->setErrMsg(err_msg);
}

PM_logOutCom::~PM_logOutCom() {
}

string PM_logOutCom::toString(){
	string code;
	string head = PM_logOutCom::name;
	string err_msg = this->getErrMsg();
	
	code += head + " ";
	code += err_msg + "\n";
	
	return code;
}

string PM_logOutCom::getErrMsg() const{
	return this->err_msg;
}

void PM_logOutCom::setErrMsg(string err_msg){
	this->err_msg = err_msg;
}