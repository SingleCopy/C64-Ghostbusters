#importonce 
#import "GHQData.asm"

*= $88b6
StateGHQ_Enter: 
{
    lda #$00
    sta NumberOfGhostsCaught
    lda MaxGhostTraps
    sta NumberOfEmptyTraps
    lda #$03
    sta RemainingGhostbusters
    lda #$99
    sta RemainingBackbackCharge
    jsr ResetObjectPositions
    lda #$5a
    sta ObjectPosX + 10
    lda #$a8
    sta ObjectPosY + 10
    lda #$cf
    sta ObjectPosX2 + 10
    lda #$c7
    sta ObjectPosY2 + 10
    jmp NextGameState
}

*= $88dc
StateGHQ_MoveGhostbustersFromGHQToCar:
{
    ldx #$00
    ldy #$00
    sty ZeroPagePointer1
    jsr label_9b44

    lda $30
    sta $31
    sta $32
    jsr MoveAllObjectsTowardsTargetSpeed
    ldx #$0a
    
    loop:
    {
        lda ObjectPosX, x
        cmp #$70
        bne next
        lda ObjectPosX + 2, x
        bne next
        lda #$5a
        sta ObjectPosX + 2, x
        lda #$a8
        sta ObjectPosY + 2, x
        lda #$a8
        sta ObjectPosX2 + 2, x
        lda #$c7
        sta ObjectPosY2 + 2, x

        next:
        inx
        inx
        cpx #$0e
        bcc loop
    }

    ldx #$0e
    waitLoop:
    {
        jsr DidObjectArriveAtTarget
        bne return
        dex
        dex
        bpl waitLoop
    }

    lda #GameStates.PrepareMapScreen
    sta GameState
    jmp NextGameState.ReturnToMainLoop

    return:
    jmp NextGameState.ReturnToMainLoop
}