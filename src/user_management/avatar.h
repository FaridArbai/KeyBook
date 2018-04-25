#ifndef AVATAR_H
#define AVATAR_H

#include <string>
#include "src/user_management/iomanager.h"

using std::string;

class Avatar{
public:
    Avatar();
    Avatar(string image_path);
    Avatar(string username, string format, string image_bin);

    string toString();

    string getImagePath() const;
    void setImagePath(string image_path);

    string getFormat();
    string getBinary();

    static string getImageFormat(string image_path);

private:
    string image_path;
};

#endif // AVATAR_H
