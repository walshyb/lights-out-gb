INCLUDE "hardware.inc/hardware.inc"

SECTION "Cursor Vars", WRAM0

wCursorPositionX:: db
wCursorPositionY:: db
wCursorCurrentRow:: db
wCursorCurrentCol:: db

SECTION "Cursor", ROM0

CursorData: INCBIN "assets/cursor.2bpp"
CursorDataEnd:

InitCursor::
  ; Set current row and col to 0
  xor a
  ld [wCursorCurrentRow], a
  ld [wCursorCurrentCol], a

  ; Set default position
  ld a, 16
  ld [wCursorPositionX], a
  ld a, 39
  ld [wCursorPositionY], a

  ; Load cursor sprite into VRAM
  ld de, CursorData
  ld hl, $8000
  ld bc, CursorDataEnd - CursorData
  call MemCpy

  ; Set palette to white
  ; TODO: set light palette on OnBlocks and dark palette on OffBlocks
  ld a, 0 ; All white (assuming white is color index 0)
  ld [rOBP0], a

  ret

MoveCursorLeft::
  ; If farthest left we can go, just return
  ld a, [wCursorCurrentCol]
  cp a, 0
  ret z

  ; Update col index
  dec a
  ld [wCursorCurrentCol], a

  ; Move cursor sprite
  ld a, [wCursorPositionX]
  add a, -24
  ld [wCursorPositionX], a
  call DrawCursor

  ret

MoveCursorRight::
  ; If farthest left we can go, just return
  ld a, [wCursorCurrentCol]
  cp a, 4
  ret z

  ; Update col index
  inc a
  ld [wCursorCurrentCol], a

  ; Move cursor sprite
  ld a, [wCursorPositionX]
  add a, 24
  ld [wCursorPositionX], a
  call DrawCursor

  ret

MoveCursorDown::
  ; If farthest left we can go, just return
  ld a, [wCursorCurrentRow]
  cp a, 4
  ret z

  ; Update row index
  inc a
  ld [wCursorCurrentRow], a

  ; Move cursor sprite
  ld a, [wCursorPositionY]
  add a, 24
  ld [wCursorPositionY], a
  call DrawCursor

  ret

MoveCursorUp::
  ; If farthest left we can go, just return
  ld a, [wCursorCurrentRow]
  cp a, 0
  ret z

  ; Update row index
  dec a
  ld [wCursorCurrentRow], a

  ; Move cursor sprite
  ld a, [wCursorPositionY]
  add a, -24
  ld [wCursorPositionY], a
  call DrawCursor

  ret

; Render top left, top right, bottom left, bottom right cursor sprites
DrawCursor::
    ld hl, _OAMRAM

    ld a, [wCursorPositionY]
    ld [hli], a ; write Y
    ld a, [wCursorPositionX]
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld [hli], a ; write attributes

    ld a, [wCursorPositionY]
    ld [hli], a
    ld a, [wCursorPositionX]
    add a, 14
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %00100000 ; flip v
    ld [hli], a ; write attributes

    ld a, [wCursorPositionY]
    add a, 14
    ld [hli], a
    ld a, [wCursorPositionX]
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %01000000 ; flip h
    ld [hli], a ; write attributes

    ld a, [wCursorPositionY]
    add a, 14
    ld [hli], a
    ld a, [wCursorPositionX]
    add a, 14
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %01100000 ; flip h and v
    ld [hli], a ; write attributes
  ret
