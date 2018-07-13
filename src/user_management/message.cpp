#include "message.h"

const string Message::FIELDS_SEP = "\n";
const QString Message::MODEL_NAME = QString::fromStdString("MessageModel");

Message::Message() : QObject::QObject(nullptr){

}

Message::Message(string sender, string date_str, string text):QObject::QObject(nullptr){
    this->setSender(sender);
    this->setDate(date_str);
    this->setText(text);
}

Message::Message(string code):QObject::QObject(nullptr){
    int i0, iF;
    int pos_split;
    string sender;
    string date_str_text;
    string date_str;
    string text;

    pos_split = code.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    sender = code.substr(i0,iF);

    i0 = pos_split + 1;
    iF = code.length() - i0;
    date_str_text = code.substr(i0,iF);

    pos_split = date_str_text.find(FIELDS_SEP);

    i0 = 0;
    iF = pos_split;
    date_str = date_str_text.substr(i0,iF);

    i0 = pos_split + 1;
    iF = date_str_text.length() - i0;
    text = date_str_text.substr(i0,iF);

    this->setSender(sender);
    this->setDate(date_str);
    this->setText(text);
}

string Message::toString(){
    string code = "";
    string sender = this->getSender();
    string date_str = this->getDate().toString();
    string text = this->getText();

    code += sender + FIELDS_SEP;
    code += date_str + FIELDS_SEP;
    code += text;

    return code;
}

string Message::getSender() const{
   return this->sender;
}

void Message::setSender(string sender){
    this->sender = sender;
}

Date Message::getDate() const{
    return this->date;
}

void Message::setDate(string date_str){
    this->date = Date(date_str);
}

void Message::setDate(Date date){
    this->date = date;
}

string Message::getText() const{
    return this->text;
}

void Message::setText(string text){
    this->text = text;
}

QString Message::getSenderGUI(){
    string sender = this->getSender();
    QString sender_gui = QString::fromStdString(sender);
    return sender_gui;
}

QString Message::getDateGUI(){
    string date = this->getDate().toHumanReadable();

    QString date_gui = QString::fromStdString(date);
    return date_gui;
}

QString Message::getTextGUI(){
    string text = this->getText();
    QString text_gui = QString::fromStdString(text);
    return text_gui;
}

void Message::setReliability(bool reliable){
    this->reliable = reliable;
}

bool Message::getReliability(){
    return this->reliable;
}























































