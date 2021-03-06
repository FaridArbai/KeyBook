#ifndef REGWINDOW_H
#define REGWINDOW_H

#include "src/connection_management/connection.h"
#include "src/connection_management/servermessage.h"

#include <QObject>
#include <QString>
#include <string>
#include <QWaitCondition>
#include <QMutex>

#include "src/frame_management/requestingframe.h"
#include "src/connection_management/requesthandler.h"
#include "src/protocol_messages/PM_regReq.h"
#include "src/protocol_messages/PM_regRep.h"

#include "src/protocol_messages/PM_logReq.h"
#include "src/protocol_messages/PM_logRep.h"
#include "src/protocol_messages/PM_updateStatus.h"
#include "src/protocol_messages/PM_logOutReq.h"
#include "src/protocol_messages/PM_logOutRep.h"
#include "src/protocol_messages/ProtocolMessage.h"

#include "src/user_management/iomanager.h"
#include "src/user_management/privateuser.h"

using namespace std;

class RegisterFrame : public QObject, public RequestingFrame{
    Q_OBJECT
public:
    RegisterFrame(QObject *parent = nullptr);

    RegisterFrame(RequestHandler* request_handler);

    Q_INVOKABLE void signUp(QString entered_username, QString entered_password);

    void signUpImpl(string username, string password);
    void saveDataImpl(string username, string password);

signals:
    void receivedRegisterResponse(QString feedback_message, bool success);
    void userRegisteredIn();

private:
    static const string DEFAULT_STATUS;
    static const string DEFAULT_IMAGE_NAME;

    PrivateUser* createDefaultUser(string username, string password);
    void sendDefaultParams(string username, string password);

};

#endif // REGWINDOW_H










































