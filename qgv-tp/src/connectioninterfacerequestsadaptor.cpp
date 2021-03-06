/*
 * This file was generated by qdbusxml2cpp version 0.7
 * Command line was: qdbusxml2cpp -i connectioninterfacerequeststypes.h -c ConnectionInterfaceRequestsAdaptor -a src/connectioninterfacerequestsadaptor.h:src/connectioninterfacerequestsadaptor.cpp data/Conn.I.Requests.xml
 *
 * qdbusxml2cpp is Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * Hand Edited! Do not re-generate
 */

#include "connectioninterfacerequestsadaptor.h"
#include "connectioninterfacerequeststypes.h"
#include "connection.h"
#include <QtCore/QMetaObject>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QVariant>

/*
 * Implementation of adaptor class ConnectionInterfaceRequestsAdaptor
 */

ConnectionInterfaceRequestsAdaptor::ConnectionInterfaceRequestsAdaptor(QObject *parent)
    : QDBusAbstractAdaptor(parent)
{
    // constructor
    setAutoRelaySignals(true);
}

ConnectionInterfaceRequestsAdaptor::~ConnectionInterfaceRequestsAdaptor()
{
    // destructor
}

org::freedesktop::Telepathy::RequestableChannelClassList
ConnectionInterfaceRequestsAdaptor::requestableChannelClasses() const
{
    // get the value of property RequestableChannelClasses
    return qvariant_cast< org::freedesktop::Telepathy::RequestableChannelClassList >(parent()->property("RequestableChannelClasses"));
}


QDBusObjectPath
ConnectionInterfaceRequestsAdaptor::CreateChannel(const QVariantMap &request, QVariantMap &channel_properties)
{
    // handle method call org.freedesktop.Telepathy.Connection.Interface.Requests.CreateChannel
    return static_cast<Connection *>(parent())->CreateChannel(request, channel_properties);
}

bool
ConnectionInterfaceRequestsAdaptor::EnsureChannel(const QVariantMap &request, QDBusObjectPath &channel_object, QVariantMap &channel_properties)
{
    // handle method call org.freedesktop.Telepathy.Connection.Interface.Requests.EnsureChannel
    return static_cast<Connection *>(parent())->EnsureChannel(request, channel_object, channel_properties);
}

