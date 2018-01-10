
TEMPLATE = app

TARGET = chatclient

LIBS += -lws2_32

DEFINES += QT_DEPRECATED_WARNINGS

HEADERS += \
	 src/protocol_messages/PM_addContactCom.h \
	 src/protocol_messages/PM_addContactRep.h \
	 src/protocol_messages/PM_addContactReq.h \
	 src/protocol_messages/PM_blockContact.h \
	 src/protocol_messages/PM_changeSatus.h \
	 src/protocol_messages/PM_delContact.h \
	 src/protocol_messages/PM_logOutCom.h \
	 src/protocol_messages/PM_logOutRep.h \
	 src/protocol_messages/PM_logOutReq.h \
	 src/protocol_messages/PM_logRep.h \
	 src/protocol_messages/PM_logReq.h \
	 src/protocol_messages/PM_msg.h \
	 src/protocol_messages/PM_regRep.h \
	 src/protocol_messages/PM_regReq.h \
	 src/protocol_messages/PM_undefined.h \
	 src/protocol_messages/PM_updateStatus.h \
	 src/protocol_messages/ProtocolMessage.h \
	 src/user_management/date.h \
	 src/user_management/status.h \
	 src/user_management/user.h \
	 src/user_management/avatar.h \
	 src/user_management/presence.h \
	 src/user_management/contact.h \
	 src/user_management/message.h \
	 src/user_management/privateuser.h \
	 src/frame_management/registerframe.h \
	 src/frame_management/logframe.h \
	 src/frame_management/requestingframe.h \
	 src/connection_management/connection.h \
	 src/connection_management/requesthandler.h \
	 src/connection_management/servermessage.h \
	 src/connection_management/connection.h \
	 src/user_management/iomanager.h \
	 src/frame_management/personalprofileframe.h \
	 src/frame_management/contactprofileframe.h \
	 src/frame_management/conversationframe.h \
	 src/protocol_messages/encryption/rsa.h \
	 src/frame_management/mainframe.h

SOURCES += \
			  src/main.cpp \
	 src/protocol_messages/PM_addContactCom.cpp \
	 src/protocol_messages/PM_addContactRep.cpp \
	 src/protocol_messages/PM_addContactReq.cpp \
	 src/protocol_messages/PM_blockContact.cpp \
	 src/protocol_messages/PM_changeSatus.cpp \
	 src/protocol_messages/PM_delContact.cpp \
	 src/protocol_messages/PM_logOutCom.cpp \
	 src/protocol_messages/PM_logOutRep.cpp \
	 src/protocol_messages/PM_logOutReq.cpp \
	 src/protocol_messages/PM_logRep.cpp \
	 src/protocol_messages/PM_logReq.cpp \
	 src/protocol_messages/PM_msg.cpp \
	 src/protocol_messages/PM_regRep.cpp \
	 src/protocol_messages/PM_regReq.cpp \
	 src/protocol_messages/PM_undefined.cpp \
	 src/protocol_messages/PM_updateStatus.cpp \
	 src/protocol_messages/ProtocolMessage.cpp \
	 src/user_management/date.cpp \
	 src/user_management/status.cpp \
	 src/user_management/user.cpp \
	 src/user_management/avatar.cpp \
	 src/user_management/presence.cpp \
	 src/user_management/contact.cpp \
	 src/user_management/message.cpp \
	 src/user_management/privateuser.cpp \
	 src/frame_management/registerframe.cpp \
	 src/frame_management/logframe.cpp \
	 src/frame_management/requestingframe.cpp \
	 src/connection_management/connection.cpp \
	 src/connection_management/requesthandler.cpp \
	 src/connection_management/servermessage.cpp \
	 src/user_management/iomanager.cpp \
	 src/frame_management/personalprofileframe.cpp \
	 src/frame_management/contactprofileframe.cpp \
	 src/frame_management/conversationframe.cpp \
	 src/protocol_messages/encryption/rsa.cpp \
	 src/frame_management/mainframe.cpp

RESOURCES += qml.qrc \
	 icons/default.png \
	 icons/whitesendicon.png \
	 icons/whiteprofileicon.png \
	 icons/whitebackicon.png \
	 icons/whitechangestatusicon.png \
	 icons/whiteplusicon.png \
	 icons/whitechaticon.png \
	 icons/whitegroupicon.png \
	 icons/whiteforbiddenicon.png \
	 icons/whitetrashicon.png \


QT += widgets \
        quick

CONFIG += c++11





