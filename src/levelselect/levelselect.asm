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
  ; Load number of levels into numLevels variable!
  ld a, $0009
  ld [numLevels], a

  call InitLevelSelectTiles
  call DrawLevelSelectBackground
  call LoadTextFontIntoVRAM
  call InitLevelSelectCursor
  call DrawLevelSelectCursor

  ; Turn on screen
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
  ld [rLCDC], a

  
  .screen_loop:
    call HandleKeyPress
    jr .screen_loop

  ret

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
    ; This is effectively modulo by 4 (c % 4). We only want 
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

      ; .load_level_num_or_1 
      ; checks to see if we're about to
      ; print the "middle" tile in the level block.
      ; if we are, print the level number, 
      ; else, print a solid box
      .load_level_num_or_solid_box:
      ; If we're in the second row,
      ; print the level num
      ld a, b
      cp 2
      jr nz, .load_solid_box

      ; TODO
      ; handle nums more than 10!
      ; handle printing 2 digit nums
      ld a, c
      add 145
      jr .load_solid_box_end

      .load_solid_box: 
      ld a, 1
      .load_solid_box_end:

      ld [hli], a
      .load_level_num_or_solid_box_end:



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

HandleKeyPress:
  ; Super ugly and annoying,
  ; but wait 8 VBlanks before processing key.
  ; Not waiting for these vblanks makes processing go SUPER speed
  call Input
  ld a, 250
  ld [wVBlankCount], a
  call WaitForVBlankFunction

  ; Ideally, I want to do just this.
  ; but i can't *upsidedown face*
  ; it infinite loops randomly??
  ; and sometimes it will process all keys but one??
  ;call WaitForKeyFunction

  ld a, [wCurKeys]
  and PADF_LEFT
  call nz, MoveLevelSelectCursorLeft

  ld a, [wCurKeys]
  and PADF_RIGHT
  call nz, MoveLevelSelectCursorRight

  ld a, [wCurKeys]
  and PADF_UP
  call nz, MoveLevelSelectCursorUp

  ld a, [wCurKeys]
  and PADF_DOWN
  call nz, MoveLevelSelectCursorDown

  ld a, [wCurKeys]
  and PADF_A
  call nz, HandleAPress

  ret
