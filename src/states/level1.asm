INCLUDE "hardware.inc/hardware.inc"

SECTION "LEVEL 1", ROM0

LoadLevel1::
    ; Load black tile into VRAM
    ld de, BlackTile
    ld hl, $9010
    ld bc, 16
    call MemCpy

    ; Set up the background tilemap
    ld de, 1
    ld hl, $9880
    ld bc, $9A33 - $9880 + 1
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
