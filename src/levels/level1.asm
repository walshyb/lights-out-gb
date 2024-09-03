INCLUDE "hardware.inc/hardware.inc"

SECTION "Level 1", ROM0

InitLevel1::
  ; Load current grid into levelGrid variable in memory
  ld de, .grid 
  ld hl, levelGrid
  ld bc, .gridEnd - .grid
  call MemCpy

  ; Render the level
  call RenderBlocks

  ; Turn on the screen
  call TurnOnLCD

  ret

.grid:
  db %00000 ; 00
  db %00100 ; 04 
  db %01110 ; 0E
  db %00100 ; 04
  db %00000 ; 00
.gridEnd:


