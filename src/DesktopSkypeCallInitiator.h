#ifndef DESKTOPSKYPECALLINITIATOR_H
#define DESKTOPSKYPECALLINITIATOR_H

#include "CalloutInitiator.h"
#include "SkypeClient.h"

class DesktopSkypeCallInitiator : public CalloutInitiator
{
    Q_OBJECT

private:
    explicit DesktopSkypeCallInitiator(QObject *parent = 0);

signals:

public slots:
    void initiateCall (const QString &strDestination);

private slots:
    void onCallInitiated (bool bSuccess, const QVariantList &params);

private:
    SkypeClient *skypeClient;

    friend class CallInitiatorFactory;
};

#endif // DESKTOPSKYPECALLINITIATOR_H