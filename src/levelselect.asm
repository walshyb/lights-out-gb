INCLUDE "hardware.inc/hardware.inc"
INCLUDE "util/text-macros.inc"

SECTION "Level Select Variables", WRAM0

; Tileset offset
; 1 is is a black box, or the "middle tile" for this screen
; 2 and 3 should be left and right sides of leftmost boxes
; 4 and 5 should be left and right sides of second box, etc
levelSelectTileOffset:: ds 1

; Number of levels
numLevels:: ds 1

SECTION "Level Select", ROM0


levelSelectTileData: INCBIN "assets/levelselect.2bpp"
levelSelectTileDataEnd:

levelSelectTilemap: INCBIN "assets/levelselect.tilemap"
levelSelectTilemapEnd:

InitLevelSelectScreen::
  call InitLevelSelectTiles
  call DrawLevelSelectBackground

  ld a, LCDCF_ON | LCDCF_BGON
  ld [rLCDC], a

  ret

  ; call InitLevelSelectTiles
  ; load cursor sprite
  ; draw tiles
  ;   start at $9860


  ; TODO: fetch save data
  ; allow player input

DrawLevelSelectBackground:
  ld hl, $9861
  ld a, 2
  ld [levelSelectTileOffset], a

  ; bc will contain our counters
  ; b will keep track of tiles left to print
  ; c keeps track of how many levels we have left to print
  ld bc, $0304

  ; Draw row of blocks
  .draw_blocks_loop:
    ; If c is 0, we've printed all a block for each level
    ld a, c
    cp 0
    jr z, .draw_blocks_loop_end
    
    push hl

    ; draw 3 rows of tiles for current block
    .draw_tile_loop:
      ; if b is 0, we've printed all the tiles for this block
      ld a, b
      cp 0
      jr z, .draw_tile_loop_end

      push hl

      ld a, [levelSelectTileOffset]
      ld [hli], a 

      ld a, 1
      ld [hli], a

      ld a, 1
      ld [hli], a

      ld a, [levelSelectTileOffset]
      add 1
      ld [hli], a 

      pop hl

      ld de, $20
      add hl, de

      ; Subtract 1 from tile counter
      ; TODO check for end tile loop here?
      ld a, b
      sub 1
      ld b, a
      jr .draw_tile_loop
    .draw_tile_loop_end:

    ; Get the hl value we saved, and move hl over
    ; by 4 tiles we can print the next block
    pop hl
    ld de, $04
    add hl, de

    ; Reset number of tiles we have to print 
    ld a, 3
    ld b, a

    ; TODO maybe check for end loop here?
    ; subtrack 1 from level counter
    ld a, c
    sub 1
    ld c, a
    jr .draw_blocks_loop

    ; TODO: jump down 1 row after printing 4 blocks


  .draw_blocks_loop_end:






    
  
  ret
