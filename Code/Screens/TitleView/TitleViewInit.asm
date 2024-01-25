.label ProcessorPort = $0001

.label BALL_SPRITE_X = $EA66
.label BALL_SPRITE_Y = $EA67
.label BALL_SPRITE_EXTENDED_X = $EA68
.label SHADOW_SID_VOLUME  = $EA82

#importonce 
#import "TitleViewData.asm"
#import "TitleViewShared.asm"
#import "TitleViewMain.asm"

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

*= $F4E7
    bMemoryAddressLow1: .byte $EA
    bMemoryAddressHigh1: .byte $F4
    bMemoryAddressLow2: .byte $FF
    bMemoryAddressHigh2: .byte $14

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

*= $62EB
.macro TitleScreenInit(){
    lda #Speech.Ghostbusters // Ghostbusters
    jsr TriggerSpeech

    lda #Speech.Laugh  // Ha ha ha ha ha
    jsr TriggerSpeech

    MainSetup();
}

*= $6425
NMIVector: {
    pha
    lda $19
    cmp #$3f
    bne continue

    lda #$08
    sta VIC_SCREEN_CONTROL_REGISTER_1
    lda #$00
    sta $EAB2
    jmp GameMainInit

    continue:
    pla
    rti
}

*= $63D7
_63D7: 
{
    ldx #$02

    // Read backwards from $A7D3 to $A75B
    loop:
    {
        dec $88, x
        bpl decrementX

        // Lookup the memory address and store it in the zero page 
        lda LOOKUP_A2B7_LO, x
        sta ZeroPagePointer7
        lda LOOKUP_A2BA_HI, x
        sta ZeroPagePointer7+1

        ldy $82, x
        lda (ZeroPagePointer7), y
        asl
        tay
        lda LOOKUP_A75B, y // Store addresses $A409, $A60A, $A6B1
        sta ZeroPagePointer8
        lda LOOKUP_A75B + 1, y
        sta ZeroPagePointer8 + 1
        ldy $85, x
        lda (ZeroPagePointer8), y
        sta $dc
        and #$1f
        sta $88, x
        ldy $85, x
        bit $dc
        bpl continue

        iny
        iny
        lda (ZeroPagePointer8), y
        and #$0f
        sta $94, x
        dey

        continue:
        bvc skipDecrementY
        dey

        skipDecrementY:
        iny
        iny
        sty $85, x
        lda (ZeroPagePointer8), y
        eor #$ff

        bne decrementX
        sta $85, x
        inc $82, x

        decrementX:
        dex
        bpl loop
    }
    
    rts
}

*= $8DB9
TriggerSpeech: {   
    sei
    inc $eb 
    pha
    lda $20
    beq continue

    ldy #$07
    lda #$ff

    loop:
    {
        sta $5FF8,y
        dey
        bpl loop
    }

    ldy #$78

    loop2: //$8DCD
    { 
        lda #$ff
        sta $576F,y
        lda #00
        sta $DB6F,y
        dey
        bne loop2
        beq label_8df2
    }

    continue: // $8DDC
    ldy #$27
    
    loop3: // $8DDE
    {
        ldx $57C0,y
        lda #00
        sta $57C0,y
        txa
        sta $EA8A,y
        dey
        bpl loop3
    }

    lda VIC_CURRENT_RASTER_LINE
    sta $e1

    label_8df2:
    lda #00
    sta $D404
    sta $D40B
    sta SID_VOICE_3_CONTROL_REGISTER

    lda #$07
    sta $D418

    pla
    jsr PlayGhostbustersVoice

    label_8e06: // $8E06
    lda $20
    bne label_8e27
    lda VIC_SCREEN_CONTROL_REGISTER_1
    asl
    lda VIC_CURRENT_RASTER_LINE
    ror
    cmp $e1
    sta $e1

    bcs label_8e27
    lda $08
    and #$03
    bne label_8e21
    jsr _63D7 

    label_8e21:
    jsr _63BA
    jsr _91C8

    label_8e27:
    lda #$ff
    jsr PlayGhostbustersVoice
    lsr
    bcs label_8e06

    lda #<NMIVector
    sta NMI_ROM_VECTOR
    lda #>NMIVector
    sta NMI_ROM_VECTOR + 1

    lda SHADOW_SID_VOLUME
    sta SID_VOLUME_FILTER_MODES
    lda #$00
    sta $eb
    lda #$81
    sta INTERRUPT_STATUS_REGISTER
    lda #$b8
    sta VIC_CURRENT_RASTER_LINE
    lda VIC_SCREEN_CONTROL_REGISTER_1
    and #$7f
    sta VIC_SCREEN_CONTROL_REGISTER_1
    cli
    lda $20
    beq label_8e6a
    ldy #$78

    loop1:
    {
        lda #$00
        sta $576F, y
        lda #$01
        sta $DB6F, y
        dey
        bne loop1
        rts
    }

 label_8e6a:
    ldy #$27

 label_8e6c:
    lda $ea8a, y
    sta $57c0, y
    dey
    bpl label_8e6c
    rts
}



