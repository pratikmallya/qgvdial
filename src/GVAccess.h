/*
qgvdial is a cross platform Google Voice Dialer
Copyright (C) 2009-2012  Yuvraaj Kelkar

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Contact: yuvraaj@gmail.com
*/

#ifndef __GVACCESS_H__
#define __GVACCESS_H__

#include "global.h"

// For some reason the symbian MOC doesn't like it if I don't include QObject
// even though it is present in QtCore which is included in global.h
#include <QObject>

class GVAccess;
typedef void (GVAccess::*WebPageCancel)();

enum GVAccess_Work {
    GVAW_Nothing = 0,
    GVAW_aboutBlank,
    GVAW_login,                     // user and password
    GVAW_logout,
    GVAW_dialCallback,              // Destination number, callback number, type
    GVAW_dialOut,                   // Destination number, callout number
    GVAW_getRegisteredPhones,
    GVAW_getInbox,                  // type, start page, page count, last update
    GVAW_sendSMS,                   // Number, text
    GVAW_playVmail,                 // Voicemail link, destination filename
    GVAW_markAsRead                 // Message ID
};

struct GVAccess_WorkItem
{
    GVAccess_WorkItem()
    {
        init ();
    }

    void init ()
    {
        whatwork = GVAW_Nothing;
        arrParams.clear ();
        receiver = NULL;
        method   = NULL;
        cancel   = NULL;
        bCancel  = false;
    }

    GVAccess_Work      whatwork;
    QVariantList    arrParams;

    bool            bCancel;
    WebPageCancel   cancel;

    // Callback
    QObject        *receiver;
    const char     *method;
};

class GVAccess : public QObject
{
    Q_OBJECT

protected:
    GVAccess (QObject *parent = NULL);
    virtual ~GVAccess ();

    //! This function will find out the proxy information for the system
    bool getSystemProxies (QNetworkProxy &http, QNetworkProxy &https);

    //! Cancel whatever work is current
    bool cancelWork ();

public:
    bool enqueueWork (GVAccess_Work whatwork, const QVariantList &params,
                      QObject      *receiver, const char         *method);
    //! Cancel the work specified
    bool cancelWork (GVAccess_Work whatwork);

    //! Simplify a phone number
    static void simplify_number (QString &strNumber, bool bAddIntPrefix = true);
    static bool isNumberValid (const QString &strNumber);
    static void beautify_number (QString &strNumber);

    virtual void setView (QWidget *view);

    bool setProxySettings (bool bEnable,
                           bool bUseSystemProxy,
                           const QString &host, int port,
                           bool bRequiresAuth,
                           const QString &user, const QString &pass);

    void setTimeout (int seconds = 20);
    void setEmitLog (bool enable);

    QString getLastErrorString();
    virtual QNetworkAccessManager *nwAccessMgr() = 0;

signals:
    //! Status emitter
    void status(const QString &strText, int timeout = 2000);

    //! When we start loading a page
    void loadStarted ();
    //! When we finish loading a page
    void loadFinished (bool bOk);
    //! For the progress bar
    void loadProgress (int val);
    //! Emitted at the end of every work item
    void workCompleted (bool bSuccess, const QVariantList &arrParams);

    //! Emitted for each registered phone number
    void registeredPhone (const GVRegisteredNumber &info);
    //! Emitted when dialing has started (for callback method)
    void dialInProgress (const QString &strNumber);
    //! Emitted for every inbox entry
    void oneInboxEntry (const GVInboxEntry &hevent);
    //! Emitted when GV returns an access number to dial out
    void dialAccessNumber (const QString  &strAccessNumber,
                           const QVariant &context        );

public slots:
    //! To be invoked to complete a dial
    virtual void dialCanFinish ();
    //! Invoked when the user presses cancel
    virtual void userCancel () = 0;

protected:
    //! Get the name of the work associated with this enum value
    QString getNameForWork (GVAccess_Work whatwork);
    //! Begin the next work
    void doNextWork ();
    //! Complete the work so that the next one can begin
    virtual void completeCurrentWork (GVAccess_Work whatwork, bool bOk);

    //! To be used for Data Access API ONLY
    QNetworkRequest
    createRequest (QString         strUrl    ,
                   QStringPairList arrPairs  ,
                   QByteArray     &byPostData);

    //! To be used for Data Access API ONLY
    QNetworkReply *
    postRequest (QNetworkAccessManager   *mgr     ,
                 QString                  strUrl  ,
                 QStringPairList          arrPairs,
                 QString                  strUA   ,
                 QObject                 *receiver,
                 const char              *method  );

    //! Load the about:blank page
    virtual bool aboutBlank () = 0;
    //! Login to Google voice
    virtual bool login () = 0;
    //! Log out of Google voice
    virtual bool logout () = 0;
    //! Make a phone call to an arbitrary number
    virtual bool dialCallback (bool bCallback) = 0;
    //! Get registered phones from the settings page
    virtual bool getRegisteredPhones () = 0;
    //! Begin the process to get inbox
    virtual bool getInbox () = 0;
    //! This sends SMSes
    virtual bool sendSMS () = 0;
    //! Play a voicemail
    virtual bool playVmail () = 0;
    //! Mark an inbox entry as read
    virtual bool markAsRead () = 0;

protected slots:

protected:
    //! The mutex that locks the lists below
    QMutex                      mutex;
    //! The list of work
    QList<GVAccess_WorkItem>    workList;
    //! Whats the current work being done
    GVAccess_WorkItem           workCurrent;
    //! Are we logged in?
    bool                        bLoggedIn;

    //! The subscribers google voice number
    QString                     strSelfNumber;
    //! rnr_se: Pulled off the login page
    QString                     strRnr_se;

    //! The currently selected registered callback number
    QString                     strCurrentCallback;

    int                         timeout;

    //! Should qDebug messages be emitted or not?
    bool                        bEmitLog;

    //! Store the last error string here
    QString                     strLastError;

    friend class Singletons;
};

#endif //__GVACCESS_H__
