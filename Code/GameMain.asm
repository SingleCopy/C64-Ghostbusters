*= $6fe2
label_6fe2:
{
    inc ShouldLoadAccountScreen
    lda #$1b
    sta VIC_SCREEN_CONTROL_REGISTER_1
    jsr ClearScreen

    MainLoop:
    {
        lda LoopTrigger
        beq MainLoop
    }

    lda #$00
    sta LoopTrigger

    lda VIC_SCREEN_CONTROL_REGISTER_1
    ora #$10
    ldy #$00
    bit $45
    bpl label_7003
    and #$ef
    ldy #$00

    label_7003:

    and #$7f
    sta VIC_SCREEN_CONTROL_REGISTER_1
    sty VIC_BORDER_COLOR

    lda CountdownTimer
    beq skipCountdownTimerDecrement
    dec CountdownTimer

    skipCountdownTimerDecrement:
    lda CarDirectionControl
    beq DrivingScreen.label_7024
    bpl label_701f
    jsr DrivingScreen.MoveCarLeft
    inc CarDirectionControl
    jmp DrivingScreen.label_7024

    label_701f:
    jsr DrivingScreen.MoveCarRight
    dec CarDirectionControl

    // Continues on to label_7024
}

*= $7106 "label_7106"
label_7106:
{
    // Called when in the city map view, might still be called in other places!!!
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    beq label_7110
    cmp #ZeroPagePointer1 + 1
    bne label_7175

    label_7110:
    {
        lda $09
        and #$03
        ora #$10
        sta ZeroPagePointer1

        loop:
        {
            ldx ZeroPagePointer1
            lda $3eba, x
            sta ZeroPagePointer4
            lda $3ece, x
            ora #$d8
            sta ZeroPagePointer4 + 1
            lda $c8, x
            and #$03
            tay
            cpy #$03
            bne label_7139
            lda $09
            and #$10
            bne label_7139
            lda #$0d
            bne label_713c

            label_7139:
            lda $3ee2, y

            label_713c:
            sta ZeroPagePointer3
            lda #$2c
            cpx #$04
            bcc label_714a
            cpx #$10
            bcs label_714a
            lda #$7c

            label_714a:
            tay

            label_714b:
            ldx #$04

            label_714d:
            lda ZeroPagePointer3
            sta (ZeroPagePointer4), y
            dey
            dex
            bpl label_714d
            tya
            sec
            sbc #ZeroPagePointer1
            tay
            bpl label_714b
            lda ZeroPagePointer1
            sec
            sbc #$04
            sta ZeroPagePointer1
            bpl loop
        }
        ldx #$02
        lda #$01

        loop2:
        {
            sta $d9cc, x
            sta $db2e, x
            dex
            bpl loop2
        }
        sta $d9cf
    }

    label_7175:
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    bcc label_71c1
    cmp #$2a
    bcc label_7182
    jmp label_71c1

    label_7182: 
    lda $4c
    bne label_71c1
    ldx #$00
    lda LastKeyPressed
    sta $29
    cmp #$20
    bne label_71c1
    inc $4c
    lda #$00
    sta LastKeyPressed
    ldy $4a

    label_7198:
    cpy $4b
    bcs label_71a4
    lda #$00
    sta $e900, y
    iny
    bne label_7198

    label_71a4:
    lda $3fb9, x
    cmp #$ff
    beq label_71c4
    cmp #$20
    bne label_71b1
    lda #$00

    label_71b1:
    cmp #$40
    bcc label_71b7
    sbc #$40

    label_71b7:
    sta $e900, y
    inc $4a
    inx
    iny
    jmp label_71a4

    label_71c1: 
    jmp label_71f6
}

*= $71c4 "label_71c4"
label_71c4:
{
    sta $e900, y
    lda $4b
    bne label_71cd
    inc $4b
}

*= $71cd
label_71cd: 
{
    tya
    sec
    sbc #$43
    tax
    lda RemainingBackbackCharge
    jsr SplitValueInTwoDigits
    jsr ReplaceLeadingZeroWithBlank
    sta $e912, x
    lda ZeroPagePointer1 + 1
    sta $e913, x

    lda NumberOfEmptyTraps
    jsr SplitValueInTwoDigits
    lda ZeroPagePointer1 + 1
    sta $e924, x
    lda RemainingGhostbusters
    jsr SplitValueInTwoDigits
    lda ZeroPagePointer1 + 1
    sta $e935, x
}

