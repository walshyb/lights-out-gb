INCLUDE "hardware.inc/hardware.inc"
INCLUDE "util/text-macros.inc"

SECTION "Level Select", ROM0

levelSelectTileData: INCBIN "assets/levelselect.2bpp"
levelSelectTileDataEnd:

levelSelectTilemap: INCBIN "assets/levelselect.tilemap"
levelSelectTilemapEnd:

InitLevelSelectScreen::
  call DrawLevelSelectBackground

  ld a, LCDCF_ON | LCDCF_BGON
  ld [rLCDC], a

  ret

  ; call InitLevelSelectTiles
  ; load cursor sprite
  ; draw tiles
  ;   start at $9860


  ; TODO: fetch save data
  ; allow player input

DrawLevelSelectBackground:
  ld de, levelSelectTileData
  ld hl, $9000
  ld bc, levelSelectTileDataEnd - levelSelectTileData
  call MemCpy

  ld de, levelSelectTilemap 
  ld hl, $9800
  ld bc, levelSelectTilemapEnd - levelSelectTilemap
  call MemCpy

  ret

