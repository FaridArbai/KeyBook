#include "logframe.h"
#include <iostream>
#include <QDebug>

LogFrame::LogFrame(QObject *parent) :QObject(parent){
}

LogFrame::LogFrame(MainFrame* contacts_frame, RequestHandler* request_handler) :
    RequestingFrame::RequestingFrame(request_handler){
    this->setContactsFrame(contacts_frame);
    this->user = nullptr;
}



void LogFrame::logIn(const QString entered_username, const QString entered_password){
    string username = entered_username.toStdString();
    string password = entered_password.toStdString();

    PM_logReq request_pm = PM_logReq(username,password);
    ProtocolMessage* response_pm;

    response_pm = this->request_handler->recvResponseFor(&request_pm);

    bool log_result = ((PM_logRep*)response_pm)->getResult();

    if(log_result){
        PrivateUser* user = IOManager::loadUser(username);

        this->setPrivateUser(user);
        this->spreadPrivateUser();

        emit userLoggedIn();
    }
    else{
        QString err_str = QString::fromStdString(((PM_logRep*)response_pm)->getErrMsg());
        emit updateErrorLabel(err_str);
    }

    delete response_pm;
}

void LogFrame::spreadPrivateUser(){
    MainFrame* contacts_frame = this->getContactsFrame();
    PrivateUser* user = this->getPrivateUser();

    contacts_frame->setPrivateUser(user);
}

PrivateUser* LogFrame::getPrivateUser() const{
    return this->user;
}

void LogFrame::setPrivateUser(PrivateUser* user){
    this->user = user;
}

MainFrame* LogFrame::getContactsFrame() const{
    return this->contacts_frame;
}

void LogFrame::setContactsFrame(MainFrame* contacts_frame){
    this->contacts_frame = contacts_frame;
}













































































