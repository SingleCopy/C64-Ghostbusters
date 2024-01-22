#importonce 
#import "TextViewSharedData.asm"
#import "/AccountView/AccountView.asm"
#import "/VehicleSelectionView/VehicleSelectionView.asm"
#import "/EquipmentView/EquipmentView.asm"
#import "/GameOverFailureScreen/GameOverFailureScreen.asm"
#import "/GameOverSuccessScreen/GameOverSuccessScreen.asm"

*= $35e6
EquipmentScreenFillCarColor:
{          
    lda #$12

    // a = x offset on screen to start with
    FillCarColor:
    sta ZeroPagePointer3 + 1
    ldx #$00

    NextLine:
    {
        lda #>SCREEN_CHAR   // $54
        sta ZeroPagePointer4 + 1
        lda #>COLOR_RAM      // $d8
        sta ZeroPagePointer1 + 1
        txa
        clc
        adc #$a0
        sta ZeroPagePointer1
        sta ZeroPagePointer4
        lda LOOKUP_AB07, x
        sta ZeroPagePointer3
        ldy ZeroPagePointer3 + 1

        loop:
        {
            lda ZeroPagePointer3
            sta (ZeroPagePointer4), y
            lda #$08
            sta (ZeroPagePointer1), y
            inc ZeroPagePointer3
            tya
            clc
            adc #$28
            tay
            bcc continue
            inc ZeroPagePointer4 + 1
            inc ZeroPagePointer1 + 1

            continue:
                lda ZeroPagePointer3
                and #$0f
                bne loop
        }

        inx
        cpx #$0c
        bcc NextLine
    }
    rts
}

// deducts the value in ZEROPAGE_POINTER_1, ZEROPAGE_POINTER_1 + 1, ZEROPAGE_POINTER_3 from the current balance
// sets to 0
*= $9636
DeductMoney:
{
    sed
    sec
    lda MoneyInAccount + 2
    sbc ZeroPagePointer1
    sta MoneyInAccount + 2
    lda MoneyInAccount + 1
    sbc ZeroPagePointer1 + 1
    sta MoneyInAccount + 1
    lda MoneyInAccount
    sbc ZeroPagePointer3
    bcs HasEnoughMoney
    lda #$00
    sta MoneyInAccount + 2
    sta MoneyInAccount + 1

    HasEnoughMoney:
    sta MoneyInAccount
    cld
    rts
}

*= $7658
ResetTextOutputCoords:
{
    lda #$01
    sta TextOutputX
    sta TextOutputY
    jmp NextGameState
}

*= $8d18
State_PlayLaughOnFailure:
{
    lda LastMiniGameResult
    beq continue

    // laugh
    lda #$03
    jsr TriggerSpeech

    continue:
    lda #$ff
    sta $02
    jmp NextGameState
}

*= $8d29
State_ResetGame:
{
    lda $19
    cmp #$20
    beq resetGame
    cmp #$28
    beq resetGame
    jmp NextGameState.ReturnToMainLoop

    resetGame: // 8d36
    sei
    jmp GameMainInit
}

// checks if enough money is in the account for a value from ZEROPAGE_POINTER_1, ZEROPAGE_POINTER_1 + 1, ZEROPAGE_POINTER_3
// carry is set if enough
*= $9654
HasEnoughMoney:
{
    sed
    sec
    lda MoneyInAccount + 2
    sbc ZeroPagePointer1
    lda MoneyInAccount + 1
    sbc ZeroPagePointer1 + 1
    lda MoneyInAccount
    sbc ZeroPagePointer3
    cld
    rts
}

*= $9063
TrimAccountBalance:
{
    // find first (non-space) digit of account money
    ldx #$00
    Loop:
    {
        lda AccountBalance, x
        cmp #$20
        bne Continue
        inx
        bne Loop
    }

    Continue:
        // shift left
        ldy #$00

    Loop2:
    {
        lda AccountBalance, x
        sta AccountBalance, y
        cmp #$ff
        beq return
        inx
        iny
        bne Loop2
    }

    return:
        rts
}

*= $9b90
CalculateAccountBalance:
{
    // clear account
    ldx #$13
    lda #$00
    loop:
    {
        sta AccountBalance, x
        dex
        bpl loop
    }

    ldx #$ff
    ldy #$00

    label_9b9e:
    inx
    cpx #$14
    bcs label_9bb9
    lda AccountName, x
    cmp #$2c
    bne label_9b9e

    label_9baa:
    inx
    cpx #$14
    bcs label_9bb9
    lda AccountName, x
    sta AccountBalance, y
    iny
    jmp label_9baa

    label_9bb9:
    ldx #$13

    label_9bbb:
    lda AccountBalance, x
    bne label_9bc3
    dex
    bpl label_9bbb

    label_9bc3:
    inx
    lda #$20
    sta AccountBalance, x
    inx
    ldy #$00

    label_9bcc:
    cpx #$14
    bcs label_9be3
    lda AccountName, y
    cmp #$41
    bcc label_9be3
    cmp #$5b
    bcs label_9be3
    sta AccountBalance, x
    iny
    inx
    jmp label_9bcc

    label_9be3:
    lda #$ff
    sta AccountBalance, x
    lda #$80
    jsr SetDisplayTextPointer
    rts
}