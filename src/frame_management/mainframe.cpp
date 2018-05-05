#include "mainframe.h"
#include <QDebug>

const int MainFrame::WAIT_THRESHOLD_SEC = 2;

MainFrame::MainFrame(QQmlContext** context_ptr, RequestHandler* request_handler) :
RequestingFrame::RequestingFrame(request_handler){
    this->setContext(context_ptr);
    this->setUserLoaded(false);
    this->setInConversation(false);
}

void MainFrame::refreshContactsGUI(){
    PrivateUser* user = this->getPrivateUser();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::MODEL_NAME, QVariant::fromValue(user->getContactsGUI()));
}

void MainFrame::refreshContactGUI(QString username_gui){
    string username = username_gui.toStdString();
    QObject* contact = this->user->getContact(username);
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::VAR_NAME,contact);
}

void MainFrame::addContact(QString entered_username){
    QFuture<void> future = QtConcurrent::run(this,&MainFrame::addContactImpl,entered_username);
    QFuture<void> time_notifier = QtConcurrent::run(this,&MainFrame::notifyThreshold);
}

void MainFrame::addContactImpl(QString entered_username){
    this->changeNumberOfDelegateThreads(1);
    string username = entered_username.toStdString();
    string this_username = this->user->getUsername();
    bool result;
    string err_msg = "";
    Contact* possible_contact;
    bool is_already_a_contact;

    possible_contact = this->user->getContact(username);
    is_already_a_contact = (possible_contact!=nullptr);

    if(username==this_username){
        result = false;
        err_msg = "You cannot add yourself as a contact";
    }
    else if (is_already_a_contact){
        result = false;
        err_msg = username + " is already in your contact list";
    }
    else{
        PM_addContactReq add_req(this->user->getUsername(), username);
        ProtocolMessage* add_rep;

        add_rep = this->request_handler->recvResponseFor(&add_req);

        result = ((PM_addContactRep*)add_rep)->getResult();

        if(result==true){
            this->current_add_rep = add_rep;
            emit this->receivedRequestedContact();
        }
        else{
            err_msg = ((PM_addContactRep*)add_rep)->getErrMsg();
        }
    }

    this->changeNumberOfDelegateThreads(-1);

    if(result==false){
        emit finishedAddingContact(result, QString::fromStdString(err_msg));
    }
}

void MainFrame::addRequestedContact(QString entered_username){
    qDebug() << "aqui" << endl;
    ProtocolMessage* add_rep = this->current_add_rep;
    string username = entered_username.toStdString();
    string status_text = ((PM_addContactRep*)add_rep)->getStatus();
    string status_date = ((PM_addContactRep*)add_rep)->getStatusDate();
    string presence_text = ((PM_addContactRep*)add_rep)->getPresence();
    string presence_date = ((PM_addContactRep*)add_rep)->getPresenceDate();
    Avatar avatar = ((PM_addContactRep*)add_rep)->getAvatar(username);

    Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,avatar);

    this->user->addContact(new_contact);
    this->refreshContactsGUI();

    emit this->finishedAddingContact(true,"");
    qDebug() << "aqui" << endl;
}


void MainFrame::updateUserStatus(QString entered_status){
    string status_text = entered_status.toStdString();
    this->user->updateStatus(status_text);
    string username = this->user->getUsername();
    PM_updateStatus::StatusType update_type = PM_updateStatus::StatusType::status;
    PM_updateStatus update = PM_updateStatus(username, update_type, status_text);

    this->request_handler->sendTrap(&update);

    QString new_status_gui = entered_status;
    QString new_date_gui = QString::fromStdString(this->user->getStatus().getDate().toHumanReadable());

    emit statusChanged(new_status_gui, new_date_gui);
}

PrivateUser* MainFrame::getPrivateUser() const{
    return this->user;
}

void MainFrame::setPrivateUser(PrivateUser* user){
    this->user = user;
    string user_str = user->toString();

    this->refreshContactsGUI();

    // Add a 1 second delay to user's instantiation to make sure
    // that the networking thread reaches the waiting code on
    // the loading condition

    std::this_thread::sleep_for(std::chrono::seconds(1));

    this->setUserLoaded(true);
    this->notifyUserLoaded();

    //on logout, set it again to false
}

void MainFrame::setContext(QQmlContext** context_ptr){
    this->context_ptr = context_ptr;
}

