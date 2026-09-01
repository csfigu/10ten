/*
 * PopupController.qml
 *
 * 10ten dialogs: help, about, new-game confirmation, game over.
 * Adapted from 8192's PopupController.qml (c) 2017 Jan Sprinz aka. NeoTheThird.
 * Licensed under the GNU General Public License version 3.
 */

import QtQuick 2.15
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Item {
    id: popupController

    function confirmNew(size) {
        PopupUtils.open(confirmNewComponent, null, {newSize: size || 0})
    }

    Component {
        id: confirmNewComponent
        Dialog {
            id: confirmNewDia
            property int newSize: 0
            title: "New game"
            text: newSize > 0 ? ("Start a new " + newSize + "×" + newSize + " game? The current game will be lost.")
                              : "Start a new game? The current game will be lost."

            Button {
                text: "Start"
                color: "#2E7D32"
                onClicked: {
                    game.newGame(confirmNewDia.newSize > 0 ? confirmNewDia.newSize : undefined)
                    PopupUtils.close(confirmNewDia)
                }
            }

            Button {
                text: "Cancel"
                color: "#757575"
                onClicked: {
                    PopupUtils.close(confirmNewDia)
                }
            }
        }
    }

    function help() {
        PopupUtils.open(helpComponent)
    }

    Component {
        id: helpComponent
        Dialog {
            id: helpDia
            title: "How to play"
            text: "Place the numbers 1 to N (N = size × size) on the board.\n\nFrom the current cell you may move:\n• ±3 cells horizontally or vertically\n• ±2 cells diagonally\n\nOnly empty cells can receive the next number.\nThe game ends when no valid move remains.\nFill 80% or more of the board for an excellent result."

            Button {
                text: "Close"
                onClicked: {
                    PopupUtils.close(helpDia)
                }
            }
        }
    }

    function about() {
        PopupUtils.open(aboutComponent)
    }

    Component {
        id: aboutComponent
        Dialog {
            id: aboutDia
            title: "10ten"
            text: "Version: " + mainView.version + "\n\nA number placement puzzle for Ubuntu Touch.\n\nAdapted from 8192 (c) 2017 Jan Sprinz (NeoTheThird) and ported from 10ten-app (csfigu).\nLicensed under GPL-3.0.\n\nSource: github.com/csfigu/10ten"

            Button {
                text: "Source"
                onClicked: {
                    Qt.openUrlExternally("https://github.com/csfigu/10ten")
                    PopupUtils.close(aboutDia)
                }
            }

            Button {
                text: "Close"
                color: "#757575"
                onClicked: {
                    PopupUtils.close(aboutDia)
                }
            }
        }
    }

    function gameOver(excellent, score) {
        PopupUtils.open(gameOverComponent, null, {excellent: excellent, score: score})
    }

    Component {
        id: gameOverComponent
        Dialog {
            id: gameOverDia
            property bool excellent: false
            property int score: 0
            title: gameOverDia.excellent ? "Excellent!" : "Game over"
            text: "Score: " + gameOverDia.score + (gameOverDia.excellent ? "\nYou filled most of the board!" : "\nNo valid moves remain.")

            Button {
                text: "New game"
                color: "#2E7D32"
                onClicked: {
                    game.newGame()
                    PopupUtils.close(gameOverDia)
                }
            }

            Button {
                text: "Quit"
                color: "#C62828"
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}
