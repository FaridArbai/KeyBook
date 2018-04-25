#include "avatar.h"

Avatar::Avatar(){
}

Avatar::Avatar(string image_path){
    this->setImagePath(image_path);
}

Avatar::Avatar(string username, string format, string image_bin){
    string image_path = IOManager::getImagePath(username,format);
    this->setImagePath(image_path);
    IOManager::saveImage(image_path,image_bin);
}

string Avatar::toString(){
    string code;
    string image_path = this->getImagePath();

    code = image_path;

    return code;
}

string Avatar::getImagePath() const{
    return this->image_path;
}

void Avatar::setImagePath(string image_path){
    this->image_path = image_path;
}

string Avatar::getImageFormat(string image_path){
    string format;
    string image_name;
    int pos_slash = 0;
    int last_pos_slash;
    int pos_point;

    while(pos_slash!=string::npos){
        last_pos_slash = pos_slash;
        pos_slash = image_path.find("/",(pos_slash+1));
        if(pos_slash==string::npos){
            pos_slash = image_path.find("\\",(last_pos_slash+1));
        }
    }


    pos_point = image_path.find(".",last_pos_slash);

    format = image_path.substr(pos_point+1);

    return format;
}

string Avatar::getFormat(){
    string image_path = this->getImagePath();
    string format;
    string image_name;
    int pos_slash = 0;
    int last_pos_slash;
    int pos_point;

    while(pos_slash!=string::npos){
        last_pos_slash = pos_slash;
        pos_slash = image_path.find("/",(pos_slash+1));
        if(pos_slash==string::npos){
            pos_slash = image_path.find("\\",(last_pos_slash+1));
        }
    }


    pos_point = image_path.find(".",last_pos_slash);

    format = image_path.substr(pos_point+1);

    return format;
}

string Avatar::getBinary(){
    string image_path = this->getImagePath();
    string image_bin = IOManager::getImageBinary(image_path);

    return image_bin;
}































