*= $F080
PlayGhostbustersVoice: {
    jmp _F42E
}

*= $F083
_F083: // Called from the NMI Vector interrupt
{
    pha
    lda wF000:$F000  // This value is being modified
    lsr
    sta SID_VOLUME_FILTER_MODES
    cmp CIA2_INTERRUPT_CONTROL
    dec $fd
    beq continue_F097
    inc wF000
    pla
    rti


    continue_F097: // F097
    lda #<IRQ_F0A4
    sta NMI_ROM_VECTOR

    lda wF000
    sta lookupF000
    pla
    rti

    IRQ_F0A4:
        pha
        lda lookupF000:$F000
        lsr
        sta SID_VOLUME_FILTER_MODES
        cmp CIA2_INTERRUPT_CONTROL
        dec $FE
        beq label_f0b8
        dec $f0a6
        pla
        rti
}

label_f0b8:
{
    lda $ff
    beq label_f0f2
    lda #<IRQ_F0C3
    sta NMI_ROM_VECTOR
    pla
    rti
}

IRQ_F0C3:
{
    pha
    nop
    lda #$0e
    lsr
    sta SID_VOLUME_FILTER_MODES
    cmp CIA2_INTERRUPT_CONTROL
    dec $ff
    beq label_f0f2
    lda #<IRQ_F0D9
    sta NMI_ROM_VECTOR
    pla
    rti
}

IRQ_F0D9:
{
    cmp CIA2_INTERRUPT_CONTROL
    dec $ff
    beq label_f0f1
    rti
}

lsmf_f0e1:
{
    pha
    lda #$90
    sta $dd0f
    lda #$07
    sta SID_VOLUME_FILTER_MODES
    cmp CIA2_INTERRUPT_CONTROL
    pla
    rti
}

 label_f0f1:
 {
    pha
 }
 label_f0f2:
 {
    lda $F4da
    sta NMI_ROM_VECTOR
    lda $F4db
    sta $f085
    lda $F4dc
    sta $fd
    sta $fe
    lda $F4dd
    sta $ff
    cld
    inc $F4e0
    beq label_f113
    jmp label_f13a
 }

 label_f113:
 {
    txa
    pha
    tya
    pha
    jsr label_f120
    pla
    tay
    pla
    tax
    pla
    rti
 }

 label_f120:
 {
    inc $F4de
    bne label_f128
 }

*= $F125
_F125: 
{
    jsr _F1BC
}

label_f128:
{
    lda $F4DF
    sta $F4E0

    lda $F4DB
    and #$40
    eor #$40
    tax
    clc
}

*= $F137
indirectJumpAddress:
{
    jmp indirectJumpAddress // F138
}

label_f13a:
{
    pla
    rti
}

*= $F13C
_F13C:
{
    txa
    pha
    tya
    pha
    lda $F4e3
    cmp $F4db
    beq _F14B
    jsr _F3FC
}

*= $F14B
_F14B:
{
    jsr _F31C
    pla
    tay
    pla
    tax
    pla
    rti
}

*= $F154
_F154:
{
    lda $f4dc
    cmp #$10
    beq _F16E
    sec
    sbc $f4e2
    sta $f4dc
    lda $f4db
    clc
    adc $f4e2
    sta $f4db
    pla
    rti
}

*= $F16E
_F16E:
{
    lda $f4db
    and #$40
    sta $f4db
    lda $f4e1
    sta $f4dc
    pla
    rti
}

*= $F17E
_F17E: 
{
    lda #$E1
    sta $F4DA
    rts
}

*= $F184
_F184: 
{
    lda #$C3
    sta $F4DA
    lda #$80
    sta $F4DD
    rts
}

*= $F18F
_F18F: {
    jmp _F372
    jmp _F3E2
    jsr _F267
    jmp ready
    jsr _F2E4
    
    ready:
    lda $F1BD
    and #$10
    beq timeToJump
    lda $F1BD
    eor #$10
    sta $F1BD
    lda $F4E3
    sta $F4DB
    jmp _F31C
    
    timeToJump: //F1B6
    jsr _F3FC
    jmp _F31C
}

*= $F1BC
_F1BC: {
    lda tmpX:#$00 // $F1BD
    and #$20
    beq continue
    lda #$7e
    sta indirectJumpAddress + 1
    rts

    continue:
    ldy #00
    lda ($f5),y
    sta tmpX
    ora #$f0
    sta $F4DF

    iny
    lda ($f5),y
    lsr
    lsr
    lsr
    ora #$e0
    sta $F4DE
    bcs _F251

    iny
    lda ($f5),y
    adc bMemoryAddressLow1
    sta $f9

    iny
    lda ($f5),y
    adc bMemoryAddressHigh1
    sta $fa
    
    lda #$83
    sta $F4DA

    ldy #01
    lda ($f5),y
    and #03
    tax
    cmp #02
    bpl _F22A

    ldy #0
    lda ($f5),y
    and #$40
    bne continue2
    lda #$20

    continue2:  // $F20b
    sta $F4E1

    lsr
    lsr
    lsr
    sta $F4E2

    lda #$54
    sta $F111
    sty $F4DD
    txa
    lsr
    lda #$8f
    bcs continue3
    lda #$92

    continue3:  // $F224
    sta indirectJumpAddress + 1
    jmp _F25B
}

*= $F22A
_F22A: {
    ldy #0
    lda ($f5),y
    rol
    rol
    rol
    and #03
    tay

    lda Lookup_F24D, y
    sta $F4DC

    lda #$3c
    sta $F111
    txa
    lsr
    lda #$95
    bcs continue
    lda #$9b

    continue:
    sta indirectJumpAddress + 1
    jmp _F25B
}

*= $F251
_F251: {
    lda #$3a
    sta $F111

    lda #$84
    sta indirectJumpAddress + 1
}

*= $F25B
_F25B: {
    lda $f5
    clc
    adc #$04
    sta $f5
    bcc return 
    inc $f6

    return:
    rts
}

_F267:
{
    adc $f4dc
    sta $f2d4
    stx $f4e3

    ldy #$00
    lda ($f9), y
}

*= $F274
_F274: 
{
    sta $f2a2
    and #$03
    asl
    asl
    clc
    adc #$d4
    sta $fb
    lda $f2a2
    lsr
    lsr
    and #$03
    tay
    lda ( $fb ), y
    sta LOOKUP_F000, x
    inx
    jmp _F2AA
}

*= $F291
_F291: 
{
    ldy #$00
    lda ($f9), y
    sta $f2a2
    and #$03
    tay
    lda ($fb), y
    sta LOOKUP_F000, x
    inx
    lda #$00
    lsr
    lsr
    and #$03
    tay
    lda ($fb), y

}

*= $F2AA
_F2AA: 
{
    sta LOOKUP_F000, x
    inx
    lda $f2a2
    lsr
    lsr
    lsr
    lsr
    and #$03
    tay
    lda ( $fb ), y
    sta LOOKUP_F000, x
    inx
    lda $f2a2
    rol
    rol
    rol
    and #$03
    tay
    lda ( $fb ), y
    sta LOOKUP_F000, x
    inx
    inc $f9
    bne label_f2d3
    inc $fa

 label_f2d3:
    cpx #$00
    bne _F291
    rts
}

*= $F2E4
_F2E4:
{
    adc $F4DC
    sta countCheck
    stx $F4E3
    ldy #$00
    lda ($f9), y
    lsr
    lsr
    lsr
    and #$1e
    sta $f000, x
    inx
    jmp _F30D
    loop:
        lda ($f9), y
        asl
        and #$1e
        sta $f000, x
        inx
        lda ($f9), y
        lsr
        lsr
        lsr
        and #$1e

    _F30D:
        sta $f000, x
        inx
        inc $f9
        bne continue
        inc $fa
        
        continue:
        cpx countCheck:#$00
        bne loop

    rts
}

_F31C:
{
    inc $F4e4
    beq label_f330
    lda $F4e5
    clc
    adc $F4e6
    sta $F4e5
    lsr
    sta $F4dd
    rts
}

label_f330:
{
    ldy #$00
    lda ( $f7 ), y
    tax
    and #$fe
    sta $F4e5
    txa
    lsr
    inc $f7
    lda ( $f7 ), y
    ror
    ror
    ror
    ror
    ora #$e0
    sta $F4e4
    lda ( $f7 ), y
    and #$0f
    tay
    lda LOOKUP_F362, y
    sta $F4e6
    inc $f7
    bne label_f35a
    inc $f8
}

