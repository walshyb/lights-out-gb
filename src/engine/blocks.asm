INCLUDE "hardware.inc/hardware.inc"

SECTION "Blocks", ROM0

; 0, 1, 32, 33 = 2
; 2, 34 = 4
; 64, 65 = 6
; 66 = 5


; Render level grid
; All blocks "off" by default
RenderBlocks::
  ld hl, $9862 ; Start point
  ld c, 5 ; column counter
  ld b, 5 ; row counter
  jr .renderBlock ; jump to load first block in row

.startNewRow
  ld c, 5 ; reset number of blocks we want in row

  ; next row's start point is 52 (offset from last block's
  ; position) + 32 to go down 1 line
  ld de, 52 + 32 
  add hl, de
  jr .renderBlock ; jump to load first block in row

.addBlockToRow:
  ld de, 3
  add hl, de

.renderBlock:
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

  dec c  ; Decrease column counter
  jr nz, .addBlockToRow
  dec b  ; Decrease row counter
  jr nz, .startNewRow

  ret
