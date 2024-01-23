#importonce 
#import "VehicleSelectionViewData.asm"

// States
*= $757e
SelectVehicleInit:
{
    //select vehicle
    lda #DisplayText.VehicleSelection
    jsr SetDisplayTextPointer
    lda #$00
    sta $15
    jmp NextGameState
}

SelectVehicleShowBalance:
{
    // you have x in account
    lda #DisplayText.YouHave
    jsr SetDisplayTextPointer
    lda #$03
    sta $15
    lda MoneyInAccount + 2
    sta $53
    lda MoneyInAccount + 1
    sta $52
    lda MoneyInAccount
    sta $51
    jmp NextGameState
}

SelectVehicleShowBalance2:
{
    jsr label_9d24
    jsr TextViewShared.TrimAccountBalance
    lda #$80
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $75b0
DisplayCarOptions:
{
    //key options
    lda #DisplayText.KeyOptions
    jsr SetDisplayTextPointer

    lda #$00
    sta CarType

    jsr label_9c83
    jmp NextGameState

    ShowCarsInfoLoop: // 75bf
    {
        jmp ChooseCar.ShowCarsInfo

        label_75c2:
        cmp #$20 // If the user has pressed Space
        bne ShowCarsInfoLoop
    }   

    jsr StateDisplayEquipmentScreenCar.Render
    jsr ClearScreen
    lda #$01
    sta TextOutputX
    sta TextOutputY
    jsr TextViewShared.EquipmentScreenFillCarColor
    ldx #ZeroPagePointer1

    Loop:
    {
        lda #$00
        sta $db49, x
        sta $db71, x
        lda TEXT_KEY_OPTIONS_NO_LINEBREAKS, x
        jsr SanitizeOutput
        sta $5749, x
        lda TEXT_KEY_OPTIONS_ONLY, x
        jsr SanitizeOutput
        sta $5771, x
        dex
        bpl Loop
    }

    ldx CarType
    lda #$01
    sta VIC_BACKGROUND_COLOR_1
    lda CAR_MULTICOLOR, x
    sta VIC_BACKGROUND_COLOR_2
    inc CarType
    lda CarType
    and #$03
    sta CarType

    lda CAR_NAME_TEXT_INDEX, x
    jsr SetDisplayTextPointer
    jsr label_9c83
    jmp NextGameState.ReturnToMainLoop
}

*= $7625
ChooseCar:
{
    lda KeyboardEntryBuffer
    cmp #'1'
    bcc DisplayCarOptions.ShowCarsInfoLoop.label_75c2
    cmp #'5'
    bcs ShowCarsInfo
    sec
    sbc #$01
    and #$03
    sta CarType
    tax

    // can afford the car?
    lda CAR_PRICE_LOW, x
    sta ZeroPagePointer1 + 1
    lda CAR_PRICE_HIGH, x
    sta ZeroPagePointer3
    lda #$00
    sta ZeroPagePointer1
    jsr TextViewShared.HasEnoughMoney
    bcs BuyCar

    ShowCarsInfo:   // $764b
    {
        lda #GameStates.ClearScreenAndResetTextOutputPos
        sta GameState
        jmp NextGameState.ReturnToMainLoop
    }

    BuyCar:
    jsr TextViewShared.DeductMoney

    PrepareScreen:
    jsr ClearScreen
    // Continues on to ResetTextOutputCoords($7658)
}

*= $7661
StateDisplayEquipmentScreenCar:
{
    jsr Render
    jmp NextState  // NOTE: Could save a jmp call here

    Render: // $7667
    {
        //display car graphic on screen
        ldx CarType
        lda CAR_GRAPHIC_ADDRESS_HIGH, x
        sta ZeroPagePointer4 + 1
        sta ZeroPagePointer3
        lda CAR_GRAPHIC_ADDRESS_LOW, x
        sta ZeroPagePointer4
        lda #$00
        sta ZeroPagePointer1
        lda #$5a
        sta ZeroPagePointer1 + 1
        ldy #$00

    label_767f:
        lda (ZeroPagePointer4), y
        sta (ZeroPagePointer1), y
        iny
        bne label_767f
        inc ZeroPagePointer4 + 1
        inc ZeroPagePointer1 + 1
        lda ZeroPagePointer1 + 1
        cmp #$5d
        bcc label_767f

    label_7690:
        lda ZeroPagePointer4
        sec
        sbc #$80
        sta ZeroPagePointer4
        lda ZeroPagePointer4 + 1
        sbc #$00
        sta ZeroPagePointer4 + 1
        ldy #$00

    label_769f:
        lda (ZeroPagePointer4), y
        tax
        lda $e700, x
        sta (ZeroPagePointer1), y
        iny
        bpl label_769f
        lda ZeroPagePointer1
        clc
        adc #$80
        sta ZeroPagePointer1
        lda ZeroPagePointer1 + 1
        adc #$00
        sta ZeroPagePointer1 + 1
        cmp #$60
        bcc label_7690
        rts
    }
    
    NextState:
        jmp NextGameState
}