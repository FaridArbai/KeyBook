#ifndef CONTACT_H
#define CONTACT_H

#include "src/user_management/user.h"
#include "src/user_management/presence.h"
#include "src/user_management/message.h"
#include "src/user_management/latchword.h"

#include <QString>
#include <QObject>
#include <stdio.h>

#include <string>
#include <vector>
#include "src/user_management/stda.h"

using namespace std;

class Contact : public QObject, public User{
    Q_OBJECT

    Q_PROPERTY(QString presence_gui READ getPresenceGUI NOTIFY presenceChanged)
    Q_PROPERTY(QString shortpresence_gui READ getShortPresenceGUI NOTIFY presenceChanged)
    Q_PROPERTY(QString unread_messages_gui READ getUnreadMessagesGUI NOTIFY unreadMessagesChanged)
    Q_PROPERTY(QString last_message_gui READ getLastMessageGUI NOTIFY lastMessageChanged)
    Q_PROPERTY(QString username_gui READ getUsernameGUI CONSTANT)
    Q_PROPERTY(QString avatar_path_gui READ getAvatarPathGUI NOTIFY avatarChanged)
    Q_PROPERTY(int avatar_color_gui READ getAvatarColorGUI NOTIFY avatarChanged)
    Q_PROPERTY(QString status_gui READ getStatusGUI NOTIFY statusChanged)
    Q_PROPERTY(QString status_date_gui READ getStatusDateGUI NOTIFY statusChanged)

public:
    static const string FIELDS_SEP;
    static const string MESSAGE_SEP;
    static const QString MODEL_NAME;
    static const QString VAR_NAME;

    Contact();
    Contact(string username, string status_text, string status_date,
            string presence_text, string presence_date, Avatar avatar,
            string ptpkey);
    Contact(string code);
    Contact(const Contact& orig) = delete;
    virtual ~Contact();

    string toString();

    void appendMessage(Message* message);

    Presence getPresence() const;
    void changePresence(string presence_text, string date_str);
    void setPresence(Presence presence);
    void setPresence(string presence_str);
    void setPresence(string presence_text, string date_str);

    int getUnreadMessages() const;
    void setUnreadMessages(int unread_messages);
    void setUnreadMessages(string unread_messages_str);

    vector<Message*> getMessages() const;
    void setMessages(vector<Message*> messages);
    void setMessages(string unread_messages_str);

    void setUser(string user_code);

    Latchword* getLatchword();
    void setLatchword(Latchword latchword);

    QString getPresenceGUI();
    QString getShortPresenceGUI();
    QString getUnreadMessagesGUI();

    void changeStatus(string status_text, string date_str);
    void changeStatus(string new_status_text);
    void changeAvatar(Avatar avatar);

    QString getUsernameGUI();
    QString getAvatarPathGUI();
    QString getStatusGUI();
    QString getStatusDateGUI();
    QString getLastMessageGUI();
    int getAvatarColorGUI();

    void pushMessage(string sender, string recipient, string date_str, string text);

    QList<QObject*>& getMessagesGUI();

    void incrementUnreadMessages();
    void restartUnreadMessages();

signals:
    void presenceChanged();
    void unreadMessagesChanged();
    void avatarChanged();
    void statusChanged();
    void lastMessageChanged();

private:
    Presence presence;
    int unread_messages;
    vector<Message*> messages;
    QList<QObject*> messages_gui;
    Latchword latchword;

    string messagesToString();

};

#endif // CONTACT_H
