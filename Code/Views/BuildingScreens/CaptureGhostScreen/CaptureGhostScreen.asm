#importonce 
#import "CaptureGhostScreenData.asm"

*= $8279
StatePrepareCaptureGhostSequence1:
{
    jsr ClearScreen
    ldx #$0f
    lda #$00
    sta $65

    resetObjectPositions:
    {
        sta ObjectPosX, x
        dex
        bpl resetObjectPositions
    }
    ldx #$03

    // Write to $72, $71, $70 or $6f
    clearMemoryLoop:
    {
        sta $6f, x
        dex
        bpl clearMemoryLoop
    }
    lda #$0c
    sta BackgroundColor

    ldx #$00
    stx VIC_BACKGROUND_COLOR_1

    lda #$09
    loop:
    {
        sta COLOR_RAM, x
        sta COLOR_RAM + $100, x
        sta COLOR_RAM + $200, x
        sta COLOR_RAM + $270, x
        inx
        bne loop
    }

    lda #$00
    sta CarDrivingCurrentPos
    jmp NextGameState
}

*= $84f2
StateCaptureGhostPlaceTrap:
{
    lda #$0e
    jsr label_9b35
    jsr MoveAllObjectsTowardsTargetSpeed
    ldx #$00
    jsr label_9aef
    jsr label_9b14
    jsr label_9a16
    ldx CaptureGhostVisitType
    lda $c8, x
    and #$0c
    cmp #$0c
    bne label_8522
    jsr CheckFireButtonIsPressed
    beq label_8522
    and #$10
    bne label_8522
    lda ObjectPosY + 10
    clc
    adc #$01
    sta ObjectPosY2 + 14
    jmp NextGameState

    label_8522:
    jsr label_9aa6
    jsr label_9a8a
    jmp NextGameState.ReturnToMainLoop
}

*= $852b
StateCaptureGhostPlaceFirstGhostbuster:
{
    jsr MoveAllObjectsTowardsTargetSpeed
    jsr label_9aa6
    jsr label_9a8a
    ldx #$00
    jsr label_9aef
    jsr label_9b14
    lda #$0e
    jsr label_9b35
    jsr CheckFireButtonIsPressed
    beq return
    and #$10
    bne return
    lda $30
    and #$01
    ora #$16
    sta $30
    lda LOOKUP_3EF0
    sta ObjectPosX2 + 12
    lda $3ef1
    sta ObjectPosY2 + 12
    jmp NextGameState

    return:
    jmp NextGameState.ReturnToMainLoop
}

*= $8562
StateCaptureGhostPlaceSecondGhostbuster:
{
    jsr MoveAllObjectsTowardsTargetSpeed
    jsr label_9aa6
    jsr label_9a8a
    ldx #$02
    jsr label_9aef
    jsr label_9b14
    lda #$0e
    sta ZeroPagePointer1
    ldx #$01
    ldy #$02
    jsr label_9b44
    jsr CheckFireButtonIsPressed
    beq return
    and #$10
    bne return
    lda $31
    and #$01
    ora #$16
    sta $31
    jsr label_98eb
    jsr label_9918
    jmp NextGameState

    return:
    jmp NextGameState.ReturnToMainLoop
}

