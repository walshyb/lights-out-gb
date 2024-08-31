INCLUDE "hardware.inc/hardware.inc"

SECTION "Screen Funcs", ROM0

TurnOnLCD::
  ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
  ld [rLCDC], a
  ret

ClearBackground::
  ;ld a, 0
  xor a
  ld [rLCDC], a

  ld bc, 1024
  ld hl, $9800

ClearBackgroundLoop:
  ld a, 0
  ld [hli], a

  dec bc
  ld a, b
  or a, c

  jp nz, ClearBackgroundLoop

  call TurnOnLCD

  ret
