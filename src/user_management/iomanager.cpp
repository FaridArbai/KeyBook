#include "iomanager.h"
#include "privateuser.h"
#include <QDebug>
#include <QString>

#ifdef _WIN32
const string IOManager::FILE_HEADER = "file:///";
#else
const string IOManager::FILE_HEADER = "file://";
#endif

string IOManager::ROOT_PATH;
const string IOManager::LEAF_TO_IMAGES  = "/";
const string IOManager::LEAF_TO_USERS   = "/";

PrivateUser* IOManager::loadUser(string username){
    string path_to_user = IOManager::getPathToUser(username);
    std::ifstream ifs(path_to_user);
    std::string user_str;
    user_str.assign(std::istreambuf_iterator<char>(ifs),std::istreambuf_iterator<char>());

    PrivateUser* user = new PrivateUser(user_str);

    user->moveToMainThread();

    return user;
}

void IOManager::loadDataIntoUser(string username, PrivateUser* user){
    string path_to_user = IOManager::getPathToUser(username);
    std::ifstream ifs(path_to_user);
    std::string user_str;
    user_str.assign(std::istreambuf_iterator<char>(ifs),std::istreambuf_iterator<char>());

    user->load(user_str);
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
    string path_to_user =  IOManager::getRootToUsers() + username;

    return path_to_user;
}

void IOManager::saveImage(string image_path,string image_bin){
    std::ofstream output_file(image_path,std::ofstream::binary);

    output_file << image_bin;
    output_file.close();
}

 string IOManager::getImageBinary(string path){
    std::ifstream input_file(path,std::ios::binary);
    std::ostringstream image_stream;

    image_stream << input_file.rdbuf();
    string image_bin(image_stream.str());

    return image_bin;
}

string IOManager::getImagePath(string username, string format){
    string title = IOManager::generateImageTitle(username);
    string image_name = title + "." + format;
    string image_path = IOManager::getImagePath(image_name);

    return image_path;
}

string IOManager::getImagePath(string image_name){
    string image_path = IOManager::getRootToImages() + image_name;
    return image_path;
}

string IOManager::generateImageTitle(string username){
    string nonce = IOManager::generateNonce();
    string image_title = username + "_" + nonce;
    return image_title;
}

string IOManager::generateNonce(){
    time_t t = time(0);
    struct tm* todays_date = localtime(&t);

    string day = stda::to_string(todays_date->tm_mday);
    string month = stda::to_string(todays_date->tm_mon + 1);
    string year = stda::to_string((todays_date->tm_year + 1900)%2000);
    string hour = stda::to_string(todays_date->tm_hour);
    string minute = stda::to_string(todays_date->tm_min);
    string second = stda::to_string(todays_date->tm_sec);

    if(hour.length()==1){
        hour = "0" + hour;
    }
    if(minute.length()==1){
        minute = "0" + minute;
    }
    if(day.length()==1){
        day = "0" + day;
    }
    if(month.length()==1){
        month = "0" + month;
    }


    string nonce = day + month + year + hour + minute + second;

    return nonce;
}

string IOManager::getRootToUsers(){
    string root_to_users =
            IOManager::ROOT_PATH +
            IOManager::LEAF_TO_USERS;
    return root_to_users;
}

string IOManager::getRootToImages(){
    string root_to_images =
            IOManager::ROOT_PATH +
            IOManager::LEAF_TO_IMAGES;
    return root_to_images;
}

void IOManager::setExecPath(string EXEC_PATH){
    IOManager::ROOT_PATH = EXEC_PATH;
}


void IOManager::init(){
    char path_c[FILENAME_MAX];
    string exec_path;
    struct stat info;
    string path_to_data;
    string path_to_users;
    string path_to_images;
    string path_to_default;
    bool exists;
    bool forbidden_access;
    int err_code;

    GetCurrentDir(path_c,FILENAME_MAX);
    exec_path = string(path_c);

    IOManager::setExecPath(exec_path);

    path_to_data = exec_path + "/default.png";

    stat(path_to_data.c_str(),&info);

    exists = (access(path_to_data.c_str(),0)==0);

    qDebug() << "Se entra en el init" << endl;

    if(!exists){
        qDebug() << "Se va a crear la imagen" << endl;
        string image_bin = Base64::decode(IOManager::DEFAULT_IMAGE);
        IOManager::saveImage("default.png",image_bin);
    }
}

const string IOManager::DEFAULT_IMAGE =
        "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"
        "6MDA9mzg7AAAAAElFTkSuQmCC";




























