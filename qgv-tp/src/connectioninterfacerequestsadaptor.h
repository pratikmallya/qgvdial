/*
 * This file was generated by qdbusxml2cpp version 0.7
 * Command line was: qdbusxml2cpp -i connectioninterfacerequeststypes.h -c ConnectionInterfaceRequestsAdaptor -a src/connectioninterfacerequestsadaptor.h:src/connectioninterfacerequestsadaptor.cpp data/Conn.I.Requests.xml
 *
 * qdbusxml2cpp is Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This is an auto-generated file.
 * This file may have been hand-edited. Look for HAND-EDIT comments
 * before re-generating it.
 */

#ifndef CONNECTIONINTERFACEREQUESTSADAPTOR_H_1280083803
#define CONNECTIONINTERFACEREQUESTSADAPTOR_H_1280083803

#include <QtCore/QObject>
#include <QtDBus/QtDBus>
#include "connectioninterfacerequeststypes.h"
class QByteArray;
template<class T> class QList;
template<class Key, class Value> class QMap;
class QString;
class QStringList;
class QVariant;
//class org::freedesktop::Telepathy::RequestableChannelClass;
//class org::freedesktop::Telepathy::RequestableChannelClassList;

/*
 * Adaptor class for interface org.freedesktop.Telepathy.Connection.Interface.Requests
 */
class ConnectionInterfaceRequestsAdaptor: public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.freedesktop.Telepathy.Connection.Interface.Requests")
    Q_CLASSINFO("D-Bus Introspection", ""
                "  <interface name=\"org.freedesktop.Telepathy.Connection.Interface.Requests\">\n"
                "    <property access=\"read\" type=\"(a{sv}as)\" name=\"RequestableChannelClasses\">\n"
                "      <annotation value=\"org::freedesktop::Telepathy::RequestableChannelClassList\" name=\"com.trolltech.QtDBus.QtTypeName\"/>\n"
                "    </property>\n"
                "    <method name=\"CreateChannel\">\n"
                "      <annotation value=\"QVariantMap\" name=\"com.trolltech.QtDBus.QtTypeName.In0\"/>\n"
                "      <annotation value=\"QVariantMap\" name=\"com.trolltech.QtDBus.QtTypeName.Out1\"/>\n"
                "      <arg direction=\"in\" type=\"a{sv}\" name=\"request\"/>\n"
                "      <arg direction=\"out\" type=\"o\" name=\"channel_object\"/>\n"
                "      <arg direction=\"out\" type=\"a{sv}\" name=\"channel_properties\"/>\n"
                "    </method>\n"
                "    <method name=\"EnsureChannel\">\n"
                "      <annotation value=\"QVariantMap\" name=\"com.trolltech.QtDBus.QtTypeName.In0\"/>\n"
                "      <annotation value=\"QVariantMap\" name=\"com.trolltech.QtDBus.QtTypeName.Out2\"/>\n"
                "      <arg direction=\"in\" type=\"a{sv}\" name=\"request\"/>\n"
                "      <arg direction=\"out\" type=\"b\" name=\"yours\"/>\n"
                "      <arg direction=\"out\" type=\"o\" name=\"channel_object\"/>\n"
                "      <arg direction=\"out\" type=\"a{sv}\" name=\"channel_properties\"/>\n"
                "    </method>\n"
                "    <signal name=\"NewChannels\">\n"
                "      <annotation value=\"org::freedesktop::Telepathy::ChannelDetailsList\" name=\"com.trolltech.QtDBus.QtTypeName.In0\"/>\n"
                "      <arg type=\"a(oa{sv})\" name=\"new_channels\"/>\n"
                "    </signal>\n"
                "    <signal name=\"ChannelClosed\">\n"
                "      <arg type=\"o\" name=\"removed_channel_object\"/>\n"
                "    </signal>\n"
                "  </interface>\n"
                        "")
public:
    ConnectionInterfaceRequestsAdaptor(QObject *parent);
    virtual ~ConnectionInterfaceRequestsAdaptor();

public: // PROPERTIES    
    Q_PROPERTY(org::freedesktop::Telepathy::RequestableChannelClassList RequestableChannelClasses READ requestableChannelClasses)
    org::freedesktop::Telepathy::RequestableChannelClassList requestableChannelClasses() const;

public Q_SLOTS: // METHODS
    QDBusObjectPath CreateChannel(const QVariantMap &request, QVariantMap &channel_properties);
    bool EnsureChannel(const QVariantMap &request, QDBusObjectPath &channel_object, QVariantMap &channel_properties);
Q_SIGNALS: // SIGNALS
    void ChannelClosed(const QDBusObjectPath &removed_channel_object);
    void NewChannels(org::freedesktop::Telepathy::ChannelDetailsList new_channels);
};

#endif