label_f35a:
{
    lda $F4e5
    lsr
    sta $F4dd
    rts
}

*= $F372
_F372: {
    sta $F4DB
    adc $F4E1
    sta $F3AA
    
    lda $F4E1
    sta $F4DC

    ldy #$00

    lda ($F9),y
    lsr
    lsr
    tay

    lda #$0e
    bcc continue
    lda #$10
    
    continue: // F38E
    sta LOOKUP_F000,x
    inx
    jsr _F3C3
    jmp _F39F
}

*= $F398
_F398: {
    ldy #$00
    lda ($f9), y
    jsr WriteSomething_F3AE
}

*= $F39F
_F39F: {
    loop:
    {
        tya
        jsr WriteSomething_F3AE
        inc $f9
        bne continue
        inc $fa

        continue:
        {
            cpx #$00    // This value is updated
            bcc _F398
        }
    }
    rts
}

*= $F3AE
WriteSomething_F3AE: {
    lsr
    tay
    lda #$0e
    bcc continue1
    lda #$10

continue1:
    sta LOOKUP_F000, x
    inx
    tya
    lsr
    tay
    lda #$0e
    bcc _F3C3
    lda #$10
}

*= $F3C3
_F3C3: {
    sta LOOKUP_F000,x
    inx
    tya
    lsr
    tay
    lda #$0e
    bcc continue
    lda #$10

    continue: // F3D0
    sta LOOKUP_F000,x
    inx
    tya
    lsr
    tay
    lda #$0e
    bcc continue2
    lda #$10

    continue2: // F3DD
    sta LOOKUP_F000,x
    inx
    rts
}

*= $F3E2
_F3E2: {
    sta $F4DB
    adc $F4E1
    sta $F2D4
    lda $F4E1
    sta $F4DC

    ldy #$00
    lda ($f9),y
    and #$fc
    ora #$01
    jmp _F274
}

_F3FC:
{
    ldx #$00
    lda $F4DB
    sta $F41B
    lda $F4E3
    sta $F417
    lda $F4DB
    and #$40
    eor #$40
    ora #$20
    sta $F41F

    loop:
    {
        lda LOOKUP_F000, x
        sec
        adc LOOKUP_F000, x
        ror
        sta LOOKUP_F000, x
        inx
        cpx $F4DC
        bne loop
    }
    lda $F41F
    sta $F4DB
    rts
}

*= $F42E
_F42E: {
    cmp #$ff
    beq continue

    cmp #$fe
    beq continue3

    cmp #$fd
    beq continue4

    jsr _F496
    jsr continue3

    bmi $F46C

    lda #00
    sta $F4DB

    lda #$f2
    sta $fc

    // Make this into a macro
    lda #$f0
    sta NMI_ROM_VECTOR + 1

    lda #$c3
    sta NMI_ROM_VECTOR

    lda #01
    sta $FF

    jsr _F125
    jsr continue5

    continue: // F45F
    lda ProcessorPort
    lsr
    lsr
    lda #$80
    bcs continue2
    lda CIA2_CONTROL_TIMER_B
    and #$01
    
    continue2: // F46C
    rts

    continue3: // F46D
    lda #$90
    sta CIA2_CONTROL_TIMER_B
    jmp continue

    continue4: // F475
    stx bMemoryAddressLow1
    sty bMemoryAddressHigh1
    jmp continue

    continue5:
    lda #$91
    sta CIA2_CONTROL_TIMER_B

    lda #$65
    sta CIA2_TIMER_B_LOW_BYTE

    lda #00
    sta CIA2_TIMER_B_HIGH_BYTE

    lda #$82
    sta $DD0D
    lda $DD0D
    rts
}

*= $F496
_F496: {
    rol
    rol
    rol
    tax
    ror
    and #$fc
    clc
    adc bMemoryAddressLow1
    sta $f9

    txa
    and #03
    adc bMemoryAddressHigh1
    sta $fa

    ldy #00
    lda ($f9),y
    adc bMemoryAddressLow1
    sta $f7

    iny

    lda ($f9),y
    adc bMemoryAddressHigh1
    sta $f8

    lda #$ff
    sta $F4E4
    iny

    lda ($f9),y
    clc
    adc bMemoryAddressLow1
    sta $f5
    iny

    lda ($f9),y
    adc bMemoryAddressHigh1
    sta $f6

    lda #00
    sta $F1BD

    rts
}