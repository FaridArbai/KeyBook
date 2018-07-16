#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>
#include <QString>
#include <QDebug>

#include <string>
#include "src/user_management/date.h"

using namespace std;

class Message : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString sender_gui READ getSenderGUI CONSTANT)
    Q_PROPERTY(QString date_gui READ getDateGUI CONSTANT)
    Q_PROPERTY(QString timestamp_gui READ getTimestampGUI CONSTANT)
    Q_PROPERTY(QString text_gui READ getTextGUI CONSTANT)
    Q_PROPERTY(bool reliability_gui READ getReliability CONSTANT)

    Q_PROPERTY(bool first_of_its_day_gui READ isFirstOfItsDay CONSTANT)

    Q_PROPERTY(bool first_of_group_gui READ isFirstOfGroup CONSTANT)

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

    void setFirstOfItsDay(bool first);
    bool isFirstOfItsDay();

    void setFirstOfGroup(bool first);
    bool isFirstOfGroup();

    QString getSenderGUI();
    QString getDateGUI();
    QString getTimestampGUI();
    QString getTextGUI();

    void setReliability(bool reliability);
    bool getReliability();

    void setFirstOfGroup(Message* previous);
    void setFirstOfItsDay(Message* previous);
private:
    string sender;
    Date date;
    string text;
    bool reliable;
    bool first_of_its_day;
    bool first_of_group;
};

#endif // MESSAGE_H
























