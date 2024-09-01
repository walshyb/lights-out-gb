INCLUDE "hardware.inc/hardware.inc"

SECTION "LEVEL 1", ROM0

LoadLevel1::
    ; Load black tile into VRAM
    ld de, BlackTile
    ld hl, $9000
    ld bc, 16
    call MemCpy

    call TurnOnLCD

    ; Set up the background tilemap
    ; Trying to make $9800 - $9A33 black tiles (read from $9000)
    ; This makes the debugger screen mostly black, with some white boxes
    ; And eventually the emulator screen goes fully black
    ld de, $9000
    ld hl, $9880
    ld bc, $9A33 - $9800
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
