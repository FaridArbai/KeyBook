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
        Date date = this->getDate();
        int days_since_last_conn = date.daysFromToday();

        if(days_since_last_conn==0){
            string hour = date.getHour();
            string minutes = date.getMinute();

            presence_str = "Last seen at " + hour + ":" + minutes;
        }
        else if(days_since_last_conn==1){
            string hour = date.getHour();
            string minutes = date.getMinute();

            presence_str = "Last seen yesterday at " + hour + ":" + minutes;
        }
        else{
            presence_str = "Last seen on " + date.toHumanReadable();
        }
    }

    return presence_str;
}

string Presence::toShortlyHumanReadable(){
    string presence_str;

    if(this->getText()=="online"){
        presence_str = "Online";
    }
    else{
        Date date = this->getDate();
        int days_since_last_conn = date.daysFromToday();

        if(days_since_last_conn==0){
            string hour = date.getHour();
            string minutes = date.getMinute();

            presence_str = "Last seen at " + hour + ":" + minutes;
        }
        else if(days_since_last_conn==1){
            presence_str = "Last seen yesterday";
        }
        else{
            string month = date.getMonth();
            string day = date.getDay();

            presence_str = "Last seen on " + day + "/" + month;
        }
    }

    return presence_str;
}





































































