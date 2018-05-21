#include "latchword.h"

Latchword::Latchword(){
    string password = "holaholaholahola";
    int password_len = password.length();
    int key_len = SymmetricEngine::KEY_LENGTH;
    string key;

    if (password_len>key_len){
        key = password.substr(0,key_len);
    }
    else{
        int pad_len = key_len - password_len;

        for(int i=0; i<pad_len; i++){
            key += SymmetricEngine::PAD_TOKEN;
        }
    }

    key = password;

    this->setPTPKey(key);
    this->ptp_engine.init(key,key,key,key);
}

Latchword::Latchword(string password){
    int password_len = password.length();
    int key_len = SymmetricEngine::KEY_LENGTH;
    string key;

    if (password_len>key_len){
        key = password.substr(0,key_len);
    }
    else{
        int pad_len = key_len - password_len;
        key = password;

        for(int i=0; i<pad_len; i++){
            key += SymmetricEngine::PAD_TOKEN;
        }
    }

    this->setPTPKey(key);
    this->ptp_engine.init(key,key,key,key);
}

string Latchword::getPTPKey() const{
   return this->ptp_key;
}

void Latchword::setPTPKey(string ptp_key){
    this->ptp_key = ptp_key;
}

string Latchword::encrypt(string message){
    string encr = this->ptp_engine.encrypt(message);
    this->ptp_engine.refresh();

    return encr;
}

string Latchword::decrypt(string encr){
    string decr = this->ptp_engine.decrypt(encr);
    this->ptp_engine.refresh();

    return decr;
}

string Latchword::toString(){
    return this->getPTPKey();
}

Message* Latchword::decrypt(Message* encr){
    string sender = encr->getSender();
    Date date = encr->getDate();
    string encrypted_text = encr->getText();
    string decrypted_text = this->decrypt(encrypted_text);
    Message* decr = new Message();

    decr->setSender(sender);
    decr->setDate(date);
    decr->setText(decrypted_text);

    return decr;
}





























































