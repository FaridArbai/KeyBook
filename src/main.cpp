
#include <Qt>
#include <QDebug>
#include <QGuiApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlApplicationEngine>
#include <QWaitCondition>
#include <QMutex>
#include <QtAndroid>
#include <QAndroidJniObject>

#include <thread>
#include <iostream>
#include <string>
#include <stdlib.h>

#include "./connection_management/connection.h"
#include "./connection_management/servermessage.h"

#include "./frame_management/logframe.h"
#include "./frame_management/registerframe.h"
#include "./frame_management/mainframe.h"

#include "./protocol_messages/ProtocolMessage.h"
#include "./protocol_messages/PM_updateStatus.h"
#include "./protocol_messages/PM_msg.h"
#include "./protocol_messages/PM_addContactCom.h"

#include "./user_management/date.h"
#include "./user_management/status.h"
#include "./user_management/avatar.h"
#include "./user_management/user.h"
#include "./user_management/presence.h"
#include "./user_management/message.h"
#include "./user_management/contact.h"
#include "./user_management/privateuser.h"
#include "./user_management/iomanager.h"

#include <signal.h>

QQmlContext* context;

#define BUFFER_LENGTH 1048576

using namespace std;

void listeningTask(Connection& server_conn, ServerMessage* server_response,QWaitCondition* RESPONSE_CONDITION, MainFrame* main_frame);
void handleTrap(ProtocolMessage* trap, MainFrame* main_frame);

int main(int argc, char *argv[]){
    // Connection
    Connection server_conn;
    ServerMessage server_response;
    QWaitCondition RESPONSE_CONDITION;
    RequestHandler request_handler(&server_conn,&server_response,&RESPONSE_CONDITION);

    //Context instantiation
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    context = engine.rootContext();

    // Frames
    MainFrame main_frame(&context,&request_handler);
    LogFrame log_frame(&main_frame,&request_handler);
    RegisterFrame register_frame(&request_handler);


    // Start the networking thread
    thread listening_thread = thread(listeningTask, std::ref(server_conn), &server_response,&RESPONSE_CONDITION,&main_frame);
    listening_thread.detach();

    // GUI
        // Provide access to the frame managers
        context->setContextProperty("log_frame", &log_frame);
        context->setContextProperty("register_frame", &register_frame);
        context->setContextProperty("main_frame", &main_frame);

        // Initialize the IOManager
        IOManager::init();

        // Load the GUI resources
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    // END GUI

        QtAndroid::runOnAndroidThread([=]()
        {
            QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
            window.callMethod<void>("addFlags", "(I)V", 0x80000000);
            window.callMethod<void>("clearFlags", "(I)V", 0x04000000);
            window.callMethod<void>("setStatusBarColor", "(I)V", 0xff015f6a); // Desired statusbar color
        });


    // Start the GUI thread
    int app_result;
    app_result = app.exec();

    //save all the data before shutting down the app
    main_frame.logOutUser();

    return app_result;
}


void listeningTask(Connection& server_conn, ServerMessage* server_response, QWaitCondition* RESPONSE_CONDITION, MainFrame* main_frame){
    bool is_response;
    ProtocolMessage* pm_recv;

    while(true){
        pm_recv = server_conn.recvPM();
        is_response = pm_recv->isResponse();

        if(is_response){
            server_response->setProtocolMessage(pm_recv);
            RESPONSE_CONDITION->notify_all();
        }
        else{
            handleTrap(pm_recv,main_frame);
        }
    }

}

void handleTrap(ProtocolMessage* trap, MainFrame* main_frame){
    ProtocolMessage::MessageType trap_type;
    PrivateUser* user;
    bool is_loaded;
    QMutex load_mutex;
    QWaitCondition* LOAD_CONDITION = main_frame->getUserLoadedCondition();

    // Do not handle the trap until the user is fully loaded

    is_loaded = main_frame->userIsLoaded();

    if(!is_loaded){
        load_mutex.lock();
        LOAD_CONDITION->wait(&load_mutex);
        load_mutex.unlock();
    }

    user = main_frame->getPrivateUser();

    // Trap handle
    trap_type = trap->getType();

    switch(trap_type){
        case(ProtocolMessage::MessageType::updateStatus):{
            PM_updateStatus* update = dynamic_cast<PM_updateStatus*>(trap);
            string username = update->getUsername();
            PM_updateStatus::StatusType status_type = update->getType();

            switch(status_type){
                case(PM_updateStatus::StatusType::presence):{
                    string presence_text = update->getNewStatus();
                    string date_str = update->getDate();

                    user->updatePresenceOf(username,presence_text,date_str);
                    break;
                }
                case(PM_updateStatus::StatusType::status):{
                    string status_text = update->getNewStatus();
                    string date_str = update->getDate();

                    user->updateStatusOf(username,status_text,date_str);

                    break;
                }
                case(PM_updateStatus::StatusType::image):{
                    string username = update->getUsername();
                    Avatar new_avatar = update->getAvatar();

                    user->updateAvatarOf(username,new_avatar);

                    break;
                }
                default:{
                    break;
                }
            }//end status_type
            break;
        }
        case(ProtocolMessage::MessageType::msg):{
            PM_msg* msg = dynamic_cast<PM_msg*>(trap);
            string sender = msg->getFrom();
            string recipient = msg->getTo();
            string date_str = msg->getDate();
            string text = msg->getMsg();

            main_frame->handleMessage(sender,recipient,date_str,text);

            break;
        }
        case(ProtocolMessage::MessageType::addContactCom):{
            PM_addContactCom* add_com = dynamic_cast<PM_addContactCom*>(trap);

            main_frame->handleNewContact(add_com);
            break;
        }
        default:{
            break;
        }
    }//end switch(trap_type)

    delete trap;
}






























