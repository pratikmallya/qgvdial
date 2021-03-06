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

#include "SymbianDTMFPrivate.h"
#include "SymbianCallInitiator.h"

SymbianDTMFPrivate::SymbianDTMFPrivate(SymbianCallInitiator *p)
: CActive(EPriorityNormal)
, parent (p)
, bUsable (false)
{
    TInt rv;
    TRAP(rv, CActiveScheduler::Add(this));
    if (KErrNone == rv) {
        bUsable = true;
        return;
    }

    QString msg = QString("Error adding activeschedular : %1").arg (rv);
    Q_WARN(msg);
}//SymbianDTMFPrivate::SymbianDTMFPrivate

SymbianDTMFPrivate::~SymbianDTMFPrivate ()
{
    Cancel();
    parent = NULL;
}//SymbianDTMFPrivate::~SymbianDTMFPrivate

SymbianDTMFPrivate *
SymbianDTMFPrivate::NewL(SymbianCallInitiator *p)
{
    SymbianDTMFPrivate* self =
    SymbianDTMFPrivate::NewLC(p);
    CleanupStack::Pop(self);
    return self;
}//SymbianDTMFPrivate::NewL

SymbianDTMFPrivate *
SymbianDTMFPrivate::NewLC(SymbianCallInitiator *p)
{
    SymbianDTMFPrivate *self = new (ELeave) SymbianDTMFPrivate(p);
    if (NULL == self) {
        Q_WARN ("Malloc failure on SymbianDTMFPrivate!");
        return NULL;
    }

    CleanupStack::PushL(self);
//    self->ConstructL();
    return self;
}//SymbianDTMFPrivate::NewLC

void
SymbianDTMFPrivate::RunL ()
{
    Q_DEBUG("RunL");
    bool bSuccess = (iStatus == KErrNone);
    if (NULL != parent) {
        Q_DEBUG("RunL about to call onDtmfSent");
        parent->onDtmfSent (this, bSuccess);
    }
    Q_DEBUG("RunL called onDtmfSent");
}//SymbianDTMFPrivate::RunL

void
SymbianDTMFPrivate::DoCancel ()
{
    parent->iTelephony->CancelAsync(CTelephony::ESendDTMFTonesCancel);
}//SymbianDTMFPrivate::DoCancel

void
SymbianDTMFPrivate::sendDTMF (const QString &strTones)
{
#define SIZE_LIMIT 40
    if (strTones.length () > SIZE_LIMIT) {
        Q_DEBUG ("Too many DTMF characters");
        return;
    }
    TBuf<SIZE_LIMIT>aNumber;
#undef SIZE_LIMIT

    TPtrC8 ptr(reinterpret_cast<const TUint8*>(strTones.toUtf8().constData()));
    aNumber.Copy(ptr);

    parent->iTelephony->SendDTMFTones(iStatus, aNumber);
    SetActive ();
}//SymbianDTMFPrivate::sendDTMF
