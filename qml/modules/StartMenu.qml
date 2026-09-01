/*
 * StartMenu.qml
 *
 * 10ten start screen: logo, best score, board-size choice.
 * Licensed under the GNU General Public License version 3.
 */

import QtQuick 2.15
import Lomiri.Components 1.3
import "GameLogic.js" as Logic

Item {
    id: startMenu

    property int bestScore: 0
    property bool canResume: false

    signal startGame(int size)
    signal resumeGame()
    signal showHelp()

    Column {
        anchors.centerIn: parent
        width: parent.width * 0.8
        spacing: units.gu(1.8)

        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../../assets/logo.png"
            width: units.gu(16)
            height: width
            fillMode: Image.PreserveAspectFit
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "10ten"
            font.pixelSize: units.gu(6)
            font.bold: true
            color: Logic.getTheme("white").fg
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Number placement puzzle"
            font.pixelSize: units.gu(2)
            color: Logic.getTheme("white").fg
            opacity: 0.7
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.6
            height: units.gu(5)
            radius: units.gu(0.8)
            color: Logic.getTheme("white").cellBg

            Text {
                anchors.centerIn: parent
                text: "BEST: " + startMenu.bestScore
                font.pixelSize: units.gu(2.6)
                font.bold: true
                color: Logic.getTheme("white").fg
            }
        }

        Button {
            width: parent.width
            height: units.gu(6)
            text: "5×5 board"
            color: "#2E7D32"
            onClicked: startMenu.startGame(5)
        }

        Button {
            width: parent.width
            height: units.gu(6)
            text: "10×10 board"
            color: "#1565C0"
            onClicked: startMenu.startGame(10)
        }

        Button {
            width: parent.width
            height: units.gu(5)
            text: "Continue game"
            visible: startMenu.canResume
            onClicked: startMenu.resumeGame()
        }

        Button {
            width: parent.width
            height: units.gu(5)
            text: "How to play"
            color: "#757575"
            onClicked: startMenu.showHelp()
        }
    }
}
