SECTION "Text", ROM0

textFontTileData: INCBIN "assets/Insigbyte.2bpp"
textFontTileDataEnd:

LoadTextFontIntoVRAM::
  ld de, textFontTileData 
  ld hl, $8800
  ld bc, textFontTileDataEnd - textFontTileData 
  call MemCpy
  ret

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
  
  ; subtract the value in a (the tile index) by $80 
  ; so we can read from the font tile data in vram, opposed to
  ; the background data
  sub $80
  ld [de], a
  inc de

  jp DrawTextTilesLoop


