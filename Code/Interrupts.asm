//==============================================================================
// Interupt Functions

*= $8e76
RasterInterrupt: 
{
    pha
    txa
    pha
    tya
    pha
    cld
    lda $eb
    bne label_8ed1
    lda INTERRUPT_STATUS_REGISTER
    and #01
    bne WasRasterIRQ
    jmp _8FC0

    WasRasterIRQ:
    {
        lda ShouldLoadAccountScreen
        bne label_8ed4
        lda $9a
        ora #$18
        ldx #$c1

        // Wait for raster line to get to C1 (193)?
        loop: 
        {
            cpx VIC_CURRENT_RASTER_LINE
            bne loop
        }

        ldx #$0a
        wait:
        {
            dex
            bpl wait
        }

        sta VIC_SCREEN_CONTROL_REGISTER_1
        jsr DisplayTitleScroller
        jmp _8EB7
    }

    *= $8EB7
    _8EB7: 
    {
        lda $9A
        and #07
        tax
        lda TITLE_RASTER_POS, x
        ldx #$1b

        loop:
        {
            cmp VIC_CURRENT_RASTER_LINE
            bne loop
        }

        ldy #$0c
        wait:
        {
            dey
            bne wait
        }

        stx VIC_SCREEN_CONTROL_REGISTER_1
        jsr _97A1
    } 

    label_8ed1:
    {
        jmp _8FC0
    }

    label_8ed4:
    {
        lda $06
        asl
        asl
        asl
        eor $06
        asl
        rol $06

        loop:
        {
            inc $08
            lda $ea73
            beq label_8eed
            lda $08
            and #$07
            cmp #$01
            beq loop
        }

        label_8eed:
        {
            jsr DisplayTitleScroller
            lda GameState
            cmp #GameStates.CityMapUpdateLoop
            bcc label_8f3f // If we are at the account screen
            lda $49
            and #$07
            sta $dc
            lda VIC_SCREEN_CONTROL_REGISTER_2
            and #$f8
            ora $dc
            tay
            ldx #$06
            lda GameState
            cmp #GameStates.WriteDownAccountBalance
            bcs label_8f12
            cmp #$2a
            bcc label_8f12
            ldx #$00
        }

        label_8f12:
        {
            lda #223

            waitForRasterLineLoop:  // Loop till we are line 223
            {
                cmp VIC_CURRENT_RASTER_LINE
                bne waitForRasterLineLoop
            }

            jsr SimpleReturn
            jsr SimpleReturn

            inc $dc
            nop
            nop
            nop
            stx VIC_SPRITE_MULTICOLOR_0
            stx VIC_SPRITE_5_COLOR
            stx VIC_SPRITE_6_COLOR
            stx VIC_SPRITE_0_COLOR
            stx VIC_BACKGROUND_COLOR_0
            stx VIC_SPRITE_1_COLOR
            stx VIC_SPRITE_3_COLOR
            stx VIC_SPRITE_4_COLOR
            sty VIC_SCREEN_CONTROL_REGISTER_2
        }

        label_8f3f:
        {
            //move all sprites in left border
            ldx #14
            lda #0

            moveSpriteLeftLoop:
            {
                sta VIC_REGISTERS, x
                dex
                dex
                bpl moveSpriteLeftLoop
            }

            sta VIC_SPRITE_X_POS_EXTENDED   // Set all Sprite MSB to 0

            // wait for raster 236
            ldx #$00
            lda #236
            
            waitForRasterLine:
            {
                cmp VIC_CURRENT_RASTER_LINE
                bne waitForRasterLine
            }

            jsr SimpleReturn
            jsr SimpleReturn
            jsr SimpleReturn
            inc $dc
            nop
            nop
            nop
            nop
            stx VIC_BACKGROUND_COLOR_0
            stx VIC_SPRITE_0_COLOR
            stx VIC_SPRITE_1_COLOR
            jsr _97A1
            lda #$ff
            sta VIC_SPRITE_ENABLE_REGISTER
            lda VIC_SCREEN_CONTROL_REGISTER_2
            ora #$17
            sta VIC_SCREEN_CONTROL_REGISTER_2

            ldx #$07

            setSpritePositions:
            {
                txa
                asl
                tay
                lda ObjectPosX, y
                sec
                rol
                rol $dc
                sta SPRITE_X_POS, y
                lda ObjectPosY, y
                sta SPRITE_Y_POS, y
                lda $2b, x
                sta $57f8, x
                tay
                lda $a949, y
                sta VIC_SPRITE_COLOR, x
                dex
                bpl setSpritePositions
            }

            lda $dc
            sta VIC_SPRITE_X_POS_EXTENDED
            lda BackgroundColor
            sta VIC_BACKGROUND_COLOR_0
            lda SpriteMulticolor1
            sta VIC_SPRITE_MULTICOLOR_0
            lda SpriteMulticolor2
            sta VIC_SPRITE_MULTICOLOR_1

            lda #$01
            sta LoopTrigger
            jsr PlayThemeTune
            jsr SoundEffects.label_3be9
        }
    }
}

