INCLUDE "hardware.inc/hardware.inc"

SECTION "Title Screen", ROM0

titleScreenTileData:  INCBIN "assets/titlescreen-text.2bpp"
titleScreenTileDataEnd:

titleScreenTileMap: INCBIN "assets/titlescreen-text.tilemap"
titleScreenTileMapEnd:

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

  ld de, titleScreenTileMap
  ld hl, $9800
  ld bc, titleScreenTileMapEnd - titleScreenTileMap
  call MemCpy




  ret
