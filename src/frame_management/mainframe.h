#ifndef MAINFRAME_H
#define MAINFRAME_H

#include "QQmlContext"
#include <QString>
#include <QWaitCondition>
#include <QMutex>
#include <QtAndroid>
#include <QAndroidJniObject>

#include <QtConcurrent/QtConcurrent>

using namespace QtConcurrent;

#include "src/frame_management/requestingframe.h"
#include "src/frame_management/image_picker/imagepickerandroid.h"

#include "src/connection_management/requesthandler.h"

#include "src/user_management/privateuser.h"
#include "src/user_management/iomanager.h"

#include "src/protocol_messages/PM_addContactReq.h"
#include "src/protocol_messages/PM_addContactCom.h"
#include "src/protocol_messages/PM_addContactRep.h"
#include "src/protocol_messages/PM_updateStatus.h"
#include "src/protocol_messages/PM_msg.h"
#include "src/protocol_messages/PM_logOutReq.h"
#include "src/protocol_messages/PM_logOutCom.h"
#include "src/protocol_messages/PM_logOutRep.h"

#include <string>
#include <thread>
#include <chrono>

using namespace std;

class MainFrame : public QObject, public RequestingFrame{
    Q_OBJECT
public:
    MainFrame(QQmlContext** context, RequestHandler* request_handler);

    Q_INVOKABLE void updateUserStatus(QString entered_status);
    Q_INVOKABLE void updateImagePath(QString entered_image_path);

    Q_INVOKABLE QString getCurrentUsername();
    Q_INVOKABLE QString getCurrentStatus();
    Q_INVOKABLE QString getCurrentStatusDate();
    Q_INVOKABLE QString getCurrentImagePath();

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

    Q_INVOKABLE void openImagePicker();
    Q_INVOKABLE void saveRetouchedImage(QString source, int x, int y, int width, int height);
    Q_INVOKABLE void sendAvatar();

    Q_INVOKABLE void addContact(QString entered_username);
    Q_INVOKABLE void addRequestedContact(QString entered_username);

    Q_INVOKABLE void changeStatusbarColor(int color);

    Q_INVOKABLE void initScreenResources();

    Q_INVOKABLE void measureVKeyboardHeight();
    Q_INVOKABLE int getStatusbarHeight();
    Q_INVOKABLE int getNavigationbarHeight();
    Q_INVOKABLE int getAppHeight();
    Q_INVOKABLE int getAppWidth();
    Q_INVOKABLE float getDensity();

signals:
    void finishedAddingContact(bool add_result, QString err_msg);
    void finishedUploadingImage();
    void statusChanged(QString new_status_gui, QString new_date_gui, QString err_msg = "");
    void avatarChanged();
    void avatarChanging(QString selected_image_path);
    void receivedMessageForCurrentConversation();
    void receivedForeignContact();
    void receivedRequestedContact();
    void receivedNewMessage();
    void logOut();
    void waitingForTooLong();
    void statusbarHeightChanged(int statusbar_height);
    void navigationbarHeightChanged(int navigationbar_height);
    void appHeightChanged(int app_height);
    void vkeyboardHeightChanged(int vkeyboard_height);

private:
    static const int WAIT_THRESHOLD_SEC;
    PrivateUser* user;
    bool user_is_loaded = false;
    QWaitCondition USER_LOADED;
    QQmlContext** context_ptr;
    bool in_conversation;
    PM_addContactCom* current_add_com;
    ProtocolMessage* current_add_rep;
    QWaitCondition FINISHED_ADDING_FOREIGN;
    int n_delegate_threads = 0;
    QMutex delegate_thread_mtx;

    int statusbar_height;
    int navigationbar_height;
    int app_height;
    int app_width;
    int vkeyboard_height;
    float density;
    bool statusbar_transparent = false;
    bool android_thread_busy = false;
    QMutex android_sync_mtx;
    QWaitCondition ANDROID_TASK_FINISHED;

    void setInConversation(bool in_conversation);
    bool getInConversation();
    int getNumberOfDelegateThreads();
    void changeNumberOfDelegateThreads(int delta);

    void sendAvatarImpl();
    void addContactImpl(QString entered_username);
    void logOutUserImpl();
    void notifyThreshold();

    void setStatusbarHeight(int statusbar_height);
    void setNavigationbarHeight(int navigationbar_height);
    void setAppHeight(int app_height);
    void setAppWidth(int app_width);
    void setDensity(float density);
    void setVKeyboardHeight(int vkeyboard_height);
    void setAndroidThreadBusy(int android_thread_busy);

    int getVKeyboardHeight();
    int getAndroidThreadBusy();
};

#endif // MAINFRAME_H
