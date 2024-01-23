#importonce 
#import "BuildingScreenSharedData.asm"
#import "/CaptureGhostScreen/CaptureGhostScreen.asm"
#import "/GHQScreen/GHQScreen.asm"
#import "/EnterZuulScreen/EnterZuulScreen.asm"

*= $82af
StatePrepareCaptureGhostSequence2:
{
    lda VIC_SCREEN_CONTROL_REGISTER_1
    and #$ef
    sta VIC_SCREEN_CONTROL_REGISTER_1

    CopyBuildingCharset()
    CopyBuildingCharMap()
    CopySomething1()
    CopySomething2()
    CopySomething3()

    label_83a0:
    ldx CaptureGhostVisitType
    lda LOOKUP_A1C0, x
    rol
    rol
    rol
    and #$03
    sta $27
    tax
    beq label_841f

    CopySomething4()

    ldx $27
    lda LOOKUP_9F24_LOW, x
    sta ZeroPagePointer5
    lda LOOKUP_9F28_HIGH, x
    sta ZeroPagePointer5 + 1
    lda #$d0
    sta ZeroPagePointer6
    lda #$5b
    sta ZeroPagePointer6 + 1
    ldy #$00
    ldx #$01
    jsr Copy1536BytesFromZP5ToZP6.CopyXPlusYMultipliedBy256BytesFromZP5ToZP6

    label_841f:
    lda CaptureGhostVisitType
    cmp #$11
    bne label_8437

    ldx #$0b
    loop1:
    {
        lda LOOKUP_9DC4, x
        and #$3f
        sta $554d, x
        lda #$02
        sta $d94d, x
        dex
        bpl loop1
    }

    label_8437:
    ldx CaptureGhostVisitType
    lda $a1c0, x
    asl
    asl
    and #$30
    beq label_8451
    ora #$0f
    tay
    ldx #$0f

    loop4: // $8447
    {
        lda LOOKUP_9dd4, y
        sta $5a68, x
        dey
        dex
        bpl loop4
    }

    label_8451:
    LoadCarSideViewCharset()

    ldx CarType
    lda LOOKUP_A8A1, x
    ora #$08
    tay
    ldx #$03
    clc
    
    loop2:
    {
        lda LOOKUP_375B, x
        sta $56f2, x
        adc #$04
        sta $571a, x
        adc #$04
        sta $5742, x

        tya
        sta $daf2, x
        sta $db1a, x
        sta $db42, x
        dex
        bpl loop2
    }

    lda #$00
    sta LastKeyPressed
    lda #$00
    sta VIC_SPRITE_PRIORITY_REGISTER
    lda #$0f
    sta VIC_SPRITE_EXPAND_Y
    lda #$00
    sta VIC_SPRITE_EXPAND_X
    sta VIC_SPRITE_EXPAND_Y
    lda #$ef
    sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
    lda #$01
    sta SpriteMulticolor2
    lda #$0b
    sta VIC_BACKGROUND_COLOR_2

    ldx #$07
    loop6:
    {
        lda LOOKUP_380A, x
        sta $2b, x
        lda LOOKUP_3EF6, x
        sta ObjectPosX, x
        lda LOOKUP_3EFE, x
        sta ObjectPosX + 8, x
        lda LOOKUP_3EE6, x
        sta ObjectPosX2, x
        lda LOOKUP_3EEE, x
        sta ObjectPosX2 + 8, x
        dex
        bpl loop6
    }

    lda CaptureGhostVisitType
    cmp #$11
    beq label_84e4
    cmp #$0a
    beq label_84eb
    lda #$7f
    sta CountdownTimer
    jmp NextGameState

    label_84e4:
    lda #GameStates.GHQ_Enter
    sta GameState
    jmp NextGameState.ReturnToMainLoop

    label_84eb:
    lda #GameStates.EnterZuul_Prepare
    sta GameState
    jmp NextGameState.ReturnToMainLoop
}

// Copy data from $1fa8-$25a7 to $5a00-$5fff
.macro CopyBuildingCharset()
{
    // copy house charset Map?
    lda #<BUILDING_CHARSET
    sta ZeroPagePointer5
    lda #>BUILDING_CHARSET
    sta ZeroPagePointer5 + 1
    lda CaptureGhostVisitType
    cmp #$0a
    bne label_82cd
    
    // Load charset for entering the zuul building
    lda #<ZUUL_CHARSET
    sta ZeroPagePointer5
    lda #>ZUUL_CHARSET
    sta ZeroPagePointer5 + 1

    label_82cd:
    lda #$00
    sta ZeroPagePointer6
    lda #$5a
    sta ZeroPagePointer6 + 1
    jsr Copy1536BytesFromZP5ToZP6
}

