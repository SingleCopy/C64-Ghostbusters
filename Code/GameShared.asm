*= $3bdc
ResetVariablesToZero: // $3bdc
{
    lda #$00
    sta $e8
    sta SID_VOICE_3_CONTROL_REGISTER
    sta $ea81
    sta $98
    rts
}

*= $73bd
label_73bd:
{
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    bcs CityMapScreen.label_73c6
    jmp CityMapScreen.label_73c6.JumpToNextTableState
}

// replaces blanks with zero and substracts 40 if high enough (make upper case?)
*= $7615
SanitizeOutput:
{
    cmp #$20
    bne label_761d
    lda #$00
    beq return

    label_761d:
    cmp #$40
    bcc return
    sec
    sbc #$40

    return:
    rts
}

*= $8d86
NextGameState:
{
    lda #$00
    sta LastKeyPressed
    inc GameState
    nop

    ReturnToMainLoop:
    jmp label_6fe2.MainLoop
}

*= $8d96
ResetStatesForTextDisplay:
{
    lda #$08
    sta BackgroundColor
    jsr ClearScreen
    ldx #$0f
    lda #$00

    loop:
    {
        sta ObjectPosX, x
        dex
        bpl loop
    }

    jsr ClearMemory_0082_008A

    lda #$ff
    sta $88
    sta $89
    sta $8a
    jsr ResetSIDRegisters
    lda #$03
    sta $15
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

*= $96CA
DisableKeyboardInterrupts:
{
    ldx #$ff 
    stx CIA1_DATA_DIRECTION_PORT_A // Disable keyboard interrupts
    stx CIA1_DATA_PORT_A // Disable joystick interrupts
    inx // set x to 0
    stx CIA1_DATA_DIRECTION_PORT_B  // Disable the SID chip
    lda CIA1_DATA_PORT_B
    and #$1f
    sta JoystickValue

    lda JoystickValue
    cmp #$1f    // Check if the joystick has been pressed?
    beq return
    stx $45
    stx $46

    return:
    rts
}

*= $96E8
ScanKeyboard:
{
    lda #$ff
    sta CIA1_DATA_PORT_A
    cmp CIA1_DATA_PORT_B
    bne return
    cmp CIA1_DATA_PORT_A
    bne return
    lda #$3f
    sta ZeroPagePointer1
    lda #$ff
    sta $19
    lda #$00
    sta CIA1_DATA_PORT_A
    lda CIA1_DATA_PORT_B
    cmp #$ff
    beq label_9751

    loop:
    {
        lda ZeroPagePointer1
        and #$07
        tax
        lda ZeroPagePointer1
        lsr
        lsr
        lsr
        tay
        lda BIT_TABLE + 8, x
        sta CIA1_DATA_PORT_A
        lda CIA1_DATA_PORT_B
        and BIT_TABLE, y
        bne next
        ldx ZeroPagePointer1
        lda keyboardMatrixLookup, x
        cmp #$21
        beq next
        stx $19

    next:
        dec ZeroPagePointer1
        bpl loop
    }

    ldx $19
    cpx #$ff
    beq label_9751
    lda $389e, x
    cmp $18
    beq return
    cmp #$2f
    beq label_9751
    sta LastKeyPressed
    sta $18
    lda #$00
    sta $45
    sta $46
    jmp return

    label_9751:
    lda #$00
    sta $18

    return: // $9755
    rts
}

// x = text index
*= $99cc
FetchScrollerText:
{
    lda $4b
    bne ScrollerAlreadyActive
    lda TEXT_LOOKUP_LOW, x
    sta ZeroPagePointer5
    lda TEXT_LOOKUP_HIGH, x
    sta ZeroPagePointer5 + 1

    ldx #$00
    ldy #$00
    
    FetchNextChar:
    {
        lda (ZeroPagePointer5), y
        cmp #$ff
        beq EndOfText
        cmp #$20
        bne NotABlank
        lda #$00

        NotABlank:
        cmp #$40
        bcc NoCharOverflow
        sbc #$40

        NoCharOverflow:
        sta FORMATTED_SCROLLER_TEXT, x

        inc $4a
        iny
        inx
        bne FetchNextChar
    }

    EndOfText:
    sta FORMATTED_SCROLLER_TEXT, x
    lda #$01
    sta $4b

    ScrollerAlreadyActive:
    rts
}

*= $9ada
CheckFireButtonIsPressed:
{
    lda JoystickValue
    and #FIRE_BUTTON_MASK
    cmp FireButtonPressed   // Set some register flags, maybe?
    sta FireButtonPressed
    rts
}

*= $9c08
label_9c08:
{
    cmp ZeroPagePointer1
    bcc label_9c13
    cmp ZeroPagePointer1 + 1
    bcs label_9c13
    sec
    bcs label_9c14

    label_9c13:
    clc

    label_9c14:
    rts
}

// moves object in slot x towards target (POS_X2/Y2)
*= $9c23
MoveObjectTowardsTarget:
{
    lda #$03

    CustomSpeed:
    sta ZeroPagePointer1 + 1
    lda ObjectPosX2, x
    sec
    sbc ObjectPosX, x
    beq label_9c4e
    php
    cmp ZeroPagePointer1 + 1
    bcc label_9c38
    lda ZeroPagePointer1 + 1
    sec
    sbc #$01

    label_9c38:
    sta ZeroPagePointer1
    plp
    bcs label_9c47
    lda ObjectPosX, x
    sec
    sbc ZeroPagePointer1
    sta ObjectPosX, x
    jmp label_9c4e

    label_9c47:
    lda ObjectPosX, x
    clc
    adc ZeroPagePointer1
    sta ObjectPosX, x

    label_9c4e:
    lda ObjectPosY2, x
    sec
    sbc ObjectPosY, x
    beq label_9c75
    php
    cmp ZeroPagePointer1 + 1
    bcc label_9c5f
    lda ZeroPagePointer1 + 1
    sec
    sbc #$01

    label_9c5f:
    sta ZeroPagePointer1
    plp
    bcs label_9c6e
    lda ObjectPosY, x
    sec
    sbc ZeroPagePointer1
    sta ObjectPosY, x
    jmp label_9c75


    label_9c6e:
    lda ObjectPosY, x
    clc
    adc ZeroPagePointer1
    sta ObjectPosY, x

    label_9c75:
    rts
}

*= $9d96
Copy1536BytesFromZP5ToZP6:
{
    ldx #$05
    ldy #$00

    CopyXPlusYMultipliedBy256BytesFromZP5ToZP6:
    {
        lda (ZeroPagePointer5), y
        sta (ZeroPagePointer6), y
        iny
        bne CopyXPlusYMultipliedBy256BytesFromZP5ToZP6
        inc ZeroPagePointer5 + 1
        inc ZeroPagePointer6 + 1
        dex
        bpl CopyXPlusYMultipliedBy256BytesFromZP5ToZP6
    }
    rts
}