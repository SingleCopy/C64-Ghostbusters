*= $3624 "TitleTextScroller"
TEXT_TITLE_SCROLLER:
 .text "       "
 .byte $5B, $5C, $5D, $5E, $5F, $60, $61, $62   //activision logo
 .text "                       PRESS F1 OR F3 TO START  "
 .text "GHOSTBUSTERS"
 .byte $63, $66 // TM
 .text "         DESIGNED BY DAVID CRANE   COPYRIGHT 1984  "

*= $374B // Ends $375A
BIT_TABLE: // uses one byte of VIC_INIT_VALUES!
    .byte $01, $02, $04, $08, $10, $20, $40, $80
    .byte $FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F

//    .encoding "ascii" char ( = 21 when it should be 23?
*= $6443
Lyrics:
    .text @" \$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"IF THERE'S SOMETHING STRANGE\$0d"
    .text @"IN YOUR NEIGHBORHOOD,\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"IF THERE'S SOMETHING WEIRD,\$0d"
    .text @"AND IT DON'T LOOK GOOD,\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"IF YOU'RE SEEING THINGS\$0d"
    .text @"RUNNING THROUGH YOUR HEAD,\$0d"
    .text @"WHO CAN YOU CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"AN INVISIBLE MAN\$0d"
    .text @"SLEEPING IN YOUR BED,\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"IF YOU'RE ALL ALONE,\$0d"
    .text @"PICK UP THE PHONE,\$0d"
    .text @"AND CALL...\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"I HEAR IT LIKES THE GIRLS.\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"YEAH(  YEAH(  YEAH(  YEAH(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"IF YOU HAVE A DOSE OF A\$0d"
    .text @"FREAKY GHOST, BABY,\$0d"
    .text @"YOU'D BETTER CALL...\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"BUSTIN' MAKES ME FEEL GOOD(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"I AIN'T 'FRAID OF NO GHOST(\$0d"
    .text @"WHEN IT COMES THROUGH YOUR DOOR,\$0d"
    .text @"UNLESS YOU JUST WANT SOME MORE,\$0d"
    .text @"YOU'D BETTER CALL...\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d"
    .text @"WHO YOU GONNA CALL?\$0d"
    .text @"       GHOSTBUSTERS(\$0d\$ff"

*= $68F0
Data_68F0:
    .byte                          $02, $00, $00
    .byte $00, $00, $00, $D1, $00, $63, $E7, $00
    .byte $66, $C5, $00, $65, $E4, $00, $65, $C7
    .byte $00, $00, $E5, $00, $00, $E6, $00, $00
    .byte $00, $64, $E6, $00, $65, $D3, $00, $65
    .byte $E5, $00, $65, $C5, $00, $00, $E5, $00
    .byte $00, $E6, $00, $00, $73, $D3, $00, $63
    .byte $E4, $00, $64, $C6, $00, $E6, $00, $E5
    .byte $00, $E0, $00, $E3, $00, $00, $64, $C4
    .byte $00, $64, $00, $04, $85, $D3, $00, $00
    .byte $00, $00, $E6, $00, $00, $E5, $00, $00
    .byte $F6, $00, $00, $00, $63, $E5, $00, $64
    .byte $D4, $00, $73, $D5, $00, $76, $D4, $00
    .byte $76, $D5, $00, $75, $D4, $00, $00, $00
    .byte $00, $00, $00, $00, $00

// Skip the standard ASCII charset when loading the TitleScreenCharSet
*= $6960 "TitleScreenCharSet"  
    .import binary "..\Content\TitleScreen\TitleScreenCharSet.bin", $200, $550

*= $6eb0 "GhostbustersTitleCharMap" 
    .import binary "..\Content\TitleScreen\GhostbustersTitleCharMap.bin"

*= $6f0a "GhostbustersLogoCharMap" 
    .import binary "..\Content\TitleScreen\GhostbustersLogoCharMap.bin"

*= $8EA7
BallSwingCurve:
    .byte $FD, $FD, $FD, $FE, $FE, $FE, $FF, $00
    .byte $00, $01, $02, $02, $02, $03, $03, $03