*= $859b
StateCaptureGhostActivateProtonStream: 
{
    jsr label_9aa6

    lda RemainingBackbackCharge
    beq backbackDischarged

    jsr label_992b
    
    backbackDischarged:
    jsr MoveAllObjectsTowardsTargetSpeed
    jsr ActivatePhotonStreams
    ldy #$00
    lda ObjectPosX2 + 12
    sec
    sbc ObjectPosX2 + 10
    bcs label_85b9
    eor #$ff
    adc #$01
    iny

    label_85b9:
    cmp #$0c
    bcc label_85d4
    ldx #$02

    checkJoystickInput:   // $85bf
    {
        lda INPUT_MASK, x // Value $07 or $0b, used to determine which GB should move
        cpy #$00
        beq label_85c8
        eor #$0c

        label_85c8:
        ora JoystickValue
        jsr label_9aef.label_9af1
        jsr label_9b14
        dex
        dex
        bpl checkJoystickInput
    }

    label_85d4:
    lda ObjectPosY + 10
    sec
    sbc ObjectPosY + 12
    bcs label_85df
    eor #$ff
    adc #$01

    label_85df:
    lsr
    lsr
    sta ZeroPagePointer1
    lda #$2a
    sec
    sbc ZeroPagePointer1
    sta ZeroPagePointer1
    tya
    bne label_8602
    lda $30
    cmp #$16
    bne label_865e
    lda $31
    cmp #$17
    bne label_865e
    lda ObjectPosX + 12
    sec
    sbc ObjectPosX + 10
    bcc label_865e
    bcs label_8615

    label_8602:
    lda $31
    cmp #$16
    bne label_865e
    lda $30
    cmp #$17
    bne label_865e
    lda ObjectPosX + 10
    sec
    sbc ObjectPosX + 12
    bcc label_865e

    label_8615:
    cmp ZeroPagePointer1
    bcs label_865e
    lda #$40
    sta $ea72

    waitForTrigger:
    {
        lda LoopTrigger
        beq waitForTrigger
    }

    jsr ActivatePhotonStreams

    lda #$00
    sta LoopTrigger

    dec $ea72
    bne waitForTrigger

    lda #$00
    sta RemainingBackbackCharge
    sta $2b
    sta $2c
    sta $2d
    sta $2e
    jsr ResetVariablesToZero

    // crossed streams
    ldx #$08
    jsr FetchScrollerText

    lda #$18
    sta $30
    sta $31
    dec RemainingGhostbusters
    dec RemainingGhostbusters

    lda #$00
    sta ObjectPosX2 + 8
    sta ObjectPosY2 + 8
    lda #GameStates.CaptureGhost_GhostCaptureFailed
    sta GameState
    lda #$00
    sta LastMiniGameResult
    jmp NextGameState.ReturnToMainLoop

    label_865e:
    jsr CheckFireButtonIsPressed
    beq label_8682
    and #$10
    bne label_8682

    label_8667:
    lda $30
    and #$01
    ora #$0e
    sta $30
    lda $31
    and #$01
    ora #$0e
    sta $31
    jsr ResetVariablesToZero
    ldy #$03
    jsr PlaySoundEffect
    jmp NextGameState

    label_8682:
    lda $09
    and #$0f
    bne return
    sed
    sec
    lda RemainingBackbackCharge
    beq backpackEmpty
    sbc #$01
    sta RemainingBackbackCharge

    backpackEmpty:
    cld
    bne return

    // backpacks discharged
    ldx #$03
    jsr FetchScrollerText
    jmp label_8667

    return:
    jmp NextGameState.ReturnToMainLoop
}

*= $86a0
StateCaptureGhost_OpenTrap: 
{
    jsr label_9aa6
    jsr MoveAllObjectsTowardsTargetSpeed
    lda #$0e
    sta VIC_SPRITE_EXPAND_Y
    lda #$00
    sta VIC_SPRITE_PRIORITY_REGISTER
    jsr label_9a35
    lda $7a
    cmp #$9c
    bcc label_86d8
    lda #$00
    sta $2b
    sta $2c
    sta $2d
    sta $2e
    lda $06
    and #$02
    tax
    lda ObjectPosX + 10, x
    sta ObjectPosX2 + 8
    lda ObjectPosY + 10, x
    sta ObjectPosY2 + 8
    lda #$01
    sta LastMiniGameResult
    jmp NextGameState

    label_86d8:
    clc
    adc #$03
    sta $7a
    ldx #$01

    loop:
    {
        lda ObjectPosX, x
        sec
        sbc $a9a0, x
        sta ZeroPagePointer1
        clc
        adc $a9a2, x
        sta ZeroPagePointer1 + 1
        lda ObjectPosX + 8, x
        jsr label_9c08
        bcc label_86fe
        dex
        bpl loop
    }
    lda #GameStates.CaptureGhost_GhostCaptureSuccessful
    sta GameState
    jmp NextGameState.ReturnToMainLoop

    label_86fe:
    jmp NextGameState.ReturnToMainLoop
}

*= $8701
MoveGhostToGhostbuster:
{
    jmp StateCaptureGhost_GhostCaptureFailed.SlimeGhostbuster
}

