#ifndef PRIVATEUSER_H
#define PRIVATEUSER_H

#include "user.h"
#include "contact.h"

#include <string>
#include <vector>
#include <algorithm>
#include "iostream"

#include <QList>
#include <QVector>

using namespace std;

class PrivateUser : public User{

public:
    static const string FIELDS_SEP;

    PrivateUser();
    PrivateUser(string code);
    PrivateUser(string username, string status_text, string image_path);
    PrivateUser(const PrivateUser& orig) = delete;
    virtual ~PrivateUser();

    string toString();

    void addContact(Contact* new_contact);
    void deleteContact(Contact* contact);

    void updateStatus(string new_status_text);

    void updatePresenceOf(string username, string presence_text, string date_str);
    void updateStatusOf(string username, string status_text, string date_str);

    QList<QObject*>& getContactsGUI();
    Contact* getContact(string username);

    vector<Contact*> getContacts() const;
    void setContacts(vector<Contact*> contacts);

    void setConversationWith(string username);
    void finishCurrentConversation();

    QList<QObject*>& getConversationMessagesGUI();

    void addMessage(string sender, string recipient, string date_str, string text);

private:
    vector<Contact*> contacts;
    QList<QObject*> contacts_gui;

    bool in_conversation;
    string conversation_username;

    void pushContact(Contact* new_contact);
    void popContact(Contact* contact);

    void setInConversation(bool in_conversation);
    bool getInConversation();

    string getConversationUsername();
};

#endif // PRIVATEUSER_H
