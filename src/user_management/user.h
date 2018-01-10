#ifndef USER_H
#define USER_H

#include "date.h"
#include "status.h"
#include "avatar.h"

#include <QObject>
#include <QObject>

#include <string>

using namespace std;

class User{

public:
    static const string FIELDS_SEP;

    User();
    User(string username, string status_text, string image_path);
    User(string username, string status_text, string status_date, string image_path);
    User(string user_code);
    virtual ~User();

    string toString();

    string getUsername() const;
    void setUsername(string Username);

    Status getStatus() const;

    void setStatus(Status status);
    void setStatus(string status_str);
    void setStatus(string status_text, string status_date);

    Avatar getAvatar() const;
    void setAvatar(Avatar avatar);
    void setAvatar(string avatar_str);

    void setUser(string user_code);

protected:
    string username;
    Status status;
    Avatar avatar;

};

#endif // USER_H
