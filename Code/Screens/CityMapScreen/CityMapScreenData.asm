*= $2a50
MAP_CHARSET:
    .import binary "..\Content\CityMapData.bin"

*= $3a04
TEXT_CITY_PK_ENERGY:
    .text "CITY'S PK ENERGY: "

*= $3a16
TEXT_NO_EMPTY_TRAPS:
    .text "YOU HAVE NO EMPTY TRAPS. GO BACK TO GHQ. " + @"\$ff"

*= $3a40
TEXT_NO_BACKUP_MEN:
    .text "YOUR BACKUP MEN ARE ALL OUT OF ACTION. GO BACK TO GHQ. " + @"\$ff"

*= $3a78
TEXT_SORRY_NO_BAIT:
    .text "SORRY, NO BAIT. " + @"\$ff"

*= $3a89
TEXT_BACKPACKS_DISCHARGED:
    .text "BACKPACKS DISCHARGED. GO BACK TO GHQ. " + @"\$ff"

*= $3ab0
TEXT_MARSHMALLOW_ALERT:
    .text "-MARSHMALLOW ALERT- " + @"\$ff"

*= $3ac5
TEXT_MARSHMALLOW_MAN_DAMAGE:
    .text "MARSHMALLOW MAN DID $4000 WORTH OF DAMAGE. THAT AMOUNT WILL BE DEDUCTED FROM YOUR BALANCE. " + @"\$ff"

*= $3b21
TEXT_MARSHMALLOW_REWARD:
    .text "MAYOR AWARDS YOU $2000 FOR AVERTING MARSHMALLOW CATASTROPHE. " + @"\$ff"

*= $3767
STREET_NAME_1:
    .byte $6E,$6F,$70,$71,$72,$73,$74,$75,$76,$6D,$77
STREET_NAME_2:
    .byte $6E,$78,$79,$7A,$7B,$78,$7C,$6D,$7D,$7E,$77
STREET_NAME_3:
    .byte $6E,$7F,$80,$81,$82,$83,$84,$85,$86,$87,$77
STREET_NAME_4:
    .byte $6E,$88,$7B,$82,$89,$8A,$8B,$8C,$8D,$8E,$77

*= $3793
LOOKUP_3793:
    .byte $04, $05, $07, $06, $08, $09, $08, $09


// sprite positions (16 bytes) (x, y)
*= $37a3
LOOKUP_37A3:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
     // The X,Y Pos of the 4 road stripes, used by each sprite
    .byte 54,0, 109,0, 109,0, 54,0

*= $37b3
STARTING_SPRITE_POSITIONS:
    .byte 71, 186   // Player Start X, Y Pos
    .byte 71, 186   // Player Start X, Y Pos again?
    .byte 0, 66     // Key Master X, Y 
    .byte 0, 186    // Gate Keeper X, Y

    .byte 0, 18     // Top Left Ghost X, Y
    .byte 168, 50   // Bottom Left Ghost X, Y
    .byte 0, 226    // Top Right Ghost X, Y
    .byte 168, 194  // Bottom Right Ghost X, Y

STARTING_SPRITE_POSITIONS_X2:
    .byte $47, $BA,$47,$BA,$1D,$42,$1D,$BA
    .byte $62, $7A,$62,$7A,$62,$7A,$62,$7A
    .byte $1B, $1F,$37,$3B,$53,$57,$6F,$73
    .byte $8B, $8F,$00,$00,$40,$44,$68,$6C
    .byte $90, $94,$B8,$BC,$FF,$FF,$39,$1D
    .byte $39, $55,$71,$8D,$71,$6A,$42,$6A
    .byte $92, $BA,$92,$00,$01,$01,$00,$00
    .byte $FF, $FF,$00,$65,$6A,$65,$92

// sprite pos of something?
*= $3802
LOOKUP_3802:
    .byte $61
LOOKUP_3803:
    .byte $86,$65,$87

*= $389a
MAP_TEXT_ZUUL:
    .byte $1a, $15, $15, $0c

*= $3f06
MAP_STREET_NAMES_TOP:
    .byte $A9,$A9,$59,$5A,$5B,$5C,$5D,$5E
    .byte $A9,$59,$5F,$60,$61,$62,$5E,$A9
    .byte $59,$63,$64,$65,$66,$5E,$A9,$59
    .byte $67,$68,$69,$6A,$5E,$A9,$59,$6B
    .byte $6C,$69,$6A,$5E,$A9,$A9,$A9

