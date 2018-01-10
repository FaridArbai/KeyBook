#ifndef IOMANAGER_H
#define IOMANAGER_H

#include "privateuser.h"

#include <string>
#include <iostream>
#include <fstream>

using namespace std;

class IOManager{
public:
    IOManager();

    static PrivateUser* loadUser(string username);
    static void saveUser(PrivateUser* user);

private:
    static const string ROOT_TO_USERS;
    static const string ROOT_TO_IMAGES;

    static string getPathToUser(PrivateUser* user);
    static string getPathToUser(string username);
};

#endif // IOMANAGER_H
