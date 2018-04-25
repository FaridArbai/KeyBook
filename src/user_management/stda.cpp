#include "stda.h"

int stda::stoi(std::string str){
    const char* str_c = str.c_str();
    int number = atoi(str_c);
    return number;
}


string stda::to_string(int number){
    string str = "";
    char str_c[256];

    sprintf(str_c, "%d", number);

    str = string(str_c);

    return str;
}

string stda::to_string(long long int number){
    string str = "";
    char str_c[256];
    sprintf(str_c, "%lld", number);
    str = string(str_c);
    return str;
}
