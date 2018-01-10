/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_addContactCom.cpp
 * Author: Faraday
 * 
 * Created on December 2, 2017, 7:23 PM
 */

#include "src/protocol_messages/PM_addContactCom.h"

const string PM_addContactCom::name = "addContactCom";

PM_addContactCom::PM_addContactCom() {
}

PM_addContactCom::PM_addContactCom(const PM_addContactCom& orig) {
	this->setContact(orig.getContact());
	this->setStatus(orig.getStatus());
	this->setStatusDate(orig.getStatusDate());
	this->setImage(orig.getImage());
	this->setPresence(orig.getPresence());
	this->setPresenceDate(orig.getPresenceDate());
}

PM_addContactCom::PM_addContactCom(string contact, string status, string status_date, string image, string presence, string presence_date) {
	this->setContact(contact);
	this->setStatus(status);
	this->setStatusDate(status_date);
	this->setImage(image);
	this->setPresence(presence);
	this->setPresenceDate(presence_date);
}

PM_addContactCom::~PM_addContactCom(){
}

PM_addContactCom::PM_addContactCom(string code){
	string contact;
	string status;
	string status_date;
	string image;
	string presence;
	string presence_date;
	string fields_status_image_presence;
	string fields_image_presence;
	string status_field;
	string presence_field;
	string body;
	int i0, iF;
	int pos_first_space;
	int pos_secnd_space;
	int l_code;
	int pos_split;
	
	l_code = code.length();
	
	pos_first_space = code.find(" ");
	
	i0 = pos_first_space + 1;
	iF = l_code - i0;
	body = code.substr(i0,iF);
	
	pos_secnd_space = body.find(" ");
	
	i0 = 0;
	iF = pos_secnd_space;
	contact = body.substr(i0,iF);
	
	//Decode status field
	
		//1. get the string containing the fields
		i0 = pos_secnd_space + 1;
		iF = body.length() - i0;
		fields_status_image_presence = body.substr(i0,iF);
				  
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
	
	this->setContact(contact);			
	this->setStatus(status);			
	this->setStatusDate(status_date);
	this->setImage(image);
	this->setPresence(presence);
	this->setPresenceDate(presence_date);
}

string PM_addContactCom::toString(){
	string code = "";
	string head = PM_addContactCom::name;
	string contact = this->getContact();
	string status = this->getStatus();
	string status_date = this->getStatusDate();
	string image = this->getImage();
	string presence = this->getPresence();
	string presence_date = this->getPresenceDate();
	
	code += head + " ";
	code += contact + " ";
	code += status + "@" + status_date;
	code += "#" + image + "#";
	code += presence + "@" + presence_date + "\n";
	
	return code;
}

string PM_addContactCom::getContact() const{
	return this->contact;
}

void PM_addContactCom::setContact(string contact){
	this->contact = contact;
}

string PM_addContactCom::getStatus() const{
	return this->status;
}

void PM_addContactCom::setStatus(string status){
	this->status = status;
}

string PM_addContactCom::getStatusDate() const{
	return this->status_date;
}

void PM_addContactCom::setStatusDate(string status_date){
	this->status_date = status_date;
}

string PM_addContactCom::getImage() const{
	return this->image;
}

void PM_addContactCom::setImage(string image){
	this->image = image;
}

string PM_addContactCom::getPresence() const{
	return this->presence;
}

void PM_addContactCom::setPresence(string presence){
	this->presence = presence;
}
    
string PM_addContactCom::getPresenceDate() const{
	return this->presence_date;
}

void PM_addContactCom::setPresenceDate(string presence_date){
	this->presence_date = presence_date;
}