*= $8fc0
_8FC0: {
    lda #$81
    sta INTERRUPT_STATUS_REGISTER

    lda #$b8
    sta VIC_CURRENT_RASTER_LINE
    lda VIC_SCREEN_CONTROL_REGISTER_1
    and #$7f
    sta VIC_SCREEN_CONTROL_REGISTER_1
    
    pla
    tay
    pla
    tax
    pla
    rti
}

*= $9756
DisplayTitleScroller:{
    bit 02
    bvs continue1
    bmi continue2

    continue1:  //$975C
    dec 04
    lda 04
    cmp #$ff
    bne continue2
    dec 05
    lda 05
    and #03
    sta 05

    continue2: //$975C
    lda 04
    sta $dc
    lda 05
    ldx #02
    
    loop:   // $9774
    {
        lsr
        ror $dc
        dex
        bpl loop
    }

    lda $dc
    eor #$ff
    and #$7f
    tay
    inx

    // Convert data from $3624 and writes it to $57C0
    // $20 => 0, $51 => $11, $52 => $12, $61 => $21, $62 => $22
    FetchNextChar:
    {
        lda TEXT_TITLE_SCROLLER, y // $3624
        cmp #$20
        bne NotABlank
        lda #0

        NotABlank:  //$978B
        cmp #$40
        bcc NoMask
        and #$3F
        
        NoMask: //$9791
        sta $57C0,x
        iny
        cpy #$80
        bcc NotEndOfTextReached
        ldy #0

        NotEndOfTextReached: //$979b
        inx
        cpx #$28
        bcc FetchNextChar
    }
    
    rts
}

*= $97A1
_97A1: {
    lda $04
    sec
    sbc #$b8
    sta $dc

    lda $05
    sbc #03
    and #03

    sta $dd
    lda $dc
    sta VIC_SPRITE_7_X

    lda $dd
    lsr
    ror
    and #$80
    sta $de
    lda VIC_SPRITE_X_POS_EXTENDED
    and #$7f
    ora $de
    sta VIC_SPRITE_X_POS_EXTENDED
    lda #$80
    ldx $dd
    cpx #02
    bcc continue
    asl

    continue:
    sta VIC_SPRITE_ENABLE_REGISTER
    
    lda #$f2
    sta VIC_SPRITE_7_Y

    lda #02
    sta VIC_SPRITE_7_COLOR

    lda #$3b
    sta $57FF

    lda $04
    and #$07
    sta $dc

    lda VIC_SCREEN_CONTROL_REGISTER_2
    and #$e0
    ora $dc
    tay
    lda VIC_SCREEN_CONTROL_REGISTER_1
    and #$3f
    tax

    // wait for raster 242
    lda #$f2

    loop:
    {
        cmp VIC_CURRENT_RASTER_LINE
        bne loop
    }

    sty VIC_SCREEN_CONTROL_REGISTER_2
    stx VIC_SCREEN_CONTROL_REGISTER_1
    lda VIC_SPRITE_MULTICOLOR_MODE_REGISTER

    sta $dc
    and #$7f
    sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER

    lda VIC_SPRITE_PRIORITY_REGISTER
    pha
    ora #$80
    sta VIC_SPRITE_PRIORITY_REGISTER

    ldy #$F4

    NextLine:
    {
        ldx RAINBOW_COLORS - $f4, y
        loop:
        {
            cpy VIC_CURRENT_RASTER_LINE
            bne loop
        }

        stx VIC_SPRITE_7_COLOR
        iny
        cpy #$fc
        bne NextLine
    }

    lda $dc
    sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
    pla 
    sta VIC_SPRITE_PRIORITY_REGISTER
    rts
}
