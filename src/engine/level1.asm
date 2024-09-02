INCLUDE "hardware.inc/hardware.inc"

SECTION "Level 1", ROM0

InitLevel1::
  ld de, .grid 
  ld hl, levelGrid
  ld bc, .gridEnd - .grid
  call MemCpy

  ret


.grid:
  dw `00000
  dw `00100
  dw `01110
  dw `00100
  dw `00000
.gridEnd:


