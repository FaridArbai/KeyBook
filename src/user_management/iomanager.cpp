#include "iomanager.h"

const string IOManager::ROOT_TO_USERS   = "./data/users/";
const string IOManager::ROOT_TO_IMAGES  = "./data/images/";

IOManager::IOManager(){
}

PrivateUser* IOManager::loadUser(string username){
    string path_to_user = IOManager::getPathToUser(username);
    std::ifstream ifs(path_to_user);
    std::string user_str;
    user_str.assign(std::istreambuf_iterator<char>(ifs),std::istreambuf_iterator<char>());

    PrivateUser* user = new PrivateUser(user_str);

    return user;
}

void IOManager::saveUser(PrivateUser* user){
    string path_to_user = IOManager::getPathToUser(user);
    std::ofstream user_file(path_to_user);

    user_file << (user->toString());

    user_file.close();
}

string IOManager::getPathToUser(PrivateUser* user){
    string username = user->getUsername();
    string path_to_user =  IOManager::getPathToUser(username);
    return path_to_user;
}

string IOManager::getPathToUser(string username){
    string path_to_user =  IOManager::ROOT_TO_USERS + username;

    return path_to_user;
}
