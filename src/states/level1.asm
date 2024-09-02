INCLUDE "hardware.inc/hardware.inc"

SECTION "LEVEL 1", ROM0

LoadLevel1::
    ; Load black tile into VRAM
    ld de, BlackTile
    ld hl, $9010
    ld bc, 16
    call MemCpy

    call LoadBackground

    ret

; Loads 1 in addresses $9880 - $9A33. Effectively, our background "tilemap"
; This is because our black tile is in the first index ($9010) of VRAM
LoadBackground::
  ld hl, $9880  ;Start point
  ld bc, $9A33 - $9880 + 2

.loop
  ld a, 1
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .loop
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
