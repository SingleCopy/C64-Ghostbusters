#importonce 
#import "AccountViewData.asm"

.label IntoStarted = $6328

*= $7061
label_7061:
{
    jsr DisableKeyboardInterrupts
    lda $02
    cmp #$80
    beq label_7070
    lda #$1f
    sta JoystickValue
    sta $34
}

*= $7070
label_7070:
{
    jsr ScanKeyboard
    lda $20
    cmp #$01
    bne label_708c
    lda #$02
    sta $20
    lda #$80
    sta $02
    asl
    sta $03
    sta $04
    sta $05
    ldx #$11
    bne PrepareToCopy.CopyBytes
}

*= $708C
label_708c: 
{
    lda $08
    bne label_70ba
    bit $02
    bmi label_70aa
    inc $03
    lda $03
    and #$07
    sta $03
    bne label_70aa
    lda #$c0
    sta $02
}

*= $70a2
PrepareToCopy:
{
    // copy 12 bytes from $9051 to $33
    ldx #$0b

    CopyBytes:
    {
        jsr Copy18BytesFrom9051To33.CopyXBytesFrom9051To33
        jmp NextGameState.ReturnToMainLoop
    }
}

*= $70aa
label_70aa:
{
    inc $46
    bne label_70ba
    inc $45
    lda $45
    cmp #$04
    bcc label_70ba
    lda #$80
    sta $45
}

*= $70ba
label_70ba:
{
    lda GameState
    cmp #GameStates.PrepareEnding
    bcs label_70ee
    lda $19
    cmp #$3f
    beq label_70d7
}

*= $70c6
label_70c6:
{
    lda $47
    and #$bf
    sta $47
    bmi label_70ee
    lda SHADOW_SID_VOLUME
    sta SID_VOICE_3_MAIN_VOLUME_CONTROL
    jmp label_70ee
}

*= $70d7
label_70d7: {
    lda GameState
    cmp #GameStates.CityMapUpdateLoop
    bcc label_70c6
    bit $47
    bvs label_70ee
    lda $47
    eor #$80
    ora #$40
    sta $47
    lda #$00
    sta SID_VOICE_3_MAIN_VOLUME_CONTROL
}

*= $70ee
label_70ee: {
    bit $47
    bmi return
    inc $09
    bit $02
    bpl return
    lda $14
    beq label_7106
    dec $14
    bne return
    jmp PrepareToCopy

    return: // $7103
    jmp NextGameState.ReturnToMainLoop
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
    beq LineBreak
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

    LineBreak:
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
    jsr SetDisplayTextPointer
}

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

*= $74a2
StartIntro:
{
    lda #DisplayText.Intro
    jsr SetDisplayTextPointer
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

    jsr label_9c83
    jmp NextGameState
}

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
        jsr SetDisplayTextPointer
        jsr label_9c83
        jmp NextGameState
    }
}

HaveAccountQuery:
{
    lda KeyboardEntryBuffer
    cmp #'Y'
    beq EnterAccountNumber
    cmp #ZeroPagePointer2
    beq HasNoAccount

    lda #GameStates.InvalidHaveAccountQueryOption
    sta GameState
    jmp InvalidHaveAccountQueryOption.Reset

    HasNoAccount:
        // init with $10000
        lda #$01
        sta MoneyInAccount

        // welcome to your new franchise
        lda #DisplayText.NewBusiness
        jsr SetDisplayTextPointer
        lda #GameStates.ClearScreenAndResetTextOutputPos
        sta GameState
        jmp NextGameState.ReturnToMainLoop
}

EnterAccountNumber:
{
    lda #DisplayText.EnterAccountNumber
    jsr SetDisplayTextPointer
    jsr label_9c83
    jmp NextGameState
}

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
    jsr SetDisplayTextPointer
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
    jsr SetDisplayTextPointer
    lda #$00
    sta $15
    jmp NextGameState

    Continue:
    jmp NextGameState.ReturnToMainLoop
}

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

