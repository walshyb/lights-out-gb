INCLUDE "hardware.inc/hardware.inc"

; TODO
; this should probably be implemented in the engine's cursor logic
; just with offsets to separate cursor in level or on level select

SECTION "Level Select Cursor Vars", WRAM0

wLevelSelectCursorPositionX:: db
wLevelSelectCursorPositionY:: db
wLevelSelectCursorCurrentRow:: db
wLevelSelectCursorCurrentCol:: db

SECTION "Level Select Cursor", ROM0

LevelSelectCursorData: INCBIN "assets/cursor.2bpp"
LevelSelectCursorDataEnd:

InitLevelSelectCursor::
  ; Set current row and col to 0
  xor a
  ld [wLevelSelectCursorCurrentRow], a
  ld [wLevelSelectCursorCurrentCol], a

  ; Set default position
  ld a, 20
  ld [wLevelSelectCursorPositionX], a
  ld a, 30
  ld [wLevelSelectCursorPositionY], a

  ; Load cursor sprite into VRAM
  ld de, LevelSelectCursorData
  ld hl, $8000
  ld bc, LevelSelectCursorDataEnd - LevelSelectCursorData
  call MemCpy

  ; Set 5 bytes for grid mask to 0
  ld de, DefaultGrid
  ld hl, wGridMask
  ld bc, DefaultGridEnd - DefaultGrid
  call MemCpy

  ; Set palette to white
  ; TODO: set light palette on OnBlocks and dark palette on OffBlocks
  ld a, 0 ; All white (assuming white is color index 0)
  ld [rOBP0], a

  ret

; On A press, flip tiles
HandleLevelSelectAPress::
  ret
 

MoveLevelSelectCursorLeft::
  ; If farthest left we can go, just return
  ld a, [wLevelSelectCursorCurrentCol]
  cp a, 0
  ret z

  ; Update col index
  dec a
  ld [wLevelSelectCursorCurrentCol], a

  ; Move cursor sprite
  ld a, [wLevelSelectCursorPositionX]
  add a, -32
  ld [wLevelSelectCursorPositionX], a
  call DrawLevelSelectCursor

  ret

MoveLevelSelectCursorRight::
  ; If farthest left we can go, just return
  ld a, [wLevelSelectCursorCurrentCol]
  cp a, 3
  ret z

  ; Update col index
  inc a
  ld [wLevelSelectCursorCurrentCol], a

  ; Move cursor sprite
  ld a, [wLevelSelectCursorPositionX]
  add a, 32
  ld [wLevelSelectCursorPositionX], a
  call DrawLevelSelectCursor

  ret

MoveLevelSelectCursorDown::
  ; If farthest left we can go, just return
  ld a, [wLevelSelectCursorCurrentRow]
  cp a, 2
  ret z

  ; Update row index
  inc a
  ld [wLevelSelectCursorCurrentRow], a

  ; Move cursor sprite
  ld a, [wLevelSelectCursorPositionY]
  add a, 32
  ld [wLevelSelectCursorPositionY], a
  call DrawLevelSelectCursor

  ret

MoveLevelSelectCursorUp::
  ; If farthest left we can go, just return
  ld a, [wLevelSelectCursorCurrentRow]
  cp a, 0
  ret z

  ; Update row index
  dec a
  ld [wLevelSelectCursorCurrentRow], a

  ; Move cursor sprite
  ld a, [wLevelSelectCursorPositionY]
  add a, -32
  ld [wLevelSelectCursorPositionY], a
  call DrawLevelSelectCursor

  ret

; Render top left, top right, bottom left, bottom right cursor sprites
DrawLevelSelectCursor::
    ld hl, _OAMRAM

    ld a, [wLevelSelectCursorPositionY]
    ld [hli], a ; write Y
    ld a, [wLevelSelectCursorPositionX]
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld [hli], a ; write attributes

    ld a, [wLevelSelectCursorPositionY]
    ld [hli], a
    ld a, [wLevelSelectCursorPositionX]
    add a, 20
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %00100000 ; flip v
    ld [hli], a ; write attributes

    ld a, [wLevelSelectCursorPositionY]
    add a, 20
    ld [hli], a
    ld a, [wLevelSelectCursorPositionX]
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %01000000 ; flip h
    ld [hli], a ; write attributes

    ld a, [wLevelSelectCursorPositionY]
    add a, 20
    ld [hli], a
    ld a, [wLevelSelectCursorPositionX]
    add a, 20
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %01100000 ; flip h and v
    ld [hli], a ; write attributes
  ret
