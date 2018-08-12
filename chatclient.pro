
TEMPLATE = app

TARGET = chatclient

DEFINES += QT_DEPRECATED_WARNINGS

android{
	QT += androidextras
}else{
	windows{
		LIBS += -lws2_32
		LIBS += -LC:/OpenSSL-Win32/lib -llibcrypto
		INCLUDEPATH += C:\OpenSSL-Win32\include
	}
	unix{
		LIBS += -L/usr/bin/openssl/lib -libcrypto
		INCLUDEPATH += /usr/include
	}
}

CONFIG += c++11

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
	 src/frame_management/mainframe.h \
    src/protocol_messages/encoding/base64.h \
    src/user_management/stda.h \
    src/encryption_engines/publicengine.h \
    src/encryption_engines/symmetricengine.h \
    src/encryption_engines/encryption/aes.h \
    src/encryption_engines/encryption/aes.hpp \
    src/user_management/latchword.h \
    src/user_management/signedtext.h

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
	 src/frame_management/mainframe.cpp \
    src/protocol_messages/encoding/base64.cpp \
    src/user_management/stda.cpp \
    src/encryption_engines/publicengine.cpp \
    src/encryption_engines/symmetricengine.cpp \
    src/encryption_engines/encryption/aes.cpp \
    src/user_management/latchword.cpp \
    src/user_management/signedtext.cpp

RESOURCES += qml/qml.qrc \
    qml/image_resources.qrc


QT += widgets \
        quick
android{
	HEADERS += \
		src/frame_management/image_picker/caminhoimagens.h \
		src/frame_management/image_picker/imagepickerandroid.h

	SOURCES += \
		src/frame_management/image_picker/caminhoimagens.cpp \
		src/frame_management/image_picker/imagepickerandroid.cpp

	DISTFILES += \
		 android/AndroidManifest.xml \
		 android/gradle/wrapper/gradle-wrapper.jar \
		 android/gradlew \
		 android/res/values/libs.xml \
		 android/build.gradle \
		 android/gradle/wrapper/gradle-wrapper.properties \
		 android/gradlew.bat \
		 android/AndroidManifest.xml \
		 android/gradle/wrapper/gradle-wrapper.jar \
		 android/gradlew \
		 android/res/values/libs.xml \
		 android/build.gradle \
		 android/gradle/wrapper/gradle-wrapper.properties \
		 android/gradlew.bat \
		 src/frame_management/ImageChooser.java \
		 android/AndroidManifest.xml \
		 android/res/values/libs.xml \
		 android/build.gradle \
		 android/AndroidManifest.xml \
		 android/AndroidManifest.xml \
		 android/gradle/wrapper/gradle-wrapper.jar \
		 android/gradlew \
		 android/res/values/libs.xml \
		 android/build.gradle \
		 android/gradle/wrapper/gradle-wrapper.properties \
		 android/gradlew.bat \
		 android/AndroidManifest.xml \
		 android/gradle/wrapper/gradle-wrapper.jar \
		 android/gradlew \
		 android/res/values/libs.xml \
		 android/build.gradle \
		 android/gradle/wrapper/gradle-wrapper.properties \
		 android/gradlew.bat \
		 android/src/org/qtproject/example/EncrypTalkBeta3/Utils.java \
		 android/src/org/qtproject/example/EncrypTalkBeta3/AndroidEncryptionUtils.java

	ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

	contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
		 ANDROID_EXTRA_LIBS =
	}
}


