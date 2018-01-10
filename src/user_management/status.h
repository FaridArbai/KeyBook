#ifndef STATUS_H
#define STATUS_H

#include "date.h"
#include <string>

using namespace std;

class Status{
public:
    Status();
    Status(const Status& orig);
    Status(string code_or_text);
    Status(string text, string date_str);

    string toString();

    string getText() const;
    void setText(string text);

    Date getDate() const;
    void setDate(Date date);
    void setDate(string date_str);
private:
    string text;
    Date date;

    static const string FIELD_SEP;
};

#endif // STATUS_H
