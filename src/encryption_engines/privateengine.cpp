#include "privateengine.h"

const char PrivateEngine::PRIVATE_KEY[] = "-----BEGIN RSA PRIVATE KEY-----\n"
                             "MIIEowIBAAKCAQEA36F1ad/VQcnDRSuh95LcxaiaMFz9KSuSDQZTKZV5wq3N2BVM\n"
                             "hzbWFZhCexwVbGZNwlOrSLxVAzGQlmT3nRD8pef2gL90MSyuH9VRF+Wypq2XvKp4\n"
                             "8CScu6QruzeYkq9GJS/Ow55Ofei8TyKEz27jr3EdFIBQpQfNAytdOEkDIZQFryZw\n"
                             "rtsAQ7D/TAsXbIlpsYPQETnS9FeqFiuyey96OnfDaiF0LgRaP44FyWPKh9PtTiMD\n"
                             "AUVAapSNrK6mFZ29jfBNPKbOgRbS4CnxS6P6tUZ/O1/sYrEymwgp9EBdx62I4wl5\n"
                             "I+uvzbt0Nld2qkETwLyDweenjTdSiz2IlB2LqwIDAQABAoIBABX+3XuSZnlYDPrK\n"
                             "td2R9mECmlfTbZsVDAJ38soOR7GcQrjUL3jFLf1lwnQ1aO4GifNpI1m+HGZ6A4yn\n"
                             "Vat/NjpjPF2hdx43FNFQu+8ryoyWWmxWIBsOntPd6+c4KquSzcVulFmtQm8j6xGl\n"
                             "hYaZk494ArI3hLcWs1VyeHLGy6YLqAAlazZ8H++KjrULpWTs6sw5UE5YTUNRamhl\n"
                             "i6VY3SMUnyIuP1aSQtWmq4npiNMWokO9Sf7dblV6ucYsURaiod5qUuBdEdjB6BXO\n"
                             "eVDikD692tJwj6GGEjT62Wti86eO7QvssT/n3/qaUoEhPGcdpBkgLz9sQyv0f68u\n"
                             "ZcZ6QTECgYEA+St4U2fWKPfQSrfU4kvjrhBId+m5jTJNK29xJ2VTP6sPheqnac1M\n"
                             "xV+/NK51ZBr0qvb4MrI04zkrimP6pliKXMSzZyi9H0tv+8ekUvADr2Ept3bnK8Gu\n"
                             "49B/2Lr4hjsq0xaLNaBHKtoPxzJ2xJeBqtON3pNysQ+9Zj5unVCvSh0CgYEA5cLF\n"
                             "GEb3Pe6bwEVTGi2pUXebRg7amVUd4uX0w118LgM5cq7/+iRJmIgO8sKQP1JI7PB7\n"
                             "rtzyc3n3YSItKF5T7xTYxEsJ7J15sObbRyuTimxBQXDv0Fo/4EN2CGC9/bvoHfnb\n"
                             "i9my+uKU1fFhjFSXuf4/jH6ezGJTGLavG/+EgmcCgYB4j33y7UUEIZPY80XAEPQj\n"
                             "HqHR03cCSJpqL8vSQgabwcsLAtTqLnm87mz3son+W8SSjFjfPra0Us8scN+waRrZ\n"
                             "dBtSCLYpVDjk3F43+wXtb9fde1yzIU3b0OBrH1xspmg8JqZI1jpZE5WazmIFEUGe\n"
                             "RCpazYErBvCfbgnbeFS4SQKBgGZdy9CQNbHbMHuOp4LfWzPX1U92aMCuIp2oFNBC\n"
                             "Q4SAnUTSYWwCZOPXoslYFEqSD7m5P3HeMQtwCN63CmWU+VJo+Fckk6xfUQuXH5Vq\n"
                             "/dZLext8BOzQeOsjQ2BiMePtp3JLkxyRBuQutV9Ip0yNl/gfJhMjiv7Gw/0bz5Lq\n"
                             "2g/7AoGBAPfVih4U4wcEkUFNAM75ZjEAjHXVr/g1SngcsKM7SfgejacgnqUFaN59\n"
                             "RS3/41uE/c1uowR3de+UnucSxqcU7IXFceutyIOYdmehwSefm445kAe+xQTfHBTk\n"
                             "s7fDiRVslFGkziwAMrf65wlAHuldFVQrIleEztxdCfG7EL6xOKIZ\n"
                             "-----END RSA PRIVATE KEY-----";

string PrivateEngine::decrypt(const string& encr_b64){
    string encr;
    int encr_len;
    const char* encr_c;
    char* decr_c;
    string decr;

    BIO* private_bio = BIO_new_mem_buf(PRIVATE_KEY,(int)sizeof(PRIVATE_KEY));
    EVP_PKEY* private_key_evp = PEM_read_bio_PrivateKey(private_bio,NULL,NULL,NULL);
    RSA* private_key_rsa = EVP_PKEY_get1_RSA(private_key_evp);

    encr = Base64::decode(encr_b64);
    encr_len = encr.length();
    encr_c = encr.c_str();

    decr_c = (char*)malloc(RSA_size(private_key_rsa));

    RSA_private_decrypt(encr_len,
                       (unsigned char*)encr_c,
                       (unsigned char*)decr_c,
                       private_key_rsa,
                       RSA_PKCS1_OAEP_PADDING);

    decr = string(decr_c);
    free(decr_c);

    return decr;
}

string PrivateEngine::sign(const string& msg){
    string hash = PrivateEngine::sha256(msg);
    string signature = PrivateEngine::encryptHash(hash);

    return signature;
}

string PrivateEngine::sha256(const string& msg){
    string hash_str;
    const char* msg_c = msg.c_str();
    int msg_len = msg.length();
    unsigned char hash[SHA256_DIGEST_LENGTH+1];
    SHA256_CTX sha256;

    SHA256_Init(&sha256);
    SHA256_Update(&sha256,msg_c,msg_len);
    SHA256_Final(hash,&sha256);
    hash[SHA256_DIGEST_LENGTH] = (unsigned char)'\0';

    hash_str = string((const char*)hash);

    return hash_str;
}

string PrivateEngine::encryptHash(const string& hash){
    int hash_len = hash.length();
    const char* hash_c = hash.c_str();
    char* encr_c;
    int encr_len;
    string encr_b64;

    BIO* private_bio = BIO_new_mem_buf(PRIVATE_KEY,(int)sizeof(PRIVATE_KEY));
    EVP_PKEY* private_key_evp = PEM_read_bio_PrivateKey(private_bio,NULL,NULL,NULL);
    RSA* private_key_rsa = EVP_PKEY_get1_RSA(private_key_evp);

    encr_c = (char*)malloc(RSA_size(private_key_rsa));

    encr_len = RSA_private_encrypt(hash_len+1,
                                   (unsigned char*)hash_c,
                                   (unsigned char*)encr_c,
                                   private_key_rsa,
                                   RSA_PKCS1_PADDING);

    encr_b64 = Base64::encode((const unsigned char*)encr_c,encr_len);
    free(encr_c);

    return encr_b64;
}


























































































