#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>
#include <QString>

#include <string>
#include "src/user_management/date.h"

using namespace std;

class Message : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString sender_gui READ getSenderGUI CONSTANT)
    Q_PROPERTY(QString date_gui READ getDateGUI CONSTANT)
    Q_PROPERTY(QString text_gui READ getTextGUI CONSTANT)
    Q_PROPERTY(bool reliability_gui READ getReliability CONSTANT)
public:
    static const string FIELDS_SEP;
    static const QString MODEL_NAME;

    Message();
    Message(string sender, string date_str, string text);
    Message(string code);

    string toString();

    string getSender() const;
    void setSender(string sender);

    Date getDate() const;
    void setDate(string date_str);
    void setDate(Date date);

    string getText() const;
    void setText(string text);

    QString getSenderGUI();
    QString getDateGUI();
    QString getTextGUI();

    void setReliability(bool reliability);
    bool getReliability();
private:
    string sender;
    Date date;
    string text;
    bool reliable;
};

#endif // MESSAGE_H
























