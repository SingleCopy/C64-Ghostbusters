#importonce 
#import "EnterZuulScreenData.asm"

.namespace EnterZuulScreen 
{
    .namespace States
    {
        *= $8a2c
        Init: 
        {
            ldx #$07
            lda #$00
            sta $77

            label_8a32:
            sta ObjectPosX, x
            sta ObjectPosX + 8, x
            sta ObjectPosX2, x
            sta ObjectPosX2 + 8, x
            sta $2b, x
            dex
            bpl label_8a32
            sta CountdownTimer
            ldx #$03

            loop: // $8a43
            {
                lda LOOKUP_A905, x
                sta $2b, x
                dex
                bpl loop
            }

            lda #$f0
            sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
            lda #$0f
            sta VIC_SPRITE_EXPAND_X
            sta VIC_SPRITE_EXPAND_Y
            lda #$03
            sta RemainingGhostbusters
            lda #$02
            sta $ea78
            sta $ea79
            jsr label_8a6a
            jmp NextGameState
        }

        *= $8b07
        Update:
        {
            lda CountdownTimer
            bne label_8b77
            lda $ea78
            beq label_8af6
            lda $ea79
            beq label_8b00

            lda LOOKUP_A905
            sta $2b
            lda $a907
            sta $2d
            lda $ea77
            beq label_8b5d
            bmi label_8b28
            bne label_8b3d

            label_8b28:
            lda #$02
            ldx #$0a
            jsr MoveObjectTowardsTarget.CustomSpeed
            ldx #$0a
            jsr BuildingScreenShared.DidObjectArriveAtTarget
            bne label_8b77
            jsr label_8a6a
            lda #$2f
            sta CountdownTimer

            label_8b3d:
            ldx #$00
            ldy #$00
            lda #$0e
            sta ZeroPagePointer1
            jsr BuildingScreenShared.label_9b44
            lda #$02
            ldx #$0a
            jsr MoveObjectTowardsTarget.CustomSpeed
            ldx #$0a
            jsr BuildingScreenShared.DidObjectArriveAtTarget
            bne label_8b77
            lda #$00
            sta $ea77
            beq label_8b77

            label_8b5d:
            ldx #$00
            lda #$0e
            sta ZeroPagePointer1
            ldy #$00
            jsr BuildingScreenShared.label_9b44
            ldx #$0a
            lda #$02
            jsr MoveObjectTowardsTarget.CustomSpeed
            ldx #$00
            jsr BuildingScreenShared.HandleJoystickInput
            jsr label_8a80

            label_8b77:
            // clear collision register
            lda VIC_SPRITE_SPRITE_COLLISION_REGISTER

            lda $08
            lsr
            and #$3f
            cmp #$20
            bcc continue
            eor #$3f
            
            continue:
            tax
            and #$1f
            tax
            lda LOOKUP_A8A5, x
            sta ObjectPosY
            sta ObjectPosY + 4
            clc
            adc #$2a
            sta ObjectPosY + 2
            sta ObjectPosY + 6
            lda LOOKUP_A8C5, x
            sta ObjectPosX
            sta ObjectPosX + 2
            clc
            adc #$18
            sta ObjectPosX + 4
            sta ObjectPosX + 6
            lda LOOKUP_A8E5, x
            pha
            and #$0f
            clc
            adc #$2e
            sta $2e
            pla
            and #$f0
            lsr
            lsr
            lsr
            lsr
            clc
            adc #$2c
            sta $2c
            jmp NextGameState.ReturnToMainLoop
        }

        *= $8bbf
        PrepareEnding:
        {
            lda CountdownTimer
            bne label_8bc8
            dec CountdownTimer
            jmp NextGameState

            label_8bc8:
            ldy #$27
            lda #$00

            // Clear memory $5770-$5797
            loop: //8bcc
            {
                
                sta $5770, y
                dey
                bpl loop
            }
            jmp NextGameState.ReturnToMainLoop
        }

        *= $8bd5
        ScrollToTopOfBuilding:
        {
            jsr ScrollDown
            lda CountdownTimer
            cmp #$19
            lda #$00
            bcs label_8bf2
            lda #$19
            sec
            sbc CountdownTimer
            asl
            asl
            asl
            sec
            sbc #$1b
            ldy CountdownTimer
            bne label_8bf2
            sec
            sbc #$08

            label_8bf2:
            sta ObjectPosY + 10
            sta ObjectPosY + 12
            lda #$5e
            sta ObjectPosX + 10
            lda #$84
            sta ObjectPosX + 12
            ldx #$07

            label_8c00:
            lda $3812, x
            sta $2b, x
            dex
            bpl label_8c00
            lda #$00
            sta $77
            sta VIC_SPRITE_EXPAND_X
            lda #$01
            sta $78
            lda CountdownTimer
            bne label_8c1c
            dec CountdownTimer
            jmp NextGameState

            label_8c1c:
            jmp NextGameState.ReturnToMainLoop
        }

        *= $8c1f
        CrossTheStreams:
        {
            lda #$01
            sta RemainingBackbackCharge
            jsr BuildingScreenShared.ActivatePhotonStreams
            lda CountdownTimer
            lsr
            lsr
            lsr
            lsr
            cmp #$09
            bcs return
            sta ZeroPagePointer1
            lda #$08
            sec
            sbc ZeroPagePointer1
            tax
            lda LOOKUP_A915, x
            clc
            adc #$56
            sta $0f
            lda LOOKUP_A92F, x
            adc #$55
            sta $10
            ldy #$07

            label_8c49:
            lda #$a8
            sta (ZeroPagePointer6), y
            dey
            bpl label_8c49
            lda CountdownTimer
            beq label_8c60
            cmp #$10
            bne return

            // zuul scream
            lda #Speech.Scream
            jsr TriggerSpeech
            jmp NextGameState.ReturnToMainLoop

            label_8c60:
            lda #GameStates.DisplayCongratulations
            sta GameState

            // award $5000
            lda #$50
            sta ZeroPagePointer1 + 1
            lda #$00
            sta ZeroPagePointer3
            sta ZeroPagePointer1

            jsr AddMoneyToAccount

            return: // $8c71
            jmp NextGameState.ReturnToMainLoop    
        }
    }

    *= $3300
    ScrollDown:
    {
        ldx #$27

        copyRow:
        {
            lda SCREEN_CHAR + 19 * 40, x
            sta SCREEN_CHAR + 20 * 40, x
            lda SCREEN_CHAR + 18 * 40, x
            sta SCREEN_CHAR + 19 * 40, x
            lda SCREEN_CHAR + 17 * 40, x
            sta SCREEN_CHAR + 18 * 40, x
            lda SCREEN_CHAR + 16 * 40, x
            sta SCREEN_CHAR + 17 * 40, x
            lda SCREEN_CHAR + 15 * 40, x
            sta SCREEN_CHAR + 16 * 40, x
            lda SCREEN_CHAR + 14 * 40, x
            sta SCREEN_CHAR + 15 * 40, x
            lda SCREEN_CHAR + 13 * 40, x
            sta SCREEN_CHAR + 14 * 40, x
            lda SCREEN_CHAR + 12 * 40, x
            sta SCREEN_CHAR + 13 * 40, x
            lda SCREEN_CHAR + 11 * 40, x
            sta SCREEN_CHAR + 12 * 40, x
            lda SCREEN_CHAR + 10 * 40, x
            sta SCREEN_CHAR + 11 * 40, x
            lda SCREEN_CHAR +  9 * 40, x
            sta SCREEN_CHAR + 10 * 40, x
            lda SCREEN_CHAR + 8 * 40, x
            sta SCREEN_CHAR + 9 * 40, x
            lda SCREEN_CHAR + 7 * 40, x
            sta SCREEN_CHAR + 8 * 40, x
            lda SCREEN_CHAR + 6 * 40, x
            sta SCREEN_CHAR + 7 * 40, x
            lda SCREEN_CHAR + 5 * 40, x
            sta SCREEN_CHAR + 6 * 40, x
            lda SCREEN_CHAR + 4 * 40, x
            sta SCREEN_CHAR + 5 * 40, x
            lda SCREEN_CHAR + 3 * 40, x
            sta SCREEN_CHAR + 4 * 40, x
            lda SCREEN_CHAR + 2 * 40, x
            sta SCREEN_CHAR + 3 * 40, x
            lda SCREEN_CHAR + 1 * 40, x
            sta SCREEN_CHAR + 2 * 40, x
            lda SCREEN_CHAR + 0 * 40, x
            sta SCREEN_CHAR + 1 * 40, x

            lda COLOR_RAM + 19 * 40, x
            sta COLOR_RAM + 20 * 40, x
            lda COLOR_RAM + 18 * 40, x
            sta COLOR_RAM + 19 * 40, x
            lda COLOR_RAM + 17 * 40, x
            sta COLOR_RAM + 18 * 40, x
            lda COLOR_RAM + 16 * 40, x
            sta COLOR_RAM + 17 * 40, x
            lda COLOR_RAM + 15 * 40, x
            sta COLOR_RAM + 16 * 40, x
            lda COLOR_RAM + 14 * 40, x
            sta COLOR_RAM + 15 * 40, x
            lda COLOR_RAM + 13 * 40, x
            sta COLOR_RAM + 14 * 40, x
            lda COLOR_RAM + 12 * 40, x
            sta COLOR_RAM + 13 * 40, x
            lda COLOR_RAM + 11 * 40, x
            sta COLOR_RAM + 12 * 40, x
            lda COLOR_RAM + 10 * 40, x
            sta COLOR_RAM + 11 * 40, x
            lda COLOR_RAM +  9 * 40, x
            sta COLOR_RAM + 10 * 40, x
            lda COLOR_RAM + 8 * 40, x
            sta COLOR_RAM + 9 * 40, x
            lda COLOR_RAM + 7 * 40, x
            sta COLOR_RAM + 8 * 40, x
            lda COLOR_RAM + 6 * 40, x
            sta COLOR_RAM + 7 * 40, x
            lda COLOR_RAM + 5 * 40, x
            sta COLOR_RAM + 6 * 40, x
            lda COLOR_RAM + 4 * 40, x
            sta COLOR_RAM + 5 * 40, x
            lda COLOR_RAM + 3 * 40, x
            sta COLOR_RAM + 4 * 40, x
            lda COLOR_RAM + 2 * 40, x
            sta COLOR_RAM + 3 * 40, x
            lda COLOR_RAM + 1 * 40, x
            sta COLOR_RAM + 2 * 40, x
            lda COLOR_RAM + 0 * 40, x
            sta COLOR_RAM + 1 * 40, x
            dex
            bmi continue
            jmp copyRow
        }

        continue:
        lda CountdownTimer
        cmp #$15
        bcc label_3422
        and #$03
        cmp #$03
        bne label_3406
        dec CountdownTimer

        label_3406:
        lda CountdownTimer
        and #$03
        tax
        lda somedata_3456, x
        tay
        ldx #$27

        loop:
        {
            lda COLOR_LOOKUP,x
            sta COLOR_RAM,x
            lda somedata_3459, y
            sta $5400, x
            dey
            dex
            bpl loop
        }
        rts

        label_3422:
        ldx CountdownTimer
        lda LOOKUP_A915, x
        clc
        adc #$f0
        sta ZeroPagePointer5
        lda LOOKUP_A92F, x
        adc #$18
        sta ZeroPagePointer5 + 1
        lda LOOKUP_A915, x
        clc
        adc #$60
        sta ZeroPagePointer1
        lda LOOKUP_A92F, x
        adc #$1c
        sta ZeroPagePointer1 + 1
        ldy #$27

        loop2:
        {
            lda (ZeroPagePointer5), y
            sta SCREEN_CHAR, y
            lda (ZeroPagePointer1), y
            lsr
            lsr
            lsr
            lsr
            sta COLOR_RAM, y
            dey
            bpl loop2
        }
        rts
    }

    *= $8a6a
    label_8a6a:
    {
        lda #$a8
        sta ObjectPosX + 10
        lda #$c7
        sta ObjectPosY + 10
        lda #$60
        sta ObjectPosX2 + 10
        lda #$c0
        sta ObjectPosY2 + 10
        lda #$01
        sta $ea77
        rts
    }

    *= $8a80
    label_8a80:
    {
        lda ObjectPosX2 + 10, x
        cmp #$20
        bcs label_8a88
        lda #$20

        label_8a88:
        cmp #$8c
        bcc label_8a8e
        lda #$8c

        label_8a8e:
        sta ObjectPosX2 + 10, x
        lda $08
        and #$03
        bne label_8ac6
        lda ObjectPosY2 + 10, x
        cmp #$b9
        bcs label_8ac6
        lda VIC_SPRITE_SPRITE_COLLISION_REGISTER
        and #$2f
        beq label_8ac6
        lda #$30
        sta ObjectPosX2 + 10, x
        lda #$e5
        sta ObjectPosY2 + 10, x
        lda #$18
        sta $30
        sta $57fd
        dec $ea79
        dec RemainingGhostbusters

        // play laugh
        lda #Speech.Laugh
        jsr TriggerSpeech

        lda #$2f
        sta CountdownTimer
        lda #$ff
        sta $ea77
        rts

        label_8ac6:
        lda ObjectPosY2 + 10, x
        cmp #$aa
        bcs label_8aed
        lda ObjectPosX2 + 10, x
        cmp #$5b
        bcc label_8aeb
        cmp #$5f
        bcs label_8aeb
        jsr label_8a6a
        lda #$2f
        sta $2b
        lda #$30
        sta $2d
        dec $ea78
        dec RemainingGhostbusters
        lda #$3f
        sta CountdownTimer
        rts

        label_8aeb:
        lda #$aa

        label_8aed:
        cmp #$c8
        bcc label_8af3
        lda #$c8

        label_8af3:
        sta ObjectPosY2 + 10, x
        rts
    }

    *= $8af6
    label_8af6:
    {
        lda #$cf
        sta CountdownTimer
        jsr CityMapScreen.ResetObjectPositions
        jmp NextGameState
    }

    *= $8b00
    label_8b00:
    {
        lda #GameStates.DisplayGoodTry
        sta GameState
        jmp NextGameState.ReturnToMainLoop
    }
}