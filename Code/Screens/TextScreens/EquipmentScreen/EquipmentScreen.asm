#importonce 
#import "EquipmentScreenData.asm"

.namespace EquipmentScreen 
{
    .namespace States 
    {
        *= $76bf
        PrepareCar:
        {
            jsr TextScreenShared.SetCarColor
            jmp NextGameState
        }

        *= $76c5
        SetTextAndSprites:
        {
            lda #$01
            sta VIC_BACKGROUND_COLOR_1
            ldx CarType
            lda CAR_MULTICOLOR, x
            sta VIC_BACKGROUND_COLOR_2
            lda #$00
            sta $15
            lda CurrentEquipmentView
            clc
            adc #DisplayText.MonitoringEquipment
            // current equipment screen text
            jsr TextScreenShared.SetDisplayTextPointer
            lda CurrentEquipmentView
            asl
            asl
            asl
            ora #$04
            tay
            lda #$04
            sta ZeroPagePointer1 + 1

            loop:
            {
                lda LOOKUP_AAB3, y
                sta ZeroPagePointer1
                beq continue
                sec
                sbc #$33
                tax
                lda InstalledEquipment
                and EQUIPMENT_FLAG, x
                beq continue

                lda #$00
                sta ZeroPagePointer1

                continue:
                ldx ZeroPagePointer1 + 1
                lda ZeroPagePointer1
                sta $2e, x
                dey
                dec ZeroPagePointer1 + 1
                bpl loop
            }

            // set up equipment sprite positions
            ldx #$09
            label_770d:
            lda SPRITE_POSITIONS_EQUIPMENT_SCREEN, x
            sta ObjectPosX2 + 6, x
            sta ObjectPosX + 6, x
            dex
            lda SPRITE_POSITIONS_EQUIPMENT_SCREEN, x
            sta ObjectPosX2 + 6, x
            sta ObjectPosX + 6, x
            dex
            bpl label_770d

            //
            ldx #$05
            
            loop2:
            {
                lda SPRITE_POSITIONS_EQUIPMENT_SCREEN_2, x
                sta ObjectPosX, x
                sta ObjectPosX2, x
                dex
                bpl loop2
            }

            lda #$01
            sta $2b
            lda #$00
            sta SpriteMulticolor2
            sta VIC_SPRITE_EXPAND_Y
            sta VIC_SPRITE_PRIORITY_REGISTER
            lda #$01
            sta SpriteMulticolor1
            lda #$ff
            sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
            lda #$01
            sta $5e
            jmp NextGameState
        }

        UpdateLoop:
        {
            ldx #$0e

            loop1:
            {
                jsr MoveObjectTowardsTarget
                dex
                dex
                bpl loop1
            }

            lda #$06
            sta VIC_SPRITE_EXPAND_X

            lda EquipmentSlotPlusThree
            asl
            tay
            bne label_7797

            lda ForkliftPositionSlot
            and #$1c
            sta ForkliftPositionSlot

            lda #$01
            sta $2b
            lda #$03
            sta $2c
            sta $2d

            lda ForkliftPositionSlot
            asl
            tax
            lda LOOKUP_A9CE, x
            sta ObjectPosY2
            lda ForkliftPositionSlot
            and #$01
            tax
            lda STAPLER_SLOT_X_POS, x
            sta ObjectPosX2
            lda ObjectPosX
            sec
            sbc #$18
            sta ObjectPosX + 2
            sta ObjectPosX + 4
            sta ObjectPosX2 + 2
            sta ObjectPosX2 + 4
            lda ObjectPosY
            sta ObjectPosY + 2
            sta ObjectPosY2 + 2
            sta ObjectPosY + 4
            sta ObjectPosY2 + 4

            label_7797:
            lda EquipmentSlotPlusThree
            asl
            tay
            beq label_780a

            ldx CarType
            lda CAR_EQUIPMENT_SLOT_X_POS_OFFSET, x
            sta ZeroPagePointer1
            lda ForkliftPositionSlot
            and #$0c
            asl
            adc ZeroPagePointer1
            tax

            // Forklist over car?
            lda ForkliftPositionSlot
            and #$03
            beq NotOverCar

            txa
            clc
            adc SelectedEquipment
            tax
            
            NotOverCar:
            lda EQUIPMENT_SCREEN_SLOT_POSITION_X, x
            sta ObjectPosX2, y
            sec
            sbc #$10
            sta ObjectPosX2
            lda #$00
            sta ZeroPagePointer1
            lda SelectedEquipment
            cmp #$05
            bne NotATrap

            // selected a trap, traps can stack
            lda ForkliftPositionSlot
            and #$03
            beq NoStackingOnLeftSide

            // offset of traps * 3
            lda MaxGhostTraps
            asl
            clc
            adc MaxGhostTraps
            sta ZeroPagePointer1

            NotATrap:
            NoStackingOnLeftSide:

            lda LOOKUP_A9CE, x
            sec
            sbc ZeroPagePointer1
            sta ObjectPosY2, y
            sta ObjectPosY2
            sta ObjectPosY2 + 2
            sta ObjectPosY2 + 4
            lda #$02
            sta $2b
            lda #$03
            sta $2c
            sta $2d
            lda ObjectPosX, y
            sec
            sbc #$08
            sta ObjectPosX2 + 4
            sbc #$0b
            cmp #$4c
            bcc label_7803

            lda #$4c
            label_7803:
            sta ObjectPosX2
            clc
            adc #$0c
            sta ObjectPosX2 + 2

            label_780a:
            lda ForkliftPositionSlot
            lsr
            lsr
            tay
            lda ForkliftPositionSlot
            and #$03
            bne label_7860
            lda JoystickValue
            and #$10
            cmp $11
            sta $11
            beq label_7860
            cmp #$00
            bne label_7860

            // fire button pushed
            lda EquipmentSlotPlusThree
            bne label_7847
            lda $002e, y
            beq label_7860

            lda ForkliftPositionSlot
            lsr
            lsr
            sta ZeroPagePointer1
            clc
            adc #$03
            sta EquipmentSlotPlusThree
            lda CurrentEquipmentView
            asl
            asl
            clc
            adc ZeroPagePointer1
            tax
            lda EQUIPMENT_TYPE_IN_SLOT, x
            sta SelectedEquipment
            jmp label_7860

            label_7847:
            lda ForkliftPositionSlot
            lsr
            lsr
            clc
            adc #$03
            cmp EquipmentSlotPlusThree
            bne label_7860
            lda EquipmentSlotPlusThree
            asl
            tax
            lda #$14
            sta ObjectPosX2, x
            lda #$00
            sta EquipmentSlotPlusThree
            sta SelectedEquipment

            label_7860:
            jsr CheckIfAllObjectsArrivedAtTargetX
            beq label_786d

            ldy #$02
            jsr PlaySoundEffect
            jmp label_78c1

            label_786d:
            jsr ResetVariablesToZero
            lda JoystickValue
            and #$08
            bne label_7881

            // move forklist over car
            lda ForkliftPositionSlot
            and #$03
            bne label_7881
            inc ForkliftPositionSlot
            jmp label_78c1

            label_7881:
            lda JoystickValue
            and #$04
            bne label_7892

            // move forklift back to shelf
            lda ForkliftPositionSlot
            and #$03
            beq label_7892
            dec ForkliftPositionSlot
            jmp label_78c1

            label_7892:
            lda ForkliftPositionSlot
            and #$03
            bne label_78c1
            lda EquipmentSlotPlusThree
            bne label_78c1
            lda JoystickValue
            and #$02
            bne label_78ae

            // move forklift down
            lda ForkliftPositionSlot
            cmp #$10
            bcs label_78ae
            lda ForkliftPositionSlot
            adc #$04
            sta ForkliftPositionSlot
            
            label_78ae:
            lda JoystickValue
            and #$01
            bne label_78c1

            // move forklift up
            lda ForkliftPositionSlot
            and #$1c
            beq label_78c1
            lda ForkliftPositionSlot
            sec
            sbc #$04
            sta ForkliftPositionSlot

            label_78c1:
            ldx CurrentEquipmentView
            lda ForkliftPositionSlot
            and #$03
            bne label_78d8
            lda ForkliftPositionSlot
            cmp HIGHEST_FORKLIFT_LOCATION_PER_EQUIPMENT_SCREEN, x
            bcc label_78d8
            lda HIGHEST_FORKLIFT_LOCATION_PER_EQUIPMENT_SCREEN, x
            sec
            sbc #$01
            sta ForkliftPositionSlot

            label_78d8:
            lda JoystickValue
            and #$10
            cmp $11
            sta $11
            beq CannotPutEquipmentInCar
            cmp #$00
            bne CannotPutEquipmentInCar

            // attempt to load equipment in car
            ldx CarType
            lda NumberOfEquipmentLoadedIntoCar
            cmp CAR_EQUIPMENT_CAPACITY, x
            bcc CanStoreEquipment

            // car is full
            ldx #$07
            jsr FetchScrollerText
            jmp CannotPutEquipmentInCar

            CanStoreEquipment:
            // is forklift over car?
            lda ForkliftPositionSlot
            and #$03
            bne PutEquipmentInCar

            CannotPutEquipmentInCar:
            jmp CheckKeyActions

            PutEquipmentInCar:
            jsr CheckIfAllObjectsArrivedAtTargetX
            bne CannotPutEquipmentInCar    // forklift is still moving
            ldx EquipmentSlotPlusThree
            lda $2b, x
            sec
            sbc #$33
            tay
            lda EQUIPMENT_PRICES, y
            sta ZeroPagePointer1 + 1
            lda #$00
            sta ZeroPagePointer1
            sta ZeroPagePointer3

            jsr TextScreenShared.HasEnoughMoney
            bcc CannotPutEquipmentInCar
            jsr TextScreenShared.DeductMoney

            lda EQUIPMENT_FLAG, y
            ora InstalledEquipment
            sta InstalledEquipment

            inc NumberOfEquipmentLoadedIntoCar

            // added a trap?
            lda $2b, x
            cmp #$38
            bne skip
            inc MaxGhostTraps
            inc NumberOfEmptyTraps
            
            skip:
            cmp #$36
            bne label_793e
            lda RemainingGhostBait
            clc
            adc #$05 // Add 5 ghost bait
            sta RemainingGhostBait

            label_793e:
            lda #$00
            sta ZeroPagePointer4 + 1
            lda EquipmentSlotPlusThree
            asl
            tay
            lda ObjectPosY, y
            sec
            sbc #$52
            sta ZeroPagePointer4
            bcs label_7952
            dec ZeroPagePointer4 + 1

            label_7952:
            lda ObjectPosX, y
            sec
            sbc #$57
            lsr
            lsr
            lsr
            sta ZeroPagePointer1
            lda #$00
            bcc label_7963
            lda #$80

            label_7963:
            clc
            adc ZeroPagePointer4
            sta ZeroPagePointer4
            lda ZeroPagePointer4 + 1
            clc
            adc ZeroPagePointer1
            clc
            adc #$5a
            sta ZeroPagePointer4 + 1
            lda #$00
            sta ZeroPagePointer1 + 1
            ldx EquipmentSlotPlusThree
            lda $57f8, x
            ldx #$05

            label_797d:
            asl
            rol ZeroPagePointer1 + 1
            dex
            bpl label_797d
            sta ZeroPagePointer1
            lda ZeroPagePointer1 + 1
            clc
            adc #$40
            sta ZeroPagePointer1 + 1
            lda ObjectPosX, y // there was a lda+2 here?
            sec
            sbc #$57
            and #$03
            sta ZeroPagePointer3
            ldx #$00
            ldy #$00

            label_799a:
            lda (ZeroPagePointer1), y
            sta ZeroPagePointer3 + 1
            iny
            lda (ZeroPagePointer1), y
            sta $27
            iny
            lda (ZeroPagePointer1), y
            sta $28
            iny
            lda #$00
            sta $29
            lda ZeroPagePointer3
            sta $2a

            label_79b1:
            dec $2a
            bmi label_79c8
            lsr ZeroPagePointer3 + 1
            ror $27
            ror $28
            ror $29
            lsr ZeroPagePointer3 + 1
            ror $27
            ror $28
            ror $29
            jmp label_79b1

            label_79c8:
            lda ZeroPagePointer3 + 1
            sta $e800, x
            inx
            lda $27
            sta $e800, x
            inx
            lda $28
            sta $e800, x
            inx
            lda $29
            sta $e800, x
            inx
            cpx #$5c
            bcc label_799a
            ldx #$00
            lda #$00
            sta $28

            label_79ea:
            lda $e800, x
            tay
            lda $e600, y
            sta ZeroPagePointer3
            eor #$ff
            sta ZeroPagePointer3 + 1
            lda $e800, x
            and ZeroPagePointer3
            sta $27
            ldy $28
            lda (ZeroPagePointer4), y
            and ZeroPagePointer3 + 1
            ora $27
            sta (ZeroPagePointer4), y
            inc $28
            bne label_7a0e
            inc ZeroPagePointer4 + 1

            label_7a0e:
            inx
            inx
            inx
            inx
            cpx #$54
            bcc label_79ea
            txa
            sec
            sbc #$53
            tax
            lda ZeroPagePointer4
            clc
            adc #$6b
            sta ZeroPagePointer4
            lda ZeroPagePointer4 + 1
            adc #$00
            sta ZeroPagePointer4 + 1
            cpx #$04
            bne label_79ea
            lda EquipmentSlotPlusThree
            sec
            sbc #$03
            asl
            asl
            asl
            tax

            lda EquipmentSlotPlusThree
            asl
            tay
            lda LOOKUP_A9CE, x
            sta ObjectPosY, y
            sta ObjectPosY2, y

            lda #$00
            sta ObjectPosX, y
            sta EquipmentSlotPlusThree

            lda #$14
            sta ObjectPosX2, y
            tya
            lsr
            tax
            lda $2b, x
            cmp #$38
            beq CheckKeyActions

            lda #$00
            sta $2b, x

            CheckKeyActions:
            lda LastKeyPressed
            beq noAction
            cmp #'E'    // E for end
            bne EndNotChosen

            // finished equipment screen
            lda #$00
            sta LastKeyPressed

            // only start game if we have at least one trap
            lda MaxGhostTraps
            bne continue
            jmp NextGameState.ReturnToMainLoop

            continue:
            jmp NextGameState

            EndNotChosen:
            cmp #'1'
            bcc noAction
            cmp #'4'
            bcs noAction
            and #$03
            sec
            sbc #$01
            cmp CurrentEquipmentView
            beq noAction
            sta CurrentEquipmentView

            lda #$00
            sta LastKeyPressed
            sta CurrentlyDisplayedText
            sta $5e
            sta ForkliftPositionSlot
            sta EquipmentSlotPlusThree
            sta SelectedEquipment
            lda #GameStates.EquipmentScreenPrepareCar
            sta GameState
            jmp TextScreenShared.ResetTextOutputCoords

            noAction:
            jmp NextGameState.ReturnToMainLoop
        }
    }


    // checks whether all objects arrived at the target x pos
    // returns 0 if they did, anything else when they did not
    *= $9c15
    CheckIfAllObjectsArrivedAtTargetX:
    {
        ldx #$0f

        loop:
        {
            lda ObjectPosX, x
            cmp ObjectPosX2, x
            bne ObjectNotAtTarget
            dex
            bpl loop
        }

        // all objects arrived at target
        lda #$00

        ObjectNotAtTarget:
        rts
    }
}