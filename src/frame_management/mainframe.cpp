#include "mainframe.h"

MainFrame::MainFrame(QQmlContext** context_ptr, RequestHandler* request_handler) :
RequestingFrame::RequestingFrame(request_handler){
    this->setContext(context_ptr);
    this->setUserLoaded(false);
    this->setInConversation(false);
}

void MainFrame::refreshContactsGUI(){
    PrivateUser* user = this->getPrivateUser();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::MODEL_NAME, QVariant::fromValue(user->getContactsGUI()));
}

void MainFrame::refreshContactGUI(QString username_gui){
    string username = username_gui.toStdString();
    QObject* contact = this->user->getContact(username);
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::VAR_NAME,contact);
}

void MainFrame::addContact(QString entered_username){
    string username = entered_username.toStdString();
    string this_username = this->user->getUsername();
    bool result;
    string err_msg = "";
    Contact* possible_contact;
    bool is_already_a_contact;

    possible_contact = this->user->getContact(username);
    is_already_a_contact = (possible_contact!=nullptr);

    if(username==this_username){
        result = false;
        err_msg = "You can not add yourself as a contact";
    }
    else if (is_already_a_contact){
        result = false;
        err_msg = "User " + username + " is already in your contact list";
    }
    else{

        PM_addContactReq add_req(this->user->getUsername(), username);
        ProtocolMessage* add_rep;

        add_rep = this->request_handler->recvResponseFor(&add_req);

        result = ((PM_addContactRep*)add_rep)->getResult();

        if(result==true){
            string status_text = ((PM_addContactRep*)add_rep)->getStatus();
            string status_date = ((PM_addContactRep*)add_rep)->getStatusDate();
            string presence_text = ((PM_addContactRep*)add_rep)->getPresence();
            string presence_date = ((PM_addContactRep*)add_rep)->getPresenceDate();
            string image_str = ((PM_addContactRep*)add_rep)->getImage();

            Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,image_str);

            this->user->addContact(new_contact);

            this->refreshContactsGUI();
        }
        else{
            err_msg = ((PM_addContactRep*)add_rep)->getErrMsg();
        }
    }

    emit finishedAddingContact(result, QString::fromStdString(err_msg));
}

void MainFrame::updateUserStatus(QString entered_status){
    string status_text = entered_status.toStdString();
    this->user->updateStatus(status_text);
    string username = this->user->getUsername();
    PM_updateStatus::StatusType update_type = PM_updateStatus::StatusType::status;
    PM_updateStatus update = PM_updateStatus(username, update_type, status_text);

    this->request_handler->sendTrap(&update);

    QString new_status_gui = entered_status;
    QString new_date_gui = QString::fromStdString(this->user->getStatus().getDate().toString()); // more readable

    new_status_gui += "@" + new_date_gui;

    emit statusChanged(new_status_gui, new_date_gui);
}

PrivateUser* MainFrame::getPrivateUser() const{
    return this->user;
}

void MainFrame::setPrivateUser(PrivateUser* user){
    this->user = user;
    string user_str = user->toString();

    this->refreshContactsGUI();

    // Add a 1 second delay to user's instantiation to make sure
    // that the networking thread reaches the waiting code on
    // the loading condition

    std::this_thread::sleep_for(std::chrono::seconds(1));

    this->setUserLoaded(true);
    this->notifyUserLoaded();

    //on logout, set it again to false
}

void MainFrame::setContext(QQmlContext** context_ptr){
    this->context_ptr = context_ptr;
}

void MainFrame::logOutUser(){
    bool is_loaded = this->userIsLoaded();

    if(is_loaded){
        PM_logOutReq log_out_req = PM_logOutReq();
        ProtocolMessage* log_out_rep;

        log_out_rep = this->request_handler->recvResponseFor(&log_out_req);

        delete log_out_rep;

        IOManager::saveUser(user);

        this->setUserLoaded(false);
        delete user;
        this->user = nullptr;
    }
}

QString MainFrame::getCurrentUsername(){
    QString username_gui = QString::fromStdString(this->user->getUsername());
    return username_gui;
}

QString MainFrame::getCurrentStatus(){
    QString status_gui = QString::fromStdString(this->user->getStatus().getText());
    return status_gui;
}

QString MainFrame::getCurrentStatusDate(){
    QString status_date_gui = QString::fromStdString(this->user->getStatus().getDate().toString());
    return status_date_gui;
}

bool MainFrame::userIsLoaded(){
    return this->user_is_loaded;
}

void MainFrame::setUserLoaded(bool is_loaded){
    this->user_is_loaded = is_loaded;
}

void MainFrame::notifyUserLoaded(){
    this->USER_LOADED.notify_all();
}

QWaitCondition* MainFrame::getUserLoadedCondition(){
    QWaitCondition* USER_LOADED_CONDITION = &(this->USER_LOADED);

    return USER_LOADED_CONDITION;
}

void MainFrame::loadConversationWith(QString contact_name){
    this->setInConversation(true);
    this->user->setConversationWith(contact_name.toStdString());
    this->refreshMessagesGUI();
}

void MainFrame::finishCurrentConversation(){
    this->setInConversation(false);
    this->user->finishCurrentConversation();
}

void MainFrame::refreshMessagesGUI(){
    QList<QObject*>& messages_gui = this->user->getConversationMessagesGUI();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Message::MODEL_NAME,QVariant::fromValue(messages_gui));
}

void MainFrame::handleMessage(string sender, string recipient, string date_str, string text){
    this->foreign_contact_mutex.lock();
    bool in_conversation = this->getInConversation();

    if(current_add_com!=nullptr){
        QMutex finished_adding_foreign_mutex;
        finished_adding_foreign_mutex.lock();
        this->foreign_contact_mutex.unlock();
        FINISHED_ADDING_FOREIGN.wait(&finished_adding_foreign_mutex);
        finished_adding_foreign_mutex.unlock();
    }
    else{
        this->foreign_contact_mutex.unlock();
    }

    this->user->addMessage(sender,recipient,date_str,text);

    if(in_conversation){
        emit receivedMessageForCurrentConversation();
    }
}

void MainFrame::sendMessage(QString conversation_recipient, QString entered_text){
    string recipient = conversation_recipient.toStdString();
    string sender = this->user->getUsername();
    string text = entered_text.toStdString();
    PM_msg msg(sender,recipient,text);
    string date_str = msg.getDate();

    this->request_handler->sendTrap(&msg);

    this->user->addMessage(sender,recipient,date_str,text);

    this->refreshMessagesGUI();
}

void MainFrame::setInConversation(bool in_conversation){
    this->in_conversation = in_conversation;
}

bool MainFrame::getInConversation(){
    return in_conversation;
}

void MainFrame::handleNewContact(PM_addContactCom* add_com){
    this->current_add_com = new PM_addContactCom(*add_com);
    emit receivedForeignContact();
}

void MainFrame::addForeignContact(){
    this->foreign_contact_mutex.lock();
    string username = current_add_com->getContact();
    string status_text = current_add_com->getStatus();
    string status_date = current_add_com->getStatusDate();
    string presence_text = current_add_com->getPresence();
    string presence_date = current_add_com->getPresenceDate();
    string image_str = current_add_com->getImage();

    Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,image_str);

    this->user->addContact(new_contact);

    refreshContactsGUI();

    delete current_add_com;
    current_add_com = nullptr;
    FINISHED_ADDING_FOREIGN.notify_all();
    this->foreign_contact_mutex.unlock();
}



























































