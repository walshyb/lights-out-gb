INCLUDE "hardware.inc/hardware.inc"

SECTION "LEVEL 1", ROM0


BlackTileData:  INCBIN "assets/blacktile.2bpp"
BlackTileDataEnd:

BlackTileMap:  INCBIN "assets/blacktile.tilemap"
BlackTileMapEnd:


LoadLevel1::
    ; Load black tile into VRAM
    ld de, BlackTileData
    ld hl, $9000
    ld bc, BlackTileDataEnd - BlackTileData
    call MemCpy

    call TurnOnLCD

    ; Set up the background tilemap
    ; Just trying to get a single black tile to appear, no dice
    ; This makes the whole screen black
    ld de, BlackTileMap 
    ld hl, $9800
    ld bc, BlackTileMapEnd - BlackTileMap
    call MemCpyNoDeInc

    ret

; Define a black tile (8x8 pixels), all bits set to FF
BlackTile:
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
    db $FF, $FF
BlackTileEnd:

; Here temporarily
; This does, effectively, what MemCpy does
; but does not increment de because it's only
; reading from one address in vram
MemCpyNoDeInc::
  ld a, [de]
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, MemCpyNoDeInc
	ret
