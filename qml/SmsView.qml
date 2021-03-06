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

import Qt 4.7

Rectangle {
    id: container
    objectName: "SmsPage"

    color: "black"

    signal sigBack
    signal sigText(string strNumbers, string strText)

    onSigBack: smsText.closeSoftwareInputPanel()
    onSigText: smsText.closeSoftwareInputPanel()

    function addSmsDestination(name, number) {
        modelDestinations.append({"name": name, "number": number});
    }

    function clearAllDestinations() {
        smsText.text = '';
        modelDestinations.clear();
    }

    ListModel {
        id: modelDestinations
        ListElement {
            name: "John Doe"
            number: "+1 111 222 3333"
        }
    }

    Timer {
        id: hackModelTimer
        property int index: 0
        interval: 100
        repeat: false
        onTriggered: {
            modelDestinations.remove(index);
            if (modelDestinations.count == 0) {
                container.sigBack();
            }
        }
    }

    Flickable {
        id: mainFlick
        anchors.fill: parent

        contentHeight: smsLabel.height + smsLabel.anchors.topMargin +
                       smsTextRect.height + smsTextRect.anchors.topMargin +
                       remainingCharsText.height + remainingCharsText.anchors.topMargin +
                       repeaterColumn.height + btnRow.height + 8
        contentWidth: width

        Text {
            id: smsLabel
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }

            text: "SMS Text"
            color: "white"

            font { family: "Nokia Sans"; bold: true; pointSize: (7 * g_fontMul) }
        }

        FocusScope {
            id: smsTextRect

            anchors {
                top: smsLabel.bottom
                topMargin: 2
                left: parent.left
            }
            height: smsText.paintedHeight
            width: parent.width - 1

            Rectangle {
                anchors.fill: parent

                border.color: smsText ? "orange" : "blue"
                color: "slategray"

                TextEdit {
                    id: smsText

                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    // Forcibly set width so that wrap mode can work
                    width: parent.width
                    wrapMode: Text.WordWrap
                    textFormat: TextEdit.PlainText

                    inputMethodHints: Qt.ImhNoAutoUppercase + Qt.ImhNoPredictiveText

                    font { family: "Nokia Sans"; pointSize: (8 * g_fontMul) }
                    color: "white"
                }//TextEdit (with all the SMS text)
            }//Rectangle (bounding the sms text edit)
        }//FocusScope

        Text {
            id: remainingCharsText
            text: "Remaining characters = " + (140 - smsText.text.length)
            color: "white"
            font { family: "Nokia Sans"; pointSize: (6 * g_fontMul) }

            anchors {
                top: smsTextRect.bottom
                topMargin: 5
                left: parent.left
                right: parent.right
            }
        }// Text (remaining characters)

        Column {
            id: repeaterColumn
            anchors {
                top: remainingCharsText.bottom
                topMargin: 2
                left: parent.left
                right: parent.right
            }

            height: childrenRect.height

            Repeater {
                width: mainFlick.width

                model: modelDestinations
                delegate: Item {
                    id: entryRepeater

                    height: entryText.height
                    width: mainFlick.width

                    Text {
                        id: entryText

                        anchors {
                            left: parent.left
                            top: parent.top
                        }

                        text: name + " (" + number + ")"
                        font { family: "Nokia Sans"; pointSize: (7 * g_fontMul) }
                        color: "white"
                    }//Text

                    Rectangle {
                        id: imageRect
                        anchors {
                            right: parent.right
                            rightMargin: 1
                            top: parent.top
                            bottom: parent.bottom
                        }
                        width: height
                        height: entryRepeater.height - 1

                        color: "black"
                        border.color: "slategrey"

                        Image {
                            anchors.fill: parent

                            source: "close.png"
                            fillMode: Image.PreserveAspectFit

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    hackModelTimer.index = index;
                                    hackModelTimer.start();
                                }

                                onPressed: imageRect.color = "orange"
                                onReleased: imageRect.color = "black"
                            }//MouseArea
                        }//Image

                    }//Rectangle (bordering the close image)
                }//delegate (Rectangle)
            }//Repeater
        }//Column

        Row {
            id: btnRow

            spacing: 2

            anchors {
                top: repeaterColumn.bottom
                topMargin: 5
                left: parent.left
                right: parent.right
                rightMargin: 1
            }
            height: btnBack.height + 2

            MeegoButton {
                id: btnBack

                text: "Back"
                width: (parent.width / 2) - parent.spacing
                anchors.verticalCenter: parent.verticalCenter

                onClicked: container.sigBack();
            }// Back button

            MeegoButton {
                id: btnSend

                text: "Send"
                width: (parent.width / 2) - parent.spacing
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    var i = 0;
                    var arrNumbers = Array();
                    var strNumbers;

                    for (i = 0; i < modelDestinations.count; i++) {
                        arrNumbers[i] = modelDestinations.get(i).number;
                    }
                    strNumbers = arrNumbers.join(",");

                    container.sigText(strNumbers, smsText.text)
                }
            }// Send button
        }//Row (back and send buttons)
    }//Flickable (mainFlick)
}//Rectangle
