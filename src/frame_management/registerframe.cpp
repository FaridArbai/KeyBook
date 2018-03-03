#include "registerframe.h"

const string RegisterFrame::DEFAULT_STATUS = "This app is hilarious! :D";
const string RegisterFrame::DEFAULT_IMAGE_NAME = "default.png";

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

        PrivateUser* user = this->createDefaultUser(username,password);
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
    string path_to_default_image = IOManager::getImagePath(RegisterFrame::DEFAULT_IMAGE_NAME);

    PrivateUser* default_user =
            new PrivateUser(username,
                            default_status,
                            path_to_default_image);

    this->sendDefaultParams(username,password);

    return default_user;
}

void RegisterFrame::sendDefaultParams(string username, string password){
    PM_logReq log_req(username,password);
    PM_logOutReq log_out_req = PM_logOutReq();
    ProtocolMessage* pm_response;
    bool logged_in;

    pm_response = this->request_handler->recvResponseFor(&log_req);

    logged_in = ((PM_logRep*)pm_response)->getResult();

    delete pm_response;

    if(logged_in){
        PM_updateStatus update_status(username,
                                      PM_updateStatus::StatusType::status,
                                      RegisterFrame::DEFAULT_STATUS);
        this->request_handler->sendTrap(&update_status);

        string path_to_default_image =
                IOManager::getImagePath(RegisterFrame::DEFAULT_IMAGE_NAME);
        Avatar avatar(path_to_default_image);
        PM_updateStatus update_image(username,avatar);
        this->request_handler->sendTrap(&update_image);

        pm_response = this->request_handler->recvResponseFor(&log_out_req);

        delete pm_response;
    }
}




























