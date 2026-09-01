/*
 * GameLogic.js
 *
 * 10ten game logic. Ported from the TypeScript implementation in
 * 10ten-app (csfigu) — packages/api/src/lib/gameLogic.ts and
 * apps/web/src/lib/colorUtils.ts.
 *
 * Copyright (C) 2026 csfigu (10ten adaptation)
 * Copyright (C) 2017 Jan Sprinz aka. NeoTheThird <neo@neothethird.de> (8192)
 * Licensed under the GNU General Public License version 3.
 */

/* ---------- board ---------- */

function initializeBoard(size) {
    var board = [];
    for (var r = 0; r < size; r++) {
        var row = [];
        for (var c = 0; c < size; c++) {
            row.push(0);
        }
        board.push(row);
    }
    return board;
}

function isValidPosition(size, row, col) {
    return row >= 0 && row < size && col >= 0 && col < size;
}

/* Valid moves: ±3 cells straight (same row/column), ±2 cells diagonal. */
function isValidMove(board, currentPos, nextPos) {
    var size = board.length;
    if (!isValidPosition(size, nextPos[0], nextPos[1])) {
        return false;
    }
    if (board[nextPos[0]][nextPos[1]] !== 0) {
        return false;
    }
    var rowDiff = Math.abs(nextPos[0] - currentPos[0]);
    var colDiff = Math.abs(nextPos[1] - currentPos[1]);
    var isHorizontal = rowDiff === 0 && colDiff === 3;
    var isVertical = rowDiff === 3 && colDiff === 0;
    var isDiagonal = rowDiff === 2 && colDiff === 2;
    return isHorizontal || isVertical || isDiagonal;
}

function getPossibleMoves(board, currentPos) {
    var possible = [];
    if (!currentPos) {
        return possible;
    }
    var row = currentPos[0];
    var col = currentPos[1];
    var candidates = [
        [row, col - 3], [row, col + 3], [row - 3, col], [row + 3, col],
        [row - 2, col - 2], [row - 2, col + 2], [row + 2, col - 2], [row + 2, col + 2]
    ];
    for (var i = 0; i < candidates.length; i++) {
        if (isValidMove(board, currentPos, candidates[i])) {
            possible.push(candidates[i]);
        }
    }
    return possible;
}

function isGameOver(board, currentPos, currentNumber) {
    var size = board.length;
    if (currentNumber > size * size) {
        return true;
    }
    var possible = getPossibleMoves(board, currentPos);
    return possible.length === 0;
}

function getMaxNumber(size) {
    return size * size;
}

function makeMove(board, position, number) {
    var newBoard = [];
    for (var r = 0; r < board.length; r++) {
        newBoard.push(board[r].slice());
    }
    newBoard[position[0]][position[1]] = number;
    return newBoard;
}

function undoMove(board, position) {
    var newBoard = [];
    for (var r = 0; r < board.length; r++) {
        newBoard.push(board[r].slice());
    }
    newBoard[position[0]][position[1]] = 0;
    return newBoard;
}

function calculateProgress(currentNumber, maxNumber) {
    if (maxNumber <= 1) {
        return 0;
    }
    return Math.round(((currentNumber - 1) / (maxNumber - 1)) * 100);
}

/* ---------- colors ---------- */

function hsvToRgb(h, s, v) {
    var hPrime = h / 60;
    var c = v * s;
    var x = c * (1 - Math.abs((hPrime % 2) - 1));
    var m = v - c;
    var r = 0, g = 0, b = 0;
    if (hPrime >= 0 && hPrime < 1) { r = c; g = x; b = 0; }
    else if (hPrime >= 1 && hPrime < 2) { r = x; g = c; b = 0; }
    else if (hPrime >= 2 && hPrime < 3) { r = 0; g = c; b = x; }
    else if (hPrime >= 3 && hPrime < 4) { r = 0; g = x; b = c; }
    else if (hPrime >= 4 && hPrime < 5) { r = x; g = 0; b = c; }
    else if (hPrime >= 5 && hPrime < 6) { r = c; g = 0; b = x; }
    return {
        r: Math.round((r + m) * 255),
        g: Math.round((g + m) * 255),
        b: Math.round((b + m) * 255)
    };
}

function rgbToHex(rgb) {
    function toHex(n) {
        var h = Math.max(0, Math.min(255, n)).toString(16);
        return h.length === 1 ? "0" + h : h;
    }
    return "#" + toHex(rgb.r) + toHex(rgb.g) + toHex(rgb.b);
}

/* Tile color: continuous gradient from cold blue (240°) to hot red (0°)
 * based on the number's progress toward the max number. */
function getNumberColor(number, maxNumber) {
    if (maxNumber <= 1) {
        return "#0000FF";
    }
    var progress = Math.max(0, Math.min(1, (number - 1) / (maxNumber - 1)));
    var hue = 240 - progress * 240;
    var saturation = 0.7 + progress * 0.3;
    var value = 0.8 + progress * 0.2;
    return rgbToHex(hsvToRgb(hue, saturation, value));
}

function hexToRgb(hex) {
    if (typeof hex !== "string") {
        console.warn("hexToRgb got non-string:", typeof hex, String(hex))
        return { r: 0, g: 0, b: 0 };
    }
    var clean = hex.replace("#", "");
    return {
        r: parseInt(clean.substring(0, 2), 16),
        g: parseInt(clean.substring(2, 4), 16),
        b: parseInt(clean.substring(4, 6), 16)
    };
}

function getContrastColor(hex) {
    var rgb = hexToRgb(hex);
    var luminance = (0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b) / 255;
    return luminance > 0.5 ? "#000000" : "#FFFFFF";
}

/* Hex color with alpha, "#AARRGGBB". */
function withAlpha(hex, alpha) {
    var rgb = hexToRgb(hex);
    var a = Math.max(0, Math.min(255, Math.round(alpha * 255))).toString(16);
    if (a.length === 1) { a = "0" + a; }
    return "#" + a + rgb.r.toString(16) + rgb.g.toString(16) + rgb.b.toString(16);
}

/* ---------- themes ---------- */

var themes = {
    white:  { bg: "#FFFFFF", fg: "#000000", cellBg: "#F0F0F0", path: "#4A90E2" },
    dark:   { bg: "#2D2D2D", fg: "#FFFFFF", cellBg: "#404040", path: "#5DADE2" },
    pastel: { bg: "#FDF5E6", fg: "#5D4037", cellBg: "#FFE0B2", path: "#81C784" },
    neon:   { bg: "#0D0D0D", fg: "#00FF00", cellBg: "#1A1A1A", path: "#FF00FF" },
    retro:  { bg: "#C0C0C0", fg: "#000000", cellBg: "#909090", path: "#800080" }
};

var themeOrder = ["white", "dark", "pastel", "neon", "retro"];

function getTheme(name) {
    return themes[name] || themes.white;
}

function getNextTheme(current) {
    var index = themeOrder.indexOf(current);
    return themeOrder[(index + 1) % themeOrder.length];
}