// Copy data from $2300-$26df to $5400-$5747
.macro CopyBuildingCharMap()
{
    lda #<ENTER_ZUUL_CHARMAP
    sta ZeroPagePointer5
    lda #>ENTER_ZUUL_CHARMAP
    sta ZeroPagePointer5 + 1

    lda CaptureGhostVisitType
    cmp #$0a
    bne label_82ee

    // Load zuul portal charmap
    lda #<ZUUL_CLOSE_PORTAL_CHARMAP
    sta ZeroPagePointer5
    lda #>ZUUL_CLOSE_PORTAL_CHARMAP
    sta ZeroPagePointer5 + 1

    label_82ee:
    lda #$00
    sta ZeroPagePointer6
    lda #$57
    sta ZeroPagePointer6 + 1

    // copy 839 bytes from either $1880 or $26df to $5400-$5700
    ldx #$03
    ldy #$47
    jsr CopyXMultipliedBy256PlusYBytesFromZP5ToZPG6
}

.macro CopySomething1()
{
    ldx CaptureGhostVisitType
    lda LOOKUP_A1C0, x
    and #$03
    tax
    lda LOOKUP_9dd0, x
    sta ZeroPagePointer1
    lda #$e0
    sta ZeroPagePointer5
    lda #$29
    sta ZeroPagePointer5 + 1
    lda CaptureGhostVisitType
    cmp #$0a
    bne label_8320
    lda #$60
    sta ZeroPagePointer5
    lda #$1f
    sta ZeroPagePointer5 + 1

    label_8320:
    lda #$00
    sta ZeroPagePointer6
    lda #$db
    sta ZeroPagePointer6 + 1
    ldx #$03
    ldy #$47

    // Copy data from $2600-$2a2f to $d800-$db47
    loop:
    {
        lda (ZeroPagePointer5), y
        cmp #$0a
        bne label_8334
        lda ZeroPagePointer1

        label_8334:
        sta (ZeroPagePointer6), y
        dey
        cpy #$ff
        bne loop
    }

    dec ZeroPagePointer5 + 1
    dec ZeroPagePointer6 + 1
    dex
    bpl loop.label_8334
}

.macro CopySomething2()
{
    lda #$30
    sta ZeroPagePointer6
    lda #$54
    sta ZeroPagePointer6 + 1
    lda #$03
    sta ZeroPagePointer3
    lda #$00
    sta ZeroPagePointer1 + 1

    outerLoop: // $8352
    {
        lda #$00
        sta ZeroPagePointer1
        ldx CaptureGhostVisitType
        lda LOOKUP_A1C0, x
        lsr
        lsr
        lsr
        lsr
        and #$03
        sta $27
        beq StatePrepareCaptureGhostSequence2.label_83a0
        tax
        lda LOOKUP_9f14, x
        tax

        innerLoop:  // $836a
        {
            ldy ZeroPagePointer1
            lda LOOKUP_9efc, y
            clc
            adc ZeroPagePointer1 + 1
            tay
            lda LOOKUP_9ecc, x
            sta (ZeroPagePointer6), y
            inx
            inc ZeroPagePointer1
            lda ZeroPagePointer1
            cmp #$18
            bcc innerLoop
        }

        lda ZeroPagePointer1 + 1
        clc
        adc #$06
        sta ZeroPagePointer1 + 1
        dec ZeroPagePointer3
        bpl outerLoop
    }
}

.macro CopySomething3()
{
    ldx $27
    lda LOOKUP_9f18, x
    tax
    ldy #$00

    loop3:
    {
        lda LOOKUP_9e14, x
        sta $5b30, y
        inx
        iny
        cpy #$70
        bcc loop3
    }
}

// Copy data from  to $5510-55a8
// Might be replacing some of the charset data in the VIC memry address space
.macro CopySomething4()
{
    // low table pointer
    lda LOOKUP_9F1C_LOW, x
    sta ZeroPagePointer5
    lda LOOKUP_9F20_HIGH, x
    sta ZeroPagePointer5 + 1

    lda #$20
    sta ZeroPagePointer6
    sta ZeroPagePointer1
    lda #$55
    sta ZeroPagePointer6 + 1

    lda #$d9
    sta ZeroPagePointer1 + 1
    ldy #$00
    lda #$09
    sta ZeroPagePointer3 + 1

    outerLoop2: // label_83cd:
    {
        lda #$15
        sta ZeroPagePointer3

        innerLoop: // label_83d1:
        {
            lda (ZeroPagePointer5), y
            sta (ZeroPagePointer6), y
            lda #$09
            sta (ZeroPagePointer1), y
            iny
            bne label_83e2
            inc ZeroPagePointer6 + 1
            inc ZeroPagePointer1 + 1
            inc ZeroPagePointer5 + 1

            label_83e2:
            dec ZeroPagePointer3
            bpl innerLoop
        }

        lda ZeroPagePointer6
        clc
        adc #$12
        sta ZeroPagePointer6
        lda ZeroPagePointer6 + 1
        adc #$00
        sta ZeroPagePointer6 + 1
        lda ZeroPagePointer1
        clc
        adc #$12
        sta ZeroPagePointer1
        lda ZeroPagePointer1 + 1
        adc #$00
        sta ZeroPagePointer1 + 1
        dec ZeroPagePointer3 + 1
        bpl outerLoop2
    }
}

.macro LoadCarSideViewCharset()
{
    lda CarType
    asl
    tax
    lda CAR_SIDEVIEW_CHARSETS, x
    sta ZeroPagePointer5
    lda CAR_SIDEVIEW_CHARSETS + 1, x
    sta ZeroPagePointer5 + 1
    ldy #$5f

    loop: //label_8461:
    {
        lda (ZeroPagePointer5), y
        sta $5a00, y
        dey
        bpl loop
    }
}

*= $9080
ActivatePhotonStreams:
{
    lda #$0f
    sta VIC_SPRITE_EXPAND_Y
    lda #$00
    sta $7a

    ldx #$02

    label_908b:
    txa
    lsr
    tay
    lda $0077, y
    and #$01
    tay

    // set photon beam positions
    lda ObjectPosX + 10, x
    clc
    adc $a99a, y
    sta ObjectPosX, x
    sta ObjectPosX2, x
    clc
    adc $a99c, y
    sta ObjectPosX + 4, x
    sta ObjectPosX2 + 4, x

    lda ObjectPosY + 10, x
    sec
    sbc #$29
    sta ObjectPosY, x
    sta ObjectPosY2, x
    sec
    sbc #$28
    sta ObjectPosY + 4, x
    sta ObjectPosY2 + 4, x
    dex
    dex
    bpl label_908b
    inc $79
    lda $79
    cmp #$06
    bcc label_90c6
    lda #$00
    sta $79

    label_90c6:
    ldx #$01

    label_90c8:
    lda $77, x
    and #$01
    tay
    lda RemainingBackbackCharge
    bne label_90d7
    nop
    nop
    nop
    jmp label_90e6

    label_90d7:
    tya
    pha
    ldy #$04
    nop
    nop
    nop
    pla
    tay
    lda $a9c8, y
    clc
    adc $79

    label_90e6:
    sta $2b, x
    sta $2d, x
    dex
    bpl label_90c8
    rts
}

// compare object pos in slot x with $b0,$b1?
*= $9a01
DidObjectArriveAtTarget:
{
    lda ObjectPosX, x
    cmp ObjectPosX2, x
    bne return
    lda ObjectPosY, x
    cmp ObjectPosY2, x

    return:
    rts
}

*= $9ae3
MoveAllObjectsTowardsTargetSpeed:
{
    ldx #$0e

    loop:
    {
        lda #$02
        jsr MoveObjectTowardsTarget.CustomSpeed
        dex
        dex
        bpl loop
    }

    rts
}

*= $9aef
HandleJoystickInput:
{
    lda JoystickValue

    label_9af1:
    sta ZeroPagePointer1 + 1
    lda ZeroPagePointer1 + 1
    and #$08
    bne label_9afb
    inc ObjectPosX2 + 10, x

    label_9afb:
    lda ZeroPagePointer1 + 1
    and #$04
    bne label_9b03
    dec ObjectPosX2 + 10, x

    label_9b03:
    lda ZeroPagePointer1 + 1
    and #$02
    bne label_9b0b
    inc ObjectPosY2 + 10, x

    label_9b0b:
    lda ZeroPagePointer1 + 1
    and #$01
    bne label_9b13
    dec ObjectPosY2 + 10, x

    label_9b13:
    rts
}

*= $9b44
label_9b44:
{
    lda $09
    and #$01
    bne label_9b6f
    lda $77, x
    and #$01
    sta ZeroPagePointer1 + 1
    lda ObjectPosX + 10, y
    sec
    sbc ObjectPosX2 + 10, y
    beq label_9b5e
    rol
    and #$01
    sta ZeroPagePointer1 + 1

    label_9b5e:
    lda $77, x
    clc
    adc #$02
    cmp #$08
    bcc label_9b69
    lda #$00

    label_9b69:
    and #$fe
    ora ZeroPagePointer1 + 1
    sta $77, x

    label_9b6f:
    lda ObjectPosX2 + 10, y
    cmp ObjectPosX + 10, y
    bne label_9b88
    lda ObjectPosY2 + 10, y
    cmp ObjectPosY + 10, y
    bne label_9b88

    lda $77, x
    and #$01
    ora ZeroPagePointer1
    jmp label_9b8d

    label_9b88:
    lda $77, x
    clc
    adc #$0e
    
    label_9b8d:
    sta $30, x
    rts
}

*= $9da9
CopyXMultipliedBy256PlusYBytesFromZP5ToZPG6:
{
    lda (ZeroPagePointer5), y
    sta (ZeroPagePointer6), y
    dey
    cpy #$ff
    bne CopyXMultipliedBy256PlusYBytesFromZP5ToZPG6
    dec ZeroPagePointer5 + 1
    dec ZeroPagePointer6 + 1
    dex
    bpl CopyXMultipliedBy256PlusYBytesFromZP5ToZPG6
    rts
}