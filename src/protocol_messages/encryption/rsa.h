#ifndef RSA_H
#define RSA_H

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <string>

using namespace std;

// This is the header file for the library librsaencrypt.a

// Change this line to the file you'd like to use as a source of primes.
// The format of the file should be one prime per line.

namespace RSA{

    // This function will encrypt the data pointed to by message. It returns a pointer to a heap
    // array containing the encrypted data, or NULL upon failure. This pointer should be freed when
    // you are finished. The encrypted data will be 8 times as large as the original data.
    long long* rsa_encrypt(const char *message, const unsigned long message_size, const struct public_key_class *pub);

    // This function will decrypt the data pointed to by message. It returns a pointer to a heap
    // array containing the decrypted data, or NULL upon failure. This pointer should be freed when
    // you are finished. The variable message_size is the size in bytes of the encrypted message.
    // The decrypted data will be 1/8th the size of the encrypted data.
    char* rsa_decrypt(const long long *message, const unsigned long message_size, const struct private_key_class *pub);

    //const public_key_class public_key;

    string encrypt(string orig);
    string decrypt(string encr);

}
#endif /* RSA_H */
