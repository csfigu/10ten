# Changelog

## v0.1 — 2026-09-01

Initial release of 10ten for Ubuntu Touch.

### Features
- Number placement puzzle: place the numbers 1 to N (N = board size × size) on the board
- Movement rules: ±3 cells horizontally/vertically, ±2 cells diagonally from the current cell
- Board sizes: 10×10 and 5×5, selectable from the start menu
- 5 color themes (white, dark, pastel, neon, retro)
- Undo, move timer, live progress bar
- Local high score (BEST) and automatic game resume
- Start menu with best score, board-size choice and "Continue game"
- Help screen with the rules
- Keyboard controls (arrows + Q/E/Z/C) for desktop usage
- Auto-save: the running game survives app restarts

### Technical
- Pure QML + Lomiri UI Toolkit (Qt 5.15), framework ubuntu-touch-24.04-1.x
- Game logic ported from 10ten-app (TypeScript) to QML/JavaScript
- Packaging, layout and board concepts adapted from 8192 by Jan Sprinz (NeoTheThird)
- GPL-3.0 licensed

### Fixes included (from device testing)
- Board grid sizing (plain Grid has no cellWidth/cellHeight)
- QML color objects no longer passed into JS color helpers (dark-theme safe)
- Confirmation dialogs with properly declared properties (no ReferenceError blocking input)
- Start menu now hides correctly when a game starts; controls bar pinned to the bottom so tile taps never hit buttons
- Header (score/time/progress) and footer (controls) made visible and separated from the board
- Logo on a light background so it stays visible in dark system themes
