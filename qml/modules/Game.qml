/*
 * Game.qml
 *
 * 10ten board and game state. Adapted from 8192's Game.qml
 * (c) 2017 Jan Sprinz aka. NeoTheThird <neo@neothethird.de>,
 * with the game rules ported from 10ten-app (csfigu).
 *
 * Licensed under the GNU General Public License version 3.
 */

import QtQuick 2.15
import Lomiri.Components 1.3
import "GameLogic.js" as Logic

Item {
    id: game

    property int boardSize: 10
    property var board: []
    property int currentNumber: 1
    property var currentPosition: null       // [row, col]
    property var moves: []                   // list of [row, col]
    property int elapsedTime: 0
    property string gameStatus: "idle"       // idle | active | over
    property string themeName: "white"
    property int highscore: 0
    property var reachableCells: []          // "row,col" strings

    readonly property int score: currentNumber - 1
    readonly property int maxNumber: Logic.getMaxNumber(boardSize)
    readonly property int progress: Logic.calculateProgress(currentNumber, maxNumber)

    signal gameFinished(bool excellent)
    signal gameChanged()

    Timer {
        id: ticker
        interval: 1000
        repeat: true
        running: game.gameStatus === "active"
        onTriggered: {
            game.elapsedTime += 1
            game.gameChanged()
        }
    }

    function newGame(size) {
        boardSize = size || boardSize
        board = Logic.initializeBoard(boardSize)
        var r = Math.floor(Math.random() * boardSize)
        var c = Math.floor(Math.random() * boardSize)
        board[r][c] = 1
        currentPosition = [r, c]
        currentNumber = 2
        moves = []
        elapsedTime = 0
        gameStatus = "active"
        refreshReachable()
        gameChanged()
    }

    function placeNumber(row, col) {
        if (gameStatus !== "active") {
            return
        }
        if (currentNumber > maxNumber) {
            endGame()
            return
        }
        if (!currentPosition || !Logic.isValidMove(board, currentPosition, [row, col])) {
            return
        }
        board = Logic.makeMove(board, [row, col], currentNumber)
        currentPosition = [row, col]
        moves = moves.concat([[row, col]])
        currentNumber += 1
        refreshReachable()
        gameChanged()
        if (Logic.isGameOver(board, currentPosition, currentNumber)) {
            endGame()
        }
    }

    function undo() {
        // Mirrors the web app: at least 2 placed numbers so that the
        // current position always stays well-defined.
        if (gameStatus !== "active" || moves.length <= 1) {
            return
        }
        var last = moves[moves.length - 1]
        board = Logic.undoMove(board, last)
        moves = moves.slice(0, -1)
        currentPosition = moves[moves.length - 2]
        currentNumber -= 1
        refreshReachable()
        gameChanged()
    }

    function tileColor(number) {
        return Logic.getNumberColor(number, maxNumber)
    }

    function endGame() {
        gameStatus = "over"
        if (score > highscore) {
            highscore = score
        }
        var excellent = score >= maxNumber * 0.8
        refreshReachable()
        gameChanged()
        gameFinished(excellent)
    }

    function toggleTheme() {
        themeName = Logic.getNextTheme(themeName)
        gameChanged()
    }

    function refreshReachable() {
        var list = []
        if (gameStatus === "active" && currentPosition) {
            var possible = Logic.getPossibleMoves(board, currentPosition)
            for (var i = 0; i < possible.length; i++) {
                list.push(possible[i][0] + "," + possible[i][1])
            }
        }
        reachableCells = list
    }

    function serialize() {
        if (gameStatus !== "active") {
            return ""
        }
        return JSON.stringify({
            size: boardSize,
            board: board,
            number: currentNumber,
            pos: currentPosition,
            moves: moves,
            time: elapsedTime,
            theme: themeName
        })
    }

    function restore(json) {
        try {
            var s = JSON.parse(json)
            if (!s || !s.board || !s.size) {
                return false
            }
            boardSize = s.size
            board = s.board
            currentNumber = s.number
            currentPosition = s.pos
            moves = s.moves
            elapsedTime = s.time
            themeName = s.theme || "white"
            gameStatus = "active"
            refreshReachable()
            gameChanged()
            return true
        } catch (e) {
            return false
        }
    }

    /* ---------- board rendering ---------- */

    Item {
        id: boardArea
        width: parent.width
        height: width
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            radius: units.gu(1)
            color: Logic.getTheme(game.themeName).bg
            opacity: 0.9
        }

        Grid {
            id: grid
            anchors.fill: parent
            anchors.margins: units.gu(0.6)
            columns: game.boardSize
            rows: game.boardSize
            spacing: units.gu(0.4)

            Repeater {
                model: game.boardSize * game.boardSize
                delegate: cellComponent
            }
        }
    }

    Component {
        id: cellComponent

        Rectangle {
            id: cell

            property int row: Math.floor(index / game.boardSize)
            property int col: index % game.boardSize
            property int value: game.board.length ? (game.board[row] ? game.board[row][col] : 0) : 0
            property bool reachable: game.reachableCells.indexOf(row + "," + col) >= 0
            property bool current: game.currentPosition &&
                                   game.currentPosition[0] === row &&
                                   game.currentPosition[1] === col

            width: (grid.width - grid.spacing * (grid.columns - 1)) / grid.columns
            height: width
            radius: units.gu(0.6)

            color: value ? game.tileColor(value)
                         : (reachable ? Logic.withAlpha(Logic.getTheme(game.themeName).path, 0.4)
                                      : Logic.getTheme(game.themeName).cellBg)

            border.width: current ? units.gu(0.3) : 0
            border.color: Logic.getTheme(game.themeName).fg

            scale: 1
            onValueChanged: {
                if (value > 0) {
                    scale = 1.25
                    popAnim.restart()
                }
            }

            NumberAnimation {
                id: popAnim
                target: cell
                property: "scale"
                to: 1
                duration: 150
                easing.type: Easing.OutBack
            }

            Text {
                anchors.centerIn: parent
                font.pixelSize: cell.width * 0.42
                font.bold: true
                text: cell.value > 0 ? cell.value : ""
                color: cell.value
                       ? Logic.getContrastColor(game.tileColor(cell.value))
                       : (cell.reachable ? Logic.getTheme(game.themeName).fg
                                         : Logic.getTheme(game.themeName).fg)
                opacity: cell.reachable && cell.value === 0 ? 0.5 : 1.0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: game.placeNumber(cell.row, cell.col)
            }
        }
    }

    /* dim overlay when the game is over */
    Rectangle {
        id: overLay
        anchors.fill: boardArea
        radius: units.gu(1)
        color: "#66000000"
        visible: game.gameStatus === "over"
        z: 10

        Text {
            anchors.centerIn: parent
            text: "Game over"
            font.pixelSize: units.gu(3.5)
            font.bold: true
            color: "white"
        }
    }
}
