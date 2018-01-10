/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactRep.cpp
 * Author: Faraday
 * 
 * Created on December 2, 2017, 7:22 PM
 */

#include "PM_addContactRep.h"

const string PM_addContactRep::name = "addContactRep";

PM_addContactRep::PM_addContactRep() {
}

PM_addContactRep::PM_addContactRep(const PM_addContactRep& orig) {
	this->setResult(orig.getResult());
	this->setErrMsg(orig.getErrMsg());
	this->setStatus(orig.getStatus());
	this->setStatusDate(orig.getStatusDate());
	this->setImage(orig.getImage());
	this->setPresence(orig.getPresence());
	this->setPresenceDate(orig.getPresenceDate());
}

PM_addContactRep::PM_addContactRep(bool result, string err_msg){
	this->setResult(result);
	this->setErrMsg(err_msg);
	this->setStatus("");
	this->setStatusDate("");
	this->setImage("");
	this->setPresence("");
	this->setPresenceDate("");
}

PM_addContactRep::PM_addContactRep(string status, string status_date, string image, string presence, string presence_date){
	this->setResult(true);
	this->setErrMsg("");
	this->setStatus(status);
	this->setStatusDate(status_date);
	this->setImage(image);
	this->setPresence(presence);
	this->setPresenceDate(presence_date);
}

PM_addContactRep::PM_addContactRep(string code){
	string result_str;
	bool result;
	string err_msg;
	string status;
	string image;
	string status_date;
	string presence;
	string presence_date;
	string status_field;
	string presence_field;
	int pos_first_space;
	int pos_secnd_space;
	int i0, iF;
	int l_code;
	
	l_code = code.length();
	
	pos_first_space = code.find(" ");
	
	i0 = pos_first_space + 1;
	iF = l_code - i0;
	pos_secnd_space = (code.substr(i0,iF)).find(" ") + pos_first_space + 1;
	
	i0 = pos_first_space + 1;
	iF = pos_secnd_space - i0;
	result_str = code.substr(i0, iF);
	result = (result_str=="OK");
	
	if(result){
		int pos_split;
		string fields_status_image_presence;
		string fields_image_presence;
		
		//1. get the string containing the fields
		i0 = pos_secnd_space + 1;
		iF = l_code - i0;
		fields_status_image_presence = code.substr(i0,iF);
				  
		//2. get the status field preceding first #
		pos_split = fields_status_image_presence.find("#");
		i0 = 0;
		iF = pos_split;
		status_field = fields_status_image_presence.substr(i0,iF);
		
		i0 = pos_split + 1;
		iF = fields_status_image_presence.length() - i0;
		fields_image_presence = fields_status_image_presence.substr(i0,iF);
		
		//3. get the image field and the presence field
		pos_split = fields_image_presence.find("#");
		
		i0 = 0;
		iF = pos_split;
		image = fields_image_presence.substr(i0,iF);
		
		i0 = pos_split + 1;
		iF = fields_image_presence.length() - i0;
		presence_field = fields_image_presence.substr(i0,iF);
		
		//4. split status_field into the value and the date
		pos_split = status_field.find("@");
		
		i0 = 0;
		iF = pos_split;
		status = status_field.substr(i0,iF);
		
		i0 = pos_split + 1;
		iF = status_field.length() - i0;
		status_date = status_field.substr(i0,iF);
		
		//5. split presence_field into the value and the date
		pos_split = presence_field.find("@");
		
		i0 = 0;
		iF = pos_split;
		presence = presence_field.substr(i0,iF);
		
		i0 = pos_split + 1;
		iF = presence_field.length();
		presence_date = presence_field.substr(i0,iF);
	}
	else{
		i0 = pos_secnd_space + 1;
		iF = l_code - i0;
		err_msg = code.substr(i0, iF);
		status = "";
		status_date = "";
		image = "";
		presence = "";
		presence_date = "";
	}
	
	this->setResult(result);
	this->setErrMsg(err_msg);
	this->setStatus(status);
	this->setStatusDate(status_date);
	this->setImage(image);
	this->setPresence(presence);
	this->setPresenceDate(presence_date);
}

PM_addContactRep::~PM_addContactRep() {
}

string PM_addContactRep::toString(){
	string code = "";
	string name = PM_addContactRep::name;
	bool result = this->getResult();
	string result_str = (result)?"OK":"NOK";
	string err_msg = this->getErrMsg();
	string status_date = this->getStatusDate();
	string presence = this->getPresence();
	string presence_date = this->getPresenceDate();
	
	code += name + " ";
	code += result_str + " ";
	
	if(result==false){
		code += err_msg + "\n";
	}
	else{
		code += status + "@" + status_date;
		code += "#" + image + "#";
		code += presence + "@" + presence_date;
		code += "\n";
	}
	
	return code;
}

bool PM_addContactRep::getResult() const{
	return this->result;
}
    
void PM_addContactRep::setResult(bool result){
	this->result = result;
}
    
string PM_addContactRep::getErrMsg() const{
	return this->err_msg;
}
    
void PM_addContactRep::setErrMsg(string err_msg){
	this->err_msg = err_msg;
}

string PM_addContactRep::getStatus() const{
	return this->status;
}

void PM_addContactRep::setStatus(string status){
	this->status = status;
}

string PM_addContactRep::getStatusDate() const{
	return this->status_date;
}

void PM_addContactRep::setStatusDate(string status_date){
	this->status_date = status_date;
}

string PM_addContactRep::getImage() const{
	return this->image;
}

void PM_addContactRep::setImage(string image){
	this->image = image;
}

string PM_addContactRep::getPresence() const{
	return this->presence;
}

void PM_addContactRep::setPresence(string presence){
	this->presence = presence;
}
    
string PM_addContactRep::getPresenceDate() const{
	return this->presence_date;
}

void PM_addContactRep::setPresenceDate(string presence_date){
	this->presence_date = presence_date;
}

