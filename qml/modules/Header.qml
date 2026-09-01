/*
 * Header.qml
 *
 * 10ten HUD: next number, score, best, timer, progress.
 * Adapted from 8192's Header.qml (c) 2017 Jan Sprinz aka. NeoTheThird.
 * Licensed under the GNU General Public License version 3.
 */

import QtQuick 2.15
import Lomiri.Components 1.3
import "GameLogic.js" as Logic

Item {
    id: header

    property int score: 0
    property int highscore: 0
    property int nextNumber: 1
    property int maxNumber: 100
    property int elapsed: 0
    property string themeName: "white"

    function fmtTime(s) {
        var m = Math.floor(s / 60)
        var sec = s % 60
        return (m < 10 ? "0" : "") + m + ":" + (sec < 10 ? "0" : "") + sec
    }

    Column {
        anchors.fill: parent
        spacing: units.gu(0.6)

        Row {
            width: parent.width
            height: units.gu(8)
            spacing: units.gu(0.8)

            /* next number chip */
            Rectangle {
                width: parent.width * 0.26
                height: parent.height
                radius: units.gu(0.8)
                color: Logic.getNumberColor(header.nextNumber, header.maxNumber)

                Column {
                    anchors.centerIn: parent
                    spacing: units.gu(0.2)
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: units.gu(1.3)
                        font.bold: true
                        text: "NEXT"
                        color: Logic.getContrastColor(Logic.getNumberColor(header.nextNumber, header.maxNumber))
                        opacity: 0.85
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: units.gu(3.2)
                        font.bold: true
                        text: header.nextNumber
                        color: Logic.getContrastColor(Logic.getNumberColor(header.nextNumber, header.maxNumber))
                    }
                }
            }

            /* stat boxes */
            Row {
                width: parent.width * 0.74 - units.gu(0.8)
                height: parent.height
                spacing: units.gu(0.8)

                Rectangle {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: parent.height
                    radius: units.gu(0.8)
                    color: Logic.getTheme(header.themeName).cellBg

                    Column {
                        anchors.centerIn: parent
                        spacing: units.gu(0.2)
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(1.3)
                            text: "SCORE"
                            color: Logic.getTheme(header.themeName).fg
                            opacity: 0.6
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(2.6)
                            font.bold: true
                            text: header.score
                            color: Logic.getTheme(header.themeName).fg
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: parent.height
                    radius: units.gu(0.8)
                    color: Logic.getTheme(header.themeName).cellBg

                    Column {
                        anchors.centerIn: parent
                        spacing: units.gu(0.2)
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(1.3)
                            text: "BEST"
                            color: Logic.getTheme(header.themeName).fg
                            opacity: 0.6
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(2.6)
                            font.bold: true
                            text: header.highscore
                            color: Logic.getTheme(header.themeName).fg
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: parent.height
                    radius: units.gu(0.8)
                    color: Logic.getTheme(header.themeName).cellBg

                    Column {
                        anchors.centerIn: parent
                        spacing: units.gu(0.2)
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(1.3)
                            text: "TIME"
                            color: Logic.getTheme(header.themeName).fg
                            opacity: 0.6
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: units.gu(2.2)
                            font.bold: true
                            text: header.fmtTime(header.elapsed)
                            color: Logic.getTheme(header.themeName).fg
                        }
                    }
                }
            }
        }

        /* progress */
        Row {
            width: parent.width
            height: units.gu(2.4)
            spacing: units.gu(0.8)

            ProgressBar {
                width: parent.width - units.gu(6)
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                minimumValue: 0
                maximumValue: 100
                value: Logic.calculateProgress(header.nextNumber - 1, header.maxNumber)
            }

            Text {
                width: units.gu(5.2)
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: units.gu(1.6)
                text: Logic.calculateProgress(header.nextNumber - 1, header.maxNumber) + "%"
                color: Logic.getTheme(header.themeName).fg
            }
        }
    }
}
