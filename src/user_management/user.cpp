#include "user.h"

const string User::FIELDS_SEP = "\n";

User::User(){

}

User::~User(){

}

User::User(string username, string status_text, string status_date, string image_path){
    this->setUser(username);
    this->setStatus(status_text,status_date);
    this->setAvatar(image_path);
}

User::User(string username, string status_text, string image_path){
    Status status(status_text);
    Avatar avatar(image_path);

    this->setUsername(username);
    this->setStatus(status);
    this->setAvatar(avatar);
}

/*
User::User(string username, Status status, Avatar avatar){
    this->setUsername(username);
    this->setStatus(status);
    this->setAvatar(avatar);
}
*/

User::User(string code){
    string tmp_str;
    int pos_split;
    int i0,iF;
    string username_str;
    string status_str;
    string avatar_str;

    tmp_str = code;

    pos_split = tmp_str.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    username_str = tmp_str.substr(i0,iF);

    i0 = pos_split + 1;
    iF = tmp_str.length() - i0;
    tmp_str = tmp_str.substr(i0,iF);

    pos_split = tmp_str.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    status_str = tmp_str.substr(i0,iF);

    i0 = pos_split + 1;
    iF = tmp_str.length() - i0;
    avatar_str = tmp_str.substr(i0,iF);

    this->setUsername(username_str);
    this->setStatus(status_str);
    this->setAvatar(avatar_str);
}

/*
User::User(const User& orig){
    this->setUsername(orig.getUsername());
    this->setStatus(orig.getStatus());
    this->setAvatar(orig.getAvatar());
}
*/

string User::toString(){
    string code = "";
    string username = this->getUsername();
    string status_code = this->getStatus().toString();
    string avatar_code = this->getAvatar().toString();

    code += username + FIELDS_SEP;
    code += status_code + FIELDS_SEP;
    code += avatar_code;

    return code;
}


string User::getUsername() const{
    return this->username;
}

void User::setUsername(string username){
    this->username = username;
}

Status User::getStatus() const{
    return this->status;
}

void User::setStatus(Status status){
    this->status = status;
}

Avatar User::getAvatar() const{
    return this->avatar;
}

void User::setAvatar(Avatar avatar){
    this->avatar = avatar;
}

void User::setUser(string user_code){
    User user(user_code);

    this->setUsername(user.getUsername());
    this->setStatus(user.getStatus());
    this->setAvatar(user.getAvatar());
}

void User::setStatus(string status_str){
    this->status = Status(status_str);
}

void User::setStatus(string status_text, string status_date){
    this->status = Status(status_text, status_date);
}

void User::setAvatar(string avatar_str){
    this->avatar = Avatar(avatar_str);
}





















