void MainFrame::logOutUser(){
    QFuture<void> future = QtConcurrent::run(this,&MainFrame::logOutUserImpl);
    QFuture<void> time_notifier = QtConcurrent::run(this,&MainFrame::notifyThreshold);
}

void MainFrame::logOutUserImpl(){
    bool is_loaded = this->userIsLoaded();

    if(is_loaded){
        PM_logOutReq log_out_req = PM_logOutReq();
        ProtocolMessage* log_out_rep;

        log_out_rep = this->request_handler->recvResponseFor(&log_out_req);

        delete log_out_rep;

        IOManager::saveUser(user);

        this->setUserLoaded(false);
        delete user;
        this->user = nullptr;
    }
    emit this->logOut();
}

QString MainFrame::getCurrentUsername(){
    QString username_gui = QString::fromStdString(this->user->getUsername());
    return username_gui;
}

QString MainFrame::getCurrentStatus(){
    QString status_gui = QString::fromStdString(this->user->getStatus().getText());
    return status_gui;
}

QString MainFrame::getCurrentStatusDate(){
    QString status_date_gui = QString::fromStdString(this->user->getStatus().getDate().toHumanReadable());
    return status_date_gui;
}

bool MainFrame::userIsLoaded(){
    return this->user_is_loaded;
}

void MainFrame::setUserLoaded(bool is_loaded){
    this->user_is_loaded = is_loaded;
}

void MainFrame::notifyUserLoaded(){
    this->USER_LOADED.notify_all();
}

QWaitCondition* MainFrame::getUserLoadedCondition(){
    QWaitCondition* USER_LOADED_CONDITION = &(this->USER_LOADED);

    return USER_LOADED_CONDITION;
}

void MainFrame::loadConversationWith(QString contact_name){
    this->setInConversation(true);
    this->user->setConversationWith(contact_name.toStdString());
    this->refreshMessagesGUI();
}

void MainFrame::finishCurrentConversation(){
    this->setInConversation(false);
    this->user->finishCurrentConversation();
}

void MainFrame::refreshMessagesGUI(){
    QList<QObject*>& messages_gui = this->user->getConversationMessagesGUI();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Message::MODEL_NAME,QVariant::fromValue(messages_gui));
}

void MainFrame::handleMessage(string sender, string recipient, string date_str, string text){
    bool in_conversation = this->getInConversation();

    this->user->addMessage(sender,recipient,date_str,text);

    if(in_conversation){
        emit receivedMessageForCurrentConversation();
    }
    emit receivedNewMessage();
}

void MainFrame::sendMessage(QString conversation_recipient, QString entered_text){
    string recipient = conversation_recipient.toStdString();
    string sender = this->user->getUsername();
    string text = entered_text.toStdString();
    PM_msg msg(sender,recipient,text);
    string date_str = msg.getDate();

    this->request_handler->sendTrap(&msg);

    this->user->addMessage(sender,recipient,date_str,text);

    this->refreshMessagesGUI();
    this->refreshContactsGUI();
}

void MainFrame::setInConversation(bool in_conversation){
    this->in_conversation = in_conversation;
}

bool MainFrame::getInConversation(){
    return in_conversation;
}

void MainFrame::handleNewContact(PM_addContactCom* add_com){
    QMutex handle_finished_mtx;
    handle_finished_mtx.lock();
    this->current_add_com = new PM_addContactCom(*add_com);
    emit receivedForeignContact();
    this->FINISHED_ADDING_FOREIGN.wait(&handle_finished_mtx);
    handle_finished_mtx.unlock();
}

void MainFrame::addForeignContact(){
    string username = current_add_com->getContact();
    string status_text = current_add_com->getStatus();
    string status_date = current_add_com->getStatusDate();
    string presence_text = current_add_com->getPresence();
    string presence_date = current_add_com->getPresenceDate();
    Avatar avatar = current_add_com->getAvatar();

    Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,avatar);

    this->user->addContact(new_contact);

    refreshContactsGUI();

    delete current_add_com;
    current_add_com = nullptr;
    this->FINISHED_ADDING_FOREIGN.notify_all();
}

QString MainFrame::getCurrentImagePath(){
    string image_path = IOManager::FILE_HEADER + (this->user->getAvatar()).getImagePath();
    QString image_path_gui = QString::fromStdString(image_path);
    return image_path_gui;
}

