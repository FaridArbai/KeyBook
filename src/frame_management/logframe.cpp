#include "logframe.h"
#include <iostream>
#include <QDebug>

LogFrame::LogFrame(QObject *parent) :QObject(parent){
}

LogFrame::LogFrame(MainFrame* contacts_frame, RequestHandler* request_handler, QGuiApplication* app) :
    RequestingFrame::RequestingFrame(request_handler){
    this->setContactsFrame(contacts_frame);
    this->user = nullptr;
    this->app = app;
}



void LogFrame::logIn(const QString entered_username, const QString entered_password){
    MainFrame::showProgressDialog("Logging in");
    string username = entered_username.toStdString();
    string password = entered_password.toStdString();
    QFuture<void> future = QtConcurrent::run(this, &LogFrame::logInImpl, username, password);
}

void LogFrame::logInImpl(string username, string password){
    PM_logReq request_pm = PM_logReq(username,password);
    ProtocolMessage* response_pm;

    response_pm = this->request_handler->recvResponseFor(&request_pm);

    bool log_result = ((PM_logRep*)response_pm)->getResult();

    if(log_result){
        emit this->validCredentials(QString::fromStdString(username));
    }
    else{
        QString err_str = QString::fromStdString(((PM_logRep*)response_pm)->getErrMsg());
        MainFrame::dismissProgressDialog();
        //dialog here
        emit updateErrorLabel(err_str);
    }

    delete response_pm;
}

void LogFrame::loadData(QString username){
    MainFrame::showProgressDialog("Loading data");
    //QFuture<void> future = QtConcurrent::run(this, &LogFrame::loadDataImpl, username.toStdString());
    PrivateUser* user = IOManager::loadUser(username.toStdString());

    this->setPrivateUser(user);
    this->spreadPrivateUser();

    MainFrame::dismissProgressDialog();
    emit userLoggedIn();
}

void LogFrame::loadDataImpl(string username){
    //TODO: Figure out how to create the user inside of the
    //main thread and still load it's data asynchronously.
    /**
    PrivateUser* user = IOManager::loadUser(username);

    this->setPrivateUser(user);
    this->spreadPrivateUser();

    MainFrame::dismissProgressDialog();
    emit userLoggedIn();
    **/
}

void LogFrame::closeApp(){
    qDebug() << "CLOSED FROM LOGFRAME CALLED" << endl;
    this->closeConnection();

    this->app->quit();
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













































































