INCLUDE "hardware.inc/hardware.inc"

SECTION "Level Engine", ROM0

InitLevelEngine::
  ; Load background
  call InitGameTiles
  call LoadBackground

  xor a
  ld [rLCDC], a

  call RenderBlocks
  
  call TurnOnLCD
  ret