*= $92BC // Might be the audio sample 'GHOSTBUSTERS'
Data_92BC: 
          .byte $A7,$01,$86,$01,$86,$01,$86,$01
          .byte $86,$01,$86,$01,$86,$01,$83,$02
          .byte $40,$02,$02,$84,$0E,$05,$03,$03
          .byte $83,$0B,$04,$03,$01,$84,$0E,$04
          .byte $03,$82,$12,$40,$03,$02,$84,$0E
          .byte $05,$03,$03,$83,$0B,$04,$02,$03
          .byte $84,$0D,$04,$03,$82,$12,$40,$02
          .byte $02,$9D,$0F,$00,$04,$04,$03,$9A
          .byte $0B,$00,$04,$04,$03,$A1,$0B,$04
          .byte $02,$03,$83,$0D,$04,$04,$02,$84
          .byte $0C,$03,$03,$82,$12,$40,$03,$02
          .byte $84,$0E,$02,$02,$02,$83,$0F,$05
          .byte $02,$02,$84,$0D,$04,$04,$82,$12
          .byte $40,$02,$02,$9D,$0F,$00,$04,$04
          .byte $03,$9A,$0B,$00,$04,$04,$03,$92
          .byte $0B,$04,$03,$82,$12,$40,$02,$02
          .byte $84,$0E,$05,$02,$01,$83,$0E,$02
          .byte $02,$03,$83,$0E,$03,$84,$18,$40
          .byte $02,$02,$8D,$0F,$00,$04,$04,$03
          .byte $8A,$0B,$00,$05,$02,$03,$8A,$0C
          .byte $00,$04,$04,$02,$8A,$0B,$00,$04
          .byte $00,$03,$00,$04,$90,$0A,$04,$04
          .byte $82,$12,$40,$02,$02,$84,$0E,$00
          .byte $02,$00,$02,$03,$00,$02,$01,$00
          .byte $0C,$00,$01,$03,$00,$03,$81,$11
          .byte $05,$82,$12,$40,$03,$02,$BD,$0E
          .byte $02,$02,$02,$02,$00,$03,$98,$0B
          .byte $00,$04,$04,$03,$9A,$0B,$00,$04
          .byte $04,$03,$A1,$0B,$04,$00,$04,$03
          .byte $03,$82,$08,$05,$03,$02,$03,$83
          .byte $0A,$04,$82,$12,$40,$03,$02,$85
          .byte $0F,$04,$03,$82,$12,$00,$02,$02
          .byte $85,$0E,$04,$04,$82,$12,$00,$02
          .byte $02,$85,$0E,$04,$04,$82,$12,$00
          .byte $02,$02,$85,$0E,$04,$04,$82,$12
          .byte $00,$02,$02,$85,$01,$86,$02,$86
          .byte $02,$86,$02,$86,$BF

*= $A2B7
LOOKUP_A2B7_LO: .byte <Data_A2BD, <Data_A32B, <Data_A399
*= $A2BA
LOOKUP_A2BA_HI: .byte >Data_A2BD, >Data_A32B, >Data_A399

*= $A2BD
Data_A2BD:
    .byte $01, $01, $01, $01, $01
    .byte $02, $02, $02, $03, $04, $05, $04, $1A
    .byte $1B, $1C, $02, $1D, $1B, $1C, $07, $08
    .byte $09, $0A, $09, $0A, $0B, $0C, $0B, $18
    .byte $0D, $02, $04, $1A, $1B, $1C, $02, $1D
    .byte $1B, $1C, $07, $08, $09, $0A, $09, $0A
    .byte $0B, $0C, $0B, $18, $04, $05, $04, $1A
    .byte $1E, $1F, $20, $06, $0E, $0F, $10, $11
    .byte $19, $00, $12, $13, $04, $05, $04, $21
    .byte $22, $22, $23, $06, $00, $14, $15, $16
    .byte $00, $14, $15, $17, $09, $0A, $09, $0A
    .byte $0B, $0C, $0B, $18, $04, $05, $04, $1A
    .byte $24, $25, $23, $06, $04, $05, $04, $05
    .byte $04, $05, $04, $05, $04, $05, $04, $05
    .byte $FF

*= $A32B
Data_A32B:
    .byte      $28, $29, $2A, $2B, $2B, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $2E, $2F
    .byte $30, $31, $2E, $2F, $30, $31, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $2E, $2F, $30, $31, $2E, $2F
    .byte $30, $31, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $36, $37, $36, $37, $36, $37
    .byte $38, $39, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $32, $32, $32, $32, $32, $32
    .byte $32, $35, $2E, $2F, $30, $31, $2E, $2F
    .byte $30, $31, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $2C, $2D
    .byte $2C, $2D, $2C, $2D, $2C, $2D, $FF