void sendImage(RequestHandler* request_handler, PM_updateStatus* update_avatar){
    request_handler->sendTrap(update_avatar);
}

void MainFrame::updateImagePath(QString entered_image_path){
    string new_image_path = entered_image_path.toStdString();
    Avatar new_avatar(new_image_path);
    this->user->setAvatar(new_avatar);
    string username = this->user->getUsername();
    PM_updateStatus update_avatar(username,new_avatar);

    emit avatarChanged();
}

void MainFrame::sendAvatar(){
    QFuture<void> future = QtConcurrent::run(this,&MainFrame::sendAvatarImpl);
    QFuture<void> time_notifier = QtConcurrent::run(this,&MainFrame::notifyThreshold);
}

void MainFrame::sendAvatarImpl(){
    this->changeNumberOfDelegateThreads(1);
    Avatar new_avatar = this->getPrivateUser()->getAvatar();
    string username = this->getPrivateUser()->getUsername();
    PM_updateStatus update_avatar(username,new_avatar);

    this->getRequestHandler()->sendTrap(&update_avatar);
    this->changeNumberOfDelegateThreads(-1);

    emit this->finishedUploadingImage();
}

#include <QPixmap>
#include <QImage>
#include "src/user_management/avatar.h"
#include <QFile>
#include <QMatrix>

void MainFrame::openImagePicker(){
    QMutex wait_mutex;
    wait_mutex.lock();
    imagePickerAndroid* image_picker = new imagePickerAndroid();

    image_picker->buscaImagem();

    qDebug() << "***********************Waiting..." << endl;
    image_picker->IMAGE_PICKED.wait(&wait_mutex);
    qDebug() << "**********************Finished waiting..." << endl;

    wait_mutex.unlock();
    QString new_image_path = (image_picker->image_path).replace("\"","");

    qDebug() << ("***CAMINO FINAL*** :" + new_image_path) << endl;

    if(new_image_path!=""){
        string orig_image_path = new_image_path.toStdString();
        string format = Avatar::getImageFormat(orig_image_path);
        string image_path = IOManager::getImagePath("tmp",format);

        QImage image(QString::fromStdString(orig_image_path));
        QPixmap pixmap;
        pixmap = pixmap.fromImage(image);
        QFile file(QString::fromStdString(image_path));
        file.open(QIODevice::WriteOnly);

        pixmap.save(&file,format.c_str(),100);

        file.close();

        emit this->avatarChanging(QString::fromStdString(IOManager::FILE_HEADER + image_path));
    }
}

void MainFrame::saveRetouchedImage(QString source, int x, int y, int width, int height, int angle){
    QImage source_image(source.replace(QString::fromStdString(IOManager::FILE_HEADER),""));
    QImage retouched_image = source_image.copy(x,y,width,height);
    string format = Avatar::getImageFormat(source.toStdString());
    string image_path = IOManager::getImagePath("this",format);
    QPixmap pixmap;
    QMatrix homography;
    QFile file(QString::fromStdString(image_path));

    homography.rotate(angle);
    pixmap = pixmap.fromImage(retouched_image).transformed(homography);;

    qDebug() << angle << endl;

    file.open(QIODevice::WriteOnly);
    pixmap.save(&file,format.c_str(),70);

    file.close();

    this->updateImagePath(QString::fromStdString(image_path));
}

void MainFrame::notifyThreshold(){
    std::this_thread::sleep_for(std::chrono::seconds(MainFrame::WAIT_THRESHOLD_SEC));
    int n_delegate_threads = this->getNumberOfDelegateThreads();

    if(n_delegate_threads>0){
        emit this->waitingForTooLong();
    }
}

int MainFrame::getNumberOfDelegateThreads(){
    int n_delegate_threads;

    this->delegate_thread_mtx.lock();
        n_delegate_threads = this->n_delegate_threads;
    this->delegate_thread_mtx.unlock();

    return n_delegate_threads;
}

void MainFrame::changeNumberOfDelegateThreads(int delta){
    this->delegate_thread_mtx.lock();
        this->n_delegate_threads += delta;
    this->delegate_thread_mtx.unlock();
}

#define FLAG_LAYOUT_IN_SCREEN                   0x00000100
#define FLAG_LAYOUT_NO_LIMITS                   0x00000200
#define FLAG_TRANSLUCENT_NAVIGATION             0x08000000
#define FLAG_TRASLUCENT_STATUS                  0x04000000
#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS       0x80000000
#define FLAG_FORCE_NOT_FULLSCREEN               0x00000800

