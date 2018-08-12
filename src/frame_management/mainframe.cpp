#include "mainframe.h"

const int MainFrame::WAIT_THRESHOLD_SEC = 2;
MainFrame* MainFrame::instance = nullptr;

MainFrame::MainFrame(QQmlContext** context_ptr, RequestHandler* request_handler) :
RequestingFrame::RequestingFrame(request_handler){
    this->setContext(context_ptr);
    this->setUserLoaded(false);
    this->setInConversation(false);
    MainFrame::instance = this;
}

void MainFrame::refreshContactsGUI(){
    PrivateUser* user = this->getPrivateUser();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::MODEL_NAME, QVariant::fromValue(user->getContactsGUI()));
}

void MainFrame::refreshContactsGUI(QString filter_gui){
    string filter = filter_gui.toStdString();
    PrivateUser* user = this->getPrivateUser();
    QQmlContext* context = (*context_ptr);

    context->setContextProperty(Contact::MODEL_NAME, QVariant::fromValue(user->getContactsGUI(filter)));
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
        //dialog
    }
    else if (is_already_a_contact){
        result = false;
        err_msg = username + " is already in your contact list";
        //dialog
    }
    else{
        MainFrame::showProgressDialog("Adding contact");
        PM_addContactReq add_req(this->user->getUsername(), username);
        ProtocolMessage* add_rep;

        add_rep = this->request_handler->recvResponseFor(&add_req);

        result = ((PM_addContactRep*)add_rep)->getResult();

        MainFrame::dismissProgressDialog();
        if(result==true){
            this->current_add_rep = add_rep;
            emit this->receivedRequestedContact();
            //dialog
        }
        else{
            err_msg = ((PM_addContactRep*)add_rep)->getErrMsg();
            //dialog
        }
    }

    if(result==false){
        emit finishedAddingContact(result, QString::fromStdString(err_msg));
    }
}

void MainFrame::addRequestedContact(QString entered_username, QString entered_ptpkey){
    qDebug() << "aqui" << endl;
    ProtocolMessage* add_rep = this->current_add_rep;
    string username = entered_username.toStdString();
    string status_text = ((PM_addContactRep*)add_rep)->getStatus();
    string status_date = ((PM_addContactRep*)add_rep)->getStatusDate();
    string presence_text = ((PM_addContactRep*)add_rep)->getPresence();
    string presence_date = ((PM_addContactRep*)add_rep)->getPresenceDate();
    Avatar avatar = ((PM_addContactRep*)add_rep)->getAvatar(username);
    string ptpkey = entered_ptpkey.toStdString();

    Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,avatar,ptpkey);

    this->user->addContact(new_contact);
    this->refreshContactsGUI();

    emit this->finishedAddingContact(true,"");
}


void MainFrame::updateUserStatus(QString entered_status){
    string status_text = entered_status.toStdString();
    this->user->updateStatus(status_text);

    QString new_status_gui = entered_status;
    QString new_date_gui = QString::fromStdString(this->user->getStatus().getDate().toShortlyHumanReadable());

    emit statusChanged(new_status_gui, new_date_gui);

    string username = this->user->getUsername();
    PM_updateStatus::StatusType update_type = PM_updateStatus::StatusType::status;
    PM_updateStatus update = PM_updateStatus(username, update_type, status_text);

    this->updateUserStatusNet(update);
}

void MainFrame::updateUserStatusNet(PM_updateStatus update){
    this->changeNumberOfAsyncThreads(1);
    this->request_handler->sendTrap(&update);
    this->changeNumberOfAsyncThreads(-1);
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
    this->showProgressDialog("Logging out");
}

void MainFrame::logOutUserImpl(){
    bool is_loaded = this->userIsLoaded();
    qDebug() << "SERVER STARTS LOG OUT" << endl;

    if(is_loaded){
        int n_async_threads = this->getNumberOfAsyncThreads();
        QMutex mtx;

        qDebug() << n_async_threads << endl;

        while(n_async_threads>0){
            mtx.lock();
            this->ASYNC_CHANGED.wait(&mtx);
            mtx.unlock();

            n_async_threads = this->getNumberOfAsyncThreads();
        }

        PM_logOutReq log_out_req = PM_logOutReq();
        ProtocolMessage* log_out_rep;

        qDebug() << "SERVER SENDS LOG OUT REQ" << endl;
        log_out_rep = this->request_handler->recvResponseFor(&log_out_req);
        qDebug() << "SERVER RECEIVES LOG OUT REP" << endl;

        delete log_out_rep;

        IOManager::saveUser(user);

        this->setUserLoaded(false);
        delete user;
        this->user = nullptr;
    }
    emit this->logOut();
    this->dismissProgressDialog();
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
    QString status_date_gui = QString::fromStdString(this->user->getStatus().getDate().toShortlyHumanReadable());
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
    Contact* contact = this->user->getContact(recipient);
    Latchword* latchword = contact->getLatchword();
    string encrypted_text = latchword->encrypt(text);
    PM_msg msg(sender,recipient,encrypted_text);
    string date_str = msg.getDate();

    this->request_handler->sendTrap(&msg);

    this->user->addMessage(sender,recipient,date_str,encrypted_text);

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
    string ptpkey = "";

    Contact* new_contact = new Contact(username,status_text,status_date,presence_text,presence_date,avatar,ptpkey);

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

int MainFrame::getCurrentColor(){
    int color = this->user->getAvatar().getColor();
    return color;
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
    this->changeNumberOfAsyncThreads(1);
    QFuture<void> future = QtConcurrent::run(this,&MainFrame::sendAvatarImpl);
}

void MainFrame::sendAvatarImpl(){
    Avatar new_avatar = this->getPrivateUser()->getAvatar();
    string username = this->getPrivateUser()->getUsername();
    PM_updateStatus update_avatar(username,new_avatar);

    this->getRequestHandler()->sendTrap(&update_avatar);

    this->changeNumberOfAsyncThreads(-1);
}

void MainFrame::changeNumberOfAsyncThreads(int delta){
    this->async_mutex.lock();
        this->n_async_threads += delta;
    this->async_mutex.unlock();
    this->ASYNC_CHANGED.notify_all();

    qDebug() << "ASYNC THREADS : " << delta  << endl;
}

int MainFrame::getNumberOfAsyncThreads(){
    int n_async_threads;

    this->async_mutex.lock();
        n_async_threads = this->n_async_threads;
    this->async_mutex.unlock();

    return n_async_threads;
}


void MainFrame::openImagePicker(){
#ifdef ANDROID
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
        this->savePickedImage(new_image_path);
    }
#endif
}

