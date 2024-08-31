include "hardware.inc/hardware.inc"

SECTION "Interrupts", ROM0

DisableInterrupts::
  ld a, 0
  ldh [rSTAT], a
  di
  ret