*= $8704
StateCaptureGhost_GhostCaptureFailed: 
{
    jsr MoveAllObjectsTowardsTargetSpeed
    ldx #$02
    
    label_8709:
    lda ObjectPosX + 8
    cmp ObjectPosX2 + 10, x
    bne MoveGhostToGhostbuster
    lda ObjectPosY + 8
    cmp ObjectPosY2 + 10, x
    bne MoveGhostToGhostbuster

    txa
    lsr
    tax
    lda #$18
    sta $30, x
    dec RemainingGhostbusters
    lda $a99e, x
    sta ObjectPosX2 + 8
    lda #$00
    sta ObjectPosY2 + 8
    ldx #$00

    SlimeGhostbuster:
    dex
    dex
    bmi label_8730
    jmp label_8709

    label_8730:
    ldx #$01

    label_8732:
    lda ObjectPosX + 8
    cmp $a99e, x
    bne label_8755
    ldx CaptureGhostVisitType
    lda #$00
    sta $c8, x
    lda #$03
    jsr IncreaseCityPKEnergy

    lda LastMiniGameResult
    beq label_874e

    // he slimed me
    lda #$02
    jsr TriggerSpeech

    label_874e:
    lda #GameStates.PrepareMapScreen
    sta GameState
    jmp NextGameState.ReturnToMainLoop

    label_8755:
    dex
    bpl label_8732
    jmp NextGameState.ReturnToMainLoop
}

*= $875b
StateCaptureGhost_GhostCaptureSuccessful: 
{
    jsr label_9a35
    lda $7a
    cmp #$9c
    bcc label_8784
    lda #$7f
    sta $7b
    lda #$00
    sta $2c
    sta $2d
    sta $2e
    lda ObjectPosX + 14
    sta ObjectPosX2
    sta ObjectPosX2 + 8
    lda ObjectPosY + 14
    sta ObjectPosY2
    sta ObjectPosY2 + 8
    lda #$00
    sta $ea88
    jmp NextGameState

    label_8784:
    inc $7a
    jsr label_9a0c
    lda ObjectPosX
    sta ObjectPosX + 8
    lda ObjectPosY
    sta ObjectPosY + 8
    jmp NextGameState.ReturnToMainLoop
}

*= $8794
StateCaptureGhost_CaptureGhostInTrap: 
{
    jsr MoveAllObjectsTowardsTargetSpeed
    inc $79
    lda $79
    cmp #$06
    bcc label_87a3
    lda #$00
    sta $79

    label_87a3:
    lda $2b
    beq label_87af
    lda $a9ca
    clc
    adc $79
    sta $2b

    label_87af:
    ldx #$00
    jsr DidObjectArriveAtTarget
    bne label_8804
    lda $2b
    beq label_8804
    lda #$38
    sta $32
    lda #$00
    sta $2b
    sta $2f
    lda #$01
    sta $ea88
    lda InstalledEquipment
    and #$40
    beq label_87d9

    lda NumberOfGhostsCaught
    cmp #$0a
    bcs label_87d9
    inc NumberOfGhostsCaught
    bne label_87db

    label_87d9:
    dec NumberOfEmptyTraps

    label_87db:
    ldx CaptureGhostVisitType
    lda $c8, x
    and #$0c
    cmp #$0c
    beq label_87e9
    ldy #$0f
    bne label_87f4

    label_87e9:
    lda $c8, x
    lsr
    lsr
    lsr
    lsr
    tay
    lda #$00
    sta $c8, x

    label_87f4:
    lda #$00
    sta ZeroPagePointer1
    lda LOOKUP_A1E4, y
    sta ZeroPagePointer1 + 1
    lda #$00
    sta ZeroPagePointer3
    jsr AddMoneyToAccount

    label_8804:
    dec $7b
    bne label_883a
    inc $7b
    lda $2b
    bne label_883a
    sei
    ldx #$07
    lda #$e0
    sta VIC_SPRITE_ENABLE_REGISTER

    // move first 4 sprites in top left corner
    lda #$00
    loop:
    {
        sta VIC_REGISTERS, x
        dex
        bpl loop
    }

    // ghostbusters!
    lda #$01
    jsr TriggerSpeech

    label_8823:
    lda ObjectPosX + 14
    sta ObjectPosX2 + 10
    clc
    adc #$12
    sta ObjectPosX2 + 12
    lda ObjectPosY + 14
    sta ObjectPosY2 + 10
    sta ObjectPosY2 + 12
    lda $ea88
    beq label_8837

    label_8837:
    jmp NextGameState

    label_883a:
    lda $7b
    lsr
    lsr
    and #$03
    sta ZeroPagePointer1
    tay
    lda LOOKUP_A9A4, y
    sta ZeroPagePointer1 + 1
    ldx #$02
    ldy #$01

    label_884c:
    lda ObjectPosY + 10, x
    clc
    adc ZeroPagePointer1 + 1
    sta ObjectPosY + 10, x
    asl ZeroPagePointer1
    lda ZeroPagePointer1
    lda $0030, y
    and #$01
    ora ZeroPagePointer1
    clc
    adc #$0e
    sta $0030, y
    lsr ZeroPagePointer1
    dey
    dex
    dex
    bpl label_884c
    lda $2b
    beq label_8872
    jsr label_9a0c

    label_8872:
    jmp NextGameState.ReturnToMainLoop    
}