*= $A399
Data_A399:
    .byte      $3C, $3D, $3E, $3F, $40, $41, $41 
    .byte $41, $41, $41, $41, $41, $42, $41, $41 
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $44, $41
    .byte $41, $43, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $45, $41, $45, $41, $45, $41
    .byte $45, $46, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $41, $41
    .byte $41, $41, $41, $41, $41, $41, $FF


*= $A409
Data_A409:
    .byte $23, $2D, $23, $2E, $23, $2D, $23, $2E, $23
    .byte $2D, $23, $2E, $23, $2D, $23, $2E, $FF

*= $A60A
Data_A60A:
    .byte $AF,$17,$61,$2F,$1F,$FF
   
*= $A6B1
Data_A6B1:
    .byte $2F,$2F,$2F,$2B,$FF


* = $f000
LOOKUP_F000:
    .byte $AA, $0E
    .byte $10, $10, $10, $10, $10, $10, $0E, $0E
    .byte $0E, $0E, $0E, $0E, $10, $10, $10, $0E
    .byte $0E, $10, $10, $10, $10, $0E, $0E, $0E
    .byte $10, $10, $0E, $0E, $0E, $0E, $0E, $10
    .byte $10, $10, $10, $10, $0E, $0E, $0E, $0E
    .byte $10, $10, $0E, $0E, $10, $10, $10, $0E
    .byte $0E, $0E, $10, $10, $10, $0E, $0E, $0E
    .byte $10, $10, $10, $10, $10, $10, $10, $10
    .byte $0E, $0E, $0E, $0E, $10, $0E, $0E, $10
    .byte $10, $10, $10, $10, $0E, $0E, $0E, $10
    .byte $10, $0E, $0E, $0E, $0E, $10, $10, $10
    .byte $10, $10, $0E, $0E, $0E, $10, $10, $10
    .byte $0E, $0E, $0E, $10, $10, $10, $0E, $0E
    .byte $0E, $10, $10, $10, $0E, $0E, $10, $0E
    .byte $0E, $0E, $0E, $10, $10, $10, $10, $10
    .byte $10, $10, $0E, $0E, $0E, $0E

*= $F24D
Lookup_F24D: 
    .byte $08, $10, $18, $20

*= $F2D8
    .byte $0C, $0E, $10, $12, $08, $0C, $10, $14 
    .byte $02, $0A, $12, $1A

*= $F362
LOOKUP_F362:
    .byte $F4, $F6, $F8, $FA, $FC, $FE, $FF, $00
    .byte $01, $02, $04, $06, $08, $0A, $0C, $0E

*= $F4EB // These values are read into the zero page as address jumps?
bUnknownValue:  .byte                $00, $9E, $01, $3A, $00
                .byte $D2, $01, $6E, $00, $06, $02, $96, $00

*= $F768
bAudioSample1: .byte $33, $33, $D3, $9C, $C9, $73, $C9, $99

*= $F770
bAudioSample3:
    .byte $D9,$8C,$E3,$C3,$C7,$E1,$43,$36
    .byte $43,$3E,$86,$8F,$E3,$38,$FC,$C0
    .byte $79,$0C,$3E,$CC,$71,$FC,$E1,$0F
    .byte $97,$1B,$1E,$E3,$87,$F1,$E0,$07
    .byte $31,$87,$BD,$B2,$97,$6D,$DC,$61
    .byte $29,$37,$D6,$B4,$71,$54,$8D,$CC
    .byte $B9,$70,$8D,$95,$A5,$75,$C8,$6A
    .byte $55,$B4,$56,$69,$15,$8A,$A5,$5A

