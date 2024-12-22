INCLUDE "hardware.inc/hardware.inc"
INCLUDE "util/text-macros.inc"

SECTION "Level Select", ROM0

InitLevelSelectScreen::
  ; load level tiles

  ; load cursor sprite

  ; TODO: fetch save data

  ; draw tiles
  ;   start at $9860

  ; allow player input

MiddleTile:
  db $FF, $FF ; dw `33333333
  db $FF, $FF 
  db $FF, $FF 
  db $FF, $FF 
  db $FF, $FF 
  db $FF, $FF 
  db $FF, $FF 
  db $FF, $FF 
MiddleTileEnd:

; Tile for left side of level select blocks in leftmost column (i.e. 1) in a row
OnesLeftTile:
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
  dw `11111133
OnesLeftTileEnd:

; Tile for right side of level select blocks in leftmost column (i.e. 1) in a row
OnesRightTile:
  dw `33111111
  dw `33111111
  dw `33111111
  dw `33111111
  dw `33111111
  dw `33111111
  dw `33111111
  dw `33111111
OnesRightTileEnd:

; Left side of 2 block
TwosLeftTile:
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
  dw `11133333
TwosLeftTileEnd:

; Right side of 2 block
TwosRightTile:
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
TwosRightTileEnd:

; Right side of 2 block
TwosRightTile:
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
 dw `33311111
TwosRightTileEnd:

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