*= $8875
StateCaptureGhost_MoveTowardsTrap: 
{
    lda #$0e
    jsr label_9b35
    jsr MoveAllObjectsTowardsTargetSpeed
    ldx #$0a
    jsr DidObjectArriveAtTarget
    bne return
    lda #$a8
    sta ObjectPosX2 + 10
    sta ObjectPosX2 + 12
    lda #$c7
    sta ObjectPosY2 + 10
    sta ObjectPosY2 + 12
    jmp NextGameState

    return:
    jmp NextGameState.ReturnToMainLoop
}

*= $8896
StateCaptureGhost_PickUpTrap:
{
    lda #$00
    jsr label_9b35
    jsr MoveAllObjectsTowardsTargetSpeed
    jsr label_9a16
    ldx #$03
    loop:
    {
        lda ObjectPosX + 10, x
        cmp ObjectPosX2 + 10, x
        bne return
        dex
        bpl loop
    }
    lda #GameStates.PrepareMapScreen
    sta GameState
    jmp NextGameState.ReturnToMainLoop

    return:
    jmp NextGameState.ReturnToMainLoop
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

*= $9664
AddMoneyToAccount:
{
    sed
    clc
    lda MoneyInAccount + 2
    adc ZeroPagePointer1
    sta MoneyInAccount + 2
    lda MoneyInAccount + 1
    adc ZeroPagePointer1 + 1
    sta MoneyInAccount + 1
    lda MoneyInAccount
    adc ZeroPagePointer3
    sta MoneyInAccount
    bcc noOverflow

    // cap at $9999xx
    lda #$99
    sta MoneyInAccount + 1
    sta MoneyInAccount

    noOverflow:
    cld
    rts
}

*= $98eb
label_98eb:
{
    ldy #$01
    ldx #$02

    label_98ef:
    lda ObjectPosY + 10, x
    sec
    sbc ObjectPosY + 8
    lsr
    lsr
    sta ZeroPagePointer3
    lda $0030, y
    sec
    sbc #$0e
    lsr
    bcc label_990a
    lda ZeroPagePointer3
    eor #$ff
    clc
    adc #$01
    sta ZeroPagePointer3

    label_990a:
    lda ObjectPosX + 10, x
    clc
    adc ZeroPagePointer3
    sta ZeroPagePointer1, y
    dey
    dex
    dex
    bpl label_98ef
    rts
}

*= $9918
label_9918:
{
    ldx #$01

    loop:
    {
        ldy #$00
        lda ObjectPosX + 8
        cmp ZeroPagePointer1, x
        bcs label_9924
        ldy #$ff

        label_9924:
        tya
        sta $7e, x
        dex
        bpl loop
    }

    rts
}

*= $992b
label_992b:
{
    lda ObjectPosY + 10
    sta ZeroPagePointer3
    lda ObjectPosY + 12
    sta ZeroPagePointer3 + 1
    ldy $7d
    lda ZeroPagePointer1 + 1
    sec
    sbc ZeroPagePointer1
    bcs label_9940
    eor #$ff
    adc #$01

    label_9940:
    cmp #$06
    bcs label_9946
    ldy #$06

    label_9946:
    ldx #$01

    label_9948:
    lda ZeroPagePointer3, x
    sec
    sbc ObjectPosY + 8
    cmp #$60
    bcs label_9918
    lda $7e, x
    bne label_9962
    lda ZeroPagePointer1, x
    cmp ObjectPosX + 8
    bcc label_995f
    sta ObjectPosX + 8
    ldy #$00

    label_995f:
    jmp label_996c

    label_9962:
    lda ZeroPagePointer1, x
    cmp ObjectPosX + 8
    bcs label_996c
    sta ObjectPosX + 8
    ldy #$04

    label_996c:
    dex
    bpl label_9948
    sty $7d
    rts
}

*= $9972
label_9972:
{
    ldy #$00
    ldx $7d
    lda ObjectPosX + 8
    clc
    adc $a9b8, x
    sta ObjectPosX + 8
    lda ObjectPosY + 8
    clc
    adc $a9c0, x
    cmp #$70
    bcc label_998c
    lda #$6e
    ldy #$04
    
    label_998c:
    cmp #$30
    bcs label_9994
    lda #$32
    ldy #$04

    label_9994:
    sta ObjectPosY + 8
    sta ObjectPosY2 + 8
    lda ObjectPosX + 8
    cmp #$90
    bcc label_99a2
    lda #$8e
    ldy #$04
    
    label_99a2:
    cmp #$48
    bcs label_99aa
    lda #$4a
    ldy #$04

    label_99aa:
    sta ObjectPosX + 8
    sta ObjectPosX2 + 8
    tya
    clc
    adc $7d
    and #$07
    sta $7d
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

label_9a0c:
{
    lsr $2f
    lda $09
    lsr
    lsr
    lsr
    rol $2f
    rts
}


*= $9a16
label_9a16:
{
    lda $77
    and #$01
    tay
    lda ObjectPosX + 10
    sec
    sbc #$06
    cpy #$00
    bne label_9a27
    clc
    adc #$0c

    label_9a27:
    sta ObjectPosX + 14
    sta ObjectPosX2 + 14
    lda ObjectPosY + 10
    sec
    sbc #$07
    sta ObjectPosY + 14
    sta ObjectPosY2 + 14
    rts
}

*= $9a35
label_9a35:
{
    inc $79
    lda $79
    cmp #$06
    bcc label_9a41
    lda #$00
    sta $79

    label_9a41:
    ldx #$03

    label_9a43:
    lda $a9ca, x
    clc
    adc $79
    sta $2b, x
    dex
    bpl label_9a43
    lda $7a
    cmp #$49
    bcc label_9a5b
    sta ZeroPagePointer1 + 1
    lda #$9c
    sec
    sbc ZeroPagePointer1 + 1

    label_9a5b:
    sta ZeroPagePointer1 + 1
    lda ObjectPosY + 14
    sec
    sbc #$39
    sta ZeroPagePointer1
    lda ObjectPosY + 14
    sec
    sbc #$15
    sta ObjectPosY + 6
    sec
    sbc ZeroPagePointer1 + 1
    sta ObjectPosY + 2
    cmp ZeroPagePointer1
    bcs label_9a76
    lda ZeroPagePointer1

    label_9a76:
    sta ObjectPosY + 4
    lda ObjectPosY + 2
    sec
    sbc #$14
    sta ObjectPosY
    lda ObjectPosX + 14
    sta ObjectPosX
    sta ObjectPosX + 2
    sta ObjectPosX + 4
    sta ObjectPosX + 6
    rts
}

*= $9a8a
label_9a8a:
{
    ldx CaptureGhostVisitType
    lda $c8, x
    and #$0c
    cmp #$0c
    beq return
    lda #$00
    sta $2f
    lda CountdownTimer
    bne return
    pla
    pla
    lda #GameStates.CaptureGhost_CaptureGhostInTrap
    sta GameState
    jmp StateCaptureGhost_CaptureGhostInTrap.label_8823

    return:
    rts
}

*= $9aa6
label_9aa6:
{
    lda VIC_SPRITE_PRIORITY_REGISTER
    and #$ef
    tay
    lda InstalledEquipment
    and #$02
    bne continue

    // No image intensifier installed, put ghost behind house
    tya
    ora #$10
    tay

    continue:
    sty VIC_SPRITE_PRIORITY_REGISTER
    jsr label_9972
    jsr label_98eb
    lda $09
    and #$03
    bne label_9ad9
    lda $06
    and #$01
    clc
    adc $7d
    and #$07
    sta $7d
    lda $06
    and #$01
    clc
    adc #$0a
    sta $2f

    label_9ad9:
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
label_9aef:
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

*= $9b14
label_9b14:
{
    lda ObjectPosX2 + 10, x
    cmp #$20
    bcs label_9b1c
    lda #$20

    label_9b1c:
    cmp #$8c
    bcc label_9b22
    lda #$8c

    label_9b22:
    sta ObjectPosX2 + 10, x
    lda ObjectPosY2 + 10, x
    cmp #$aa
    bcs label_9b2c
    lda #$aa

    label_9b2c:
    cmp #$c8
    bcc label_9b32
    lda #$c8

    label_9b32:
    sta ObjectPosY2 + 10, x
    rts
}

*= $9b35
label_9b35:
{
    sta ZeroPagePointer1
    ldy #$02
    ldx #$01

    label_9b3b:
    jsr label_9b44
    dey
    dey
    dex
    bpl label_9b3b
    rts
}

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