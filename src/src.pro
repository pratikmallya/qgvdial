# For the beta version of the SDK, this part will identify Meego/Harmattan
exists($$QMAKE_INCDIR_QT"/../qmsystem2/qmkeys.h"):!contains(MEEGO_EDITION,harmattan): {
  MEEGO_VERSION_MAJOR     = 1
  MEEGO_VERSION_MINOR     = 2
  MEEGO_VERSION_PATCH     = 0
  MEEGO_EDITION           = harmattan
}

contains(MEEGO_EDITION,harmattan) {
  message(Meego!)
  DEFINES += MEEGO_HARMATTAN
}

DEFINES += NO_CONTACTS_CAPTCHA

# For verbose debugging
#DEFINES += DBG_TP_VERBOSE
#DEFINES += DBG_VERBOSE

QT      *= core gui sql xml xmlpatterns script declarative phonon
TARGET   = qgvdial
TEMPLATE = app

!win32 {
# Win32 stores all intermidiate files into the debug and release folders.
# There's no need to create a separate moc and obj folder for Win32.
MOC_DIR = moc
OBJECTS_DIR = obj
}

CONFIG *= precompile_header
PRECOMPILED_HEADER = ../src/global.h

CONFIG   *= mobility
MOBILITY *= systeminfo

symbian|contains(MEEGO_EDITION,harmattan) {
    MOBILITY *= feedback
    OTHER_FILES += ../build-files/qgvdial/harmattan/qgvdial.desktop
    CONFIG += qt-components
}

include(qtsingleapplication/qtsingleapplication.pri)

win32 {
CONFIG *= embed_manifest_exe
}

maemo5 {
    message(Maemo5 your world)
    QT *= maemo5
    OTHER_FILES += ../build-files/qgvdial/maemo/qgvdial.desktop
}

# In Linux and maemo, add telepathy and openssl
unix:!symbian: {
    QT *= dbus

maemo5 {
    message(Maemo or Meego TP)
    INCLUDEPATH += $$QMAKESPEC/usr/include/telepathy-1.0/
    DEFINES += TP10
} else {
    exists($$QMAKESPEC/usr/include/telepathy-qt4/TelepathyQt/Constants) {
        message(Brand new TP)
        INCLUDEPATH += $$QMAKESPEC/usr/include/telepathy-qt4/
    } else {
        message(Old TP)
        INCLUDEPATH += $$QMAKESPEC/usr/include/telepathy-1.0/
        DEFINES += TP10
    }
}
    LIBS += -ltelepathy-qt4 -lssl -lcrypto
}

# In Windows, add openssl
win32 {
    LIBS *= -llibeay32
}

SOURCES  += ../src/main.cpp                 \
            ../src/MainApp.cpp              \
            ../src/MainWindow.cpp           \
            ../src/MainWinLogs.cpp          \
            ../src/MainWinCallText.cpp      \
            ../src/MainWinVmail.cpp         \
            ../src/MainWinLogin.cpp         \
            ../src/Singletons.cpp           \
            ../src/CacheDatabase.cpp        \
            ../src/OsDependent.cpp          \
            ../src/SkypeClientFactory.cpp   \
            ../src/SkypeClient.cpp          \
            ../src/ObserverFactory.cpp      \
            ../src/CalloutInitiator.cpp     \
            ../src/CallInitiatorFactory.cpp \
            ../src/InboxModel.cpp           \
            ../src/GvXMLParser.cpp          \
            ../src/PhoneNumberValidator.cpp \
            ../src/GVContactsTable.cpp      \
            ../src/ContactsXmlHandler.cpp   \
            ../src/SMSEntryDeleteButton.cpp \
            ../src/ChildWindowBase.cpp      \
            ../src/GVInbox.cpp              \
            ../src/RegNumberModel.cpp       \
            ../src/ContactsModel.cpp        \
            ../src/ContactDetailsModel.cpp  \
            ../src/DialContext.cpp          \
            ../src/ContactsParserObject.cpp \
            ../src/CookieJar.cpp            \
            ../src/NwReqTracker.cpp         \
            ../src/AsyncTaskToken.cpp       \
            ../src/GVApi.cpp                \
            ../src/MyXmlErrorHandler.cpp

