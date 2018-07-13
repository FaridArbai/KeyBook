#include "latchword.h"

const string Latchword::HASH_SEPARATOR = "^";

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
    string message_base64 = Base64::encode(message);
    string encr = this->ptp_engine.encrypt(message_base64);
    this->ptp_engine.refresh();
    string hash = PublicEngine::computeBase64Hash(message);

    string payload = encr + Latchword::HASH_SEPARATOR + hash;

    string payload_base64 = Base64::encode((unsigned char*)payload.c_str(), payload.length());

    return payload_base64;
}

SignedText Latchword::decrypt(string& payload_base64){
    string payload = Base64::decode(payload_base64);
    int pos_split = payload.find(Latchword::HASH_SEPARATOR);
    string encr = payload.substr(0,pos_split);
    string expected_hash = payload.substr(pos_split+1);

    string decr_base64 = this->ptp_engine.decrypt(encr);
    string decr = Base64::decode(decr_base64);
    this->ptp_engine.refresh();

    string received_hash = PublicEngine::computeBase64Hash(decr);
    bool reliable = (expected_hash == received_hash);

    SignedText result(decr, reliable);

    return result;
}

string Latchword::toString(){
    return this->getPTPKey();
}

Message* Latchword::decrypt(Message* encr){
    string sender = encr->getSender();
    Date date = encr->getDate();
    string payload = encr->getText();

    SignedText signed_text = this->decrypt(payload);

    string decrypted_text = signed_text.getText();
    bool reliable = signed_text.getReliability();


    Message* decr = new Message();

    decr->setSender(sender);
    decr->setDate(date);
    decr->setText(decrypted_text);
    decr->setReliability(reliable);

    return decr;
}





























































