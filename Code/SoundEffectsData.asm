.namespace SoundEffects 
{
    *= $3d74
    LOOKUP_3D74:
        .byte $10,$11,$12,$13,$14,$15,$20,$21
        .byte $22,$23,$40,$41,$42,$43,$80,$81

    *= $3d84
    LOOKUP_3D84_LOW:
        .byte <label_3c72, <lsmf_3c8a, <lsmf_3d5b, <lsmf_3d5b, <lsmf_3ca4, <lsmf_3c8d, <lsmf_3ce0, <lsmf_3d5b
        .byte <lsmf_3d5b, <lsmf_3ce8, <lsmf_3cf0, <lsmf_3cfe, <lsmf_3d0f, <lsmf_3d5b, <lsmf_3d5b

    *= $3d93
    LOOKUP_3D93_HIGH:
        .byte >label_3c72,>lsmf_3c8a,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3ca4,>lsmf_3c8d,>lsmf_3ce0,>lsmf_3d5b
        .byte >lsmf_3d5b,>lsmf_3ce8,>lsmf_3cf0,>lsmf_3cfe,>lsmf_3d0f,>lsmf_3d5b,>lsmf_3d5b

    *= $3da2
    LOOKUP_3DA2_LOW:
        .byte <lsmf_3cb8,<lsmf_3cc5,<lsmf_3ccc,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b

    *= $3daa
    LOOKUP_3DAA_HIGH:
        .byte >lsmf_3cb8,>lsmf_3cc5,>lsmf_3ccc,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b

    *= $3db4
    SoundEffectsLow:
        .byte <SoundEffect1, <SoundEffect2, <SoundEffect3, <SoundEffect4, <SoundEffect5

    *= $3db9
    SoundEffectsHigh:
        .byte >SoundEffect1, >SoundEffect2, >SoundEffect3, >SoundEffect4, >SoundEffect5

    *= $3dbe
    SoundEffect1:
        .byte $05, $90, $F1, $95, $06
        .byte $40, $FC, $B1, $EC, $00

    *= $3dc8
    SoundEffect2:
        .byte $05, $90, $F8, $1B, $11
        .byte $17, $BC, $32, $43, $15
        .byte $AC
        .byte $95, $31, $00

    *= $3dd6
    SoundEffect3:
        .byte $05,$40,$44,$1B,$11
        .byte $17,$BC,$F2,$2D,$AC,$00

    *= $3de1
    SoundEffect4:
        .byte $05,$40
        .byte $64,$95,$1B,$11,$27,$BC,$F2,$48
        .byte $AC,$00

    *= $3ded
    SoundEffect5:
        .byte $05,$00,$F0,$FC,$27,$FA
        .byte $04,$0C,$31,$25,$FB,$EC
        .byte $00

    *= $3dfa
    LOOKUP_3DFA:
        .byte $01
        .byte $01,$01,$01,$01,$01,$01,$01,$01
        .byte $01,$01,$01,$02,$02,$02,$02,$02
        .byte $02,$02,$03,$03,$03,$03,$03,$04
        .byte $04,$04,$04,$05,$05,$05,$06,$06
        .byte $07,$07,$07,$08,$08,$09,$09,$0A
        .byte $0B,$0B,$0C,$0D,$0E,$0E,$0F,$10
        .byte $11,$12,$13,$15,$16,$17,$19,$1A
        .byte $1C,$1D,$1F,$21,$23,$25,$27,$2A
        .byte $2C,$2F,$32,$35,$38,$3B,$3F,$43
        .byte $47,$4B,$4F,$54,$59,$5E,$64,$6A
        .byte $70,$77,$7E,$86,$8E,$96,$9F,$A8
        .byte $B3,$BD,$C8,$D4,$E1,$EE,$FD

    *= $3e5a
    LOOKUP_3E5A:
        .byte $0C
        .byte $1C,$2D,$3E,$51,$66,$7B,$91,$A9
        .byte $C3,$DD,$FA,$18,$38,$5A,$7D,$A3

        .byte $CC,$F6,$23,$53,$86,$BB,$F4,$30
        .byte $70,$B4,$FB,$47,$98,$ED,$47,$A7
        .byte $0C,$77,$E9,$61,$E1,$68,$F7,$8F
        .byte $30,$DA,$8F,$4E,$18,$EF,$D2,$C3
        .byte $C3,$D1,$EF,$1F,$60,$B5,$1E,$9C
        .byte $31,$DF,$A5,$87,$86,$A2,$DF,$3E
        .byte $C1,$6B,$3C,$39,$63,$BE,$4B,$0F
        .byte $0C,$45,$BF,$7D,$83,$D6,$79,$73
        .byte $C7,$7C,$97,$1E,$18,$8B,$7E,$FA
        .byte $06,$AC,$F3,$E6,$8F,$F8,$2E,$2E
        .byte $35,$3C,$43,$A6,$AD,$B4,$BB,$6E
        .byte $75,$7C,$83,$36,$3D,$44,$4B,$FE
        .byte $05,$0C,$13,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$01,$01,$01,$01,$02
        .byte $02,$02,$02,$02,$03,$03,$03,$0D
        .byte $0C,$09,$0A

    *= $A2B7
    LOOKUP_A2B7_LO: 
        .byte <Data_A2BD, <Data_A32B, <Data_A399
    *= $A2BA
    LOOKUP_A2BA_HI: 
        .byte >Data_A2BD, >Data_A32B, >Data_A399

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

    *= $f4e7
    bMemoryAddressLow1: .byte $ea
    bMemoryAddressHigh1: .byte $f4
    bMemoryAddressLow2: .byte $ff
    bMemoryAddressHigh2: .byte $14
}