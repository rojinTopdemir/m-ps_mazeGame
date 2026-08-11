# MIPS Maze Game

A maze game written entirely in MIPS assembly, built and run with the [MARS](http://courses.missouristate.edu/kenvollmar/mars/) simulator. A 15×15 maze is generated in memory, rendered on MARS's Bitmap Display, and the player moves through it with the keyboard until reaching the goal.

## Features

- **Maze generation** — outer border walls and an internal corridor pattern are built programmatically into a 15×15 grid (`mdArray`), with the start and goal cells carved open (`generate_maze_outer_moat`, `generate_maze_street`). The layout is fixed/deterministic, not randomized.
- **Bitmap rendering** — every maze cell is drawn as a colored block via a `draw_pixel` routine, with `draw_hline`/`draw_vline` helpers built on top of it for drawing runs of pixels in one call.
- **Player movement** — WASD controls; each move is checked against the maze array first, so the player can't walk through walls.
- **Win condition** — reaching the goal cell triggers a "GOAL!" banner, drawn letter-by-letter in pixel art.

## Controls

| Key   | Action      |
|-------|-------------|
| W     | Move up     |
| A     | Move left   |
| S     | Move down   |
| D     | Move right  |
| Space | Exit        |

## Running it

The simulator is included at `Mars4_5.jar`, so a JRE is all you need:

```bash
java -jar Mars4_5.jar
```

1. Open `mips3.asm` (the current version — see [Project files](#project-files)) and assemble it.
2. Before running, open two tools from the **Tools** menu and connect both to the program:
   - **Bitmap Display** — Unit Width/Height: `4` px, Display Width/Height: `64` x `64`, Base Address: `0x10008000 ($gp)`.
   - **Keyboard and Display MMIO Simulator** — this is what the WASD input reads from (`0xffff0000` / `0xffff0004`).
3. Run. The maze draws first, then the player (red pixel) can be moved with WASD.

## Project files

| File                              | Purpose                                                                 |
|------------------------------------|--------------------------------------------------------------------------|
| `mips3.asm`                        | Current version of the maze game                                        |
| `mips1.asm`, `mips2.asm`           | Earlier iterations, kept for reference                                  |
| `yapılanlar.txt`                   | Change log: register-saving fixes for MIPS calling-convention compliance, the `draw_hline`/`draw_vline` helpers, and the pixel-art letter drawing cleanup |
| `TASK1.docx`                       | Architecture write-up covering calling-convention correctness, pipeline hazard/CPI analysis, and a cache-locality optimization pass on the maze routines |
| `Mars4_5.jar`                      | MARS simulator used to assemble and run the `.asm` files                |
| `game.asm`, `maze-game-main.zip`   | External reference projects from other courses, kept around for study — not part of this game |

## Notes

- `mips1.asm` → `mips3.asm` track the project's progression. `mips3.asm` is the one with the calling-convention fixes and line-drawing helpers documented in `yapılanlar.txt`.
- The maze array (`mdArray`) is 15×15; the bitmap grid it's drawn onto is configured as 16×16 units (see the `PIXEL_WIDTH`/`PIXEL_HEIGHT` constants in `mips3.asm`).