*= $F800
GhostBustersVoiceSample1: 
    .byte $8C,$77,$77,$77,$76,$87,$67,$D8
    .byte $7C,$A9,$58,$65,$77,$67,$75,$FB
    .byte $7C,$B9,$69,$64,$77,$45,$84,$FC
    .byte $8C,$98,$89,$66,$67,$55,$64,$FB
    .byte $7C,$A8,$68,$86,$78,$45,$74,$FB
    .byte $7C,$98,$79,$87,$78,$45,$74,$FB
    .byte $8C,$99,$78,$87,$68,$45,$74,$FC
    .byte $AC,$79,$76,$A9,$58,$33,$86,$FC
    .byte $BC,$69,$65,$A9,$59,$22,$84,$FD
    .byte $AC,$68,$66,$98,$79,$24,$73,$FC
    .byte $9C,$68,$76,$98,$68,$34,$84,$FC
    .byte $9C,$67,$76,$88,$57,$54,$97,$DB
    .byte $8C,$88,$67,$77,$77,$66,$87,$CA
    .byte $7C,$77,$77,$77,$67,$77,$98,$A9
    .byte $7C,$76,$77,$77,$77,$77,$98,$A9
    .byte $8C,$77,$66,$87,$78,$66,$98,$CA
    .byte $AC,$79,$66,$87,$47,$33,$95,$FD
    .byte $9C,$99,$78,$77,$67,$45,$85,$FB
    .byte $9C,$89,$87,$99,$47,$44,$96,$DC
    .byte $7C,$AA,$78,$77,$88,$35,$83,$FD
    .byte $8C,$98,$89,$77,$77,$56,$74,$FB
    .byte $7C,$A9,$69,$76,$78,$45,$84,$EB
    .byte $8C,$99,$68,$65,$78,$55,$85,$EB
    .byte $8C,$77,$89,$66,$77,$66,$76,$DA
    .byte $7C,$87,$77,$76,$88,$78,$87,$B9

*= $F970
GhostBustersVoiceSample2: 
    .byte $8C,$77,$57,$64,$87,$99,$78,$D9
    .byte $9C,$88,$57,$54,$65,$98,$98,$EA
    .byte $8C,$CA,$3A,$30,$75,$87,$87,$FC
    .byte $8C,$B9,$4A,$42,$75,$77,$86,$EB
    .byte $9C,$BA,$58,$44,$64,$78,$75,$FB
    .byte $7C,$B9,$6A,$33,$76,$77,$77,$EA
    .byte $7C,$A8,$69,$54,$77,$66,$76,$EA
    .byte $7C,$BA,$69,$33,$75,$89,$56,$F9
    .byte $8C,$AA,$58,$33,$85,$9A,$56,$E9
    .byte $8C,$AA,$79,$13,$94,$7A,$75,$EB
    .byte $7C,$A8,$6A,$42,$98,$47,$84,$EC
    .byte $7C,$B9,$6A,$22,$A7,$58,$85,$EB
    .byte $9C,$9A,$46,$44,$96,$9A,$45,$F9
    .byte $9C,$8A,$56,$44,$96,$9A,$46,$F8
    .byte $7C,$99,$67,$56,$86,$79,$55,$FA
    .byte $8C,$8A,$56,$44,$96,$9B,$45,$F9
    .byte $8C,$89,$56,$45,$85,$9A,$56,$E9
    .byte $8C,$89,$56,$44,$95,$9B,$45,$F9
    .byte $8C,$89,$77,$45,$96,$8A,$55,$F9
    .byte $7C,$88,$78,$45,$96,$8A,$45,$F9
    .byte $7C,$88,$78,$45,$85,$9A,$56,$E9
    .byte $7C,$77,$77,$56,$86,$89,$56,$E9
    .byte $7C,$88,$66,$76,$87,$89,$66,$C9
    .byte $7C,$78,$66,$76,$88,$78,$87,$A9

*= $FBC0
HaVoiceSample1:
    .byte $71,$9C,$E1,$C3,$83,$87,$07,$C7
    .byte $C7,$63,$C3,$C5,$63,$98,$C3,$86
    .byte $5D,$0E,$33,$8E,$7C,$CC,$63,$78
    .byte $3D,$86,$C3,$87,$C3,$71,$F1,$E0
    .byte $1D,$87,$87,$CB,$C1,$E3,$78,$70
    .byte $CB,$23,$87,$C7,$E3,$E3,$F1,$38
    .byte $D1,$85,$C6,$C1,$C3,$C1,$8B,$73

*= $FC70
HaVoiceSample2:
    .byte $7C,$99,$88,$77,$77,$56,$76,$CA
    .byte $7C,$87,$88,$78,$77,$57,$86,$C9
    .byte $7C,$87,$88,$88,$78,$45,$85,$D9
    .byte $6C,$98,$77,$99,$79,$36,$74,$E9
    .byte $5C,$89,$86,$98,$8B,$45,$56,$E7
    .byte $7C,$67,$A8,$89,$88,$67,$46,$F5
    .byte $7C,$66,$77,$98,$A9,$68,$34,$F7