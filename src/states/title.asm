INCLUDE "hardware.inc/hardware.inc"

SECTION "Title Screen", ROM0

titleScreenTileData:  INCBIN "assets/title-spritesheet.2bpp"
titleScreenTileDataEnd:

Tilemap:  INCBIN "assets/title-spritesheet.tilemap"
TilemapEnd:

InitTitleScreen::
  call DrawTitleScreen

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a

  ret


DrawTitleScreen::
  ld de, titleScreenTileData
  ld hl, $9000
  ld bc, titleScreenTileDataEnd - titleScreenTileData
  call MemCpy

  ld de, Tilemap
  ld hl, $9800
  ld bc, TilemapEnd - Tilemap
  call MemCpy

  ret



