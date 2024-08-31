INCLUDE "hardware.inc/hardware.inc"

SECTION "Miscellaneous Funcs", ROM0

TurnOffLCD::
  xor a
  ld [rLCDC], a
  ret

TurnOnLCD::
  ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
  ld [rLCDC], a
  ret
