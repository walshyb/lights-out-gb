INCLUDE "hardware.inc/hardware.inc"

SECTION "Cursor Vars", ROM0

wCursorPositionX:: db
wCursorPositionY:: db

SECTION "Cursor", ROM0

CursorData: INCBIN "assets/cursor.2bpp"
CursorDataEnd:

CursorMetasprite::
 .metasprite1   db 0, 0, 0, 0
 .metasprite2   db 0, 8, 2, 0
 .metaspriteEnd db 128

InitCursor::

  ld a, 5
  ld [wCursorPositionX], a
  ld [wCursorPositionY], a

  ; Top Left
  ld de, CursorData
  ld hl, $8000
  ld bc, CursorDataEnd - CursorData
  call MemCpy
  
  ; Top Right
  ld de, CursorData
  ld hl, $8010
  ld bc, CursorDataEnd - CursorData
  call MemCpy


  ret
