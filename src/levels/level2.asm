INCLUDE "hardware.inc/hardware.inc"

SECTION "Level 2", ROM0

InitLevel2::
  ; Load current grid into levelGrid variable in memory
  ld de, .grid 
  ld hl, levelGrid
  ld bc, .gridEnd - .grid
  call MemCpy

  ; Render the level
  call RenderBlocks

  ret

.grid:
  db %11011 ; 00
  db %10001 ; 00
  db %00000 ; 00
  db %10001 ; 00
  db %11011 ; 00
.gridEnd:


