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

#ifndef GVXMLPARSER_H
#define GVXMLPARSER_H

#include "global.h"
#include <QObject>

class GvXMLParser : public QObject, public QXmlDefaultHandler
{
    Q_OBJECT

public:
    explicit GvXMLParser(QObject *parent = 0);
    void setEmitLog (bool enable);

public:
    QString strJson;
    QString strHtml;

protected:
    bool startElement (const QString        &namespaceURI,
                       const QString        &localName   ,
                       const QString        &qName       ,
                       const QXmlAttributes &atts        );

    bool endElement (const QString &namespaceURI,
                     const QString &localName   ,
                     const QString &qName       );

    bool characters (const QString &ch);

private:
    QString strChars;
    bool bEmitLog;
};

#endif // GVXMLPARSER_H
