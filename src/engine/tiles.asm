INCLUDE "hardware.inc/hardware.inc"

SECTION "Game Engine", ROM0

InitGameTiles::
    ; Load black tile into VRAM
    ld de, BlackTile
    ld hl, $9010
    ld bc, 16
    call MemCpy

    ; Load black tile into VRAM
    ld de, OffTile
    ld hl, $9020
    ld bc, 16
    call MemCpy

    ; Load black tile into VRAM
    ld de, OnTile
    ld hl, $9030
    ld bc, 16
    call MemCpy

    ; Load black tile into VRAM
    ld de, OffTileRight
    ld hl, $9040
    ld bc, 16
    call MemCpy

    ; Load black tile into VRAM
    ld de, OffTileBottomRight
    ld hl, $9050
    ld bc, 16
    call MemCpy

    ; Load black tile into VRAM
    ld de, OffTileBottom
    ld hl, $9060
    ld bc, 16
    call MemCpy

    ret

; Loads 1 in addresses $9880 - $9A33. Effectively, our background "tilemap"
; This is because our black tile is in the first index ($9010) of VRAM
LoadBackground::
  ld hl, $9880  ;Start point
  ld bc, $9A33 - $9880 + 2

.loop
  ld a, 1
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .loop
  ret


; TODO: get start point
; Render 1 block
RenderBlock::
  ld a, $02

  ld hl, $98C2
  ld [hl], a

  ld hl, $98C2 + 1
  ld [hl], a

  ld hl, $98C2 + 32
  ld [hl], a

  ld hl, $98C2 + 33
  ld [hl], a

  ld a, $04
  ld hl, $98C2 + 2
  ld [hl], a

  ld hl, $98C2 + 34
  ld [hl], a

  ld a, $06
  ld hl, $9902
  ld [hl], a

  ld hl, $9902 + 1
  ld [hl], a

  ld a, $05
  ld hl, $9902 + 2
  ld [hl], a


  ret



; Define a black tile (8x8 pixels), all bits set to FF
BlackTile:
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
BlackTileEnd:


OffTile:
    dw `11111111
    dw `11111111
    dw `11111111
    dw `11111111
    dw `11111111
    dw `11111111
    dw `11111111
    dw `11111111
OffTileEnd:

OffTileRight:
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
OffTileRightEnd:

OffTileBottomRight:
  dw `11113333
  dw `11113333
  dw `11113333
  dw `11113333
  dw `33333333
  dw `33333333
  dw `33333333
  dw `33333333
OffTileBottomRightEnd:

OffTileBottom:
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
  dw `33333333
  dw `33333333
  dw `33333333
  dw `33333333
OffTileBottomEnd:

OnTile:
    dw `22222222
    dw `22222222
    dw `22222222
    dw `22222222
    dw `22222222
    dw `22222222
    dw `22222222
    dw `22222222
OnTileEnd:

