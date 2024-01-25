#importonce 
#import "AccountScreenData.asm"

.namespace AccountScreen
{
    .label IntoStarted = $6328

    .namespace States 
    {
        *= $747e
        InitIntro:
        {
            lda $eab2
            cmp #$28
            bne StartIntro

            // When do we get here?

            lda IntoStarted
            beq StartIntro

            lda #$00
            sta MoneyInAccount + 2

            jsr RestoreAccountBalance

            // make sure the account is at least 1$
            lda MoneyInAccount
            ora MoneyInAccount + 1
            bne continue

            lda #$01
            sta MoneyInAccount

            continue:
            lda #GameStates.ClearScreenAndResetTextOutputPos
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }        

        *= $74bb
        StoreAccountName:
        {
            ldx #$00
            loop:
            {
                lda KeyboardEntryBuffer, x
                sta AccountName, x
                inx
                cpx #$14
                bcc loop
            }

            lda #$01
            sta IntoStarted
            
            Enter:  // $74cd
            {
                // enter account name
                lda #DisplayText.QueryExistingAccount
                jsr TextScreenShared.SetDisplayTextPointer
                jsr TextScreenShared.label_9c83
                jmp NextGameState
            }
        }

        *= $74d8
        HaveAccountQuery:
        {
            lda KeyboardEntryBuffer
            cmp #'Y'
            beq EnterAccountNumber
            cmp #ZeroPagePointer2
            beq hasNoAccount

            lda #GameStates.InvalidHaveAccountQueryOption
            sta GameState
            jmp InvalidHaveAccountQueryOption.Reset

            hasNoAccount:
            // init with $10000
            lda #$01
            sta MoneyInAccount

            // welcome to your new franchise
            lda #DisplayText.NewBusiness
            jsr TextScreenShared.SetDisplayTextPointer
            lda #GameStates.ClearScreenAndResetTextOutputPos
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }

        *= $7505
        AccountNumberEntered:
        {
            jsr ConvertAccountNumbertoBCD
            lda #$00
            sta MoneyInAccount + 2
            lda ZeroPagePointer1
            sta AccountNumber
            lda ZeroPagePointer1 + 1
            sta AccountNumber + 1
            lda ZeroPagePointer3
            sta AccountNumber + 2
            lda ZeroPagePointer3 + 1
            sta AccountNumber + 3

            jsr RestoreAccountBalance

            // was valid account?
            lda MoneyInAccount
            ora MoneyInAccount + 1
            bne continue

            // invalid account number
            lda #DisplayText.InvalidAccountNumber
            jsr TextScreenShared.SetDisplayTextPointer
            lda #$01
            sta TextOutputX
            lda #$0f
            sta TextOutputY
            lda #$bf
            sta CountdownTimer
            jmp NextGameState

            continue:
            lda #GameStates.ClearScreenAndResetTextOutputPos
            sta GameState
            jmp NextGameState.ReturnToMainLoop
        }

        *= $7544
        InvalidHaveAccountQueryOption:
        {
            lda CountdownTimer
            bne Continue

            Reset:
            lda #$01
            sta TextOutputX
            lda #$0d
            sta TextOutputY

            // $eb00 (?)
            lda #DisplayText.InvalidAccount
            jsr TextScreenShared.SetDisplayTextPointer
            lda #$00
            sta $15
            jmp NextGameState

            Continue:
            jmp NextGameState.ReturnToMainLoop
        }

        *= $755f
        InvalidAccountNumberEntered:
        {
            lda #$01
            sta TextOutputX
            lda #$0c
            sta TextOutputY
            lda #$03
            sta $15
            lda #GameStates.InitIntro
            sta GameState
            jmp StoreAccountName.Enter
        }

        *= $7572
        ClearScreenAndResetTextOutputPos:
        {
            jsr ClearScreen
            lda #$01
            sta TextOutputX
            sta TextOutputY
            jmp NextGameState
        } 
    }

    *= $7347
    label_7347: 
    {
        lda NumberOfKeysInBuffer
        beq HandleEnterKeyPressed
        lda LastKeyPressed
        beq label_7396

        // Add Beep when key is pressed
        ldy #$00
        sty SID_VOICE_3_CONTROL_REGISTER
        ldy #$41
        sty SID_VOICE_3_CONTROL_REGISTER

        cmp #$0d
        beq lineBreak
        cmp #$7f
        bne label_7377

        lda NumberOfKeysInBuffer
        cmp #$01
        beq label_7392
        dec TextOutputX
        dec NumberOfKeysInBuffer
        lda #$20
        jsr ReduceKeyboardEntryBuffer

        dec TextOutputX
        dec NumberOfKeysInBuffer
        jmp label_7392

        label_7377:
        lda TextOutputX
        cmp #$25
        bcs label_7386

        lda #$01
        sta TextOutputColor

        lda LastKeyPressed
        jsr ReduceKeyboardEntryBuffer

        label_7386:
        jmp label_7392

        lineBreak:
        ldx NumberOfKeysInBuffer
        lda #$00
        sta KeyboardEntryBuffer - 1, x
        sta NumberOfKeysInBuffer

        label_7392:
        lda #$00
        sta LastKeyPressed

        label_7396:
        jmp NextGameState.ReturnToMainLoop
    }

    *= $7399
    HandleEnterKeyPressed:
    {
        lda $5e
        beq label_73bd
        ldx #$09

        label_739f:
        {
            lda LOOKUP_AAD3, x
            sta $541a, x
            lda #$2d
            sta $546a, x
            dex
            bpl label_739f
        }

        jsr label_9d24
        lda #$01
        sta TextOutputY
        lda #$1c
        sta TextOutputX

        lda #$80
        jsr TextScreenShared.SetDisplayTextPointer
    }

    *= $74a2
    StartIntro:
    {
        lda #DisplayText.Intro
        jsr TextScreenShared.SetDisplayTextPointer
        lda #$03
        sta $15

        ldx #$13
        lda #$00

        loop:
        {
            sta KeyboardEntryBuffer, x
            dex
            bpl loop
        }

        jsr TextScreenShared.label_9c83
        jmp NextGameState
    }

    *= $74fa
    EnterAccountNumber:
    {
        lda #DisplayText.EnterAccountNumber
        jsr TextScreenShared.SetDisplayTextPointer
        jsr TextScreenShared.label_9c83
        jmp NextGameState
    }

    // sets balance to zero if invalid
    *= $9155
    RestoreAccountBalance:
    {
        ldx #$03
        lda #$00
        sta ZeroPagePointer3
        sta ZeroPagePointer3 + 1
        sta $27

        label_915f:
        lda AccountNumber, x
        stx $28
        ldx #$01

        label_9166:
        asl
        ldy #$02

        label_9169:
        asl
        rol $27
        rol ZeroPagePointer3 + 1
        rol ZeroPagePointer3
        dey
        bpl label_9169
        dex
        bpl label_9166
        ldx $28
        dex
        bpl label_915f
        jsr TextScreenShared.label_91b6
        ldx ZeroPagePointer1
        lda ZeroPagePointer3
        clc
        adc $27
        bne label_9189
        lda #$01

        label_9189:
        sta $07

        label_918b:
        jsr TextScreenShared.label_91a6
        dex
        bne label_918b
        lda $07
        cmp ZeroPagePointer3 + 1
        beq label_919d
        lda #$00
        sta ZeroPagePointer3
        sta $27

        label_919d:
        lda ZeroPagePointer3
        sta MoneyInAccount
        lda $27
        sta MoneyInAccount + 1
        rts
    }

    *= $9c88
    ReduceKeyboardEntryBuffer:
    {
        ldx NumberOfKeysInBuffer
        sta KeyboardEntryBuffer - 1, x
        inc NumberOfKeysInBuffer
    }

    *= $9cfc
    ConvertAccountNumbertoBCD:
    {
        ldx #$00
        stx ZeroPagePointer1
        stx ZeroPagePointer1 + 1
        stx ZeroPagePointer3
        stx ZeroPagePointer3 + 1

        outerLoop:
        {
            lda KeyboardEntryBuffer, x
            beq return
            and #$0f
            ldy #$03

            innerLoop:
            {
                asl ZeroPagePointer3 + 1
                rol ZeroPagePointer3
                rol ZeroPagePointer1 + 1
                rol ZeroPagePointer1
                dey
                bpl innerLoop
            }

            ora ZeroPagePointer3 + 1
            sta ZeroPagePointer3 + 1
            inx
            cpx #$08
            bcc outerLoop
        }
        
        return:
        rts
    }
}