HEADERS  += ../src/global.h                 \
            ../src/TpHeaders.h              \
            ../src/IObserver.h              \
            ../src/MainApp.h                \
            ../src/MainWindow.h             \
            ../src/Singletons.h             \
            ../src/CacheDatabase.h          \
            ../src/CacheDatabase_int.h      \
            ../src/OsDependent.h            \
            ../src/SkypeClientFactory.h     \
            ../src/SkypeClient.h            \
            ../src/ObserverFactory.h        \
            ../src/CalloutInitiator.h       \
            ../src/CallInitiatorFactory.h   \
            ../src/InboxModel.h             \
            ../src/GvXMLParser.h            \
            ../src/PhoneNumberValidator.h   \
            ../src/GVContactsTable.h        \
            ../src/ContactsXmlHandler.h     \
            ../src/SMSEntryDeleteButton.h   \
            ../src/ChildWindowBase.h        \
            ../src/GVInbox.h                \
            ../src/RegNumberModel.h         \
            ../src/ContactsModel.h          \
            ../src/ContactDetailsModel.h    \
            ../src/DialContext.h            \
            ../src/ContactsParserObject.h   \
            ../src/CookieJar.h              \
            ../src/NwReqTracker.h           \
            ../src/AsyncTaskToken.h         \
            ../src/GVApi.h                  \
            ../src/MyXmlErrorHandler.h

!contains (DEFINES, NO_CONTACTS_CAPTCHA) {
QT *= webkit
SOURCES +=  ../src/CaptchaWidget.cpp
HEADERS +=  ../src/CaptchaWidget.h
}

RESOURCES += ../src/qgvdial.qrc

# This is so that QtCreator can show these files in the files list.
OTHER_FILES  += ../src/winrsrc.rc           \
                ../qml/About.qml            \
                ../qml/ActionButtons.qml    \
                ../qml/ContactDetails.qml   \
                ../qml/ContactsList.qml     \
                ../qml/DialSettings.qml     \
                ../qml/DigitButton.qml      \
                ../qml/ExpandView.qml       \
                ../qml/Fader.qml            \
                ../qml/helper.js            \
                ../qml/HMain.qml            \
                ../qml/InboxList.qml        \
                ../qml/Keypad.qml           \
                ../qml/ListRefreshComponent.qml \
                ../qml/LoginDetails.qml     \
                ../qml/LogView.qml          \
                ../qml/Main.qml             \
                ../qml/MainView.qml         \
                ../qml/Mosquitto.qml        \
                ../qml/MeegoButton.qml      \
                ../qml/MsgBox.qml           \
                ../qml/MyButton.qml         \
                ../qml/MyTextEdit.qml       \
                ../qml/PinSetting.qml       \
                ../qml/Proxy.qml            \
                ../qml/RadioButton.qml      \
                ../qml/S3Main.qml           \
                ../qml/SaveCancel.qml       \
                ../qml/Scrollbar.qml        \
                ../qml/Settings.qml         \
                ../qml/SmsView.qml          \
                ../qml/Tab.qml              \
                ../qml/TabbedUI.qml         \
                readme.txt

# In Linux and maemo, add the telepathy related sources and headers.
unix:!symbian {
    HEADERS  += ../src/TpObserver.h            \
                ../src/TpCalloutInitiator.h    \
                ../src/QGVDbusServer.h
    SOURCES  += ../src/TpObserver.cpp          \
                ../src/TpCalloutInitiator.cpp  \
                ../src/QGVDbusServer.cpp
}

# In desktop Linux, add the Skype client
unix:!symbian:!maemo5 {
    HEADERS  += ../src/SkypeLinuxClient.h              \
                ../src/SkypeObserver.h                 \
                ../src/DesktopSkypeCallInitiator.h
    SOURCES  += ../src/SkypeLinuxClient.cpp            \
                ../src/SkypeObserver.cpp               \
                ../src/DesktopSkypeCallInitiator.cpp
}

win32 {
# Resource file is for windows only - for the icon
    RC_FILE = ../src/winrsrc.rc

# In desktop Windows, add the Skype client.
    HEADERS += ../src/SkypeWinClient.h             \
               ../src/SkypeObserver.h              \
               ../src/DesktopSkypeCallInitiator.h
    SOURCES += ../src/SkypeWinClient.cpp           \
               ../src/SkypeObserver.cpp            \
               ../src/DesktopSkypeCallInitiator.cpp
}

############################## Mosquitto ##############################
# Add mosquitto support sources to EVERYONE.
    HEADERS  += ../src/MqClientThread.h
    SOURCES  += ../src/MqClientThread.cpp

exists(../src/mqlib-build) {
    message(Forcible inclusion of mqlib!)
    include(../src/mqlib/mqlib.pri)
} else {
    message(Forcible exclusion of mqlib!)
    LIBS += -lmosquitto
}
#######################################################################

