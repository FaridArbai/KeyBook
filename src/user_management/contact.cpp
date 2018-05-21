#include "contact.h"

const string Contact::FIELDS_SEP = "\n";
const string Contact::MESSAGE_SEP = "\n";
const QString Contact::MODEL_NAME = QString::fromStdString("ContactModel");
const QString Contact::VAR_NAME = QString::fromStdString("contact");

//****************************************************************************//
//  CONSTRUCTORS
//***************************************************************************//

Contact::Contact():
    QObject::QObject(nullptr),
    User::User(){
}

Contact::~Contact(){

}

Contact::Contact(string username, string status_text, string status_date,
        string presence_text, string presence_date, Avatar avatar, string ptpkey) :
    QObject::QObject(nullptr),
    User::User(username, status_text, status_date, avatar.getImagePath()){

    this->setPresence(presence_text, presence_date);
    this->setUnreadMessages(0);
    this->setLatchword(Latchword(ptpkey));

}

Contact::Contact(string code):
    QObject::QObject(nullptr),
    User::User(){
    int pos_split = 0;
    int i0,iF;
    string tmp_str;
    string user_code = "";
    string presence_code = "";
    string unread_messages_code = "";
    string messages_code;
    string ptpkey;

    tmp_str = code;

    for(int i=0;i<3;i++){
        pos_split += tmp_str.find(User::FIELDS_SEP);
        if(i!=0){
            pos_split += 1;
        }

        i0 = pos_split + 1;
        iF = code.length() - i0;

        tmp_str = code.substr(pos_split+1,code.length()-pos_split-1);
    }

    user_code = code.substr(0,pos_split);

    pos_split = tmp_str.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    presence_code = tmp_str.substr(i0,iF);

    i0 = pos_split + 1;
    iF = tmp_str.length() - i0;
    tmp_str = tmp_str.substr(i0,iF);

    pos_split = tmp_str.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    unread_messages_code = tmp_str.substr(i0,iF);

    i0 = pos_split + 1;
    iF = tmp_str.length() - i0;
    tmp_str = tmp_str.substr(i0,iF);

    pos_split = tmp_str.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    ptpkey = tmp_str.substr(i0,iF);

    i0 = pos_split+1;
    iF = tmp_str.length() - i0;

    if(iF!=0){
        messages_code = tmp_str.substr(i0,iF);
    }
    else{
        messages_code = "";
    }

    User::setUser(user_code);
    this->setPresence(presence_code);
    this->setUnreadMessages(unread_messages_code);
    this->setLatchword(Latchword(ptpkey));
    this->setMessages(messages_code);
}

//**************************************************************************//
//  FUNCTIONS
//**************************************************************************//

void Contact::setMessages(string messages_str){
    string tmp_str;
    bool end;
    int pos_split;
    int i0, iF;
    string message_str;
    Message* message;
    vector <Message*> messages;

    tmp_str = messages_str;

    end = (messages_str=="");

    while(!end){
        pos_split = tmp_str.find(MESSAGE_SEP);
        pos_split = tmp_str.find(MESSAGE_SEP,pos_split+1);
        pos_split = tmp_str.find(MESSAGE_SEP,pos_split+1);

        if(pos_split==string::npos){
            end = true;
            message_str = tmp_str;
        }
        else{
            i0 = 0;
            iF = pos_split;
            message_str = tmp_str.substr(i0,iF);

            i0 = pos_split + 1;
            iF = tmp_str.length() - i0;
            tmp_str = tmp_str.substr(i0,iF);
        }

        message = new Message(message_str);
        messages.push_back(message);
    }

    this->setMessages(messages);
}

void Contact::setPresence(string presence_str){
    this->presence = Presence(presence_str);
}

void Contact::setUnreadMessages(string unread_messages_str){
    this->unread_messages = stda::stoi(unread_messages_str);
}

string Contact::toString(){
    string code = "";
    string presence_str = this->getPresence().toString();
    string unread_messages_str = stda::to_string(this->getUnreadMessages());
    string messages_str = this->messagesToString();

    code += User::toString() + FIELDS_SEP;
    code += presence_str + FIELDS_SEP;
    code += unread_messages_str + FIELDS_SEP;
    code += this->getLatchword()->toString() + FIELDS_SEP;
    code += messages_str;

    return code;
}

string Contact::messagesToString(){
    string messages_str = "";
    int n_messages = this->messages.size();
    Message* message;
    bool is_last_message;

    for(int i=0; i<n_messages; i++){
        message = this->messages.at(i);
        messages_str += message->toString();
        is_last_message = (i==(n_messages-1));

        if(!is_last_message){
            messages_str += MESSAGE_SEP;
        }
    }

    return messages_str;
}

