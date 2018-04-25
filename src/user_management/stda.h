#ifndef STDA_H
#define STDA_H

#include <stdlib.h>
#include <string>
#include <sstream>

using namespace std;

/**
 * @brief The stda class
 * This class name stands for std-android-comptatible, which
 * implements the stoi and to_string methods from the std
 * library which are not supported by the NDK compiler
 * due to the well-known gnu gcc 99 bug. Hence, this methods
 * are used by every single class which needs to:
 *  (1) Get the string representation of a given int
 *  (2) Get the string representation of long long int
 *  (3) Get the int which is represented by
 */



class stda{
public:
    static int stoi(string str);

    static string to_string(int number);
    static string to_string(long long int number);

};

#endif // STDA_H
