#ifndef PRESENCE_H
#define PRESENCE_H

#include "date.h"
#include <string>

using namespace std;

class Presence{
public:
    Presence();
    Presence(const Presence& orig);
    Presence(string text, string date_str);
    Presence(string code);

    string toString();

    string getText() const;
    void setText(string text);

    Date getDate() const;
    void setDate(Date date);

    string toHumanReadable();

private:
    string text;
    Date date;

    static const string FIELDS_SEP;
};

#endif // PRESENCE_H
