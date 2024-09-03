INCLUDE "hardware.inc/hardware.inc"
	rev_Check_hardware_inc 4.0

SECTION "GameVariables", WRAM0

  wLastKeys:: db
  wCurKeys:: db
  wNewKeys:: db
  wGameState::db

SECTION "Header", ROM0[$100]
	; This is your ROM's entry point
	; You have 4 bytes of code to do... something
	di
	jp EntryPoint

	; Make sure to allocate some space for the header, so no important
	; code gets put there and later overwritten by RGBFIX.
	; RGBFIX is designed to operate over a zero-filled header, so make
	; sure to put zeros regardless of the padding value. (This feature
	; was introduced in RGBDS 0.4.0, but the -MG etc flags were also
	; introduced in that version.)
	ds $150 - @, 0

SECTION "Entry point", ROM0

EntryPoint:
  call WaitForOneVBlank

  xor a
  ld [rLCDC], a

  ; Load a grayscale palette
  ld a, $E4
  ld hl, $FF47
  ld [hl], a

  ; Init sprite object library
  call InitSprObjLibWrapper

  call TurnOnLCD

  xor a
  ld [wGameState], a


NextGameState::
  ; Clear background
  call WaitForOneVBlank
  call ClearBackground

  xor a
  ld [rLCDC], a

  call DisableInterrupts

  ld a, [wGameState]

  cp 0
  call z, InitTitleScreen

  cp 1
  call InitLevelEngine
  call z, InitLevel1
  ;call LoadTitleScreen

  ;call WaitForOneVBlank
  ;call InitLevelEngine
  ;call InitLevel1

  ; Clear OAM
  ; Initialize OAM data
  ; Initialize title screen
  ; Initialize level select screen
  ; Clear Background
  ; Clear All Sprites
  ; Load Title Screen

	jr @
  