*= $3f2d
MAP_HOUSE_BLOCKS:
    .byte $44,$45,$46,$47,$48,$49,$4a,$4b
    .byte $4c,$4d,$4e,$4f,$50,$51,$52,$53
    .byte $54,$55,$56,$57,$90,$91,$92,$93
    .byte $94,$a4,$a5,$a6,$a7,$a8,$a4,$b7
    .byte $b8,$b9,$ba,$c8,$c9,$ca,$cb,$cc
    .byte $95,$96,$97,$98,$99,$a9,$aa,$ab
    .byte $ac,$ad,$a9,$bb,$bc,$bd,$be,$a9
    .byte $cd,$ce,$cf,$d0,$9a,$9b,$9c,$9d
    .byte $9e,$ae,$af,$b0,$b1,$b2,$ae,$bf
    .byte $c0,$c1,$c2,$d1,$d2,$d3,$d4,$d5
    .byte $9f,$a0,$a1,$a2,$a3,$a9,$b3,$b4
    .byte $b5,$b6,$c3,$c4,$c5,$c6,$c7,$d6
    .byte $cd,$d7,$d8,$d9,$da,$db,$dc,$dd
    .byte $de,$e4,$e5,$e6,$e7,$e8,$ee,$8f
    .byte $a9,$ac,$ef,$f3,$f4,$f5,$f6,$f7
    .byte $df,$e0,$e1,$e2,$e3,$e9,$ea,$eb
    .byte $ec,$ed,$f0,$f1,$f1,$f2,$c2,$f8
    .byte $f9,$f9,$fa,$fb

*= $3fb9
TEXT_GHOSTBUSTERS_STATUS:
    .text "BACKPACK POWER AT " + @"\$58\$58" + "% OF MAXIMUM... " + @"\$58" + " EMPTY TRAPS... " + @"\$58" + " MEN LEFT... " + @"\$ff\$ff\$aa\$aa"

*= $a855
LOOKUP_A855:
    .byte $00,$14,$28,$3C,$50
    .byte $64,$78,$8C,$00,$05,$0A,$0F,$DE
    .byte $E5,$EC,$F3,$A6,$AD,$B4,$BB,$6E
    .byte $75,$7C,$83,$36,$3D,$44,$4B,$FE
    .byte $05,$0C,$13,$F7,$1A,$9F,$67,$2F
    .byte $C2,$8A,$52,$D7,$FA,$53,$53,$53
    .byte $53,$54,$54,$54,$54,$55,$55,$55
    .byte $55,$56,$56,$56,$56,$56,$57,$57
    .byte $57,$56,$57,$54,$55,$56,$54,$55
    .byte $56,$53,$53

*= $a905
LOOKUP_A905:
    .byte $2B,$2C,$2D,$2E,$2C,$2C,$31,$31
    .byte $2E,$32,$32,$2E,$00,$02,$04,$03

*= $a915
LOOKUP_A915:
    .byte $00,$28,$50,$78,$A0
    .byte $C8,$F0,$18,$40,$68,$90,$B8,$E0
    .byte $08,$30,$58,$80,$A8,$D0,$F8,$20
    .byte $48,$70,$98,$C0,$E8

*= $a92f
LOOKUP_A92F:
    .byte $00,$00,$00,$00,$00,$00,$00,$01
    .byte $01,$01,$01,$01,$01,$02,$02,$02
    .byte $02,$02,$02
    .byte $02,$03,$03,$03,$03,$03,$03,$00
    .byte $07,$07,$07,$01,$02,$00,$07,$07
    .byte $07,$13,$13,$01,$0E,$07,$07,$07
    .byte $07,$07,$07,$07,$07,$07,$07,$07
    .byte $02,$02,$02,$02,$02,$02,$02,$02
    .byte $02,$02,$02,$02,$02,$02,$02,$02
    .byte $02,$02,$01,$01,$01,$01,$01,$01
    .byte $01,$01,$02,$02,$02,$02,$02,$02
    .byte $02,$02,$02,$02,$02,$02

*= $a9b0
LOOKUP_A9B0:
    .byte $00, $01, $04, $01

// ghost type? per building
*= $a9b4
LOOKUP_A9B4:
    .byte $14,$1C,$F8,$1F
    .byte $01,$01
    .byte $00,$FF,$FF,$FF,$00,$01,$00,$FF
    .byte $FF,$FF,$00,$01,$01,$01,$19,$3C
    .byte $25,$1F,$1F,$1F

*= $b3aa
MAP_TEXT_GHQ:
    .byte $07, $08, $11

*= $b3b0
TEXT_GOTO_ZUUL:
    .text "GO TO ZUUL( SNEAK PAST THE MARSHMALLOW MAN AND CLOSE THE PORTAL... " + @"\$ff"