symbian {
    HEADERS  += ../src/SymbianCallInitiator.h          \
                ../src/SymbianCallInitiatorPrivate.h   \
                ../src/SymbianCallObserverPrivate.h    \
                ../src/SymbianDTMFPrivate.h
    SOURCES  += ../src/SymbianCallInitiator.cpp        \
                ../src/SymbianCallInitiatorPrivate.cpp \
                ../src/SymbianCallObserverPrivate.cpp  \
                ../src/SymbianDTMFPrivate.cpp

# The Symbian telephony stack library and the equivalent of openssl
    LIBS += -letel3rdparty -llibcrypto

    TARGET.UID3 = 0x2003B499
    TARGET.CAPABILITY += NetworkServices ReadUserData ReadDeviceData WriteDeviceData SwEvent
    TARGET.EPOCSTACKSIZE = 0x14000          # 80 KB stack size
    TARGET.EPOCHEAPSIZE = 0x020000 0x2000000 # 128 KB - 20 MB

# the icon for our sis file
    ICON=../icons/qgv.svg
# This hack is required until the next version of QT SDK
    QT_CONFIG -= opengl

    vendorinfo = "%{\"Yuvraaj Kelkar\"}" \
                 ":\"Yuvraaj Kelkar\""

    my_deployment.pkg_prerules = vendorinfo
    DEPLOYMENT += my_deployment
}

###############################################################
# Installation related line go here
###############################################################

# Installation for Maemo and Harmattan
maemo5 {
    message(maemo5 install)
    exists(../../buildit.sh) || exists(../../buildit.pl) || exists(.svn) {
        PREFIX = ../debian/qgvdial/usr
        message(Built using my scripts... probably inside scratchbox)
    } else {
        PREFIX = ../maemo/debian/qgvdial/usr
        message(Build using qtcreator)
    }

    OPTPREFIX  = $$PREFIX/../opt
    DATADIR    = $$PREFIX/share
}

contains(MEEGO_EDITION,harmattan) {
    message(Harmattan install)

    OPTPREFIX  = /opt
    DATADIR    = /usr/share
}

maemo5|contains(MEEGO_EDITION,harmattan) {
    INSTALLS += target desktop icon icon48 icon64 icon_scalable dbusservice

    target.path = $$OPTPREFIX/qgvdial/bin

    desktop.path  = $$DATADIR/applications/hildon
    desktop.files = ../build-files/qgvdial/maemo/qgvdial.desktop

    icon.path = $$DATADIR/qgvdial/icons
    icon.files += qgvdial.png

    icon48.path = $$DATADIR/icons/hicolor/48x48/hildon
    icon48.files = ../icons/48/qgvdial.png

    icon64.path = $$DATADIR/icons/hicolor/64x64/hildon
    icon64.files = ../icons/64/qgvdial.png

    icon_scalable.path = $$DATADIR/icons/hicolor/scalable/hildon
    icon_scalable.files = qgvdial.png

    dbusservice.path = $$DATADIR/dbus-1/services
    dbusservice.files = ../build-files/qgvdial/maemo/qgvdial.Call.service \
                        ../build-files/qgvdial/maemo/qgvdial.Text.service
}

# Harmattan specific install section
contains(MEEGO_EDITION,harmattan) {
    INSTALLS += icon80

    desktop.path  = $$DATADIR/applications
    desktop.files = ../build-files/qgvdial/harmattan/qgvdial.desktop

    icon48.path = $$DATADIR/icons/hicolor/48x48/apps

    icon64.path = $$DATADIR/icons/hicolor/64x64/apps

    icon80.path = $$DATADIR/icons/hicolor/80x80/apps
    icon80.files = ../icons/80/qgvdial.png

    icon_scalable.path = $$DATADIR/icons/hicolor/scalable/apps
    icon_scalable.files = qgvdial.png

    dbusservice.files = ../build-files/qgvdial/harmattan/qgvdial.Call.service \
                        ../build-files/qgvdial/harmattan/qgvdial.Text.service
}

# Installation for Linux
unix:!symbian:!maemo5:!contains(MEEGO_EDITION,harmattan) {
    DATADIR = /usr/share
    message(Regular Linux install)

    INSTALLS += target icon dbusservice

    target.path =/usr/bin/qgvdial

    icon.path = $$DATADIR/qgvdial/icons
    icon.files += qgvdial.png

    dbusservice.path = $$DATADIR/dbus-1/services
    dbusservice.files = ../build-files/qgvdial/ubuntu/qgvdial.Call.service \
                        ../build-files/qgvdial/ubuntu/qgvdial.Text.service
}

