#ifndef AVATAR_H
#define AVATAR_H

#include <string>
#include "src/user_management/iomanager.h"
#include <QImage>
#include <QColor>
#include <QString>
#include <QDebug>



using std::string;

class Avatar{
public:
    Avatar();
    Avatar(string image_path);
    Avatar(string username, string format, string image_bin);
    Avatar(const Avatar& orig);

    string toString();

    string getImagePath() const;
    int getColor() const;

    void setImagePath(string image_path);
    void setColor(int color);

    string getFormat();
    string getBinary();

    void computeThemeColor();

    static string getImageFormat(string image_path);

private:
    static const int BRIGHTNESS_THRESHOLD;

    string image_path;
    int color;

    static int extractMedianColor(string source);
    static int calculateMedian(std::vector<int>& v);
};

#endif // AVATAR_H
