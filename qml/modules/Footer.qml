/*
 * Footer.qml
 *
 * 10ten controls: undo, new game, board size, theme.
 * Adapted from 8192's Footer.qml (c) 2017 Jan Sprinz aka. NeoTheThird.
 * Licensed under the GNU General Public License version 3.
 */

import QtQuick 2.15
import Lomiri.Components 1.3

Item {
    id: footer

    Row {
        anchors.fill: parent
        spacing: units.gu(0.8)

        Button {
            width: (parent.width - parent.spacing * 3) / 4
            height: parent.height
            text: "Undo"
            enabled: game.moves.length > 1 && game.gameStatus === "active"
            onClicked: game.undo()
        }

        Button {
            width: (parent.width - parent.spacing * 3) / 4
            height: parent.height
            text: "New"
            onClicked: popupController.confirmNew()
        }

        Button {
            width: (parent.width - parent.spacing * 3) / 4
            height: parent.height
            text: game.boardSize === 10 ? "5×5" : "10×10"
            onClicked: popupController.confirmNew(game.boardSize === 10 ? 5 : 10)
        }

        Button {
            width: (parent.width - parent.spacing * 3) / 4
            height: parent.height
            text: game.themeName
            onClicked: game.toggleTheme()
        }
    }
}
