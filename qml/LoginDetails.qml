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

Item {
    id: container

    signal sigUserChanged(string user)
    signal sigPassChanged(string pass)
    signal sigLogin
    signal sigLogout

    property real pointSize: (8 * g_fontMul)
    property alias username: textUsername.text
    property alias password: textPassword.text

    height: (rowUser.height + rowPass.height + btnLogin.height + 6)

    Row {
        id: rowUser

        anchors {
            left: parent.left
            top: parent.top
        }

        width: parent.width
        height: lblEmail.height
        spacing: 2

        Text {
            id: lblEmail
            text: "Email:"
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            height: paintedHeight + 2
            font { family: "Nokia Sans"; pointSize: container.pointSize }
        }

        MyTextEdit {
            id: textUsername
            height: lblEmail.height
            width: parent.width - lblEmail.width - (parent.spacing * 2)
            opacity: (g_bIsLoggedIn == true ? 0 : 1)
            pointSize: container.pointSize

            KeyNavigation.tab: textPassword
            onSigTextChanged: container.sigUserChanged(strText);
            onSigEnter: btnLogin.doClick();
        }

        Text {
            id: lblUsername
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            height: paintedHeight + 2
            opacity: (g_bIsLoggedIn == true ? 1 : 0)
            font { family: "Nokia Sans"; pointSize: container.pointSize }

            text: container.username
        }
    }//Row (username)

    Row {
        id: rowPass

        anchors {
            left: parent.left
            top: rowUser.bottom
            topMargin: 2
        }

        width: parent.width
        height: lblPass.height
        spacing: 2

        Text {
            id: lblPass
            text: "Password:"
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            height: paintedHeight + 2
            font { family: "Nokia Sans"; pointSize: container.pointSize }
        }

        MyTextEdit {
            id: textPassword
            height: lblPass.height
            width: parent.width - lblPass.width - (parent.spacing * 2)
            opacity: (g_bIsLoggedIn == true ? 0 : 1)
            echoMode: TextInput.Password
            pointSize: container.pointSize

            KeyNavigation.tab: textUsername
            onSigTextChanged: container.sigPassChanged(strText);
            onSigEnter: btnLogin.doClick();
        }

        Text {
            id: lblPassword
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            height: paintedHeight + 2
            font { family: "Nokia Sans"; pointSize: container.pointSize }
            opacity: (g_bIsLoggedIn == true ? 1 : 0)

            text: Array(container.password.length+1).join("*")
        }
    }//Row (password)

    MeegoButton {
        id: btnLogin

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rowPass.bottom
            topMargin: 2
        }

        text: (g_bIsLoggedIn == true ? "Logout" : "Login")

        function doClick() {
            if (g_bIsLoggedIn) {
                container.sigLogout();
            } else {
                container.sigLogin();
            }

            textUsername.closeSoftwareInputPanel();
            textPassword.closeSoftwareInputPanel();
        }

        onClicked: btnLogin.doClick();
    }//MyButton (login/logout)
}//Item (container)
