; Input utils from GB ASM Tutorial: https://gbdev.io/gb-asm-tutorial/part2/input.html
SECTION "InputUtilsVariables", WRAM0

mWaitKey:: db

SECTION "InputUtils", ROM0

WaitForKeyFunction::
  ; Save our original value
  push bc
	
WaitForKeyFunction_Loop:
  ; save the keys last frame
  ld a, [wCurKeys]
  ld [wLastKeys], a

  call Input

  ld a, [mWaitKey]
  ld b, a
  ld a, [wCurKeys]
  and b
  jp z, WaitForKeyFunction_NotPressed

  ld a, [wLastKeys]
  and b
  jp nz, WaitForKeyFunction_NotPressed

  ; restore our original value
  pop bc

  ret

WaitForKeyFunction_NotPressed:
  call WaitForOneVBlank
  jp WaitForKeyFunction_Loop
