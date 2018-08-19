#ifndef IOMANAGER_H
#define IOMANAGER_H

#include <QGuiApplication>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <ctime>
#include "src/user_management/stda.h"
#include "src/protocol_messages/encoding/base64.h"
#include <sys/types.h>
#include <sys/stat.h>

#ifdef _WIN32
#include <direct.h>
#define GetCurrentDir _getcwd
#define access _access_s
#else
#include <unistd.h>
#define GetCurrentDir getcwd
#endif

class PrivateUser;

using namespace std;

class IOManager{
public:
    static const string FILE_HEADER;

    IOManager() = delete;

    static PrivateUser* loadUser(string username);
    static void loadDataIntoUser(string username, PrivateUser* user);


    static void saveUser(PrivateUser* user);

    static void saveImage(string image_path, string image_bin);
    static string getImageBinary(string path);

    static string getImagePath(string username, string format);
    static string getImagePath(string image_name);

    static void init();
private:
    static string ROOT_PATH;
    static const string LEAF_TO_USERS;
    static const string LEAF_TO_IMAGES;
    static const string DEFAULT_IMAGE;

    static string getPathToUser(PrivateUser* user);
    static string getPathToUser(string username);

    static string getRootToUsers();
    static string getRootToImages();

    static string generateImageTitle(string username);
    static string generateNonce();

    static void setExecPath(string EXEC_PATH);
};

#endif // IOMANAGER_H
