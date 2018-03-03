#ifndef LOGWINDOW_H
#define LOGWINDOW_H

#include <QObject>
#include <QString>
#include <string>


#include "src/protocol_messages/ProtocolMessage.h"
#include "src/protocol_messages/PM_logReq.h"
#include "src/protocol_messages/PM_logRep.h"
#include "src/connection_management/servermessage.h"
#include "src/connection_management/requesthandler.h"
#include "src/frame_management/requestingframe.h"
#include "src/frame_management/mainframe.h"
#include "src/user_management/privateuser.h"
#include "src/user_management/iomanager.h"

using namespace std;

class LogFrame : public QObject, public RequestingFrame{
    Q_OBJECT
public:
    explicit LogFrame(QObject *parent = nullptr);

    LogFrame(MainFrame* contacts_frame, RequestHandler* request_handler);

    Q_INVOKABLE void logIn(const QString entered_username, const QString entered_password);

    void spreadPrivateUser();

    PrivateUser* getPrivateUser() const;
    void setPrivateUser(PrivateUser* user);

    MainFrame* getContactsFrame() const;
    void setContactsFrame(MainFrame* contacts_frame);

signals:
    void updateErrorLabel(QString err_msg);
    void userLoggedIn();

private:
    PrivateUser* user;
    MainFrame* contacts_frame;
};

#endif // LOGWINDOW_H
