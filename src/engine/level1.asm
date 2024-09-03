INCLUDE "hardware.inc/hardware.inc"

SECTION "Level 1", ROM0

InitLevel1::
  ; Load current grid into levelGrid variable in memory
  ld de, .grid 
  ld hl, levelGrid
  ld bc, .gridEnd - .grid
  call MemCpy

  ret


.grid:
  dw `00000 ; 00 00
  dw `00100 ; 04 00
  dw `01110 ; 0E 00
  dw `00100 ; 04 00
  dw `00000 ; 00 00
.gridEnd:


