*= $3d74
LOOKUP_3D74:
    .byte $10,$11,$12,$13,$14,$15,$20,$21
    .byte $22,$23,$40,$41,$42,$43,$80,$81

*= $3d84
LOOKUP_3D84_LOW:
    .byte <label_3c72,<lsmf_3c8a,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3ca4,<lsmf_3c8d,<lsmf_3ce0,<lsmf_3d5b
    .byte <lsmf_3d5b,<lsmf_3ce8,<lsmf_3cf0,<lsmf_3cfe,<lsmf_3d0f,<lsmf_3d5b,<lsmf_3d5b

*= $3d93
LOOKUP_3D93_HIGH:
    .byte >label_3c72,>lsmf_3c8a,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3ca4,>lsmf_3c8d,>lsmf_3ce0,>lsmf_3d5b
    .byte >lsmf_3d5b,>lsmf_3ce8,>lsmf_3cf0,>lsmf_3cfe,>lsmf_3d0f,>lsmf_3d5b,>lsmf_3d5b

*= $3da2
LOOKUP_3DA2_LOW:
    .byte <lsmf_3cb8,<lsmf_3cc5,<lsmf_3ccc,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b,<lsmf_3d5b

LOOKUP_3DAA_HIGH:
    .byte >lsmf_3cb8,>lsmf_3cc5,>lsmf_3ccc,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b,>lsmf_3d5b

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