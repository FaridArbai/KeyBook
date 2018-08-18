#include "privateuser.h"

const string PrivateUser::FIELDS_SEP = "\n<PRIVATE_USER_FIELD>\n";

PrivateUser::PrivateUser():User(){
}

PrivateUser::~PrivateUser(){
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    Contact* contact;

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);
        delete contact;
    }
}

PrivateUser::PrivateUser(string username, string status_text, string image_path) :
    User::User(username,status_text,image_path){
}

PrivateUser::PrivateUser(string code){
    int pos_split;
    int i0, iF;
    string user_str;
    string contacts_str_tmp;
    string contact_str;
    Contact* contact;
    bool end = false;
    vector<Contact*> contacts;

    pos_split = code.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    user_str = code.substr(i0,iF);

    i0 = pos_split + FIELDS_SEP.length();
    iF = code.length() - i0;
    contacts_str_tmp = code.substr(i0,iF);

    end = (contacts_str_tmp=="");

    while(!end){
        pos_split = contacts_str_tmp.find(FIELDS_SEP);

        if(pos_split==string::npos){
            end = true;
            contact_str = contacts_str_tmp;
        }
        else{
            i0 = 0;
            iF = pos_split;
            contact_str = contacts_str_tmp.substr(i0,iF);

            i0 = pos_split + FIELDS_SEP.length();
            iF = contacts_str_tmp.length() - i0;
            contacts_str_tmp = contacts_str_tmp.substr(i0,iF);
        }


        contact = new Contact(contact_str);

        contacts.push_back(contact);
    }

    User::setUser(user_str);
    this->setContacts(contacts);
}

#include <QApplication>

void PrivateUser::moveToMainThread(){
    int n_contacts = this->contacts.size();
    int n_messages;
    Contact* contact;
    vector<Message*> messages;
    Message* message;

    for(int i=0; i<n_contacts; i++){
        contact = this->contacts.at(i);
        messages = contact->getMessages();
        n_messages = messages.size();
        for(int j=0; j<n_messages; j++){
            message = messages.at(j);
            message->moveToThread(QApplication::instance()->thread());
        }
        contact->moveToThread(QApplication::instance()->thread());
    }
}

void PrivateUser::load(string code){
    int pos_split;
    int i0, iF;
    string user_str;
    string contacts_str_tmp;
    string contact_str;
    Contact* contact;
    bool end = false;
    vector<Contact*> contacts;

    pos_split = code.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    user_str = code.substr(i0,iF);

    i0 = pos_split + FIELDS_SEP.length();
    iF = code.length() - i0;
    contacts_str_tmp = code.substr(i0,iF);

    end = (contacts_str_tmp=="");

    while(!end){
        pos_split = contacts_str_tmp.find(FIELDS_SEP);

        if(pos_split==string::npos){
            end = true;
            contact_str = contacts_str_tmp;
        }
        else{
            i0 = 0;
            iF = pos_split;
            contact_str = contacts_str_tmp.substr(i0,iF);

            i0 = pos_split + FIELDS_SEP.length();
            iF = contacts_str_tmp.length() - i0;
            contacts_str_tmp = contacts_str_tmp.substr(i0,iF);
        }


        contact = new Contact(contact_str);

        contacts.push_back(contact);
    }

    User::setUser(user_str);
    this->setContacts(contacts);
}

string PrivateUser::toString(){
    string code = "";
    string user_str = User::toString();
    Contact* contact;
    string contact_str;
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    string contacts_str = "";

    code += user_str + FIELDS_SEP;

    int n_encoded_contacts = 0;

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);
        contact_str = contact->toString();
        contacts_str += contact_str;

        n_encoded_contacts++;

        if(n_encoded_contacts!=n_contacts){
            contacts_str += FIELDS_SEP;
        }
    }

    code += contacts_str;

    return code;
}

void PrivateUser::updateStatus(string new_status_text){
    this->setStatus(new_status_text);
}

void PrivateUser::addContact(Contact* new_contact){
    this->pushContact(new_contact);
}

void PrivateUser::deleteContact(Contact* contact){
    this->popContact(contact);
    delete contact;
}

void PrivateUser::updatePresenceOf(string username, string presence_text, string date_str){
    Contact* contact = this->getContact(username);

    if(contact!=nullptr){
        contact->changePresence(presence_text,date_str);
    }
}

void PrivateUser::updateStatusOf(string username, string status_text, string date_str){
    Contact* contact = this->getContact(username);

    if(contact!=nullptr){
        contact->changeStatus(status_text,date_str);
    }
}