#define R_ID_CONTENT                            0x01020002
#define KEYCODE_BACK                            0x00000004

#define TRANSPARENT_COLOR                       0x00000000
#define SOFT_INPUT_ADJUST_PAN                   0x00000020

#define ALL_ONE_BINARY                          0xFFFFFFFF
#define ALL_ZERO_BINARY                         0x00000000

void MainFrame::changeStatusbarColor(int color){

    QtAndroid::runOnAndroidThreadSync([=](){
        QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
        bool statusbar_transparent = this->statusbar_transparent;
        bool enable_transparency = (color==TRANSPARENT_COLOR);

        if(statusbar_transparent&&(!enable_transparency)){
            //window.callMethod<void>("clearFlags", "(I)V", FLAG_LAYOUT_IN_SCREEN);
            window.callMethod<void>("clearFlags", "(I)V", FLAG_LAYOUT_NO_LIMITS);
            qDebug() << "Se elimina la transparencia" << endl;
        }

        window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.callMethod<void>("clearFlags", "(I)V", FLAG_TRASLUCENT_STATUS);
        window.callMethod<void>("setStatusBarColor", "(I)V", color);

        if(enable_transparency){
            if(!statusbar_transparent){
                //window.callMethod<void>("addFlags", "(I)V", FLAG_LAYOUT_IN_SCREEN);
                window.callMethod<void>("addFlags", "(I)V", FLAG_LAYOUT_NO_LIMITS);
                this->statusbar_transparent = true;
                qDebug() << "Se aniade la transparencia" << endl;
                //window.callMethod<void>("setSoftInputMode", "(I)V", SOFT_INPUT_ADJUST_PAN);
            }
        }
        else{
            this->statusbar_transparent = false;
        }
    });
}

#include <QGradient>
#include <QPainter>

void MainFrame::initScreenResources(){
    QtAndroid::runOnAndroidThreadSync([=](){
        int app_height;
        int app_width;
        float density;
        int navigationbar_existence_id;
        bool navigationbar_present;
        bool has_navigationbar;
        int navigationbar_id;
        int navigationbar_height;
        int statusbar_id;
        int statusbar_height;
        QAndroidJniObject activity = QtAndroid::androidActivity();
        QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        QAndroidJniObject decor_view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        QAndroidJniObject view = activity.callObjectMethod("findViewById", "(I)Landroid/view/View;", R_ID_CONTENT);
        QAndroidJniObject context = view.callObjectMethod("getContext", "()Landroid/content/Context;");
        QAndroidJniObject resources = context.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
        QAndroidJniObject display_metrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");

        int kbdh = QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                            "measure",
                                                            "(Landroid/view/View;Landroid/view/View;Landroid/content/Context;)I",
                                                            view.object<jclass>(),
                                                            decor_view.object<jclass>(),
                                                            context.object<jclass>());

        //1. Get app dimensions

        app_height =
             QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                       "getAppHeight",
                                                       "(Landroid/view/View;)I",
                                                       decor_view.object<jclass>());
        app_width =
             QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                       "getAppWidth",
                                                       "(Landroid/view/View;)I",
                                                       decor_view.object<jclass>());

        density =
                display_metrics.getField<jfloat>("density");



        qDebug() << density << endl;
        //2. Get navigationbar height

        navigationbar_existence_id =
                resources.callMethod<jint>("getIdentifier",
                                            "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                                            QAndroidJniObject::fromString("config_showNavigationBar").object<jstring>(),
                                            QAndroidJniObject::fromString("bool").object<jstring>(),
                                            QAndroidJniObject::fromString("android").object<jstring>()
                                           );

        if(navigationbar_existence_id>0){
            navigationbar_present =
                    resources.callMethod<jboolean>("getBoolean",
                                                   "(I)Z",
                                                   navigationbar_existence_id);
        }
        else{
            navigationbar_present = false;
        }

        has_navigationbar = (navigationbar_existence_id>0)&&(navigationbar_present);

        if(has_navigationbar){
            navigationbar_id =
                    resources.callMethod<jint>("getIdentifier",
                                                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                                                QAndroidJniObject::fromString("navigation_bar_height").object<jstring>(),
                                                QAndroidJniObject::fromString("dimen").object<jstring>(),
                                                QAndroidJniObject::fromString("android").object<jstring>()
                                               );
            if(navigationbar_id>0){
                navigationbar_height =
                        resources.callMethod<jint>("getDimensionPixelSize",
                                                   "(I)I",
                                                   navigationbar_id);
            }
            else{
                navigationbar_height = 0;
            }
        }
        else{
            navigationbar_height = 0;
        }

        //3. Get statusbar height

        statusbar_id =
                resources.callMethod<jint>("getIdentifier",
                                            "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                                            QAndroidJniObject::fromString("status_bar_height").object<jstring>(),
                                            QAndroidJniObject::fromString("dimen").object<jstring>(),
                                            QAndroidJniObject::fromString("android").object<jstring>()
                                           );

        if(statusbar_id>0){
            statusbar_height =
                    resources.callMethod<jint>("getDimensionPixelSize",
                                               "(I)I",
                                               statusbar_id);
        }
        else{
            statusbar_height = 0;
        }

        //4. set all the values
        this->setAppHeight(app_height);
        this->setAppWidth(app_width);
        this->setDensity(density);
        this->setStatusbarHeight(statusbar_height);
        this->setNavigationbarHeight(navigationbar_height);
        this->setVKeyboardHeight(-1);

        qDebug() << "******************* HEIGHT : " << app_height << endl;
        qDebug() << "******************* STATBAR : " << statusbar_height << endl;
        qDebug() << "******************* NAVBAR : " << navigationbar_height << endl;
    });

    int kbdh2 = QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                     "get",
                                                     "()I");

    kbdh2 = (this->getAppHeight()-kbdh2);

    qDebug() << "******************* KBD : " << kbdh2 << endl;
}

