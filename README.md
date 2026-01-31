# Overview
This is a repository for Michael Probst's Global Game Jam 2026 project.

The game is called **Painter's Tape** (working title)

**Premise**
The player is presented with a wall that has blocks of colors previewed. These blocks must be painted the specific color.
The wall is automatically painted by brushes with predetermined paths. The player must use masking tape to prevent the wall from being painted a certain color.

## Mechanics

### Automatic Paint
- must be able to apply color to an overlay texture over time. writing pixels to an image file most likely
- must use masking tape as a mask for the paint
- predetermined paths for paintbrushes
- a percentage of correctness must be calclulate by comparing a goal texture to the painted texture

### Masking Tape
- player will click and drag to create a line of painters tape
- player will click tape again to remove it (will collapse from both sides then turn into a clumped ball)
