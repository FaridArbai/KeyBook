/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   PM_logOutRep.cpp
 * Author: Faraday
 * 
 * Created on December 2, 2017, 7:27 PM
 */

#include "PM_logOutRep.h"

const string PM_logOutRep::name = "logOutRep";

PM_logOutRep::PM_logOutRep() {
}

PM_logOutRep::PM_logOutRep(const PM_logOutRep& orig) {
}

PM_logOutRep::~PM_logOutRep() {
}

string PM_logOutRep::toString(){
	string code = PM_logOutRep::name + " " + "\n";
	return code;
}