void MainFrame::savePickedImage(QString new_image_path){
    string orig_image_path = new_image_path.toStdString();
#ifdef __WIN32
    if(orig_image_path.substr(0,1)=="/"){
        orig_image_path = orig_image_path.substr(1);
    }
#endif

    string format = Avatar::getImageFormat(orig_image_path);
    string image_path = IOManager::getImagePath("tmp",format);

    for(int i=0; i<image_path.length(); i++){
        if(image_path.substr(i,1)=="\\"){
            image_path.replace(i,1,"/");
        }
    }


    QImage image(QString::fromStdString(orig_image_path));
    QPixmap pixmap;
    pixmap = pixmap.fromImage(image);
    QFile file(QString::fromStdString(image_path));

    bool retval = file.open(QIODevice::WriteOnly);
    bool retval2 = pixmap.save(&file,format.c_str(),100);

    file.close();

    emit this->avatarChanging(QString::fromStdString(IOManager::FILE_HEADER + image_path));
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
#ifdef ANDROID
    QtAndroid::runOnAndroidThread([=](){
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
#endif
}

void MainFrame::changeStatusbarColor(int color, int delay){
    QtConcurrent::run([=](){
        std::this_thread::sleep_for(std::chrono::milliseconds(delay));
        this->changeStatusbarColor(color);
    });
}

void MainFrame::initScreenResources(){
#ifdef ANDROID
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

        //1. Get app dimensions

        QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "initOnGlobalLayoutListener",
                                                  "(Landroid/app/Activity;)V",
                                                  activity.object<jclass>());

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
        qDebug() << "******************* DENSITY : " << density << endl;
    });
#else

    QScreen* screen = QApplication::screens().at(0);
    float density = ((screen->logicalDotsPerInch())/160);

    qDebug() << "DENSITY : " << density << endl;

    this->setAppHeight(720);
    this->setAppWidth(401);
    this->setDensity(density);
    this->setStatusbarHeight(0);
    this->setNavigationbarHeight(0);
    this->setVKeyboardHeight(-1);
#endif
}

void MainFrame::measureVKeyboardHeight(int app_height){
#ifdef ANDROID
    QtAndroid::runOnAndroidThread([=](){
        int vkeyboard_height;
        QAndroidJniObject activity = QtAndroid::androidActivity();

        vkeyboard_height =
                QAndroidJniObject::callStaticMethod<jint>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "measureVKeyboardHeight",
                                                  "(ILandroid/app/Activity;)I",
                                                  app_height,
                                                  activity.object<jclass>());

        this->setVKeyboardHeight(vkeyboard_height);
        emit vkeyboardMeasured(vkeyboard_height);
    });
#else
    int vkeyboard_height = 0;
    this->setVKeyboardHeight(vkeyboard_height);
    emit vkeyboardMeasured(vkeyboard_height);
#endif
}


void MainFrame::showProgressDialog(std::string message){
    emit MainFrame::instance->openProgressDialog(QString::fromStdString(message));

    /***
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject view = activity.callObjectMethod("findViewById", "(I)Landroid/view/View;", R_ID_CONTENT);
    QAndroidJniObject context = view.callObjectMethod("getContext", "()Landroid/content/Context;");

    QtAndroid::runOnAndroidThreadSync([=](){
        QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "showProgressDialog",
                                                  "(Ljava/lang/String;Landroid/content/Context;)V",
                                                  QAndroidJniObject::fromString(message.c_str()).object<jstring>(),
                                                  context.object<jclass>());
    });
    ***/

}

void MainFrame::dismissProgressDialog(){
    emit MainFrame::instance->closeProgressDialog();


    /***
    QtAndroid::runOnAndroidThreadSync([=](){
        QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "dismissProgressDialog",
                                                  "()V");
    });
    ***/

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

void MainFrame::changePTPKeyOf(QString contact_name, QString ptpkey){
    Contact* contact = this->user->getContact(contact_name.toStdString());
    contact->updateLatchword(Latchword(ptpkey.toStdString()));
    emit contact->lastMessageChanged();

}

#ifdef ANDROID
#include <jni.h>
extern "C"{
#include "src/frame_management/mainframe.h"
JNIEXPORT void JNICALL
    Java_org_qtproject_example_EncrypTalkBeta3_MyJavaNatives_notifyVKeyboardClosed(JNIEnv*, jobject){

        qDebug() << "Called from Java" << endl;
        emit MainFrame::instance->vkeyboardClosed();
    }
}
#endif

void MainFrame::changeVKeyboardMode(bool pan){
#ifdef ANDROID
    QtAndroid::runOnAndroidThreadSync([=](){
        QAndroidJniObject activity = QtAndroid::androidActivity();

        QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/EncrypTalkBeta3/Utils",
                                                  "changeVKeyboardMode",
                                                  "(ZLandroid/app/Activity;)V",
                                                  pan,
                                                  activity.object<jclass>());
    });
#endif
}





























