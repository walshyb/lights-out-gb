INCLUDE "hardware.inc/hardware.inc"

SECTION "Title Screen", ROM0

; My learnings:
; If you're going to have an image take up the whole of the GB screen (effectively),
; it's better to make it 256x256 and rgbgfx that. That way screen-wrapping is
; already handled. Back when this image was GB resolution, it kept on rendering it
; offscreen into no man's land and wrapping after the 32nd column.
titleScreenTileData:  INCBIN "assets/title-spritesheet.2bpp"
titleScreenTileDataEnd:

Tilemap:  INCBIN "assets/title-spritesheet.tilemap"
TilemapEnd:

InitTitleScreen::
  call DrawTitleScreen

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a

  jr UpdateTitleScreenState

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


UpdateTitleScreenState::
  ; Wait for A press
  ; TODO: allow start press

  ; Save the passed value into the variable: mWaitKey
  ; The WaitForKeyFunction always checks against this vriable
  ld a, PADF_A
  ld [mWaitKey], a

  call WaitForKeyFunction

  ld a, 1
  ld [wGameState],a
  jp NextGameState
