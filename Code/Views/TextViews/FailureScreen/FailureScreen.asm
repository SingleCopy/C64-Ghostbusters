#importonce 
#import "FailureScreenData.asm"

*= $8c74
StateFailure_NotEnoughMoney: 
{
    jsr ResetStatesForTextDisplay
    lda #DisplayText.NotEnoughMoney
    jsr SetDisplayTextPointer
    lda #GameStates.DisplayStartingBalanceText
    sta GameState
    sta LastMiniGameResult
    jmp NextGameState.ReturnToMainLoop
}

*= $8c86
StateFailure_DisplayGoodTry:
{
    jsr ResetStatesForTextDisplay
    lda #$00
    sta LastMiniGameResult
    lda #DisplayText.GoodTry
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8c96
StateFailure_CalculateAccountBalance:
{
    jsr CalculateAccountBalance
    jmp NextGameState
}

*= $8c9C
StateFailure_FailedToClosePortal:
{
    lda #DisplayText.FailedToClosePortal
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8d3a
StateFailure_DisplayStartingBalanceText:
{
    lda #DisplayText.StartingBalance
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8d42
StateFailure_DisplayStartingBalanceAmount:
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
    jsr TrimAccountBalance
    lda #$80
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8d5d
StateFailure_DisplayEndBalanceText:
{
    lda #DisplayText.EndBalance
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8d65
StateFailure_DisplayEndBalanceAmount:
{
    lda $54
    sta MoneyInAccount
    lda $55
    sta MoneyInAccount + 1
    lda $56
    sta MoneyInAccount + 2
    jsr label_9d24
    jsr TrimAccountBalance
    lda #$80
    jsr SetDisplayTextPointer
    jmp NextGameState
}

*= $8d7f
StateFailure_SetNextGameState:
{  
    lda #GameStates.PlayLaughOnFailure
    sta GameState
    jmp NextGameState.ReturnToMainLoop
}