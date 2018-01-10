
#include "PM_logOutReq.h"

const string PM_logOutReq::name = "logOutReq";

PM_logOutReq::PM_logOutReq() : ProtocolMessage::ProtocolMessage(){

}

PM_logOutReq::PM_logOutReq(const PM_logOutReq& orig) {
}

PM_logOutReq::~PM_logOutReq() {
}

string PM_logOutReq::toString(){
	string code = PM_logOutReq::name + " " + "\n";
	return code;
}
