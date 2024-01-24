#importonce 
#import "DrivingScreenData.asm"

.namespace DrivingScreen 
{
    .const MoveCarLeftFlag = $ff
    .const MoveCarRightFlag = $01

    .namespace States 
    {
        *= $7fc9
        LoadCharData:
        {
            ldx #$07
            lda #$00

            label_7fcd:
            sta $2b, x
            dex
            bpl label_7fcd
            jsr ClearScreen
            lda #$0c
            sta BackgroundColor
            lda #$01
            sta VIC_BACKGROUND_COLOR_1
            ldx CarType
            lda CAR_MULTICOLOR, x
            sta VIC_BACKGROUND_COLOR_2
            lda $68
            beq label_7ff8
            lda #$00
            sta $68
            ldx #$07

            label_7ff0:
            lda ObjectPosX2 + 8, x
            sta $ea4e, x
            dex
            bpl label_7ff0

            label_7ff8:
            lda CarDrivingCurrentPos
            clc
            adc #$05
            bcc label_8001
            lda #$ff

            label_8001:
            sta CarDrivingMaxLength
            lda #$00
            sta CarDrivingCurrentPos
            lda #<$e000
            sta ZeroPagePointer5
            lda #>$e000
            sta ZeroPagePointer5 + 1
            lda #<$5a00
            sta ZeroPagePointer6
            lda #>$5a00
            sta ZeroPagePointer6 + 1

            // copy 6 * 256 bytes
            ldx #$05
            ldy #$00
            copyLoop:
            {
                lda (ZeroPagePointer5), y
                sta (ZeroPagePointer6), y
                iny
                bne copyLoop
                inc ZeroPagePointer5 + 1
                inc ZeroPagePointer6 + 1
                dex
                bpl copyLoop
            }

            lda #$00
            sta DrivingStripeSpeed
            sta $1c
            sta $1a
            sta LastKeyPressed
            jmp NextGameState
        }

        *= $8036
        SetSpritePositions:
        {
            lda #CarDirectionControl
            sta CarPosX
            lsr
            lsr
            jsr TextViewShared.EquipmentScreenFillCarColor.FillCarColor

            ldx #$00
            lda #$08

            colorLoop:
            {
                sta COLOR_RAM, x
                sta COLOR_RAM + $100, x
                sta COLOR_RAM + $200, x
                sta COLOR_RAM + $270, x
                inx
                bne colorLoop
            }

            lda #$f0
            sta VIC_SPRITE_EXPAND_Y
            ldx #$07

            setSpritePositionsLoop:
            {
                lda LOOKUP_37A3, x
                sta ObjectPosX, x
                lda LOOKUP_37A3 + 8, x
                sta ObjectPosX + 8, x
                lda LOOKUP_379B, x
                sta $2b, x
                dex
                bpl setSpritePositionsLoop
            }

            lda #$f0
            sta VIC_SPRITE_PRIORITY_REGISTER
            jsr NextGameState
        }

        *= $8073
        DrivingToTarget:
        {
            lda #$f8
            sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER
            lda $1c
            clc
            adc DrivingStripeSpeed
            sta $1c
            lsr
            lsr
            lsr
            lsr
            clc
            adc $1a
            cmp #$7f
            bcc label_8098
            sbc #$7f
            ldy CarDrivingCurrentPos
            cpy CarDrivingMaxLength
            beq label_8098
            inc CarDrivingCurrentPos
            bne label_8098
            dec CarDrivingCurrentPos

            label_8098:
            sta $1a
            ldx #$02

            label_809c:
            lda ObjectPosY, x
            beq label_80af
            nop
            nop
            jsr MoveObjectTowardsTarget
            lda ObjectPosY, x
            cmp #$e0
            bcc label_80af
            lda #$00
            sta ObjectPosY, x

            label_80af:
            dex
            dex
            bpl label_809c
            lda $1c
            and #$0f
            sta $1c
            lda CarDrivingCurrentPos
            cmp CarDrivingMaxLength
            beq slowDown

            inc DrivingStripeSpeed

            // clamp max. stripe speed depending on car
            ldx CarType
            lda DrivingStripeSpeed
            cmp CAR_MAX_STRIPE_SPEED, x
            bcc label_80cf
            lda CAR_MAX_STRIPE_SPEED, x
            sta DrivingStripeSpeed

            label_80cf:
            jmp label_80d8

            slowDown:
            lda DrivingStripeSpeed
            beq label_80d8
            dec DrivingStripeSpeed

            label_80d8:
            lda $1a
            sta ObjectPosY + 14
            sta ObjectPosY + 10
            clc
            adc #$7f
            sta ObjectPosY + 8
            sta ObjectPosY + 12

            lda CarDrivingCurrentPos
            cmp CarDrivingMaxLength
            beq label_8101

            lda JoystickValue
            and #$04
            bne label_80fb
            lda CarPosX
            cmp #$09
            bcc label_80fb
            lda #MoveCarLeftFlag
            sta CarDirectionControl

            label_80fb:
            lda JoystickValue
            and #$08
            bne label_810b

            label_8101:
            lda CarPosX
            cmp #CarDirectionControl
            bcs label_810b
            lda #MoveCarRightFlag
            sta CarDirectionControl

            label_810b:
            inc $65
            lda $65
            ora #$80
            sta $65
            lda $06
            sta ZeroPagePointer1
            ldx #$03

            label_8119:
            lda $6f, x
            beq label_817c
            cmp CarDrivingCurrentPos
            bne label_817c
            ldy #$ff
            lda ObjectPosY
            bne label_8133
            lda #$ff
            sta $6f, x
            ldy #$00
            stx $73
            inc ObjectPosY
            bne label_8141

            label_8133:
            lda ObjectPosY + 2
            bne label_8141
            lda #$ff
            sta $6f, x
            ldy #$02
            stx $74
            inc ObjectPosY + 2

            label_8141:
            inc $6f, x
            tya
            bmi label_817c
            lda ZeroPagePointer1
            cmp #$80
            rol
            sta ZeroPagePointer1
            and #$7f
            clc
            adc #$10
            sta ObjectPosX, y
            sta ObjectPosX2, y
            lda #$f0
            sta ObjectPosY2, y
            tya
            lsr
            tay
            lda ZeroPagePointer1
            and #$01
            clc
            adc #$08
            sta $002b, y
            lda VIC_SPRITE_EXPAND_X
            ora BIT_TABLE, y
            sta VIC_SPRITE_EXPAND_X
            lda VIC_SPRITE_EXPAND_Y
            ora BIT_TABLE, y
            sta VIC_SPRITE_EXPAND_Y

            label_817c:
            dex
            bpl label_8119

            lda CarDrivingCurrentPos
            cmp CarDrivingMaxLength
            bne continue

            // reached the end?
            lda DrivingStripeSpeed
            bne continue
            jmp NextGameState

            continue:
            ldx #$02

            label_818e:
            lda ObjectPosX + 4
            sec
            sbc #$04
            sta ZeroPagePointer3

            ldy CarType
            lda LOOKUP_3806, y
            sta ZeroPagePointer3 + 1

            lda ObjectPosY, x
            beq label_81d5
            lda ObjectPosY2, x
            cmp #$f0
            bne label_81cd
            lda JoystickValue
            and #$10
            cmp $11, x
            sta $11, x
            beq label_81d5
            cmp #$00
            bne label_81d5
            lda ObjectPosX + 4
            sec
            sbc #$20
            sta ZeroPagePointer1
            clc
            adc #$30
            sta ZeroPagePointer1 + 1
            lda ObjectPosX, x
            jsr label_9c08
            bcc label_81d5
            lda InstalledEquipment
            and #$20
            beq label_81d5

            label_81cd:
            lda ZeroPagePointer3
            sta ObjectPosX2, x
            lda ZeroPagePointer3 + 1
            sta ObjectPosY2, x

            label_81d5:
            dex
            dex
            bpl label_818e
            ldx #$02
            ldy #$01

            label_81dd:
            lda $0075, y
            beq label_81f4
            cmp #$11
            lda ZeroPagePointer3
            bcs label_81ea
            adc #$07

            label_81ea:
            sta ObjectPosX, x
            sta ObjectPosX2, x
            lda ZeroPagePointer3 + 1
            sta ObjectPosY, x
            sta ObjectPosY2, x

            label_81f4:
            dex
            dex
            dey
            bpl label_81dd
            ldx #$02

            label_81fb:
            lda ObjectPosX, x
            eor ObjectPosX2, x
            and #$fe
            bne label_821b
            lda ObjectPosY, x
            cmp ObjectPosY2, x
            bne label_821b
            txa
            lsr
            tay
            lda $0075, y
            bne label_821b
            lda #$20
            sta $0075, y
            ldy #$00
            jsr PlaySoundEffect

            label_821b:
            dex
            dex
            bpl label_81fb
            ldx #$02
            ldy #$01

            VacuumGhost:
            lda $0075, y
            beq label_8271
            sta ZeroPagePointer3
            sec
            sbc #$01
            sta $0075, y
            bne label_8249
            lda #$00
            sta ObjectPosY, x
            stx ZeroPagePointer1
            sty ZeroPagePointer1 + 1
            lda $0073, y
            asl
            clc
            adc #$08
            tax
            jsr CityMapScreen.ResetGhostPosition
            ldy ZeroPagePointer1 + 1
            ldx ZeroPagePointer1

            label_8249:
            and #$04
            lsr
            lsr
            clc
            adc #$08
            sta $002b, y
            lda ZeroPagePointer3
            cmp #$10
            bne label_8262
            lda VIC_SPRITE_EXPAND_X
            and $3753, y
            sta VIC_SPRITE_EXPAND_X

            label_8262:
            lda ZeroPagePointer3
            cmp #$08
            bne label_8271
            lda VIC_SPRITE_EXPAND_Y
            and $3753, y
            sta VIC_SPRITE_EXPAND_Y

            label_8271:
            dex
            dex
            dey
            bpl VacuumGhost
            jmp NextGameState.ReturnToMainLoop
        }
    }

    *= $34f9
    MoveCarLeft:
    {
        dec CarPosX
        lda CarPosX
        and #$03
        cmp #$03
        bne return
        lda CarPosX
        lsr
        lsr
        tax
        ldy #$0c
        
        loop:
        {
            lda $54a0, x
            sta $549f, x
            lda $54c8, x
            sta $54c7, x
            lda $54f0, x
            sta $54ef, x
            lda $5518, x
            sta $5517, x
            lda $5540, x
            sta $553f, x
            lda $5568, x
            sta $5567, x
            lda $5590, x
            sta $558f, x
            lda $55b8, x
            sta $55b7, x
            lda $55e0, x
            sta $55df, x
            lda $5608, x
            sta $5607, x
            lda $5630, x
            sta $562f, x
            lda $5658, x
            sta $5657, x
            lda $5680, x
            sta $567f, x
            lda $56a8, x
            sta $56a7, x
            lda $56d0, x
            sta $56cf, x
            lda $56f8, x
            sta $56f7, x
            inx
            dey
            bpl loop
        }
        
        return:
        rts
    }

    MoveCarRight:
    {
        inc CarPosX
        lda CarPosX
        and #$03
        bne return
        lda CarPosX
        lsr
        lsr
        clc
        adc #$0c
        tax
        ldy #$0c
        
        loop:
        {
            lda $549f, x
            sta $54a0, x
            lda $54c7, x
            sta $54c8, x
            lda $54ef, x
            sta $54f0, x
            lda $5517, x
            sta $5518, x
            lda $553f, x
            sta $5540, x
            lda $5567, x
            sta $5568, x
            lda $558f, x
            sta $5590, x
            lda $55b7, x
            sta $55b8, x
            lda $55df, x
            sta $55e0, x
            lda $5607, x
            sta $5608, x
            lda $562f, x
            sta $5630, x
            lda $5657, x
            sta $5658, x
            lda $567f, x
            sta $5680, x
            lda $56a7, x
            sta $56a8, x
            lda $56cf, x
            sta $56d0, x
            lda $56f7, x
            sta $56f8, x
            dex
            dey
            bpl loop
        }

        return:
        rts
    }

    *= $7024
    label_7024:
    {
        lda GameState
        cmp #GameStates.DrivingToTarget
        bne label_704c // This goes to the account screen
        
        // Handle Car changing position
        lda CarPosX
        and #$03
        asl
        sta ZeroPagePointer1
        lda VIC_SCREEN_CONTROL_REGISTER_2
        and #$f8
        ora ZeroPagePointer1
        sta VIC_SCREEN_CONTROL_REGISTER_2

        // set GB logo position
        lda CarPosX
        adc #$1e
        sta ObjectPosX + 4
        sta ObjectPosX + 6

        ldx CarType
        lda CAR_LOGO_Y_POS, x
        sta ObjectPosY + 4
        sta ObjectPosY + 6
    }

    *= $704c
    label_704c: 
    {
        lda $65
        beq label_7061  // This goes to the account screen
        and #$1f
        cmp #$10
        bcc continue
        eor #$1f
        
        continue:
        lsr
        lsr
        tax
        lda CAR_GB_LOGO_COLORS, x
        sta VIC_SPRITE_COLOR + 2
    }
}