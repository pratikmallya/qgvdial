TEMPLATE = app
TARGET   = qgvdial
QT      *= core gui webkit sql xml
INCLUDEPATH += .

CONFIG  += mobility
MOBILITY = multimedia bearer

win32 {
CONFIG *= embed_manifest_exe
}

maemo5 {
    message("Maemo5 your world")
    QT *= maemo5
    OTHER_FILES += qgvdial.desktop
}

# In Linux and maemo, add the telepathy libraries, sources and headers
unix:!symbian {
    QT *= dbus
    INCLUDEPATH += $$QMAKESPEC/usr/include/telepathy-1.0/
    LIBS += -ltelepathy-qt4
}

# Input
HEADERS +=  MainApp.h                   \
            MainWindow.h                \
            MyWebView.h                 \
            DialerWidget.h              \
            DigitButton.h               \
            MobileWebPage.h             \
            global.h                    \
            GVWebPage.h                 \
            DlgSelectContactNumber.h    \
            GVSettings.h                \
            GVContactsTable.h           \
            OsDependent.h               \
            GVHistory.h                 \
            SMSDlg.h                    \
            SMSEntryDeleteButton.h      \
            VoicemailWidget.h           \
            DialerValidator.h           \
            CacheDatabase.h             \
            ChildWindowBase.h           \
            UniqueAppHelper.h           \
            DialCancelDlg.h             \
            ObserverFactory.h           \
            IObserver.h                 \
            GVAccess.h                  \
            Singletons.h                \
            GVDataAccess.h              \
            SkypeClient.h               \
            SkypeClientFactory.h        \
            CalloutInitiator.h          \
            CallInitiatorFactory.h      \
            CaptchaWidget.h             \
            ContactsXmlHandler.h

SOURCES +=  main.cpp                    \
            MainApp.cpp                 \
            MainWindow.cpp              \
            MyWebView.cpp               \
            DialerWidget.cpp            \
            DigitButton.cpp             \
            MobileWebPage.cpp           \
            global.cpp                  \
            GVWebPage.cpp               \
            DlgSelectContactNumber.cpp  \
            GVSettings.cpp              \
            GVContactsTable.cpp         \
            OsDependent.cpp             \
            GVHistory.cpp               \
            SMSDlg.cpp                  \
            SMSEntryDeleteButton.cpp    \
            VoicemailWidget.cpp         \
            DialerValidator.cpp         \
            CacheDatabase.cpp           \
            ChildWindowBase.cpp         \
            UniqueAppHelper.cpp         \
            DialCancelDlg.cpp           \
            ObserverFactory.cpp         \
            GVAccess.cpp                \
            Singletons.cpp              \
            GVDataAccess.cpp            \
            SkypeClient.cpp             \
            SkypeClientFactory.cpp      \
            CalloutInitiator.cpp        \
            CallInitiatorFactory.cpp    \
            CaptchaWidget.cpp           \
            ContactsXmlHandler.cpp

RESOURCES = qgvdial.qrc

# In Linux and maemo, add the telepathy libraries, sources and headers
unix:!symbian {
    HEADERS +=  TpObserver.h            \
                TpCalloutInitiator.h
    SOURCES +=  TpObserver.cpp          \
                TpCalloutInitiator.cpp
}

# In desktop Linux, add the Skype client
unix:!symbian:!maemo5 {
    HEADERS += SkypeLinuxClient.h           \
               SkypeObserver.h              \
               DesktopSkypeCallInitiator.h
    SOURCES += SkypeLinuxClient.cpp         \
               SkypeObserver.cpp            \
               DesktopSkypeCallInitiator.cpp
}

win32 {
# Resource file is for windows only - for the icon
    RC_FILE = winrsrc.rc

# In desktop Windows, add the Skype client
    HEADERS += SkypeWinClient.h             \
               SkypeObserver.h              \
               DesktopSkypeCallInitiator.h
    SOURCES += SkypeWinClient.cpp           \
               SkypeObserver.cpp            \
               DesktopSkypeCallInitiator.cpp
}

###############################################################
# Installation related line go here
###############################################################

exists (../../buildit.pl) {
PREFIX = ../debian/qgvdial/usr
message("Build using my scripts")
}
!exists (../../buildit.pl) {
PREFIX = ../maemo/debian/qgvdial/usr
message("Build using qtcreator")
}

# Installation for maemo
maemo5 {
OPTPREFIX  = $$PREFIX/../opt/qgvdial
BINDIR     = $$OPTPREFIX/bin
DATADIR    = $$PREFIX/share
OPTDATADIR = $$OPTPREFIX/share

DEFINES += DATADIR=\"$$DATADIR\" PKGDATADIR=\"$$PKGDATADIR\"

#MAKE INSTALL

INSTALLS += target desktop icon

  target.path =$$BINDIR

  desktop.path = $$DATADIR/applications/hildon
  desktop.files += qgvdial.desktop

  icon.path = $$OPTDATADIR
  icon.files += qgvdial.png
}

# Installation for Linux
unix:!symbian:!maemo5 {
BINDIR  = $$PREFIX/bin
DATADIR = $$PREFIX/share

DEFINES += DATADIR=\"$$DATADIR\" PKGDATADIR=\"$$PKGDATADIR\"

#MAKE INSTALL

INSTALLS += target desktop icon

  target.path =$$BINDIR

  icon.path = $$DATADIR/qgvdial
  icon.files += qgvdial.png
}
