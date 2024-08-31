INCLUDE "hardware.inc/hardware.inc"

SECTION "SpriteVariables", WRAM0

wLastOAMAddress:: dw
wSpritesUsed:: db

SECTION "Sprite Funcs", ROM0

ClearAllSprites::

  ; Start clearing oam
  ;ld a, 0
  xor a
  ld b, OAM_COUNT * sizeof_OAM_ATTRS ;40 sprites times 4 bytes per sprite
  ld hl, wShadowOAM ; start of our oam sprites in RAM

ClearOamLoop::
  ld [hli], a
  dec b
  jp nz, ClearOamLoop
  ld a, 0
  ld [wSpritesUsed], a

  ; from sprobj-lib
  ; run the following during VBlank
  ld a, HIGH(wShadowOAM)
  call hOAMDMA

  ret

ClearRemainingSprites::

ClearRemainingSpritesLoop::

  ; get our offset address in hl
  ld a, [wLastOAMAddress+0]
  ld l, a
  ld a, HIGH(wShadowOAM)
  ld h, a

  ld a, l
  cp a, 160

  ; Need two rets?
  ret nc
  ret nc

  ; set the y and x to be 0
  ld a, 0
  ld [hli], a
  ld [hld], a

  ; Move up 4 bytes
  ld a, l
  add a, 4
  ld l, a

  call NextOAMSprite

  jp ClearRemainingSpritesLoop

ResetOAMSpriteAddress::
  ld a, 0
  ld [wSpritesUsed], a

  ld a, LOW(wShadowOAM)
  ld [wLastOAMAddress+0], a
  ld a, HIGH(wShadowOAM)
  ld [wLastOAMAddress+1], a
  ret

NextOAMSprite::
  ld a, [wSpritesUsed]
  inc a
  ld [wSpritesUsed], a

  ld a, [wLastOAMAddress+0]
  add a, sizeof_OAM_ATTRS
  ld [wLastOAMAddress+0], a
  ld a, HIGH(wShadowOAM)
  ld [wLastOAMAddress+1], a

  ret
