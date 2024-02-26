#importonce 
#import "CityMapScreenData.asm"

.namespace CityMapScreen 
{
    .label MAP_SCREEN_OBJECT_POS_X_CACHE   = $ea46  // x0, y0, x1, y1, ...  16 bytes
    .label MAP_SCREEN_OBJECT_POS_Y_CACHE   = $ea47
    .label MAP_SCREEN_OBJECT_POS_X2_CACHE  = $ea56  // x0, y0, x1, y1, ...  16 bytes
    .label MAP_SCREEN_OBJECT_POS_Y2_CACHE  = $ea57

    .namespace States 
    {
        *= $7a9c
        Init:
        {
            ldx #$0f
            loop:
            {
                lda STARTING_SPRITE_POSITIONS, x
                sta MAP_SCREEN_OBJECT_POS_X_CACHE, x
                lda STARTING_SPRITE_POSITIONS_X2, x
                sta MAP_SCREEN_OBJECT_POS_X2_CACHE, x
                lda #$00
                sta ObjectPosX, x

                cpx #$08
                bcs continue

                lda LOOKUP_3793, x
                sta $c0, x

                continue:
                dex
                bpl loop
            }

            lda #$00
            sta ZeroPagePointer5
            sta ZeroPagePointer6
            lda #>$5a00
            sta ZeroPagePointer5 + 1
            lda #>$e000
            sta ZeroPagePointer6 + 1
            jsr Copy1536BytesFromZP5ToZP6 // Move the selected car charset to $e000

            lda #$00
            sta $5e
            jsr ClearMemory_0082_008A
            jmp VehicleSelectionScreen.States.ChooseCar.PrepareScreen
        }

        *= $7ad5
        LoadCharData:
        {
            jsr ResetObjectPositions //95a5
            jsr ClearScreen
            lda #$0c
            sta BackgroundColor
            lda #$00
            sta VIC_SPRITE_PRIORITY_REGISTER
            lda #$07
            sta VIC_BACKGROUND_COLOR_1
            lda #$00
            sta VIC_BACKGROUND_COLOR_2

            // copy map charset from $2a50 to $5a00
            lda #<MAP_CHARSET
            sta ZeroPagePointer5
            lda #>MAP_CHARSET
            sta ZeroPagePointer5 + 1
            lda #$00
            sta ZeroPagePointer6
            lda #$5a
            sta ZeroPagePointer6 + 1
            jsr Copy1536BytesFromZP5ToZP6

            // clear colors
            ldx #$00
            lda #$0d

            colorLoop:
            {
                sta COLOR_RAM, x
                sta COLOR_RAM + $100, x
                sta COLOR_RAM + $200, x
                sta COLOR_RAM + $26e, x
                inx
                bne colorLoop
            }

            // draw the buildings
            ldx #$1d
            drawBuildingsOuterLoop:
            {
                ldy #$03
                buildingColumnLoop:
                {
                    jsr DrawMapBuilding
                    dey
                    bpl buildingColumnLoop
                    dex
                    bpl drawBuildingsOuterLoop
                }
            }


            // fill char line above bottom display
            ldx #$27
            drawRoadsLoop:
            {
                // is this the broken character?
                lda #$a9
                sta SCREEN_CHAR + 21 * 40, x
                lda #$06
                sta COLOR_RAM + 21 * 40, x
                dex
                bpl drawRoadsLoop
            }

            // horizontal street names on the left border
            ldx #$0a
            drawSideStreetNamesLoop:
            {
                lda STREET_NAME_1, x
                sta SCREEN_CHAR + 3 * 40, x
                lda STREET_NAME_2, x
                sta SCREEN_CHAR + 8 * 40, x
                lda STREET_NAME_3, x
                sta SCREEN_CHAR + 13 * 40, x
                lda STREET_NAME_4, x
                sta SCREEN_CHAR + 18 * 40, x
                dex
                bpl drawSideStreetNamesLoop
            }

            ldx #$27
            drawTopStreetNamesLoop:
            {
                lda MAP_STREET_NAMES_TOP, x
                sta SCREEN_CHAR, x
                dex
                bpl drawTopStreetNamesLoop
            }

            // display GHQ and ZUUL
            ldx #$02
            drawBuildingNames:
            {
                lda MAP_TEXT_ZUUL, x
                sta SCREEN_CHAR + 11 * 40 + 20, x
                lda MAP_TEXT_GHQ, x
                sta SCREEN_CHAR + 20 * 40 + 14, x
                lda #$01
                sta COLOR_RAM + 11 * 40 + 20, x
                sta COLOR_RAM + 20 * 40 + 14, x
                dex
                bpl drawBuildingNames
            }

            // white for L (zuuL)
            sta COLOR_RAM + 11 * 40 + 23
            // L of zuuL
            lda MAP_TEXT_ZUUL + 3
            sta SCREEN_CHAR + 11 * 40 + 23

            lda #$02
            sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
            lda #$00
            sta SpriteMulticolor1
            sta SpriteMulticolor2
            sta VIC_SPRITE_EXPAND_X
            sta VIC_SPRITE_EXPAND_Y

            ldx #$07
            
            // Set all sprites used in the city map
            setSpritePositionsLoop:
            {
                lda $c0, x
                sta $2b, x
                lda MAP_SCREEN_OBJECT_POS_X_CACHE, x
                sta ObjectPosX, x
                lda $ea4e, x
                sta ObjectPosX + 8, x
                lda MAP_SCREEN_OBJECT_POS_X2_CACHE, x
                sta ObjectPosX2, x
                lda $37cb, x
                sta ObjectPosX2 + 8, x
                dex
                bpl setSpritePositionsLoop
            }

            jmp NextGameState
        }

        *= $7bab
        UpdateLoop:
        {
            ldx #$0e
            loop1:
            {
                lda ObjectPosY, x
                sta MAP_SCREEN_OBJECT_POS_Y_CACHE, x
                lda ObjectPosX, x
                sta MAP_SCREEN_OBJECT_POS_X_CACHE, x
                cmp MAP_SCREEN_OBJECT_POS_X2_CACHE, x
                bne nextItem
                lda ObjectPosY, x
                cmp MAP_SCREEN_OBJECT_POS_Y2_CACHE, x
                bne nextItem
                txa
                lsr
                tay
                lda #$01
                jsr IncreaseCityPKEnergy
                jsr ResetGhostPosition

                nextItem:   // $7bce
                dex
                dex
                cpx #$08
                bcs loop1
            }

            ldx #$06

            label_7bd6:
            ldy #$08
            lda ObjectPosX + 8, x
            cmp ObjectPosX2 + 8, x
            beq label_7bf4
            bcc label_7be2
            ldy #$09

            label_7be2:
            sty ZeroPagePointer1
            txa
            lsr
            tay
            lda $00c4, y
            beq label_7bf4
            lda ZeroPagePointer1
            sta $002f, y
            sta $00c4, y

            label_7bf4:
            dex
            dex
            bpl label_7bd6

            ldy CityPKEnergy + 1
            cpy #$50
            bcc label_7c2e
            ldx #$02

            label_7c00:
            lda ObjectPosY + 4, x
            sta MAP_SCREEN_OBJECT_POS_Y_CACHE + 4, x
            lda ObjectPosX + 4, x
            sta MAP_SCREEN_OBJECT_POS_X_CACHE + 4, x
            cpy #$95
            bcs label_7c1a
            cmp $37fe, x
            bne label_7c2a
            lda ObjectPosY + 4, x
            cmp $37ff, x
            bne label_7c2a

            label_7c1a:
            lda LOOKUP_3802, x
            sta ObjectPosX2 + 4, x
            sta MAP_SCREEN_OBJECT_POS_X2_CACHE + 4, x
            lda LOOKUP_3803, x
            sta ObjectPosY2 + 4, x
            sta MAP_SCREEN_OBJECT_POS_Y2_CACHE + 4, x

            label_7c2a:
            dex
            dex
            bpl label_7c00

            label_7c2e:
            ldx #$03

            label_7c30:
            lda ObjectPosX + 4, x
            cmp LOOKUP_3802, x
            bne increasePKEnergyRate
            sta $ea4a, x
            dex
            bpl label_7c30
            lda $81
            bne label_7c7a

            ldx #$00

            label_7c43:
            lda MoneyInAccount, x
            cmp $51, x
            bcc label_7c52
            bne label_7c5d
            inx
            cpx #$03
            bcc label_7c43
            bcs label_7c5d

            // If we don't have enough money at the end
            label_7c52: // 7c52
            lda #GameStates.WriteDownAccountBalance
            sta GameState
            lda #$01
            sta $81
            jmp NextGameState.ReturnToMainLoop

            label_7c5d:
            lda #$01
            sta $81
            lda #$ff
            sta CountdownTimer

            // go to zuul
            ldx #ScrollerText.GotoZuul
            jsr FetchScrollerText

            lda #$63
            sta ObjectPosX2
            sta ObjectPosX2 + 2
            lda #$92
            sta ObjectPosY2
            sta ObjectPosY2 + 2
            lda #$00
            sta PKEnergyRateIncrease // Stop increasing PKE

            label_7c7a:
            ldx #$13
            loop2:
            {
                sta $c8, x
                dex
                bpl loop2
            }

            lda #$0f
            sta $d2

            increasePKEnergyRate:
            lda PKE_INCREASE_RATE
            and PKEnergyRateIncrease
            bne label_7ca6
            ldx #$0e

            label_7c8d:
            txa
            lsr
            tay
            lda $00c0, y
            beq label_7c9a
            lda #$02
            jsr MoveObjectTowardsTarget.CustomSpeed

            label_7c9a:
            dex
            dex
            bmi label_7ca6
            cpx #$04
            bcs label_7c8d
            lda $81
            bne label_7c8d

            label_7ca6:
            lda $81
            beq label_7cad
            jmp label_7d23

            label_7cad:
            ldx #$08

            label_7caf:
            lda ObjectPosX
            cmp $37d3, x
            bcc label_7ce4
            cmp $37d4, x
            bcc label_7cbd
            bne label_7ce4

            label_7cbd:
            // move up?
            lda JoystickValue
            and #$01
            bne label_7cce

            // decrease ObjectPosY
            lda ObjectPosY
            cmp #$43
            bcc label_7cce
            dec ObjectPosY
            jmp label_7cdc

            label_7cce:
            // move down?
            lda JoystickValue
            and #$02
            bne label_7ce4

            // increase ObjectPosY
            lda ObjectPosY
            cmp #$ba
            bcs label_7ce4
            inc ObjectPosY

            label_7cdc:
            lda $37d3, x
            clc
            adc #$02
            sta ObjectPosX

            label_7ce4:
            dex
            dex
            bpl label_7caf
            ldx #$08

            label_7cea:
            lda ObjectPosY
            cmp $37df, x
            bcc label_7d1f
            cmp $37e0, x
            bcc label_7cf8
            bne label_7d1f

            label_7cf8:
            // move left?
            lda JoystickValue
            and #$04
            bne label_7d09
            lda ObjectPosX
            cmp #$1e
            bcc label_7d09
            dec ObjectPosX
            jmp label_7d17

            label_7d09:
            // move right?
            lda JoystickValue
            and #$08
            bne label_7d1f
            lda ObjectPosX
            cmp #$8d
            bcs label_7d1f
            inc ObjectPosX

            label_7d17:
            lda $37df, x
            clc
            adc #$02
            sta ObjectPosY

            label_7d1f:
            dex
            dex
            bpl label_7cea

            label_7d23:
            lda ObjectPosX
            sta MAP_SCREEN_OBJECT_POS_X_CACHE
            sta MAP_SCREEN_OBJECT_POS_X2_CACHE
            sta ObjectPosX + 2
            lda ObjectPosY
            sta MAP_SCREEN_OBJECT_POS_Y_CACHE
            sta MAP_SCREEN_OBJECT_POS_Y2_CACHE
            sta ObjectPosY + 2
            ldx #$13

            label_7d39:
            lda $c8, x
            and #$f0
            sta ZeroPagePointer3
            txa
            and #$03
            asl
            tay
            lda ObjectPosX
            cmp $37d3, y
            bcc label_7d99
            cmp $37d6, y
            bcs label_7d99
            txa
            and #$1c
            lsr
            tay
            lda ObjectPosY
            cmp $37dd, y
            bcc label_7d99
            cmp $37e0, y
            bcs label_7d99
            lda $c8, x
            and #$0c
            sta ZeroPagePointer1 + 1
            ldy #$03
            lda $c8, x
            and #$0f
            cmp #$0f
            beq label_7d7f
            lsr
            lsr
            tay
            lda LOOKUP_A9B0, y
            beq label_7d7f
            and InstalledEquipment
            bne label_7d7f
            ldy #$00

            label_7d7f:
            tya
            ora ZeroPagePointer1 + 1
            stx CaptureGhostVisitType
            cmp #$0f
            bne label_7d96
            lda $c8, x
            and #$0f
            cmp #$0c
            bne label_7d94
            lda #$10
            sta ZeroPagePointer3

            label_7d94:
            lda #$0f

            label_7d96:
            jmp label_7da3

            label_7d99:
            lda $c8, x
            and #$0f
            cmp #$0c
            bcs label_7da3
            and #$0c

            label_7da3:
            ora ZeroPagePointer3
            sta $c8, x
            dex
            bpl label_7d39
            ldx #$0e

            label_7dac:
            lda ObjectPosX
            sec
            sbc #$08
            sta ZeroPagePointer1
            lda ObjectPosX
            clc
            adc #$09
            sta ZeroPagePointer1 + 1
            lda ObjectPosX, x
            jsr label_9c08
            bcc label_7df9
            lda ObjectPosY
            sec
            sbc #$11
            sta ZeroPagePointer1
            lda ObjectPosY
            clc
            adc #$0d
            sta ZeroPagePointer1 + 1
            lda ObjectPosY, x
            jsr label_9c08
            bcc label_7df9
            cpx #$08
            bcs label_7de0
            nop
            nop
            nop
            jmp label_7df9

            label_7de0:
            lda ObjectPosX, x
            sta ObjectPosX2, x
            lda ObjectPosY, x
            sta ObjectPosY2, x
            txa
            lsr
            tay
            lda $006b, y
            bne label_7df9
            lda CarDrivingCurrentPos
            bne label_7df6
            lda #$01

            label_7df6:
            sta $006b, y

            label_7df9:
            dex
            dex
            cpx #$04
            bcs label_7dac
            lda $06
            sta ZeroPagePointer3
            lsr
            lsr
            sta $27
            ldx #$02

            label_7e09:
            ldy #$04

            label_7e0b:
            lda $37ea, y
            cmp ObjectPosX + 4, x
            beq label_7e17
            dey
            bpl label_7e0b
            bmi label_7e52

            label_7e17:
            iny
            sty ZeroPagePointer1
            ldy #$03

            label_7e1c:
            lda $37f1, y
            cmp ObjectPosY + 4, x
            beq label_7e28
            dey
            bpl label_7e1c
            bmi label_7e52

            label_7e28:
            iny
            sty ZeroPagePointer1 + 1
            lda ZeroPagePointer3, x
            and #$06
            sta ZeroPagePointer3 + 1
            tay
            lda ZeroPagePointer1
            clc
            adc $37f6, y
            tay
            lda $37e9, y
            sta ObjectPosX2 + 4, x
            sta $ea5a, x
            ldy ZeroPagePointer3 + 1
            lda ZeroPagePointer1 + 1
            clc
            adc $37f7, y
            tay
            lda $37f0, y
            sta ObjectPosY2 + 4, x
            sta $ea5b, x

            label_7e52:
            dex
            bpl label_7e09
            lda $81
            beq ControlMapPlayer
            lda ObjectPosX
            cmp #CarPosX
            bne label_7e71
            lda ObjectPosY
            cmp #$92
            bne label_7e71
            lda CountdownTimer
            bne label_7e71

            lda #$0a
            sta CaptureGhostVisitType
            lda #GameStates.PrepareCaptureGhostSequence1
            sta GameState

            label_7e71:
            jmp NextGameState.ReturnToMainLoop
        }
    
        *= $8925
        MashmallowManAttackIncoming:
        {
            ldx #$0e
            loop: // $8927
            {
                lda #$02
                jsr MoveObjectTowardsTarget.CustomSpeed
                dex
                dex
                cpx #$08
                bcs loop
            }

            lda #$04
            sta ZeroPagePointer1
            ldx #$06
            ldy #$03
            
            loop2:
            {
                lda ObjectPosX + 8, x
                cmp ObjectPosX2 + 8, x
                bne next
                lda ObjectPosY + 8, x
                cmp ObjectPosY2 + 8, x
                bne next
                lda LOOKUP_A905, y
                sta $002f, y
                dec ZeroPagePointer1

                next: // $894e
                dey
                dex
                dex
                bpl loop2
            }
            lda ZeroPagePointer1
            bne label_896d
            lda #$ff
            sta CountdownTimer
            lda $68
            bne label_8962
            jmp NextGameState

            label_8962:
            lda #$00
            sta $68
            lda #ZeroPagePointer3 + 1
            sta GameState
            jmp NextGameState.ReturnToMainLoop

            label_896d:
            jmp ControlMapPlayer.label_7f29
        }

        *= $8970
        MashmallowManDestroyingBuilding:
        {
            // progress of marshmallow man damage?
            lda CountdownTimer
            bne label_8990

            // marshmallow man damage
            ldx #ScrollerText.MarshmallowManDamage
            jsr FetchScrollerText

            // deduct $4000
            lda #$40
            sta ZeroPagePointer1 + 1
            lda #$00
            sta ZeroPagePointer1
            sta ZeroPagePointer3

            jsr TextScreenShared.DeductMoney
            jsr label_983d

            lda #GameStates.MoveGhostsToOriginalPositions
            sta GameState
            jmp NextGameState.ReturnToMainLoop

            label_8990:
            lsr
            lsr
            lsr
            sta ZeroPagePointer1
            and #$03
            tax

            // sprite pointer?
            lda $a909, x
            sta $30
            lda $a90d, x
            sta $32
            lda ZeroPagePointer1
            eor #$1f
            sta ZeroPagePointer1
            lda ObjectPosY2 + 8
            clc
            adc ZeroPagePointer1
            sec
            sbc $a911, x
            sta ObjectPosY + 8
            sta ObjectPosY + 12
            clc
            adc #$15
            sta ObjectPosY + 10
            sta ObjectPosY + 14
            lda CountdownTimer
            and #$3f
            cmp #$20
            bne continue

            lda CountdownTimer
            lsr
            lsr
            lsr
            lsr
            lsr
            lsr
            eor #$03
            tay
            ldx $80
            lda #$00
            sta $ea28, x
            jsr DrawMapBuilding

            continue:
            jmp NextGameState.ReturnToMainLoop
        }

        *= $89dc
        MashmallowManDefeated:
        {
            lda #$2f
            sta $2f
            lda #$30
            sta $31
            lda CountdownTimer
            bne label_8a00

            ldx #ScrollerText.MarshmallowManReward
            jsr FetchScrollerText

            // award $2000
            lda #$20
            sta ZeroPagePointer1 + 1
            lda #$00
            sta ZeroPagePointer1
            sta ZeroPagePointer3
            jsr AddMoneyToAccount

            jsr label_983d
            jmp NextGameState

            label_8a00:
            jmp NextGameState.ReturnToMainLoop
        }

        // After a MashmallowMan attack, move the ghosts back to their original positions
        *= $8a03
        MoveGhostsToOriginalPositions:
        {
            ldx #$0e

            label_8a05:
            lda #$02
            jsr MoveObjectTowardsTarget.CustomSpeed
            dex
            dex
            cpx #$08
            bcs label_8a05
            ldx #$07

            label_8a12:
            lda ObjectPosX2 + 8, x
            cmp ObjectPosX + 8, x
            bne label_8a29
            dex
            bpl label_8a12
            ldx #$07

            label_8a1d:
            lda $ea5e, x
            sta ObjectPosX2 + 8, x
            dex
            bpl label_8a1d
            lda #GameStates.CityMapUpdateLoop
            sta GameState

            label_8a29:
            jmp NextGameState.ReturnToMainLoop
        }
    }
    
    *= $73c6 "label_73c6"
    label_73c6:
    {
        lda $09
        bne label_73f3
        ldx #$13

        label_73cc:
        lda $c8, x
        and #$f0
        beq label_73f0
        lda $c8, x
        clc
        adc #$10
        bcc label_73ee
        cmp #$0f
        bne label_73e6
        lda #$03
        jsr IncreaseCityPKEnergy
        lda #$00
        beq label_73ee

        label_73e6:
        and #$0c
        lsr
        lsr
        tay
        lda LOOKUP_A9B4, y

        label_73ee:
        sta $c8, x

        label_73f0:
        dex
        bpl label_73cc

        label_73f3:
        lda $81
        bne label_740c
        lda PKEnergyRateIncrease
        ora #$0f
        and $09
        bne label_740c
        sed
        lda CityPKEnergy
        clc
        adc #$01
        sta CityPKEnergy
        lda #$00
        jsr IncreaseCityPKEnergy.label_9897

        label_740c:
        lda $06
        sta ZeroPagePointer1
        lda $81
        beq label_7417
        jmp JumpToNextTableState

        label_7417:
        ldx #$13

        label_7419:
        lda $c8, x
        beq label_7423
        and #$0f
        cmp #$04
        bcc JumpToNextTableState

        label_7423:
        dex
        bpl label_7419
        ldy #$00
        lda PKEnergyRateIncrease
        ora #$0f
        asl
        asl

        label_742e:
        iny
        sec
        rol
        bcc label_742e

        label_7433:
        lda ZeroPagePointer1
        and #$1f
        sta ZeroPagePointer1 + 1
        lda #$21
        sta ZeroPagePointer3

        label_743d:
        ldx #$13
        dec ZeroPagePointer3

        label_7441:
        cpx #$11
        beq findOtherBuilding
        cpx #$0a
        beq findOtherBuilding
        lda $ea28, x
        beq findOtherBuilding

        // already haunted?
        lda $c8, x
        bne findOtherBuilding
        dec ZeroPagePointer1 + 1
        bmi markBuildingAsHaunted

        findOtherBuilding:
        dex
        bpl label_7441
        lda ZeroPagePointer3
        bpl label_743d
        bmi JumpToNextTableState

        markBuildingAsHaunted:
        lda #$10
        sta $c8, x
        lda ZeroPagePointer1
        cmp #$80
        rol
        sta ZeroPagePointer1
        dey
        bne label_7433

        JumpToNextTableState:   // $746d
        lda GameState
        asl
        tax
        lda TableGameStates, x
        sta ZeroPagePointer1
        lda TableGameStates + 1, x
        sta ZeroPagePointer1 + 1
        jmp (ZeroPagePointer1)
    }

    *= $7e74
    ControlMapPlayer:
    {
        jsr CheckFireButtonIsPressed
        beq label_7ed8
        and #$10
        bne label_7ed8

        lda JoystickValue
        and #$02
        bne label_7e8a

        lda CaptureGhostVisitType
        clc
        adc #$04
        sta CaptureGhostVisitType

        label_7e8a:
        lda CaptureGhostVisitType
        cmp #$11
        beq label_7eca

        lda CaptureGhostVisitType
        cmp #$0a
        bne label_7e9d

        lda $81
        bne label_7eca
        jmp label_7ed8

        label_7e9d:
        lda NumberOfEmptyTraps
        bne label_7ea9

        // no empty traps
        ldx #ScrollerText.NoEmptyTraps
        jsr FetchScrollerText
        jmp NextGameState.ReturnToMainLoop

        label_7ea9:
        lda RemainingGhostbusters
        cmp #MINIMUM_REQUIRED_GHOSTBUSTERS
        bcs checkBackbackCharge // We have enough ghostbusters, now  check the backpack charge

        // not enough ghostbusters available
        ldx #ScrollerText.NoGhostbustersAvailable
        jsr FetchScrollerText
        jmp NextGameState.ReturnToMainLoop

        checkBackbackCharge:
        lda RemainingBackbackCharge
        bne label_7ec3

        // backpacks discharged
        ldx #ScrollerText.BackpacksDischarged
        jsr FetchScrollerText
        jmp NextGameState.ReturnToMainLoop

        label_7ec3:
        ldx CaptureGhostVisitType
        lda $ea28, x
        beq label_7ed8

        label_7eca:
        lda CarDrivingCurrentPos
        bne label_7ed5
        lda #GameStates.PrepareCaptureGhostSequence1
        sta GameState
        jmp NextGameState.ReturnToMainLoop

        label_7ed5:
        jmp NextGameState

        label_7ed8:
        ldx $80
        beq label_7f29
        lda $c8, x
        and #$fc
        cmp #$f8
        bne label_7f29
        lda #$00
        sta $c8, x
        lda $80
        sec
        sbc #$04
        sta ZeroPagePointer1
        and #$03
        tax
        lda $37ea, x
        clc
        adc #$08
        sta ObjectPosX2 + 8
        sta ObjectPosX2 + 10
        clc
        adc #$0c
        sta ObjectPosX2 + 12
        sta ObjectPosX2 + 14
        lda ZeroPagePointer1
        lsr
        lsr
        tax
        lda $37f1, x
        sec
        sbc #$18
        sta ObjectPosY2 + 8
        sta ObjectPosY2 + 12
        clc
        adc #$15
        sta ObjectPosY2 + 10
        sta ObjectPosY2 + 14
        lda #$00
        sta $68

        // Marshmallow Man Alart
        ldx #ScrollerText.MarshmallowManAlert
        jsr FetchScrollerText
        lda #GameStates.MashmallowManAttackIncoming
        sta GameState
        jmp NextGameState.ReturnToMainLoop

        label_7f29:
        lda ObjectPosY
        sec
        sbc #$40
        lsr
        lsr
        lsr
        tax
        lda LOOKUP_A915, x
        clc
        adc #$7c
        sta ZeroPagePointer4
        lda LOOKUP_A92F, x
        adc #$54
        sta ZeroPagePointer4 + 1
        lda ObjectPosX
        sec
        sbc #$1d
        lsr
        lsr
        tay
        lda (ZeroPagePointer4), y
        bne label_7f60
        lda #$40
        sta (ZeroPagePointer4), y
        lda ZeroPagePointer4 + 1
        clc
        adc #$84
        sta ZeroPagePointer1 + 1
        lda ZeroPagePointer4
        sta ZeroPagePointer1
        lda #$00
        sta (ZeroPagePointer1), y

        label_7f60:
        tya
        clc
        adc ZeroPagePointer4
        cmp $1f
        beq label_7f70
        sta $1f
        inc CarDrivingCurrentPos
        bne label_7f70
        dec CarDrivingCurrentPos
        
        label_7f70:
        lda LastKeyPressed
        cmp #'B' // Has the bait key been pressed?
        bne returnToMainLoop
        lda #$00
        sta LastKeyPressed

        lda RemainingGhostBait
        bne useGhostBait

        // sorry, no bait
        ldx #ScrollerText.NoGhostBaitRemaining
        jsr FetchScrollerText
        jmp returnToMainLoop

        useGhostBait:
        dec RemainingGhostBait
        lda $68
        bne returnToMainLoop
        inc $68
        lda #$41
        sta (ZeroPagePointer4), y
        clc
        adc #$01
        iny
        sta (ZeroPagePointer4), y
        lda ZeroPagePointer4 + 1
        clc
        adc #$84
        sta ZeroPagePointer4 + 1
        lda #$03
        sta (ZeroPagePointer4), y
        dey
        sta (ZeroPagePointer4), y
        lda ObjectPosX
        sec
        sbc #$06
        sta ObjectPosX2 + 8
        sta ObjectPosX2 + 10
        clc
        adc #$0c
        sta ObjectPosX2 + 12
        sta ObjectPosX2 + 14
        lda ObjectPosY
        sec
        sbc #$0a
        sta ObjectPosY2 + 8
        sta ObjectPosY2 + 12
        clc
        adc #$15
        sta ObjectPosY2 + 10
        sta ObjectPosY2 + 14

        returnToMainLoop:
        jmp NextGameState.ReturnToMainLoop
    }

    *= $95a5
    ResetObjectPositions:
    {
        ldx #$07
        lda #$00
        sta $77

        loop:
        {
            sta ObjectPosX, x
            sta ObjectPosX + 8, x
            sta ObjectPosX2, x
            sta ObjectPosX2 + 8, x
            sta $2b, x
            dex
            bpl loop
        }
        rts
    }

    *= $95eb
    DrawMapBuilding:
    {
        stx ZeroPagePointer1
        sty ZeroPagePointer1 + 1
        cpx #$1d
        bcs label_95f7
        cpx #$04
        bcs label_95fb

        label_95f7:
        cpy #$02
        bcc return

        label_95fb:
        cpx #$10
        bcc label_9607
        cpx #$16
        bcs label_9607
        cpy #$02
        bcs return

        label_9607:
        lda $a861, x
        sta $0f
        lda $a87f, x
        sta $10
        lda $ea28, x
        tax
        lda LOOKUP_A855, x
        clc
        adc $a85d, y
        tax
        lda LOOKUP_A855, y
        asl
        tay
        lda #$04
        sta ZeroPagePointer3
        
        blocksLoop:
        {
            lda MAP_HOUSE_BLOCKS, x
            sta (ZeroPagePointer6), y
            iny
            inx
            dec ZeroPagePointer3
            bpl blocksLoop
        }
        ldx ZeroPagePointer1
        ldy ZeroPagePointer1 + 1

        return:
        rts
    }

    // Set the next pos that the ghosts return to?
    *= $983d
    label_983d:
    {
        ldx #$03

        loop: // 983f
        {
            lda $ea4e, x
            sta ObjectPosX2 + 8, x
            lda $ea52, x
            sta ObjectPosX2 + 12, x
            lda $c4, x
            sta $2f, x
            dex
            bpl loop
        }

        rts
    }

    // If a ghost has reached the zuul building, reset it back to its original positions
    *= $9851
    ResetGhostPosition: 
    {
        lda #$00
        sta $28
        ldy #$03

        label_9857:
        lda $00c4, y
        beq label_985e
        inc $28

        label_985e:
        dey
        bpl label_9857
        txa
        lsr
        tay
        lda GameState
        cmp #GameStates.CityMapUpdateLoop
        beq label_986b
        clc

        label_986b:
        lda $37b3, x
        sta MAP_SCREEN_OBJECT_POS_X_CACHE, x
        bcc label_9875
        sta ObjectPosX, x

        label_9875:
        lda $37b4, x
        sta MAP_SCREEN_OBJECT_POS_Y_CACHE, x
        bcc label_987f
        sta ObjectPosY, x

        label_987f:
        lda $37c3, x
        sta MAP_SCREEN_OBJECT_POS_X2_CACHE, x
        bcc label_9889
        sta ObjectPosX2, x

        label_9889:
        lda $37c4, x
        sta MAP_SCREEN_OBJECT_POS_Y2_CACHE, x
        bcc label_9893
        sta ObjectPosY2, x

        label_9893:
        cld
        rts
    }

    *= $9895
    IncreaseCityPKEnergy: 
    {
        sed
        clc

        label_9897:
        pha
        lda CityPKEnergy + 1
        and #$f0
        sta $ea72
        pla
        adc CityPKEnergy + 1
        sta CityPKEnergy + 1
        bcs label_98e3
        and #$f0
        cmp $ea72
        beq label_98e9
        cmp #$50
        bcc label_98e9
        stx $ea72
        lda $06
        sta $ea74

        label_98b9:
        lda $ea74
        and #$0f
        cmp #$04
        bcs label_98c4
        ora #$04

        label_98c4:
        tax
        lda $ea28, x
        bne label_98d1

        label_98ca:
        inc $ea74
        bne label_98b9
        beq label_98ca

        label_98d1:
        txa
        cmp #$0a
        beq label_98ca
        sta $80
        tax
        lda #$c8
        sta $c8, x
        ldx $ea72
        jmp label_98e9

        label_98e3:
        lda #$99
        sta $5a
        sta $5b

        label_98e9:
        cld
        rts
    }
}