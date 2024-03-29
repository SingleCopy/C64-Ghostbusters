#importonce 
#import "GameOverSuccessScreenData.asm"

.namespace GameOverSuccessScreen
{
    .namespace States
    {
        *= $8ca4
        DisplayMadeMoreMoney:
        {
            lda #DisplayText.MadeMoreMoney
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8cac
        WriteNewAccountBalance:
        {
            lda #$00
            sta MoneyInAccount + 2
            jsr label_9d24
            jsr TextScreenShared.TrimAccountBalance
            lda #$80
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8cbe
        DisplayNewAccountNumber:
        {
            lda #DisplayText.NewAccountNumber
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8cc6
        WriteNewAccountNumber:
        {
            jsr label_90ee
            lda AccountNumber
            sta ZeroPagePointer1
            lda AccountNumber + 1
            sta ZeroPagePointer1 + 1
            lda AccountNumber + 2
            sta ZeroPagePointer3
            lda AccountNumber + 3
            sta ZeroPagePointer3 + 1
            lda #$04
            jsr label_9d4d
            lda #$80
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8cea
        WriteDownAccountBalance:
        {
            lda #DisplayText.WriteDownAccountNumber
            jsr TextScreenShared.SetDisplayTextPointer
            lda #GameStates.PlayLaughOnFailure
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }

        *= $8cf6
        DisplayCongratulations:
        {
            jsr ResetStatesForTextDisplay
            lda #$00
            sta LastMiniGameResult
            lda #DisplayText.Congratulations
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d06
        CalculateAccountBalance:
        {
            jsr TextScreenShared.CalculateAccountBalance
            jmp NextGameState    
        }

        *= $8d0c
        DisplayPortalClosed:
        {
            lda #DisplayText.PortalClosed
            jsr TextScreenShared.SetDisplayTextPointer
            lda #GameStates.DisplayMadeMoreMoney
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }
    }


    *= $90ee
    label_90ee:
    {
        lda MoneyInAccount
        sta ZeroPagePointer3
        lda MoneyInAccount + 1
        sta $27
        jsr TextScreenShared.label_91b6
        ldx ZeroPagePointer1
        lda ZeroPagePointer3
        clc
        adc $27
        bne label_9104
        lda #$01

        label_9104:
        sta $07

        label_9106:
        jsr TextScreenShared.label_91a6
        dex
        bne label_9106
        lda $07
        sta ZeroPagePointer3 + 1
        ldx #$02
        lda #$00
        sta AccountNumber
        sta AccountNumber + 1
        sta AccountNumber + 2
        sta AccountNumber + 3
        sta $29

        label_9122:
        lda ZeroPagePointer3, x
        ldy #$07

        label_9126:
        lsr
        ror AccountNumber + 3
        ror AccountNumber + 2
        ror AccountNumber + 1
        ror AccountNumber
        pha
        inc $29
        lda $29
        cmp #$03
        bne label_914d
        lda #$00
        sta $29
        clc
        ror AccountNumber + 3
        ror AccountNumber + 2
        ror AccountNumber + 1
        ror AccountNumber

        label_914d:
        pla
        dey
        bpl label_9126
        dex
        bpl label_9122
        rts
    }

    *= $9d4d
    label_9d4d:
    {
        sta $27
        ldy #$00
    }
}