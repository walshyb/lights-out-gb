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
  ld de, 52 + 32 
  add hl, de

; Get value of current block (On or Off)
.getCurrentBlockValue:
  push hl ; save current hl

  ; Get address of levelGrid
  ld hl, levelGrid
  ; add b*2 to get address of bytes for current row
  ld e, b ; save b into e
  ld a, b
  add a, a
  ; load current row&column's address to HL
  add a, l
  ld l, a
  adc a, h
  sub l
  ld h, a
  ; for c times, do SLA on HL to set C equal to current row and column's value
  ld b, c ; save current value of c, since this is our  column counter and c is going to be overwritten by sla
  ld d, c
  ld a, 0
  cp a, c
  jr z, .loopEnd ; skip loop if 0th index in row
  .loop:
    sla [hl]
    dec d
    jr nc, .loop
  .loopEnd:
  ; if c is 0, render black block
  ; else render white block
  pop hl
  ld b, e
  jr c, .renderOffBlock  ; If carry is a one, render an On block
  jr nc, .renderOffBlock ; If carry is 0, render an Off BLock
  


.moveToNextBlockPosition:
  ld de, 3
  add hl, de

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

  ret
