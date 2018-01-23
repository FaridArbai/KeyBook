#include "symmetricengine.h"

const char SymmetricEngine::PAD_TOKEN = '!';

SymmetricEngine::SymmetricEngine(){
}

string SymmetricEngine::encrypt(const string& orig){
    string orig_pad;
    int encr_len;
    const char* orig_bin_c;
    uint8_t* orig_bin;
    uint8_t* encr_bin;
    const unsigned char* encr_bin_uc;
    string encr_b64;

    orig_pad = SymmetricEngine::pad(orig);
    encr_len = orig_pad.length();
    orig_bin_c = orig_pad.c_str();
    orig_bin = (uint8_t*)orig_bin_c;

    encr_bin = orig_bin;
    AES::AES_CBC_encrypt_buffer(&(this->ctx_send),encr_bin,encr_len);

    encr_bin_uc = (const unsigned char*)encr_bin;

    encr_b64 = Base64::encode(encr_bin_uc,encr_len);

    return encr_b64;
}

string SymmetricEngine::decrypt(const string& encr){
    string encr_bin_str;
    uint8_t* encr_bin;
    int n_bytes_encr;
    uint8_t* decr_bin;
    string orig;

    encr_bin_str = Base64::decode(encr);
    n_bytes_encr = encr_bin_str.length();
    encr_bin = (uint8_t*)encr_bin_str.c_str();

    decr_bin = encr_bin;
    AES::AES_CBC_decrypt_buffer(&(this->ctx_recv),decr_bin,n_bytes_encr);

    orig = string((const char*)decr_bin,n_bytes_encr);

    orig = SymmetricEngine::unpad(orig);

    return orig;
}

void SymmetricEngine::init(string key_send, string iv_send, string key_recv, string iv_recv){
    SymmetricEngine::copyBytes(key_send,this->initial_key_send);
    SymmetricEngine::copyBytes(key_recv,this->initial_key_recv);
    SymmetricEngine::copyBytes(iv_send,this->initial_iv_send);
    SymmetricEngine::copyBytes(iv_recv,this->initial_iv_recv);

    this->initCtxSend();
    this->initCtxRecv();
}

void SymmetricEngine::setKeys(string key_send, string key_recv){
    SymmetricEngine::copyBytes(key_send,this->initial_key_send);
    SymmetricEngine::copyBytes(key_recv,this->initial_key_recv);

    uint8_t* iv_send = (this->ctx_send).Iv;
    uint8_t* iv_recv = (this->ctx_recv).Iv;

    SymmetricEngine::copyBytes(iv_send,this->initial_iv_send);
    SymmetricEngine::copyBytes(iv_recv,this->initial_iv_recv);

    this->initCtxSend();
    this->initCtxRecv();
}


void SymmetricEngine::refresh(){
    this->initCtxSend();
    this->initCtxRecv();
}

void SymmetricEngine::copyBytes(string from, uint8_t* to){
    for(int i=0; i<KEY_LENGTH; i++){
        to[i] = (uint8_t)from.at(i);
    }
}

void SymmetricEngine::copyBytes(uint8_t* from, uint8_t* to){
    for(int i=0; i<KEY_LENGTH; i++){
        to[i] = from[i];
    }
}

void SymmetricEngine::initCtxSend(){
    AES::AES_init_ctx_iv(&(this->ctx_send),
                         this->initial_key_send,
                         this->initial_iv_send);
}

void SymmetricEngine::initCtxRecv(){
    AES::AES_init_ctx_iv(&(this->ctx_recv),
                         this->initial_key_recv,
                         this->initial_iv_recv);
}


string SymmetricEngine::pad(const string& orig){
    string padded;
    string pad = "";
    int len = orig.length();
    int div = SymmetricEngine::KEY_LENGTH;
    int mod = (len%div);
    int remainder = div - mod;

    if(mod>0){
        for(int i=0; i<remainder; i++){
            pad = pad + SymmetricEngine::PAD_TOKEN;
        }
        padded = orig + pad;
    }
    else{
        padded = orig;
    }

    return padded;
}

string SymmetricEngine::unpad(const string& orig){
    string unpadded = orig;

    unpadded.erase(std::remove(unpadded.begin(),unpadded.end(),SymmetricEngine::PAD_TOKEN),
                   unpadded.end());

    return unpadded;
}





















































