void Contact::appendMessage(Message* message){
    this->messages.push_back(message);
}

Presence Contact::getPresence() const{
    return this->presence;
}

void Contact::changePresence(string presence_text, string date_str){
    this->setPresence(presence_text,date_str);
    emit this->presenceChanged();
}
void Contact::setPresence(Presence presence){
    this->presence = presence;
}

void Contact::setPresence(string presence_text, string date_str){
    this->presence = Presence(presence_text, date_str);
}

int Contact::getUnreadMessages() const{
    return this->unread_messages;
}

void Contact::setUnreadMessages(int unread_messages){
    this->unread_messages = unread_messages;
}

vector<Message*> Contact::getMessages() const{
    return this->messages;
}

void Contact::setMessages(vector<Message*> messages){
    this->messages = messages;
}

QString Contact::getPresenceGUI(){
    string presence = this->getPresence().toHumanReadable();
    QString presence_gui = QString::fromStdString(presence);

    return presence_gui;
}

QString Contact::getShortPresenceGUI(){
    string presence = this->getPresence().toShortlyHumanReadable();
    QString presence_gui = QString::fromStdString(presence);

    return presence_gui;
}

QString Contact::getUnreadMessagesGUI(){
    string unread_messages_str = stda::to_string(this->getUnreadMessages());
    QString unread_messages_gui = QString::fromStdString(unread_messages_str);

    return unread_messages_gui;
}

void Contact::changeStatus(string status_text, string date_str){
    this->setStatus(status_text, date_str);

    emit this->statusChanged();
}

void Contact::changeAvatar(Avatar avatar){
    string old_image_path = this->getAvatar().getImagePath();

    this->setAvatar(avatar);
    emit this->avatarChanged();
    remove(old_image_path.c_str());
}

QString Contact::getUsernameGUI(){
    string username = this->getUsername();
    QString username_gui = QString::fromStdString(username);

    return username_gui;
}

QString Contact::getAvatarPathGUI(){
    string avatar_path = this->getAvatar().getImagePath();
    avatar_path = IOManager::FILE_HEADER + avatar_path;
    QString avatar_path_gui = QString::fromStdString(avatar_path);

    return avatar_path_gui;
}

int Contact::getAvatarColorGUI(){
    int avatar_color = this->getAvatar().getColor();
    return avatar_color;
}

QString Contact::getStatusGUI(){
    string status = this->getStatus().getText();
    QString status_gui = QString::fromStdString(status);

    return status_gui;
}

QString Contact::getStatusDateGUI(){
    string status_date = this->getStatus().getDate().toShortlyHumanReadable();
    QString status_date_gui = QString::fromStdString(status_date);

    return status_date_gui;
}

void Contact::pushMessage(string sender, string recipient, string date_str, string text){
    Message* message = new Message(sender,date_str,text);

    messages.insert(messages.begin(),message);

    emit this->lastMessageChanged();
}

QList<QObject*>& Contact::getMessagesGUI(){
    QList<QObject*> messages_list;
    vector<Message*> messages = this->getMessages();
    int n_messages = messages.size();
    QObject* message;
    Latchword* latchword = this->getLatchword();

    messages_list.reserve(messages.size());

    for(int i=0; i<n_messages; i++){
        message = latchword->decrypt(messages.at(i));
        messages_list.insert(i,message);
    }

    this->messages_gui = messages_list;

    QList<QObject*>& ref = messages_gui;

    return ref;
}

void Contact::incrementUnreadMessages(){
    this->unread_messages = this->unread_messages + 1;
    emit unreadMessagesChanged();
}

void Contact::restartUnreadMessages(){
    this->unread_messages = 0;
    emit unreadMessagesChanged();
}

QString Contact::getLastMessageGUI(){
    QString last_message_gui;
    int n_messages = this->messages.size();

    if(n_messages==0){
        last_message_gui = QString::fromStdString("");
    }
    else{
        Latchword* latchword = this->getLatchword();
        Message* last_message_encr = this->messages.at(0);
        Message* last_message = latchword->decrypt(last_message_encr);
        last_message_gui = last_message->getTextGUI();
    }

    return last_message_gui;
}

Latchword* Contact::getLatchword(){
    return &(this->latchword);
}

void Contact::setLatchword(Latchword latchword){
    this->latchword = latchword;
}






















