*= $71f6
label_71f6: 
{
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    bcc label_726d // Not STATE_CITY_MAP_UPDATE_LOOP, branch off
    lda $4b
    beq label_726d
    lda $09
    and #$00
    bne label_726d
    dec $49
    dec $49
    lda $49
    and #$06
    cmp #$06
    bne label_7234
    inc $4b
    lda $4b
    cmp #$78
    bcc label_7234
    ldx #$00

    loop:
    {
        lda $e928, x
        sta $e900, x
        cmp #$ff
        beq label_7229
        inx
        bne loop
    }

    label_7229:
    lda #$50
    sta $4b
    lda $4a
    sec
    sbc #$28
    sta $4a

    label_7234:
    ldx $4b
    cpx #$28
    bcc label_724b
    lda $e8d8, x
    cmp #$ff
    bne label_724b
    lda #$00
    sta $4b
    sta $4a
    sta $4c
    beq label_726d

    label_724b:
    ldy #$00
    lda #$ff
    sta ZeroPagePointer1   

    label_7251:
    lda #$00
    cpx #$28
    bcc label_7262
    lda $e8d8, x
    cmp #$ff
    bne label_7262
    lda #$00
    sta ZeroPagePointer1

    label_7262:
    and ZeroPagePointer1
    sta $5770, y
    inx
    iny
    cpy #$28
    bcc label_7251

    label_726d:
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    bcc label_72bd
    cmp #$2a
    bcs label_72bd
    lda $4b
    bne label_72bd
    lda $5b
    jsr SplitValueInTwoDigits
    jsr ReplaceLeadingZeroWithBlank
    sta $5783
    lda ZeroPagePointer1 + 1
    sta $5784
    lda CityPKEnergy
    jsr SplitValueInTwoDigits
    sta $5785
    lda ZeroPagePointer1 + 1
    sta $5786

    ldx #$11

    renderPKEnergyLoop:
    {
        lda TEXT_CITY_PK_ENERGY, x
        jsr SanitizeOutput
        sta $5771, x
        dex
        bpl renderPKEnergyLoop
    }

    lda GameState
    cmp #GameStates.PrepareEnding
    bcs label_72bd
    jsr label_9d24
    ldx #$06

    renderAccountMoneyLoop:
    {
        lda AccountBalance, x
        jsr SanitizeOutput
        sta $578e, x
        dex
        bpl renderAccountMoneyLoop
    }

    label_72bd:
    lda $5b
    lsr
    lsr
    lsr
    lsr
    tax
    lda LOOKUP_9DBA, x
    sta PKEnergyRateIncrease
    ldy #$00
    lda $15
    bne label_72d1
    ldy #$27

    label_72d1:
    sty $16

    renderTextLoop:
    {
        lda CurrentlyDisplayedText
        beq AccountScreen.label_7347
        lda $08
        and $15
        cmp $15
        bne label_72df

        label_72df:
        cmp #$00
        bne label_7340
        lda $ea76
        sta TextOutputColor

        ldy #$00

        // fetch next char
        lda (ZeroPagePointer2), y
        cmp #$ff
        bne notTheEnd

        lda #$00
        sta CurrentlyDisplayedText
        beq AccountScreen.label_7347

        notTheEnd:
        inc ZeroPagePointer2
        bne continue
        inc ZeroPagePointer2 + 1
    
        continue:
        cmp #$21
        bcc label_733d
        ldy $15
        cpy #$03
        bcc label_733d

        ldy #$08
        sty SID_VOICE_3_CONTROL_REGISTER

        ldy SHADOW_SID_VOLUME
        cpy #$0f
        beq playPrinterBeep

        ldy #$0f
        sty SHADOW_SID_VOLUME
        sty SID_VOICE_3_MAIN_VOLUME_CONTROL

        playPrinterBeep:
        ldy #$12
        sty SID_VOICE_3_FREQUENCY_LOW
        ldy #$34
        sty SID_VOICE_3_FREQUENCY_HIGH
        ldy #$80
        sty SID_VOICE_3_PULSE_WIDTH_LOW
        ldy #$0f
        sty SID_VOICE_3_PULSE_WIDTH_HIGH
        ldy #$03
        sty SID_VOICE_3_PULSE_AD
        ldy #$00
        sty SID_VOICE_3_PULSE_SVR
        ldy #$41
        sty SID_VOICE_3_CONTROL_REGISTER

        label_733d:
        jsr PrintChar

        label_7340:
        dec $16
        bpl renderTextLoop
    }

    jmp NextGameState.ReturnToMainLoop
}

*= $9832
ReplaceLeadingZeroWithBlank:
{
    lda ZeroPagePointer1
    cmp #$30
    bne return
    lda #$00
    sta ZeroPagePointer1

    return:
    rts
}

*= $99b7
SplitValueInTwoDigits:
{
    sta ZeroPagePointer1
    and #$0f
    clc
    adc #$30
    sta ZeroPagePointer1 + 1
    lda ZeroPagePointer1
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$30
    sta ZeroPagePointer1
    rts
}

    *= $9c8f
    PrintChar: 
    {
        cmp #$00
        sta ZeroPagePointer3 + 1
        beq endOfText
        bpl notXJump

        // jump in X
        and #$3f
        sta TextOutputX
        jmp endOfText

        notXJump:
        cmp #$0d
        beq lineBreak
        cmp #$20
        bne continue
        lda #$00

        continue:
        cmp #$40
        bcc charOverflow
        sec
        sbc #$40

        charOverflow:
        sta ZeroPagePointer3
        lda #$15
        sta ZeroPagePointer1 + 1

        ldy TextOutputY
        lda TEXT_LINE_OFFSET, y
        asl
        rol ZeroPagePointer1 + 1
        asl
        rol ZeroPagePointer1 + 1
        sta ZeroPagePointer1
        lda ZeroPagePointer3
        ldy TextOutputX
        sta (ZeroPagePointer1), y

        // change high byte to color RAM
        lda ZeroPagePointer1 + 1
        and #$03
        ora #$d8
        sta ZeroPagePointer1 + 1

        // char color
        lda TextOutputColor
        sta (ZeroPagePointer1), y

        inc TextOutputX
        lda $15
        beq endOfText
        lda TextOutputColor
        bne endOfText
        lda TextOutputX
        cmp #$20
        bcc endOfText
        lda ZeroPagePointer3 + 1
        cmp #$20
        bne endOfText

        lineBreak:
        lda #$01
        sta TextOutputX
        inc TextOutputY

        endOfText:
        rts
    }