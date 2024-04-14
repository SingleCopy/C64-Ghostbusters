*= $63BA
UpdateSongLyricsTimers: 
{
    inc $08
    ldx TitleSongElapsedTime
    cpx #$70 // 112  
    beq return
    lda Data_68F0, x
    cmp $08
    bne return
    cmp #$00

    beq incrementTitleSongElapsedTime
    lda RenderNextLyricCountdown
    clc
    adc #$10
    sta RenderNextLyricCountdown
    
    incrementTitleSongElapsedTime:
    inc TitleSongElapsedTime

    return:
    rts
}

*= $91C8
UpdateBallPosition: 
{
    .label ExtendedSpriteMask = $23

    sta $EA6D
    stx $EA6F
    sty $EA6E

    lda #$01
    sta VIC_SPRITE_ENABLE_REGISTER
    ldx BallBounceTrigger
    bne label_9235
    dec BallLyricCountdownTimer
    bpl label_9235
    ldy #$00
    sty BallLyricCountdownTimer
    lda $ea69
    sta ZeroPagePointer1
    lda $ea6a
    sta ZeroPagePointer1 + 1
    lda (ZeroPagePointer1), y
    sta $EA89
    php
    bit $EA89
    bvc moveBallToTheRight
    and #$BF

    moveBallToTheRight: // $91fc
    plp
    bpl label_9212
    cmp #$bf
    bne resetBallLyricCountdownTimer
    lda #$00
    sta BallSpriteX
    sta BallSpriteExtendedX

    resetBallLyricCountdownTimer: // $920b:
    and #$7f
    sta BallLyricCountdownTimer
    lda #$00

    label_9212:
    sta $EA6C
    inc $EA69
    bne label_921d
    inc $EA6A

    label_921d:
    lda $EA6A
    cmp #$93
    bcc label_9235
    lda $EA69
    cmp #$E1
    bcc label_9235
    lda #$93
    sta $EA6A
    lda #$E0
    sta $EA69
    
    label_9235:
    lda BallBounceCurve, x
    clc
    adc BallSpriteY
    sta BallSpriteY
    inc BallBounceTrigger
    lda BallBounceTrigger
    and #$0F
    sta BallBounceTrigger
    lda BallSpriteX
    clc
    adc $EA6C
    sta BallSpriteX

    lda BallSpriteExtendedX
    adc #$00
    sta BallSpriteExtendedX
    beq label_926d

    lda BallSpriteX
    cmp #$58
    bcc label_926d
    lda #$00
    sta BallSpriteX
    sta BallSpriteExtendedX

    label_926d:
    lda BallSpriteY
    sta VIC_SPRITE_0_Y
    sta VIC_SPRITE_0_Y + 2
    lda BallSpriteX
    sta VIC_SPRITE_0_X
    sta VIC_SPRITE_0_X + 2

    // set up extended x bit
    lda BallSpriteExtendedX
    asl
    ora BallSpriteExtendedX
    sta ExtendedSpriteMask
    lda VIC_SPRITE_X_POS_EXTENDED
    and #$FC
    ora ExtendedSpriteMask
    sta VIC_SPRITE_X_POS_EXTENDED
    lda $EA6D
    ldx $EA6F
    ldy $EA6E
    rts
}

*= $9d24
label_9d24:
{
    lda MoneyInAccount
    sta ZeroPagePointer1
    lda MoneyInAccount + 1
    sta ZeroPagePointer1 + 1
    lda MoneyInAccount + 2
    sta ZeroPagePointer3
    lda #$30
    sta AccountBalance
    ldy #$01
    lda #$03
    sta $27
    jsr label_9d51
    lda #$ff
    sta $ea17, y
    jsr label_9d74
    dex
    lda #ZeroPagePointer1 + 1
    sta AccountBalance, x
    rts
}

    *= $9d51
    label_9d51:
    {
        ldx #$00

        loop:
        {
            lda ZeroPagePointer1, x
            lsr
            lsr
            lsr
            lsr
            ora #$30
            sta AccountBalance, y
            iny
            lda ZeroPagePointer1, x
            and #$0f
            ora #$30
            sta AccountBalance, y
            iny
            inx
            cpx $27
            bcc loop
        }

        lda #$ff
        sta AccountBalance, y
        rts
    }

    label_9d74:
    {
        ldx #$00
        loop:
        {
            lda $ea15, x
            cmp #$ff
            beq return
            cmp #$2e
            beq return
            lda AccountBalance, x
            cmp #$ff
            beq return
            cmp #$30
            bne return
            lda #$20
            sta AccountBalance, x
            inx
            jmp loop
        }
        return: // $9d95
        rts
    }