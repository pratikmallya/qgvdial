import Qt 4.7
import "helper.js" as Code

Item {
    id: container

    signal sigUserChanged(string username)
    signal sigPassChanged(string password)
    signal sigLogin
    signal sigLogout
    signal sigWebPage
    signal sigRefresh
    signal sigRefreshAll
    signal sigHide
    signal sigQuit
    signal sigLinkActivated(string strLink)

    signal sigProxyChanges(bool bEnable,
                           bool bUseSystemProxy,
                           string host, int port,
                           bool bRequiresAuth,
                           string user, string pass)
    signal sigMosquittoChanges(bool bEnable, string host, int port, string topic)

    signal sigMsgBoxDone (bool ok)

    Column { // user, pass and all buttons
        id: mainColumn
        anchors.fill: parent
        anchors.topMargin: 2
        spacing: 2
        opacity: 1

        // Test properties; comment out when adding qml to c++ code.
        property string strUsername: g_strUsername       //"user@gmail.com"
        property string strPassword: g_strPassword       //"hunter2 :p"

        property int pixDiv: 10
        property int pixHeight: (container.height + container.width) / 2
        property int outerHeight: pixHeight / (pixDiv + 2)
        property int pixSize: outerHeight * 2 / 3

        Row {
            width: parent.width
            spacing: 2

            Text {
                id: lblEmail
                text: "Email:"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                height: mainColumn.outerHeight
                font.pixelSize: mainColumn.pixSize
            }

            MyTextEdit {
                id: textUsername
                height: mainColumn.outerHeight - 2
                width: parent.width - lblEmail.width
                opacity: (g_bIsLoggedIn == true ? 0 : 1)
                text: mainColumn.strUsername
                pixelSize: mainColumn.pixSize

                Keys.onReturnPressed: listButtons.login_logout_function();
                KeyNavigation.tab: textPassword
                onSigTextChanged: container.sigUserChanged(strText);
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: mainColumn.strUsername
                color: "white"
                height: mainColumn.outerHeight
                font.pixelSize: mainColumn.pixSize
                opacity: (g_bIsLoggedIn == true ? 1 : 0)
            }
        }//Row

        Row {
            width: parent.width
            spacing: 2

            Text {
                text: "Password:"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                height: mainColumn.outerHeight
                font.pixelSize: mainColumn.pixSize
            }

            MyTextEdit {
                id: textPassword
                height: mainColumn.outerHeight - 2
                width: parent.width - lblEmail.width
                opacity: (g_bIsLoggedIn == true ? 0 : 1)
                text: mainColumn.strPassword
                echoMode: TextInput.Password
                pixelSize: mainColumn.pixSize

                Keys.onReturnPressed: listButtons.login_logout_function();
                KeyNavigation.tab: textUsername
                onSigTextChanged: container.sigPassChanged(strText);
            }

           Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Array(mainColumn.strPassword.length+1).join("*")
                color: "white"
                height: mainColumn.outerHeight
                font.pixelSize: mainColumn.pixSize
                opacity: (g_bIsLoggedIn == true ? 1 : 0)
            }
        }//Row (password)

        ListView {
            id: listButtons
            width: parent.width
            height: parent.height - (textUsername.height * 2)
            clip: true

            function login_logout_function() {
                if (g_bIsLoggedIn) {
                    container.sigLogout();
                } else {
                    container.sigLogin();
                }
            }

            model: ListModel {
                ListElement {
                    text: "Login"
                    newState: ""
                }//ListElement (login/logout)
                ListElement {
                    text: "Proxy settings"
                    newState: "Proxy"
                }//ListElement (proxy settings)
                ListElement {
                    text: "Mosquitto settings"
                    newState: "Mosquitto"
                }//ListElement (mosquitto settings)
                ListElement {
                    text: "Web Page (debug)"
                    newState: ""
                }//ListElement (Web Page (debug))
                ListElement {
                    text: "Refresh"
                    newState: ""
                }//ListElement (Web Page (debug))
                ListElement {
                    text: "Hide window"
                    newState: ""
                }//ListElement (Web Page (debug))
                ListElement {
                    text: "About"
                    newState: "About"
                }//ListElement (Web Page (debug))
            }

            delegate: MyButton {
                mainText: (text == "Login" ? (g_bIsLoggedIn == true ? "Logout" : "Login") : text)
                width: parent.width
                height: mainColumn.pixHeight / mainColumn.pixDiv
                mainPixelSize: height * 2 / 3

                onClicked: {
                    if (newState != "") {
                        container.state = newState
                    }

                    if (text == "Login") {
                        if (g_bIsLoggedIn) {
                            container.sigLogout();
                        } else {
                            container.sigLogin();
                        }
                    } else if (text == "Web Page (debug)") {
                        container.sigWebPage();
                    } else if (text == "Refresh") {
                        container.sigRefresh();
                    } else if (text == "Hide window") {
                        container.sigHide();
                    }
                }//onClicked

                onPressHold: {
                    if (text == "Refresh") {
                        container.sigRefreshAll();
                    } else if (text == "Hide window") {
                        container.sigQuit();
                    }
                }
            }//delegate (MyButton)
        }//ListView
    }// Column (user, pass and all buttons)

    Proxy {
        id: proxySettings
        anchors.fill: parent
        anchors.topMargin: 2
        opacity: 0

        onSigDone: container.state = ''
        onSigProxyChanges: container.sigProxyChanges(bEnable, bUseSystemProxy,
                                                     host, port, bRequiresAuth,
                                                     user, pass)
        onSigMsgBoxDone: container.sigMsgBoxDone(ok)
    }//Proxy

    Mosquitto {
        id: mqSettings
        anchors.fill: parent
        anchors.topMargin: 2
        opacity: 0

        onSigDone: container.state = ''
        onSigMosquittoChanges: container.sigMosquittoChanges(bEnable, host, port, topic)
        onSigMsgBoxDone: container.sigMsgBoxDone(ok)
    }//Mosquitto

    About {
        id: aboutWin
        anchors.fill: parent
        anchors.topMargin: 2
        opacity: 0
        onSigBack: container.state = ''
        onSigLinkActivated: container.sigLinkActivated(strLink)
        onSigMsgBoxDone: container.sigMsgBoxDone(ok)
    }//About

    MsgBox {
        id: msgBox
        opacity: ((container.opacity == 1 && g_bShowMsg == true) ? 1 : 0)
        msgText: g_strMsgText

        width: container.width - 20
        height: (container.width + container.height) / 6
        anchors.centerIn: container

        onSigMsgBoxOk: container.sigMsgBoxDone(true)
        onSigMsgBoxCancel: container.sigMsgBoxDone(false)
    }

    states: [
        State {
            name: "Proxy"
            PropertyChanges { target: proxySettings; opacity: 1 }
            PropertyChanges { target: mqSettings; opacity: 0 }
            PropertyChanges { target: aboutWin; opacity: 0 }
            PropertyChanges { target: mainColumn; opacity: 0 }
        },
        State {
            name: "Mosquitto"
            PropertyChanges { target: proxySettings; opacity: 0 }
            PropertyChanges { target: mqSettings; opacity: 1 }
            PropertyChanges { target: aboutWin; opacity: 0 }
            PropertyChanges { target: mainColumn; opacity: 0 }
        },
        State {
            name: "About"
            PropertyChanges { target: proxySettings; opacity: 0 }
            PropertyChanges { target: mqSettings; opacity: 0 }
            PropertyChanges { target: aboutWin; opacity: 1 }
            PropertyChanges { target: mainColumn; opacity: 0 }
        }
    ]
}// Item (container)
