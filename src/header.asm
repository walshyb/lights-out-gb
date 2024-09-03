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

  ; Init sprite object library
  call InitSprObjLibWrapper



  ; Clear background
  call WaitForOneVBlank
  call ClearBackground
  call WaitForOneVBlank

  ; turn off LCD
  ld a, 0
  ld [rLCDC], a
  ld [rSCX], a
  ld [rSCY], a
  ld [rWX], a
  ld [rWY], a

  ; Load a grayscale palette
  ld a, $E4
  ld hl, $FF47
  ld [hl], a
  
  ; disable interrupts
  ;call DisableInterrupts
  ;ld a, 0
	;ldh [rSTAT], a
	;di

  ;call InitTitleScreen
  ;call LoadTitleScreen

  
  ;call WaitForOneVBlank
  call InitLevelEngine
  call InitLevel1
  call TurnOnLCD

  ; Clear OAM
  ; Initialize OAM data
  ; Initialize title screen
  ; Initialize level select screen
  ; Clear Background
  ; Clear All Sprites
  ; Load Title Screen

	jr @
  
