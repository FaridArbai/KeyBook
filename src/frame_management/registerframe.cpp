#include "registerframe.h"

const string RegisterFrame::DEFAULT_STATUS = "This app is hilarious! :D";
const string RegisterFrame::PATH_TO_DEFAULT_IMAGE = "../data/common/images/default.png";

RegisterFrame::RegisterFrame(QObject *parent) : QObject(parent) {
}

RegisterFrame::RegisterFrame(RequestHandler* request_handler):RequestingFrame(request_handler){
}

void RegisterFrame::signUp(QString entered_username, QString entered_password){
    string username = entered_username.toStdString();
    string password = entered_password.toStdString();
    PM_regReq request_pm(username,password);
    ProtocolMessage* response_pm;
    bool result;
    string feedback_message;
    string feedback_color;

    response_pm = this->request_handler->recvResponseFor(&request_pm);

    result = ((PM_regRep*)response_pm)->getResult();

    if(result==true){
        feedback_message = "Username " + username + " registered succesfully";
        feedback_color = "green";

        delete response_pm;

        PrivateUser* user = createDefaultUser(username,password);
        IOManager::saveUser(user);
        delete user;
    }
    else{
        feedback_message = ((PM_regRep*)response_pm)->getErrMsg();
        feedback_color = "red";
        delete response_pm;
    }

    emit updateFeedbackLabel(QString::fromStdString(feedback_message),QString::fromStdString(feedback_color),result);


}

PrivateUser* RegisterFrame::createDefaultUser(string username, string password){
    string default_status = RegisterFrame::DEFAULT_STATUS;
    string default_image_path = RegisterFrame::PATH_TO_DEFAULT_IMAGE;

    PrivateUser* default_user = new PrivateUser(username,default_status,default_image_path);

    this->sendDefaultParams(username,password);

    return default_user;
}

void RegisterFrame::sendDefaultParams(string username, string password){
    PM_logReq log_req(username,password);
    PM_updateStatus update_status(username,PM_updateStatus::StatusType::status,RegisterFrame::DEFAULT_STATUS);
    PM_logOutReq log_out_req = PM_logOutReq();
    ProtocolMessage* pm_response;
    bool logged_in;

    pm_response = this->request_handler->recvResponseFor(&log_req);

    logged_in = ((PM_logRep*)pm_response)->getResult();

    delete pm_response;

    if(logged_in){
        this->request_handler->sendTrap(&update_status);

        std::this_thread::sleep_for(std::chrono::milliseconds(100));

        pm_response = this->request_handler->recvResponseFor(&log_out_req);


        delete pm_response;
    }
}




























