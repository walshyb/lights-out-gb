INCLUDE "hardware.inc/hardware.inc"

SECTION "Blocks", ROM0

; Render level grid
; All blocks "off" by default
RenderBlocks::
  ld hl, $9862 ; Start point
  ld c, 0 ; column counter
  ld b, 0 ; row counter
  jr .getCurrentBlockValue; jump to load first block in row

.startNewRow
  ld c, 0 ; reset number of blocks we want in row

  ; next row's start point is 52 (offset from last block's
  ; position) + 32 to go down 1 line
  ; TODO:
  ; Figure out how to fetch original hl value so we don't have to
  ; do this ugly math :) 
  ld de, 49 + 32
  add hl, de

  
.moveToNextBlockPosition:
  ld de, 3
  add hl, de

; Get value of current block (On or Off)
.getCurrentBlockValue:
  push hl ; save current hl

  ld e, b ; save b, row counter, in e

  ; Get address of levelGrid
  ld hl, levelGrid

  ; Assign row counter to a
  ld a, b

  ; hl + b to get current row's line value in memory
  add a, l
  ld l, a
  adc a, h
  sub l
  ld h, a

  ; Look up bit c in hl. zero flag set accordingly
  ld d, c        ; copy column counter c into d
  ld a, 0
  cp a, d        ; Check if d is 0
  ld a, [hl]     ; load byte into a. z should not be changed
  ld b, %10000   ; binary byte used for comparing grid row byte
  jr z, .testBit ; jump straight to bit check if column index 0 is 0

  ; shift the 1 bit right in b for the number of columns (c) we have in the row
  .testBitLoop: 
    sra b
    dec d
    jr nz, .testBitLoop
    
  ; compare b against [hl], i.e. 10000 (b) vs 11000 ([hl]).
  ; if there's a 1 in both places, then Z will be set to 0
  .testBit:
    and b ; bitwise and against value in A

  pop hl ; restore hl position
  ld b, e ; restore b, the row count
  jr nz, .renderOnBlock  ; If Z is a one, render an On block
  jr z, .renderOffBlock ; If Z is 0, render an Off BLock

.checkEnd:
  ld a, b
  and a, c


.renderOffBlock:
  ; Tile 2 get's applied to hl + 0, hl + 1, hl + 32, hl + 33
  ld a, $02

  ld [hl], a

  push hl               ; Save HL on the stack
  inc hl                ; HL = HL + 1
  ld [hl], a            

  ld de, 31             
  add hl, de            ; HL = HL + 32
  ld [hl], a           

  inc hl              
  ld [hl], a         
  pop hl                ; Restore HL from the stack

  ; Tile 4 get's applied to hl + 2, hl + 34
  push hl
  inc hl
  inc hl 
  ld a, $04
  ld [hl], a

  ld de, 32
  add hl, de 
  ld [hl], a    
  pop hl

  ; Tile 6 get's applied to hl + 64, hl + 65
  push hl
  ld de, 64 
  add hl, de  
  ld a, $06
  ld [hl], a  

  inc hl 
  ld [hl], a
  pop hl

  ; Tile 5 get's applied to hl + 66
  push hl
  ld de, 66 
  add hl, de 
  ld a, $05
  ld [hl], a 
  pop hl

  inc c  ; Increase column counter
  ld a, 5
  cp a, c ; If we've added 5 blocks to row
  jr nz, .moveToNextBlockPosition
  inc b ; Increase row counter
  ld a, 5
  cp a, b
  jr nz, .startNewRow
  jp z, .end

; TODO: consolidate with renderOffBlock
.renderOnBlock:
  ; Tile 3 get's applied to hl + 0, hl + 1, hl + 32, hl + 33
  ld a, $03

  ld [hl], a

  push hl               ; Save HL on the stack
  inc hl                ; HL = HL + 1
  ld [hl], a            

  ld de, 31             
  add hl, de            ; HL = HL + 32
  ld [hl], a           

  inc hl              
  ld [hl], a         
  pop hl                ; Restore HL from the stack

  ; Tile 7 get's applied to hl + 2, hl + 34
  push hl
  inc hl
  inc hl 
  ld a, $07
  ld [hl], a

  ld de, 32
  add hl, de 
  ld [hl], a    
  pop hl

  ; Tile 9 get's applied to hl + 64, hl + 65
  push hl
  ld de, 64 
  add hl, de  
  ld a, $09
  ld [hl], a  

  inc hl 
  ld [hl], a
  pop hl

  ; Tile 8 get's applied to hl + 66
  push hl
  ld de, 66 
  add hl, de 
  ld a, $08
  ld [hl], a 
  pop hl

  inc c  ; Increase column counter
  ld a, 5
  cp a, c ; If we've added 5 blocks to row
  jp nz, .moveToNextBlockPosition
  inc b ; Increase row counter
  ld a, 5
  cp a, b
  jp nz, .startNewRow

.end:
  ret
