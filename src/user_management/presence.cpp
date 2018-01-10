#include "presence.h"

const string Presence::FIELDS_SEP = "@";

Presence::Presence(){
}

Presence::Presence(string text, string date_str){
    Date date(date_str);

    this->setDate(date);
    this->setText(text);
}

Presence::Presence(const Presence& orig){
    this->setText(orig.getText());
    this->setDate(orig.getDate());
}

Presence::Presence(string code){
    int pos_split;
    int i0,iF;
    string text;
    string date_str;
    Date date;

    pos_split = code.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    text = code.substr(i0,iF);

    i0 = pos_split + 1;
    iF = code.length() - i0;
    date_str = code.substr(i0,iF);
    date = Date(date_str);

    this->setText(text);
    this->setDate(date);
}

string Presence::toString(){
    string code = "";
    string text = this->getText();
    string date_code = this->getDate().toString();

    code += text + FIELDS_SEP;
    code += date_code;

    return code;
}

string Presence::getText() const{
    return this->text;
}

void Presence::setText(string text){
    this->text = text;
}

Date Presence::getDate() const{
    return this->date;
}

void Presence::setDate(Date date){
    this->date = date;
}

string Presence::toHumanReadable(){
    string presence_str;

    if(this->getText()=="online"){
        presence_str = "Online";
    }
    else{
        presence_str = "Last seen on " + this->getDate().toHumanReadable();
    }

    return presence_str;
}



