ClearScreenAndResetTextOutputPos:
{
    jsr ClearScreen
    lda #$01
    sta TextOutputX
    sta TextOutputY
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
    jsr label_91b6
    ldx ZeroPagePointer1
    lda ZeroPagePointer3
    clc
    adc $27
    bne label_9189
    lda #$01

    label_9189:
    sta $07

    label_918b:
    jsr label_91a6
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

*= $91a6
label_91a6:
{
    lda $07
    asl
    eor $07
    asl
    eor $07
    asl
    asl
    eor $07
    asl
    rol $07
    rts
}

*= $91b6
label_91b6:
{
    lda #$00
    sta ZeroPagePointer1
    ldx #$13

    label_91bc:
    lda AccountName, x
    clc
    adc ZeroPagePointer1
    sta ZeroPagePointer1
    dex
    bpl label_91bc
    rts
 }

*= $9bee
SetDisplayTextPointer:
{
    bmi msbSet

    ldx #$00
    beq skip

    msbSet:
    ldx #$01

    skip:
    stx $ea76
    sta CurrentlyDisplayedText
    asl
    tax
    // low
    lda TEXT_LOOKUP, x
    sta ZeroPagePointer2
    // high
    lda TEXT_LOOKUP + 1, x
    sta ZeroPagePointer2 + 1
    rts
}

*= $9c83
label_9c83:
{
    lda #$01
    sta NumberOfKeysInBuffer
    rts
}

*= $9c88
ReduceKeyboardEntryBuffer:
{
    ldx NumberOfKeysInBuffer
    sta KeyboardEntryBuffer - 1, x
    inc NumberOfKeysInBuffer
}

*= $9c8f
PrintChar: 
{
    cmp #$00
    sta ZeroPagePointer3 + 1
    beq EndOfText
    bpl NotXJump

    // jump in X
    and #$3f
    sta TextOutputX
    jmp EndOfText

    NotXJump:
        cmp #$0d
        beq LineBreak
        cmp #$20
        bne Continue
        lda #$00

    Continue:
        cmp #$40
        bcc CharOverflow
        sec
        sbc #$40

    CharOverflow:
        sta ZeroPagePointer3
        lda #$15
        sta ZeroPagePointer1 + 1

        ldy TextOutputY
        lda TEXT_LINE_OFFSET, y
        asl
        rol ZeroPagePointer1 + 1
        asl
        rol ZeroPagePointer1 + 1
        sta ZeroPagePointer1
        lda ZeroPagePointer3
        ldy TextOutputX
        sta (ZeroPagePointer1), y

        // change high byte to color RAM
        lda ZeroPagePointer1 + 1
        and #$03
        ora #$d8
        sta ZeroPagePointer1 + 1

        // char color
        lda TextOutputColor
        sta (ZeroPagePointer1), y

        inc TextOutputX
        lda $15
        beq EndOfText
        lda TextOutputColor
        bne EndOfText
        lda TextOutputX
        cmp #$20
        bcc EndOfText
        lda ZeroPagePointer3 + 1
        cmp #$20
        bne EndOfText

    LineBreak:
        lda #$01
        sta TextOutputX
        inc TextOutputY

    EndOfText:
    rts
}

*= $9cfc
ConvertAccountNumbertoBCD:
{
    ldx #$00
    stx ZeroPagePointer1
    stx ZeroPagePointer1 + 1
    stx ZeroPagePointer3
    stx ZeroPagePointer3 + 1
    OuterLoop:
    {
        lda KeyboardEntryBuffer, x
        beq Return
        and #$0f
        ldy #$03

        InnerLoop:
        {
            asl ZeroPagePointer3 + 1
            rol ZeroPagePointer3
            rol ZeroPagePointer1 + 1
            rol ZeroPagePointer1
            dey
            bpl InnerLoop
        }

        ora ZeroPagePointer3 + 1
        sta ZeroPagePointer3 + 1
        inx
        cpx #$08
        bcc OuterLoop
    }
    
    Return:
    rts
}

*= $9d24
label_9d24:
{
    lda MoneyInAccount
    sta ZeroPagePointer1
    lda MoneyInAccount + 1
    sta ZeroPagePointer1 + 1
    lda MoneyInAccount + 2
    sta ZeroPagePointer3
    lda #$30
    sta AccountBalance
    ldy #$01
    lda #$03
    sta $27
    jsr label_9d51
    lda #$ff
    sta $ea17, y
    jsr label_9d74
    dex
    lda #ZeroPagePointer1 + 1
    sta AccountBalance, x
    rts
}

*= $9d4d
label_9d4d:
    sta $27
    ldy #$00

*= $9d51
label_9d51:
{
    ldx #$00

    loop:
    {
        lda ZeroPagePointer1, x
        lsr
        lsr
        lsr
        lsr
        ora #$30
        sta AccountBalance, y
        iny
        lda ZeroPagePointer1, x
        and #$0f
        ora #$30
        sta AccountBalance, y
        iny
        inx
        cpx $27
        bcc loop
    }

    lda #$ff
    sta AccountBalance, y
    rts
}

 label_9d74:
 {
    ldx #$00
    loop:
    {
        lda $ea15, x
        cmp #$ff
        beq return
        cmp #$2e
        beq return
        lda AccountBalance, x
        cmp #$ff
        beq return
        cmp #$30
        bne return
        lda #$20
        sta AccountBalance, x
        inx
        jmp loop
    }
    return: // $9d95
    rts
 }