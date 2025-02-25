INCLUDE "hardware.inc/hardware.inc"

SECTION "Block Tiles", ROM0

InitGameTiles::
    ; Load black tile into VRAM
    ld de, BlackTile
    ld hl, $9010
    ld bc, 16
    call MemCpy

    ld de, OffTile
    ld hl, $9020
    ld bc, 16
    call MemCpy

    ld de, OffTileRight
    ld hl, $9040
    ld bc, 16
    call MemCpy

    ld de, OffTileBottomRight
    ld hl, $9050
    ld bc, 16
    call MemCpy

    ld de, OffTileBottom
    ld hl, $9060
    ld bc, 16
    call MemCpy

    ld de, OnTile
    ld hl, $9030
    ld bc, 16
    call MemCpy

    ld de, OnTileRight
    ld hl, $9070
    ld bc, 16
    call MemCpy

    ld de, OnTileBottomRight
    ld hl, $9080
    ld bc, 16
    call MemCpy

    ld de, OnTileBottom
    ld hl, $9090
    ld bc, 16
    call MemCpy

    ret

; Loads 1 in addresses $9880 - $9A33. Effectively, our background "tilemap"
; This is because our black tile is in the first index ($9010) of VRAM
LoadBackground::
  ld hl, $9840  ;Start point
  ld bc, $9A33 - $9840 + 2

.loop
  ld a, 1
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .loop
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


OnTileBottom:
  dw `22222222
  dw `22222222
  dw `22222222
  dw `22222222
  dw `33333333
  dw `33333333
  dw `33333333
  dw `33333333
OnTileBottomEnd:

OnTileRight:
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
OnTileRightEnd:

OnTileBottomRight:
  dw `22223333
  dw `22223333
  dw `22223333
  dw `22223333
  dw `33333333
  dw `33333333
  dw `33333333
  dw `33333333
OnTileBottomRightEnd:

InitLevelSelectTiles::
  ld de, BlackTile
  ld hl, $9000
  ld bc, 16
  call MemCpy

  ; load level tiles
  ld de, MiddleTile
  ld hl, $9010
  ld bc, 16
  call MemCpy

  ld de, OnesLeftTile 
  ld hl, $9020
  ld bc, 16
  call MemCpy

  ld de, OnesRightTile 
  ld hl, $9030
  ld bc, 16
  call MemCpy

  ld de, TwosLeftTile 
  ld hl, $9040
  ld bc, 16
  call MemCpy

  ld de, TwosRightTile 
  ld hl, $9050
  ld bc, 16
  call MemCpy

  ld de, ThreesLeftTile 
  ld hl, $9060
  ld bc, 16
  call MemCpy

  ld de, ThreesRightTile 
  ld hl, $9070
  ld bc, 16
  call MemCpy

  ld de, FoursLeftTile 
  ld hl, $9080
  ld bc, 16
  call MemCpy

  ld de, FoursRightTile 
  ld hl, $9090
  ld bc, 16
  call MemCpy

  ret

MiddleTile:
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
  dw `11111111
MiddleTileEnd:

; Tile for right side of level select blocks in leftmost column (i.e. 1) in a row
OnesRightTile:
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
OnesRightTileEnd:

; Tile for left side of level select blocks in leftmost column (i.e. 1) in a row
OnesLeftTile:
  dw `33333311
  dw `33333311
  dw `33333311
  dw `33333311
  dw `33333311
  dw `33333311
  dw `33333311
  dw `33333311
OnesLeftTileEnd:

; Right side of 2 block
TwosRightTile:
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
TwosRightTileEnd:

; Left side of 2 block
TwosLeftTile:
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
TwosLeftTileEnd:

; Left side of 3 block
ThreesLeftTile:
  dw `13333333
  dw `13333333
  dw `13333333
  dw `13333333
  dw `13333333
  dw `13333333
  dw `13333333
  dw `13333333
ThreesLeftTileEnd:

; Right side of 3 block
ThreesRightTile:
  dw `31111111
  dw `31111111
  dw `31111111
  dw `31111111
  dw `31111111
  dw `31111111
  dw `31111111
  dw `31111111
ThreesRightTileEnd:

; Left side of 4 block
FoursLeftTile:
  dw `11111333
  dw `11111333
  dw `11111333
  dw `11111333
  dw `11111333
  dw `11111333
  dw `11111333
  dw `11111333
FoursLeftTileEnd:

; Right side of 4 block
FoursRightTile:
  dw `33333111
  dw `33333111
  dw `33333111
  dw `33333111
  dw `33333111
  dw `33333111
  dw `33333111
  dw `33333111
FoursRightTileEnd:
