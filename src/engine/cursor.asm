INCLUDE "hardware.inc/hardware.inc"

SECTION "Cursor Vars", WRAM0

wCursorPositionX:: db
wCursorPositionY:: db
wCursorCurrentRow:: db
wCursorCurrentCol:: db
wGridMask:: ds 5

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
HandleAPress::
  ld a, [wCursorCurrentRow] ; load row index into b
  ld b, a
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;   Add pattern to mask          ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;
  ; Add a plus pattern to wGridMask
  ; For example, if row (b) is 1 and col (c) is 1,
  ; the mask grid will look like:
  ; 01000
  ; 11100
  ; 01000
  ; 00000
  ; 00000
  xor a
  ld d, a ; d is our index
  ld hl, wGridMask 
.addPatternToMask:
  ld a, d ; load index d into a
  sub a, b ; subtract b from a
  cp a, 0 ; if b == index
  jr z, .assignRow1C
  cp a, 1 ; if a-b == index + 1
  jr z, .assignRow08
  cp a, -1 ; if a-b == index - 1
  jr z, .assignRow08
  jr nz, .addPatternLoopEnd ; else, prep next iteration
.assignRow1C:
  ld a, $1C 
  ; grid[index] = 1c, or %11100
  ld [hl], a ; set grid row to 1C, and inc to next row
  jr .addPatternLoopEnd
.assignRow08:
  ld a, $08
  ; grid[index] = $08, or %01000
  ld [hl], a ; set grid row to 08, and inc to next row
.addPatternLoopEnd:
  ; increment hl (grid index) and d (loop counter)
  inc hl
  inc d
  ; Break if loop hits 5th iteration (because only 5 rows in grid)
  ld a, d
  cp a, 5
  jr nz, .addPatternToMask
.addPatternToMaskEnd:

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;   Shift Grid Mask              ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Shift every row in wGridMask accordingly
  ; if c == 0:
  ;   shift grid[index] left
  ; if c > 0:
  ;   shift grid[index] right c-1 times
  ld a, [wCursorCurrentCol] ; load col index into c
  ld c, a

  ; If column 1 is, no need to shift mask left or right.
  ; Skip to xor'ing the mask and the level grids
  cp a, 1
  jr z, .shiftGridMaskEnd

  ld hl, wGridMask
  ld d, 0 ; grid row index
.shiftGridMask:
  ld e, c ; grid col index
  dec e   ; set e to c - 1

  ld a, c
  cp a, 0
  ld a, [hl] ; load grid row value into a
  jr nz, .shiftRowRightETimes
.shiftRowLeft:
  ; if col == 0, shift left 1 bit. we do this for all rows.
  ; we actually only need to shift b, b-1, and b+1 rows left,
  ; but it's easier to just do all of them.
  sla a ; shift left arithmetic our current row's data
  ld [hl], a ; load value back into the mask grid's row
  jr .shiftGridLoopEnd ; next iteration
.shiftRowRightETimes:
  ; if col > 1, shift value in a right c -1 times
  srl a
  dec e
  jr nz, .shiftRowRightETimes
  ld [hl], a
.shiftGridLoopEnd:
  ; go to next row in grid
  inc hl

  ; increment row counter
  inc d

  ; break if d is 5
  ld a, d
  cp a, 5
  jr nz, .shiftGridMask
.shiftGridMaskEnd:
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;  XOR level grid against mask   ; 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; xor's each row in level grid against each row in .grid
  ; this makes it so if there is a 1 in the place in each row, then that bit gets flipped to 0
  ld hl, levelGrid
  ld de, wGridMask

  ld a, [hl] ; first value in level grid into a
  push hl
  ld h, d
  ld l, e
  ld b, [hl] ; store first value in .grid into b
  pop hl
  xor b      ; and result store in a
  ld [hli], a ; update level grid row (+ inc levelgrid row)
  inc de  ; inc .grid row

  ld a, [hl] ; first value in level grid into a
  push hl
  ld h, d
  ld l, e
  ld b, [hl] ; store first value in .grid into b
  pop hl
  xor b      ; and result store in a
  ld [hli], a ; update level grid row (+ inc levelgrid row)
  inc de  ; inc .grid row

  ld a, [hl] ; first value in level grid into a
  push hl
  ld h, d
  ld l, e
  ld b, [hl] ; store first value in .grid into b
  pop hl
  xor b      ; and result store in a
  ld [hli], a ; update level grid row (+ inc levelgrid row)
  inc de  ; inc .grid row

  ld a, [hl] ; first value in level grid into a
  push hl
  ld h, d
  ld l, e
  ld b, [hl] ; store first value in .grid into b
  pop hl
  xor b      ; and result store in a
  ld [hli], a ; update level grid row (+ inc levelgrid row)
  inc de  ; inc .grid row

  ld a, [hl] ; first value in level grid into a
  push hl
  ld h, d
  ld l, e
  ld b, [hl] ; store first value in .grid into b
  pop hl
  xor b      ; and result store in a
  ld [hli], a ; update level grid row (+ inc levelgrid row)
  inc de  ; inc .grid row

  ; Reset 5 bytes of grid mask to 0
  ld de, DefaultGrid
  ld hl, wGridMask
  ld bc, DefaultGridEnd - DefaultGrid
  call MemCpy

  call WaitForOneVBlank
  ld a, 0
  ld [rLCDC], a
  call RenderBlocks

  call TurnOnLCD

  ; TODO: reset .grid back to 0?

  ret

.grid:
  db %00000 ; 00
  db %00000 ; 00
  db %00000 ; 00
  db %00000 ; 00
  db %00000 ; 00
.gridEnd:

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
