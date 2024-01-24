#importonce 
#import "GHQData.asm"

.namespace GHQScreen 
{
    .namespace States
    {
        *= $88b6
        Init: 
        {
            lda #$00
            sta NumberOfGhostsCaught
            lda MaxGhostTraps
            sta NumberOfEmptyTraps
            lda #$03
            sta RemainingGhostbusters
            lda #$99
            sta RemainingBackbackCharge
            jsr CityMapScreen.ResetObjectPositions
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
        MoveGhostbustersFromGHQToCar:
        {
            ldx #$00
            ldy #$00
            sty ZeroPagePointer1
            jsr BuildingScreenShared.label_9b44

            lda $30
            sta $31
            sta $32
            jsr BuildingScreenShared.MoveAllObjectsTowardsTargetSpeed
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
                jsr BuildingScreenShared.DidObjectArriveAtTarget
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
    }
}