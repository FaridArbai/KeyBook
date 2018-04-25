#ifndef BASE64_H
#define BASE64_H

#include <string>

using namespace std;

class Base64{
public:
    Base64();
    static string encode(unsigned char const* bytes_to_encode, unsigned int in_len);
    static string decode(string const& encoded_string);

private:
    static const string BASE64_CHARS;
    static bool isBase64(unsigned char c);

};

#endif // BASE64_H
