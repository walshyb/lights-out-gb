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
  ld a, $0010
  ld [numLevels], a

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
  ld hl, $9841
  ld a, 2
  ld [levelSelectTileOffset], a

  ; bc will contain our counters
  ; b will keep track of tile lines left to print for current block (3 tiles * 3 lines)
  ; c is our loop counter, or how many level blocks we've printed
  ld bc, $0300

  ; Draw row of blocks
  .draw_blocks_loop:
    push hl

    ; Break if we've printed all the levels
    ; If our counter c equals [numLevels], end
    ld a, [numLevels]
    ld l, a
    ld a, c
    cp a, l
    pop hl
    jr z, .draw_blocks_loop_end

    ; if counter is 0, draw block as is
    ld a, c
    cp 0
    jr z, .draw_block

    ; If there is a 1 in bits 0 or 1, draw block.
    ; This is effectively modulo by 4 ( c % 4). We only want 
    ; 4 blocks per line.
    ; If we printed 4, then start a new line and move the
    ; hl pointer to the start of the new row
    bit 0, a
    jr nz, .draw_block
    bit 1, a
    jr nz, .draw_block

    ; Move the hl to the start of the next line
    .move_down_one_row:
    ld de, $70
    add hl, de

    .draw_block:
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
    ; add 1 to level counter
    ld a, c
    inc a
    ld c, a
    jr .draw_blocks_loop

  .draw_blocks_loop_end:

  ret
