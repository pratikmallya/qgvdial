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

#include "DesktopSkypeCallInitiator.h"
#include "Singletons.h"
#include "SkypeClient.h"

DesktopSkypeCallInitiator::DesktopSkypeCallInitiator (QObject *parent)
: CalloutInitiator(parent)
, skypeClient (NULL)
{
    attemptCreateSkypeClient ();
}//DesktopSkypeCallInitiator::DesktopSkypeCallInitiator

void
DesktopSkypeCallInitiator::attemptCreateSkypeClient ()
{
    if (NULL == skypeClient) {
        skypeClient = Singletons::getRef().getSkypeFactory()
                        .ensureSkypeClient (APPLICATION_NAME);
        if (NULL == skypeClient) {
            qWarning ("Failed to create skype Client!");
            return;
        }

        bool rv = connect (skypeClient, SIGNAL(connectedChanged(bool)),
                           this       , SIGNAL(changed()));
        Q_ASSERT(rv); Q_UNUSED(rv);
        emit changed ();
    }
}//DesktopSkypeCallInitiator::attemptCreateSkypeClient

void
DesktopSkypeCallInitiator::initiateCall (const QString &strDestination,
                                         void *ctx /*= NULL*/)
{
    bool bOk = false;
    m_Context = ctx;
    do { // Begin cleanup block (not a loop)
        attemptCreateSkypeClient ();
        if (NULL == skypeClient) {
            break;
        }

        // Save it for onSkypeConnected
        strNumber = strDestination;

        QVariantList l;
        if (!skypeClient->isConnected ()) {
            bOk =
            skypeClient->enqueueWork (SW_Connect, l, this,
                SLOT (onSkypeConnected (bool, const QVariantList &)));
            if (!bOk) {
                qWarning ("Could not connect skype!!!");
            }
            break;
        }

        onSkypeConnected (true, l);
        bOk = true;
    } while (0); // End cleanup block (not a loop)
    if (!bOk) {
        emit callInitiated (false, m_Context);
    }
}//DesktopSkypeCallInitiator::initiateCall

void
DesktopSkypeCallInitiator::onSkypeConnected (bool bSuccess, const QVariantList&)
{
    bool bOk = false;
    do { // Begin cleanup block (not a loop)
        if (!bSuccess) {
            qWarning ("Failed to connect to skype");
            break;
        }

        QVariantList l;
        l += strNumber;
        bOk =
        skypeClient->enqueueWork (SW_InitiateCall, l, this,
            SLOT (onCallInitiated (bool, const QVariantList &)));
        if (!bOk) {
            qWarning ("Failed to even begin initiating callout");
            break;
        }
    } while (0); // End cleanup block (not a loop)

    if (!bOk) {
        emit callInitiated (false, m_Context);
    }
}//DesktopSkypeCallInitiator::onSkypeConnected

void
DesktopSkypeCallInitiator::onCallInitiated (bool bSuccess, const QVariantList &)
{
    if (bSuccess) {
        qDebug ("DesktopSkype: Callout is successful");
    } else {
        qWarning ("DesktopSkype: Callout failed.");
    }
    emit callInitiated (bSuccess, m_Context);
}//DesktopSkypeCallInitiator::onCallInitiated

QString
DesktopSkypeCallInitiator::name ()
{
    return ("skype");
}//DesktopSkypeCallInitiator::name

QString
DesktopSkypeCallInitiator::selfNumber ()
{
    return ("undefined");
}//DesktopSkypeCallInitiator::selfNumber

bool
DesktopSkypeCallInitiator::isValid ()
{
    //@@UV: Ideally I need to do this, but I've disabled it because I don't have
    // a good way to make the Skype Client code monitor for the existance of
    // Skype and report back.
//    return ((NULL != skypeClient) && (skypeClient->isConnected ()));
    return true;
}//DesktopSkypeCallInitiator::isValid

bool
DesktopSkypeCallInitiator::sendDTMF (const QString &strTones)
{
    QVariantList l;
    l += strTones;
    bool bOk = skypeClient->enqueueWork (SW_SendDtmf, l, this,
                        SLOT (onDTMFSent (bool, const QVariantList &)));
    if (!bOk) {
        qWarning ("Failed to even begin sending DTMF");
    }
    return bOk;
}//DesktopSkypeCallInitiator::sendDTMF

void
DesktopSkypeCallInitiator::onDTMFSent (bool bSuccess, const QVariantList &)
{
    if (bSuccess) {
        qDebug ("DTMF sent!");
    } else {
        qWarning ("DTMF failed!!");
    }
}//DesktopSkypeCallInitiator::onDTMFSent
