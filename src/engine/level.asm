INCLUDE "hardware.inc/hardware.inc"

SECTION "Level Variables", WRAM0

; Reserve 5 bytes for the  level array (grid)
levelGrid:: ds 5

SECTION "Level Engine", ROM0

InitLevelEngine::
  ; Load background
  call InitGameTiles
  call InitCursor
  call LoadBackground
  ret

StartLevel::
  call DrawCursor
  call TurnOnLCD

  .gameLoop:
    call CheckIfWon
    jr z, HandleWin ; If z flag from CheckIfWon is zero
    call HandleKeyPress
    jr .gameLoop

  ret

CheckIfWon::
  ld hl, levelGrid
  ld a, [hli] ; 0
  cp a, 0
  ret nz

  ld a, [hli] ; 1
  cp a, 0
  ret nz

  ld a, [hli] ; 2
  cp a, 0
  ret nz

  ld a, [hli] ; 3
  cp a, 0
  ret nz

  ld a, [hl] ; 4
  cp a, 0
  ret nz

  ret

HandleWin:
  ret

HandleKeyPress:
  ; Super ugly and annoying,
  ; but wait 8 VBlanks before processing key.
  ; Not waiting for these vblanks makes processing go SUPER speed
  call Input
  ld a, 8
  ld [wVBlankCount], a
  call WaitForVBlankFunction

  ; Ideally, I want to do just this.
  ; but i can't *upsidedown face*
  ; it infinite loops randomly??
  ; and sometimes it will process all keys but one??
  ;call WaitForKeyFunction

  ld a, [wCurKeys]
  and PADF_LEFT
  call nz, MoveCursorLeft

  ld a, [wCurKeys]
  and PADF_RIGHT
  call nz, MoveCursorRight

  ld a, [wCurKeys]
  and PADF_UP
  call nz, MoveCursorUp

  ld a, [wCurKeys]
  and PADF_DOWN
  call nz, MoveCursorDown

  ret
  

DefaultGrid:
  db %00000
  db %00000
  db %00000
  db %00000
  db %00000
DefaultGridEnd:

