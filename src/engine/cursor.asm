INCLUDE "hardware.inc/hardware.inc"

SECTION "Cursor Vars", WRAM0

wCursorPositionX:: db
wCursorPositionY:: db

SECTION "Cursor", ROM0

CursorData: INCBIN "assets/cursor.2bpp"
CursorDataEnd:

CursorMetasprite::
 .metasprite1   db 0, 0, 0, 0
 .metasprite2   db 0, 8, 2, 0
 .metasprite3   db 0, 18, 2, 0
 .metaspriteEnd db 128

InitCursor::

  ; Set default position
  ld a, 16
  ld [wCursorPositionX], a
  ld a, 39
  ld [wCursorPositionY], a

  ; Top Left
  ld de, CursorData
  ld hl, $8000
  ld bc, CursorDataEnd - CursorData
  call MemCpy

  Ld a, 0 ; All white (assuming white is color index 0)
ld [rOBP0], a
  

  ret

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
    ld a, %00100000 ; flip h and v
    ld [hli], a ; write attributes

    ld a, [wCursorPositionY]
    add a, 14
    ld [hli], a
    ld a, [wCursorPositionX]
    ld [hli], a ; write x
    ld a, 0     ; tile index
    ld [hli], a ; write tile index
    ld a, %01000000 ; flip h and v
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
