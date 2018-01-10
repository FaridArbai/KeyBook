#include "avatar.h"

Avatar::Avatar(){
}

Avatar::Avatar(string image_path){
    this->setImagePath(image_path);
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
