#include "status.h"

const string Status::FIELD_SEP = "@";

Status::Status(){
    this->setText("No status");
}

Status::Status(string text, string date_str){
    this->setText(text);
    this->setDate(date_str);
}

Status::Status(string code_or_text){
    bool is_code = (code_or_text.find(FIELD_SEP)!=string::npos);

    if(is_code){
        string code = code_or_text;
        int pos_split;
        int i0,iF;
        string text;
        string date_str;

        pos_split = code.find(FIELD_SEP);

        i0 = 0;
        iF = pos_split;
        text = code.substr(i0,iF);

        i0 = pos_split + 1;
        iF = code.length() - i0;
        date_str = code.substr(i0,iF);

        this->setText(text);
        this->setDate(date_str);
    }
    else{
        string text = code_or_text;
        this->setText(text);
    }
}

Status::Status(const Status& orig){
    this->setText(orig.getText());
    this->setDate(orig.getDate());
}

string Status::toString(){
    string code;
    string text = this->getText();
    Date date = this->getDate();
    string date_str = date.toString();

    code = text + FIELD_SEP + date_str;

    return code;
}

string Status::getText() const{
    return this->text;
}

void Status::setText(string text){
    this->text = text;
}

Date Status::getDate() const{
    return this->date;
}

void Status::setDate(Date date){
    this->date = date;
}

void Status::setDate(string date_str){
    this->date = Date(date_str);
}