void PrivateUser::updateAvatarOf(string username, Avatar avatar){
    Contact* contact = this->getContact(username);

    if(contact!=nullptr){
        contact->changeAvatar(avatar);
    }
}

Contact* PrivateUser::getContact(string username){
    int n_contacts = (this->contacts).size();
    bool found = false;
    Contact* contact = nullptr;

    for(int i=0; (i<n_contacts)&&(!found); i++){
        contact = this->contacts.at(i);
        if((contact->getUsername())==username){
            found = true;
        }
    }

    if(!found){
        contact = nullptr;
    }

    return contact;
}

QList<QObject*>& PrivateUser::getContactsGUI(){
    QList<QObject*> contacts_list;
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    QObject* contact;

    contacts_list.reserve(contacts.size());

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);
        contacts_list.insert(i,contact);
    }

    this->contacts_gui = contacts_list;

    QList<QObject*>& ref = contacts_gui;

    return ref;
}

QList<QObject*>& PrivateUser::getContactsGUI(string filter){
    QList<QObject*> contacts_list;
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    QObject* contact;

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);

        if(((Contact*)contact)->getUsername().find(filter)==0){
            contacts_list.append(contact);
        }
    }

    this->contacts_gui = contacts_list;

    QList<QObject*>& ref = contacts_gui;
    return ref;
}

QList<QObject*>& PrivateUser::getConversationsGUI(){
    QList<QObject*> contacts_list;
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    QObject* contact;

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);

        if(((Contact*)contact)->getMessages().size()>0){
            contacts_list.append(contact);
        }
    }

    this->conversation_gui = contacts_list;

    QList<QObject*>& ref = this->conversation_gui;

    return ref;
}

QList<QObject*>& PrivateUser::getConversationsGUI(string filter){
    QList<QObject*> contacts_list;
    vector<Contact*> contacts = this->getContacts();
    int n_contacts = contacts.size();
    QObject* contact;

    for(int i=0; i<n_contacts; i++){
        contact = contacts.at(i);

        if(((Contact*)contact)->getMessages().size()>0){
            if(((Contact*)contact)->getUsername().find(filter)==0){
                contacts_list.append(contact);
            }
        }
    }

    this->conversation_gui = contacts_list;

    QList<QObject*>& ref = this->conversation_gui;
    return ref;
}

void PrivateUser::pushContact(Contact* new_contact){
    vector<Contact*>& contacts = this->contacts;

    contacts.insert(contacts.begin(),new_contact);
}

void PrivateUser::popContact(Contact* contact){
    vector<Contact*>& contacts = this->contacts;

    contacts.erase(std::remove(contacts.begin(), contacts.end(), contact), contacts.end());
}

vector<Contact*> PrivateUser::getContacts() const{
    return this->contacts;
}

void PrivateUser::setContacts(vector<Contact*> contacts){
    this->contacts = contacts;
}

void PrivateUser::setConversationWith(string username){
    this->conversation_username = username;
    this->setInConversation(true);

    Contact* conversation_contact = this->getContact(username);
    conversation_contact->restartUnreadMessages();
}

void PrivateUser::finishCurrentConversation(){
    this->setInConversation(false);
}

QList<QObject*>& PrivateUser::getConversationMessagesGUI(){
    string conversation_username = this->getConversationUsername();
    Contact* contact = this->getContact(conversation_username);
    QList<QObject*>& messages_gui = contact->getMessagesGUI(); //

    return messages_gui;
}

void PrivateUser::addMessage(string sender, string recipient, string date_str, string text){
    string my_username = this->getUsername();

    string contact_username = (sender!=my_username)?(sender):(recipient);

    Contact* contact = this->getContact(contact_username);

    if(contact!=nullptr){
        bool sent_to_me = (recipient==my_username);

        bool in_conversation = this->getInConversation();

        string conversation_username = this->getConversationUsername();

        bool in_conversation_with_sender;

        contact->pushMessage(sender, recipient, date_str, text);

        if(sent_to_me){
            in_conversation_with_sender = (in_conversation&&(conversation_username==sender));
            if(!in_conversation_with_sender){
                contact->incrementUnreadMessages();
            }
        }

        vector<Contact*>& contacts = this->contacts;

        contacts.erase(std::remove(contacts.begin(),contacts.end(),contact),
                       contacts.end());
        this->pushContact(contact);
    }
}

void PrivateUser::setInConversation(bool in_conversation){
    this->in_conversation = in_conversation;
}

bool PrivateUser::getInConversation(){
    return this->in_conversation;
}

string PrivateUser::getConversationUsername(){
    return this->conversation_username;
}


















































