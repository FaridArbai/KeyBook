#ifndef MAINFRAME_H
#define MAINFRAME_H

#include "QQmlContext"
#include <QString>
#include <QWaitCondition>
#include <QMutex>

#include "../frame_management/requestingframe.h"

#include "../connection_management/requesthandler.h"

#include "../user_management/privateuser.h"
#include "../user_management/iomanager.h"

#include "../src/protocol_messages/PM_addContactReq.h"
#include "../src/protocol_messages/PM_addContactCom.h"
#include "../src/protocol_messages/PM_addContactRep.h"
#include "../src/protocol_messages/PM_updateStatus.h"
#include "../src/protocol_messages/PM_msg.h"
#include "../src/protocol_messages/PM_logOutReq.h"
#include "../src/protocol_messages/PM_logOutCom.h"
#include "../src/protocol_messages/PM_logOutRep.h"

#include <string>

using namespace std;

class MainFrame : public QObject, public RequestingFrame{
    Q_OBJECT
public:
    MainFrame(QQmlContext** context, RequestHandler* request_handler);

    Q_INVOKABLE void addContact(QString entered_username);
    Q_INVOKABLE void updateUserStatus(QString entered_status);

    Q_INVOKABLE QString getCurrentUsername();
    Q_INVOKABLE QString getCurrentStatus();
    Q_INVOKABLE QString getCurrentStatusDate();

    Q_INVOKABLE void refreshContactsGUI();

    PrivateUser* getPrivateUser() const;
    void setPrivateUser(PrivateUser* user);

    void setContext(QQmlContext** context);

    Q_INVOKABLE void logOutUser();

    bool userIsLoaded();
    void setUserLoaded(bool is_loaded);

    void notifyUserLoaded();
    QWaitCondition* getUserLoadedCondition();

    Q_INVOKABLE void loadConversationWith(QString contact_name);
    Q_INVOKABLE void finishCurrentConversation();

    Q_INVOKABLE void refreshMessagesGUI();

    void handleMessage(string sender, string recipient, string date_str, string text);
    Q_INVOKABLE void sendMessage(QString conversation_recipient, QString entered_text);

    void handleNewContact(PM_addContactCom* add_com);
    Q_INVOKABLE void addForeignContact();

    Q_INVOKABLE void refreshContactGUI(QString username_gui);

signals:
    void finishedAddingContact(bool add_result, QString err_msg);
    void statusChanged(QString new_status_gui, QString new_date_gui, QString err_msg = "");
    void receivedMessageForCurrentConversation();
    void receivedForeignContact();

private:
    PrivateUser* user;

    bool user_is_loaded = false;
    QWaitCondition USER_LOADED;

    QQmlContext** context_ptr;

    bool in_conversation;

    void setInConversation(bool in_conversation);
    bool getInConversation();

    PM_addContactCom* current_add_com = nullptr;
    QWaitCondition FINISHED_ADDING_FOREIGN;
};

#endif // MAINFRAME_H
