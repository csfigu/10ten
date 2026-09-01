/*
 * Main.qml
 *
 * 10ten — a number placement puzzle for Ubuntu Touch.
 * Adapted from 8192 (c) 2017 Jan Sprinz aka. NeoTheThird <neo@neothethird.de>,
 * http://neothethird.de/8192/ — game rules ported from 10ten-app (csfigu).
 *
 * 10ten is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
import Lomiri.Components 1.3
import "modules"

Window {
    id: mainWindow
    title: "10ten"
    width: units.gu(42)
    height: units.gu(76)
    minimumWidth: units.gu(45)
    minimumHeight: units.gu(45)
    maximumWidth: Screen.width
    maximumHeight: Screen.height

    MainView {
        id: mainView
        objectName: "mainView"
        applicationName: "tenten.csfigu"
        focus: true
        automaticOrientation: true
        anchorToKeyboard: true
        anchors.fill: parent

        property string version: "0.1"
        property string viewScreen: "menu"   // "menu" | "game"

        Settings {
            id: settings
            category: "Game"
            property string state: ""
            property alias highscore: game.highscore
        }

        Page {
            id: gamePage
            title: "10ten"
            visible: true

            header: PageHeader {
                id: pageHeader
                title: "10ten"

                trailingActionBar {
                    actions: [
                        Action {
                            iconName: "info"
                            text: "How to play"
                            onTriggered: popupController.help()
                        },
                        Action {
                            iconName: "home"
                            text: "Menu"
                            onTriggered: mainView.viewScreen = "menu"
                        }
                    ]
                }
            }

            Item {
                anchors {
                    top: pageHeader.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                StartMenu {
                    id: startMenu
                    anchors.fill: parent
                    visible: mainView.viewScreen === "menu"
                    bestScore: game.highscore
                    canResume: settings.state !== ""

                    onStartGame: {
                        mainView.viewScreen = "game"
                        game.newGame(size)
                    }
                    onResumeGame: {
                        mainView.viewScreen = "game"
                        if (!game.restore(settings.state)) {
                            game.newGame(10)
                        }
                    }
                    onShowHelp: popupController.help()
                }

                Column {
                    id: gameColumn
                    visible: mainView.viewScreen === "game"
                    width: parent.width - units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: units.gu(1)
                    spacing: units.gu(1)

                    Header {
                        id: hud
                        width: parent.width
                        score: game.score
                        highscore: game.highscore
                        nextNumber: game.currentNumber
                        maxNumber: game.maxNumber
                        elapsed: game.elapsedTime
                        themeName: game.themeName
                    }

                    Game {
                        id: game
                        width: parent.width

                        onGameFinished: {
                            finishTimer.excellent = excellent
                            finishTimer.start()
                        }
                        onGameChanged: {
                            settings.state = game.serialize()
                        }
                    }

                    Footer {
                        id: footer
                        width: parent.width
                    }
                }
            }

            Timer {
                id: finishTimer
                interval: 400
                running: false
                property bool excellent: false
                onTriggered: popupController.gameOver(excellent, game.score)
            }
        }

        Keys.onPressed: {
            if (!game.currentPosition || game.gameStatus !== "active") {
                return
            }
            var r = game.currentPosition[0]
            var c = game.currentPosition[1]
            var t = null
            switch (event.key) {
            case Qt.Key_Up: t = [r - 3, c]; break
            case Qt.Key_Down: t = [r + 3, c]; break
            case Qt.Key_Left: t = [r, c - 3]; break
            case Qt.Key_Right: t = [r, c + 3]; break
            case Qt.Key_Q: t = [r - 2, c - 2]; break
            case Qt.Key_E: t = [r - 2, c + 2]; break
            case Qt.Key_Z: t = [r + 2, c - 2]; break
            case Qt.Key_C: t = [r + 2, c + 2]; break
            default: return
            }
            game.placeNumber(t[0], t[1])
            event.accepted = true
        }

        PopupController {
            id: popupController
        }

        Component.onCompleted: {
            // Start on the menu; the game starts when the user picks a board size.
        }
    }
}
