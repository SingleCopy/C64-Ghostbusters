#importonce 
#import "SoundEffectsData.asm"

*= $3be9
label_3be9:
{
    lda $e8
    beq return
    dec $ea81
    beq label_3c03
    lda $ea81
    cmp $ea80
    bne label_3c06
    lda $ea7d
    sta SID_VOICE_3_CONTROL_REGISTER
    jmp label_3c06

    label_3c03: 
    jsr label_3c31
    
    label_3c06: 
    lda $ea7e
    beq label_3c1a
    eor #$ff
    sta $ea7e
    inc $ea7e
    sec
    adc $ea83
    sta SID_VOICE_3_FREQUENCY_HIGH

    label_3c1a:
    lda $ea84
    beq return
    bmi label_3c27
    inc $ea83
    jmp label_3c2a

    label_3c27:
    dec $ea83

    label_3c2a:
    lda $ea83
    sta SID_VOICE_3_FREQUENCY_HIGH

    return:
    rts
}

*= $3c31
label_3c31:
{
    jsr label_3c61
    sta $ea7b
    and #$0f
    beq label_3c53
    tay
    lda LOOKUP_3D84_LOW - 1, y
    sta $e9
    lda LOOKUP_3D93_HIGH - 1, y
    sta $ea
    jsr label_3c5b
    lda $ea7b
    and #$0f
    cmp #$04
    bcs label_3c31
    rts
}

label_3c53:
{
    sta $ea81
    sta $e8
    sta $98
    rts
}

label_3c5b:
{
    lda $ea7b
    jmp ($00e9)
}

*= $3c61
label_3c61:
{
    stx $ea7c
    ldx #$00
    lda ($e7, x)
    inc $e7
    bne label_3c6e
    inc $e8
    
    label_3c6e:
    ldx $ea7c
    rts
}

*= $3c72
label_3c72:
{
    lsr
    lsr
    lsr
    lsr
    tay
    lda LOOKUP_3D5C, y
    sta $ea81
    rts
}

*= $3c7e
label_3c7e:
{
    jsr label_3c72
    lda $ea7d
    ora #$01
    sta SID_VOICE_3_CONTROL_REGISTER
    rts
}

*= $3c8a
lsmf_3c8a:
{
    jsr label_3c7e
}

*= $3c8d
lsmf_3c8d:
{
    jsr label_3c61
    sta $ea86
    tax
    lda LOOKUP_3E5A, x
    sta SID_VOICE_3_FREQUENCY_LOW
    lda LOOKUP_3DFA, x
    sta SID_VOICE_3_FREQUENCY_HIGH
    sta $ea83
    rts
}

*= $3ca4
lsmf_3ca4:
{
    lsr
    lsr
    lsr
    lsr
    and #$07
    tax
    lda LOOKUP_3DA2_LOW, x
    sta $e9
    lda LOOKUP_3DAA_HIGH, x
    sta $ea
    jmp ($00e9)
}

*= $3cb8
lsmf_3cb8:
{
    jsr label_3c61
    sta SID_VOICE_3_PULSE_AD
    jsr label_3c61
    sta SID_VOICE_3_PULSE_SVR
    rts
}

*= $3cc5
lsmf_3cc5:
{
    lda $ea7b
    sta $ea84
    rts
}

lsmf_3ccc:
{
    jsr label_3c61
    dec $ea7f
    beq return
    clc
    adc $e7
    sta $e7
    lda #$ff
    adc $e8
    sta $e8

    return:
    rts
}

*= $3ce0
lsmf_3ce0:
{
    lsr
    lsr
    lsr
    lsr
    sta $ea7e
    rts
}

*= $3ce8
lsmf_3ce8:
{
    lsr
    lsr
    lsr
    lsr
    sta $ea7f
    rts
}

*= $3cf0
lsmf_3cf0:
{
    lsr
    lsr
    lsr
    lsr
    sta SID_VOICE_3_PULSE_WIDTH_HIGH
    jsr label_3c61
    sta SID_VOICE_3_PULSE_WIDTH_LOW
    rts
}

lsmf_3cfe:
{
    lsr
    lsr
    lsr
    lsr
    tax
    lda LOOKUP_3D74, x
    sta SID_VOICE_3_CONTROL_REGISTER
    and #$fe
    sta $ea7d
    rts
}

*= $3d0f
lsmf_3d0f:
{
    php
    lsr
    lsr
    lsr
    lsr
    plp
    bpl label_3d19
    ora #$f0
}

*= $3d19
label_3d19:
{
    clc
    adc $ea83
    sta $ea83
    sta SID_VOICE_3_FREQUENCY_HIGH
    rts
}

*= $3d5b
lsmf_3d5b:
{
    rts
}