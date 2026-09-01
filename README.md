# 10ten

A number placement puzzle for [Ubuntu Touch](https://ubports.com).

Place the numbers 1, 2, 3 ... on the board. Each number must land exactly
**±3 cells horizontally or vertically**, or **±2 cells diagonally**, from the
current cell. The game ends when no valid move remains. Fill 80% or more of
the board for an excellent result.

- Board sizes: 10×10 and 5×5
- Undo, timer, local high score, 5 color themes
- Resume support: the running game is saved automatically

## Development

This app is written in QML and built with [clickable](https://clickable-ut.dev)
against the `ubuntu-touch-24.04-1.x` framework (Qt 5.15 + Lomiri UI Toolkit).

    clickable build          # build the .click package
    clickable build --ssh phone   # build and install on the phone over SSH

## Credits & license

Adapted from [8192](https://github.com/NeoTheThird/8192) by Jan Sprinz
(NeoTheThird) — original packaging, layout and board concepts.
Game logic ported from [10ten-app](https://github.com/csfigu/10ten-app).

Copyright (C) 2017 Jan Sprinz (original 8192)
Copyright (C) 2026 csfigu (10ten adaptation)

Licensed under the GNU General Public License, version 3.
See [LICENSE](LICENSE).