void MainFrame::measureVKeyboardHeight(){
    /**
    QtAndroid::runOnAndroidThread([=](){
        int vkeyboard_height;
        int visible_height;
        QAndroidJniObject activity = QtAndroid::androidActivity();
        QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        QAndroidJniObject decor_view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        QAndroidJniObject view = activity.callObjectMethod("findViewById", "(I)Landroid/view/View;", R_ID_CONTENT);
        QAndroidJniObject context = view.callObjectMethod("getContext", "()Landroid/content/Context;");

        visible_height =
                QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "getKeyboardHeight",
                                                  "(Landroid/view/View;Landroid/content/Context;)I",
                                                  decor_view.object<jclass>(),
                                                  context.object<jclass>());

        vkeyboard_height = (this->app_height - visible_height);

        this->setVKeyboardHeight(vkeyboard_height);
        emit vkeyboardHeightChanged(this->getVKeyboardHeight());
    });
    **/
}

void MainFrame::setStatusbarHeight(int statusbar_height){
    this->statusbar_height = (statusbar_height);
}

void MainFrame::setNavigationbarHeight(int navigationbar_height){
    this->navigationbar_height = (navigationbar_height);
}

void MainFrame::setAppHeight(int app_height){
    this->app_height = (app_height);
}

void MainFrame::setAppWidth(int app_width){
    this->app_width = (app_width);
}

void MainFrame::setDensity(float density){
    this->density = (density);
}

void MainFrame::setVKeyboardHeight(int vkeyboard_height){
    this->vkeyboard_height = (vkeyboard_height);
}

int MainFrame::getStatusbarHeight(){
    return this->statusbar_height;
}

int MainFrame::getNavigationbarHeight(){
    return this->navigationbar_height;
}

int MainFrame::getAppHeight(){
    return this->app_height;
}

int MainFrame::getAppWidth(){
    return this->app_width;
}

float MainFrame::getDensity(){
    return this->density;
}

int MainFrame::getVKeyboardHeight(){
    this->android_sync_mtx.lock();
    int sync_keyboard_height = this->vkeyboard_height;
    this->android_sync_mtx.unlock();

    return sync_keyboard_height;
}

void MainFrame::setAndroidThreadBusy(int android_thread_busy){
    this->android_sync_mtx.lock();
    this->android_thread_busy = android_thread_busy;
    this->android_sync_mtx.unlock();
}

int MainFrame::getAndroidThreadBusy(){
    this->android_sync_mtx.lock();
    int android_thread_busy = this->android_thread_busy;
    this->android_sync_mtx.unlock();
    return android_thread_busy;
}

































