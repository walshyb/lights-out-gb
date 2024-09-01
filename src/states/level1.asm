INCLUDE "hardware.inc/hardware.inc"

SECTION "LEVEL 1", ROM0


LoadLevel1::
    ld de, BlackTile
    ld hl, $9000
    ld bc, BlackTileEnd - BlackTile           
    call MemCpy

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a

  ; Fill the lower half of the screen with the black tile (index 0)
    ld hl, $9800 + (20 * 32) ; Start at the 10th row (0-indexed)
    ld de, 10 * 32           ; Rows to cover (bottom half)
        ld a, 0            ; Tile index for the black tile
FillRow:
    ld [hl+], a        ; Write tile index to the map
    dec de
    ld a, d
    or e
    jr nz, FillRow

    ret

; Define a black tile (8x8 pixels), all bits set to 0
BlackTile:
    db $00, $00  ; 1st row
    db $00, $00  ; 2nd row
    db $00, $00  ; 3rd row
    db $00, $00  ; 4th row
    db $00, $00  ; 5th row
    db $00, $00  ; 6th row
    db $00, $00  ; 7th row
    db $00, $00  ; 8th row
BlackTileEnd:
