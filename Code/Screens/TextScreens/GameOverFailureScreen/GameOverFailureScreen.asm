#importonce 
#import "GameOverFailureScreenData.asm"

.namespace GameOverFailureScreen
{
    .namespace States
    {
        *= $8c74
        NotEnoughMoney: 
        {
            jsr ResetStatesForTextDisplay
            lda #DisplayText.NotEnoughMoney
            jsr TextScreenShared.SetDisplayTextPointer
            lda #GameStates.DisplayStartingBalanceText
            sta GameState
            sta LastMiniGameResult
            jmp NextGameState.ReturnToMainLoop
        }

        *= $8c86
        DisplayGoodTry:
        {
            jsr ResetStatesForTextDisplay
            lda #$00
            sta LastMiniGameResult
            lda #DisplayText.GoodTry
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8c96
        CalculateAccountBalance:
        {
            jsr TextScreenShared.CalculateAccountBalance
            jmp NextGameState
        }

        *= $8c9C
        FailedToClosePortal:
        {
            lda #DisplayText.FailedToClosePortal
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d3a
        DisplayStartingBalanceText:
        {
            lda #DisplayText.StartingBalance
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d42
        DisplayStartingBalanceAmount:
        {
            ldx #$02
            loop: //8d44
            {
                lda MoneyInAccount, x
                sta $54, x
                lda $51, x
                sta MoneyInAccount, x
                dex
                bpl loop
            }

            jsr label_9d24
            jsr TextScreenShared.TrimAccountBalance
            lda #$80
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d5d
        DisplayEndBalanceText:
        {
            lda #DisplayText.EndBalance
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d65
        DisplayEndBalanceAmount:
        {
            lda $54
            sta MoneyInAccount
            lda $55
            sta MoneyInAccount + 1
            lda $56
            sta MoneyInAccount + 2
            jsr label_9d24
            jsr TextScreenShared.TrimAccountBalance
            lda #$80
            jsr TextScreenShared.SetDisplayTextPointer
            jmp NextGameState
        }

        *= $8d7f
        SetLaughSoundState:
        {  
            lda #GameStates.PlayLaughOnFailure
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }
    }
}