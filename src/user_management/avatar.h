#ifndef AVATAR_H
#define AVATAR_H

#include <string>

using std::string;

class Avatar{
public:
    Avatar();
    Avatar(string image_path);

    string toString();

    string getImagePath() const;
    void setImagePath(string image_path);

private:
    string image_path;
};

#endif // AVATAR_H
