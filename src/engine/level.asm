INCLUDE "hardware.inc/hardware.inc"

SECTION "Level Variables", WRAM0

; Reserve 5 bytes for the  level array (grid)
levelGrid:: ds 5

SECTION "Level Engine", ROM0

InitLevelEngine::
  ; Load background
  call InitGameTiles
  call LoadBackground

  ; Turn off screen
  xor a
  ld [rLCDC], a

  ; Load default grid into variable
  ld de, DefaultGrid
  ld hl, levelGrid
  ld bc, $05
  call MemCpy

  ; Render default grid
  call RenderBlocks
  
  call TurnOnLCD
  ret

DefaultGrid:
  db %00000
  db %00000
  db %00000
  db %00000
  db %00000
DefaultGridEnd:
