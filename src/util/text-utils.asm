SECTION "Text", ROM0

textFontTileData: INCBIN "assets/fonts/text-font.2bpp"
textFontTileDataEnd:

LoadTextFontIntoVRAM::
  ld de, textFontTileData 
  ld hl, $9000
  ld bc, textFontTileDataEnd - textFontTileData 
  jp MemCpy

; @param hl the address of the start of the string we want to write
; @param de the address where we want to start writing
DrawTextTiles::
DrawTextTilesLoop:
  ; Check for end of string char, 255
  ; return if found
  ld a, [hl]
  cp 255
  ret z

  ; Write current character (in hl) to the address on the tilemap
  ld a, [hli]
  ld [de], a
  inc de

  jp DrawTextTilesLoop


