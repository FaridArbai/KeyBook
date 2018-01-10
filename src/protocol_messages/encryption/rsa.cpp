
#include "rsa.h"

namespace RSA{

    char buffer[1024];
    const int MAX_DIGITS = 50;
    int i,j = 0;

    struct public_key_class{
      long long modulus;
      long long exponent;
    };

    struct private_key_class{
      long long modulus;
      long long exponent;
    };

    const struct public_key_class public_key = {
        953595623,
        664134353
    };

    const std::string BLOCK_SEPARATOR = "/";

    // Do not change this value since it declares server's
    // public key. Only change it in case you are deploying
    // your own server.


    // This should totally be in the math library.
    long long gcd(long long a, long long b)
    {
      long long c;
      while ( a != 0 ) {
        c = a; a = b%a;  b = c;
      }
      return b;
    }


    long long ExtEuclid(long long a, long long b)
    {
     long long x = 0, y = 1, u = 1, v = 0, gcd = b, m, n, q, r;
     while (a!=0) {
       q = gcd/a; r = gcd % a;
       m = x-u*q; n = y-v*q;
       gcd = a; a = r; x = u; y = v; u = m; v = n;
       }
       return y;
    }

    long long rsa_modExp(long long b, long long e, long long m){
      if (b < 0 || e < 0 || m <= 0){
        exit(1);
      }
      b = b % m;
      if(e == 0) return 1;
      if(e == 1) return b;

      if( e % 2 == 0){
        return ( rsa_modExp(b * b % m, e/2, m) % m );
      }
      if( e % 2 == 1){
        return ( b * rsa_modExp(b, (e-1), m) % m );
      }
        return 0;
    }

    long long* rsa_encrypt(const char *message, const unsigned long message_size,
                         const struct public_key_class *pub)
    {
      long long *encrypted = (long long*)malloc(sizeof(long long)*message_size);
      if(encrypted == NULL){
        fprintf(stderr,
         "Error: Heap allocation failed.\n");
        return NULL;
      }
      long long i = 0;
      for(i=0; i < message_size; i++){
        encrypted[i] = rsa_modExp(message[i], pub->exponent, pub->modulus);
      }
      return encrypted;
    }


    char* rsa_decrypt(const long long *message,
                      const unsigned long message_size,
                      const struct private_key_class *priv)
    {
      if(message_size % sizeof(long long) != 0){
        fprintf(stderr,
         "Error: message_size is not divisible by %d, so cannot be output of rsa_encrypt\n", (int)sizeof(long long));
         return NULL;
      }
      // We allocate space to do the decryption (temp) and space for the output as a char array
      // (decrypted)
      char *decrypted = (char*)malloc(message_size/sizeof(long long));
      char *temp = (char*)malloc(message_size);
      if((decrypted == NULL) || (temp == NULL)){
        fprintf(stderr,
         "Error: Heap allocation failed.\n");
        return NULL;
      }
      // Now we go through each 8-byte chunk and decrypt it.
      long long i = 0;
      for(i=0; i < message_size/8; i++){
        temp[i] = rsa_modExp(message[i], priv->exponent, priv->modulus);
      }
      // The result should be a number in the char range, which gives back the original byte.
      // We put that into decrypted, then return.
      for(i=0; i < message_size/8; i++){
        decrypted[i] = temp[i];
      }
      free(temp);
      return decrypted;
    }

    string encrypt(string orig){
        string encr;
        int n_bytes_orig = orig.length();
        long long int* blocks;
        int n_bytes_encr = n_bytes_orig*sizeof(long long int);
        const char* orig_c = orig.c_str();

        blocks = (long long int*)malloc(n_bytes_encr);

        blocks = RSA::rsa_encrypt(orig_c, n_bytes_orig,&RSA::public_key);

        encr = "";
        long long int encr_block;
        for(int i=0; i<n_bytes_orig;i++){
            encr_block = blocks[i];
            encr = encr + std::to_string(encr_block) + RSA::BLOCK_SEPARATOR;
        }

        free(blocks);

        return encr;
    }

    const struct private_key_class private_key={
        0,
        0
    };
    // Just defined for clarity purposes, the private
    // key is used on the server to (1) protect client's
    // user and password through the network, (2) encrypt
    // the backup files and (3) guarantee the integrity of
    // every single message by a SHA-256 HASH which serves
    // as a signature.

    string decrypt(string encr){
        string orig;
        long long int* blocks;
        int n_blocks = 0;
        string block_str;
        string encr_tmp;
        int pos_split;
        int i0,iF;
        encr_tmp = encr;
        int input_length = encr.length();

        string str_tmp;
        for(int i=0;i<input_length;i++){
            str_tmp = encr.at(i);
            if(str_tmp==RSA::BLOCK_SEPARATOR){
                n_blocks++;
            }
        }

        if(n_blocks>0){
            blocks = (long long int*)malloc(n_blocks*sizeof(long long int));

            for(int i=0; i<n_blocks;i++){
                pos_split = encr_tmp.find(RSA::BLOCK_SEPARATOR);
                block_str = encr_tmp.substr(0,pos_split);
                blocks[i] = strtoll(block_str.c_str(),nullptr,10);

                if(i!=(n_blocks-1)){
                    i0 = pos_split + 1;
                    iF = encr_tmp.length()-i0;
                    encr_tmp = encr_tmp.substr(i0,iF);
                }
            }

            char* orig_c = (char*)malloc(n_blocks + 1);

            orig_c = (char*)RSA::rsa_decrypt(blocks,(n_blocks)*8,&RSA::private_key);
            orig_c[n_blocks] = '\0';

            orig = string(orig_c);

            free(orig_c);
            free(blocks);
        }

        return orig;
    }


}































