.namespace MainTitleScreen {
    
    *= $6305 "MainLoop"
    TitleScreenLoop:
    {
        outerWaitLoop:
        {
            lda #40 // Wait till we are line 40 (#$28)
            innerWaitLoop:
            {
                cmp VIC_CURRENT_RASTER_LINE
                bne innerWaitLoop
            }
            lda VIC_SCREEN_CONTROL_REGISTER_1
            bmi outerWaitLoop  // If the MSB is set, loop as the raster is at 296 ($128)
        }

        lda #$18
        sta VIC_SCREEN_CONTROL_REGISTER_1
        lda #$1b
        sta VIC_SCREEN_CONTROL_REGISTER_2
        lda #$01
        sta VIC_BACKGROUND_COLOR_1
        lda #$02
        sta VIC_BACKGROUND_COLOR_2
        jmp UpdateMainTitleScreen
    }    

    *= $6329
    UpdateMainTitleScreen: 
    {
        jsr DisableKeyboardInterrupts
        jsr ScanKeyboard
        jsr PlayThemeTune
        jsr UpdateBallPosition
        jsr UpdateSongLyricsTimers
        lda $EA73 
        beq checkRenderNextLyricCountdown
        lda $08
        and #$07
        cmp #$01
        bne checkRenderNextLyricCountdown
        jsr UpdateBallPosition
        jsr UpdateSongLyricsTimers
    
        checkRenderNextLyricCountdown: /// $634b
        .break
        lda RenderNextLyricCountdown
        beq checkForSpacebarInput
        dec RenderNextLyricCountdown
        bne updateScreenLyrics

        updateScreenLyrics: // $6353
        .break
        lda RenderNextLyricCountdown
        and #$0f
        beq jumpToDisplayNextSongLine
        and #$07
        cmp #$07
        bne checkForSpacebarInput

        ldx #$27
        lda #$00

        removeCurrentLyricFromScreen:
        {
            sta $5400 + 20 * 40, x
            dex
            bpl removeCurrentLyricFromScreen
        }

        ldx #$00

        copyNextLyricUpOneRow:
        {
            lda $5400 + 21 * 40, x
            sta $5400 + 20 * 40, x
            inx
            cpx #$50
            bcc copyNextLyricUpOneRow
        }

        ldx #$27
        lda #$00

        removeCopiedLyric:
        {
            sta $5400 + 22 * 40, x
            dex
            bpl removeCopiedLyric
        }
        
        bmi checkForSpacebarInput // If the negative flag is set, branch

        jumpToDisplayNextSongLine: // $6382
        jsr DisplayNextSongLine

        checkForSpacebarInput:
        lda LastKeyPressed
        cmp #' '
        bne checkFromStartOfGame

        lda RenderNextLyricCountdown
        bne checkFromStartOfGame
        sta LastKeyPressed

        lda #Speech.Ghostbusters
        jsr SoundEffects.TriggerSpeech
        
        checkFromStartOfGame:    // $6396
        jsr DisableKeyboardInterrupts

        // F1/F3 pushed
        lda $19
        cmp #$20    // Has F1 been pressed
        bne checkF3WasPressed

        startGame:
        sta $eab2
        jsr ResetSIDRegisters
        jmp label_6fe2
        //jmp LoadStraightToMapView
        //jmp LoadStraightToCaptureGhost

        checkF3WasPressed:
        cmp #$28    // Has F3 been pressed
        beq startGame   
         
        jmp MainTitleScreen.TitleScreenLoop
    }

    *= $93E1
    Return: 
    {
        rts
    }

    *= $93F0
    PlayThemeTune: 
    {
        bit $47
        bmi Return  // If $47 is negative, then return

        ldx #$02
        PrepareAudio:  // $93F6
        {
            stx $ea75
            lda $a2b4, x
            sta $e1
            tay
            lda $08
            and #$03
            bne label_941d
            lda SoundEffects.LOOKUP_A2B7_LO, x
            sta ZeroPagePointer7
            lda SoundEffects.LOOKUP_A2BA_HI, x
            sta ZeroPagePointer7 + 1
            lda $88, x
            bmi label_941a
            dec $88, x
            bmi label_9420
            jmp label_94ff

            label_941a:
            jmp label_958c

            label_941d:
            jmp label_951f

            label_9420:
            ldy $82, x
            lda (ZeroPagePointer7), y
            cmp #$ff
            bne label_9434
            sta $88, x
            lda $20
            beq label_9431
            jsr ClearMemory_0082_008A

            label_9431:
            jmp label_941a

            label_9434:
            asl
            tay
            lda LOOKUP_A75B, y
            sta ZeroPagePointer8
            lda LOOKUP_A75B + 1, y
            sta ZeroPagePointer8 + 1

            ldy $85, x
            lda #$ff
            sta $de
            lda (ZeroPagePointer8), y
            sta $8e, x
            sta $dd
            and #$1f
            sta $88, x
            bit $dd
            bvs label_94b0
            inc $85, x
            lda $dd
            bpl label_948f
            iny
            iny
            lda (ZeroPagePointer8), y
            pha
            and #$0f
            sta $94, x
            pla
            lsr
            lsr
            lsr
            lsr
            sta $dc
            cmp #$0f
            bne label_947b
            lda #$6d
            sec
            sbc $82
            cmp #$0f
            bcc label_9479
            lda #$0f

            label_9479:
            sta $dc

            label_947b:
            lda $20

            beq label_9481
            lsr $dc

            label_9481:
            lda $dc
            sta ShadowSIDVolume
            sta SID_VOICE_3_MAIN_VOLUME_CONTROL
            inc $85, x
            dey
            dey
            lda $8e, x

            label_948f:
            iny
            lda (ZeroPagePointer8), y
            sta $8b, x
            asl
            tay
            lda $a1f4, y
            sta $dc
            jsr label_9593
            bne LoadAudioIntoSID
            lda $a1f5, y
            ldy $e1
            sta SID_REGISTERS + 1, y
            lda $dc
            sta SID_REGISTERS, y
            jmp LoadAudioIntoSID

            label_94b0:
            dec $de

            LoadAudioIntoSID: // $94B2
            ldy $e1
            lda $94, x
            stx $e0
            asl
            asl
            asl
            tax
            lda $A7F1, x
            sta $df
            jsr label_9593
            bne label_94e6
            lda $A7F1, x
            and $DE
            sta SID_REGISTERS + 4, y
            lda $A7EF, x
            sta SID_REGISTERS + 2, y
            lda $A7F0, x
            sta SID_REGISTERS + 3, y
            lda $A7F2, x
            sta SID_REGISTERS + 5, y
            lda $A7F3, x
            sta SID_REGISTERS + 6, y

            label_94e6:
            ldx $e0
            lda $df
            sta $91, x
            inc $85, x
            ldy $85, x
            lda (ZeroPagePointer8), y
            cmp #$ff
            bne label_94fc
            lda #$00
            sta $85, x
            inc $82, x

            label_94fc:
            jmp label_958c

            label_94ff:
            ldy $e1
            lda $8e, x
            and #$20
            bne label_951f
            jsr label_9593
            bne label_951f
            lda $91, x
            and #$fe
            sta SID_REGISTERS + 4, y
            lda $88, x
            bne label_951f
            lda #$00
            sta SID_REGISTERS + 5, y
            sta SID_REGISTERS + 6, y

            label_951f:
            lda $94, x
            asl
            asl
            asl
            tay
            lda $a7f4, y
            sta $e0
            beq label_958c
            lda $08
            and #$07
            cmp #$04
            bcc label_9536
            eor #$07

            label_9536:
            sta $de
            lda $8b, x
            asl
            tay
            sec
            lda $a1f6, y
            sbc $a1f4, y
            sta $dc
            lda $a1f7, y
            sbc $a1f5, y

            label_954b:
            lsr
            ror $dc
            dec $e0
            bpl label_954b
            sta $dd
            lda $a1f4, y
            sta $df
            lda $a1f5, y
            sta $e0
            lda $8e, x
            and #$1f
            cmp #$05
            bcc label_957b
            ldy $de

            label_9568:
            dey
            bmi label_957b
            clc
            lda $df
            adc $dc
            sta $df
            lda $e0
            adc $dd
            sta $e0
            jmp label_9568

            label_957b:
            ldy $e1
            jsr label_9593
            bne label_958c
            lda $df
            sta SID_REGISTERS, y
            lda $e0
            sta SID_REGISTERS + 1, y

            label_958c:
            dex
            bmi return
            jmp PrepareAudio
        }

        return: // $9592
        rts
    }

    label_9593:
    {
        lda $98
        beq label_95a2
        lda #$02
        cmp $ea75
        bne label_95a2
        lda #$ff
        bne return
        
        label_95a2:
        lda #$00

        return: // $95a4
        rts
    }

    *= $9682
    DisplayNextSongLine:
    {
        ldx #$07
        ldy #$00

        FetchNextChar:
        {
            lda (TitleSongTextPointerLow), y
            cmp #$ff    // Have we reached the end of the lyrics?
            bne checkCharacterType

            // Reset ZP pointers back to the start of the song
            ldy #$00
            lda #<Lyrics
            sta TitleSongTextPointerLow
            lda #>Lyrics
            sta TitleSongTextPointerHigh
            jmp return

            checkCharacterType: // $9699
            cmp #$0d        // Is it the end of the line?
            beq moveToNextSongLyric
            cmp #$20        // Is it a space?
            bne label_96a3
            lda #$00
        
            label_96a3:
            cmp #$40        // Is the char value > 40?
            bcc label_96a9
            sbc #$40        // Align character value with charset

            label_96a9:
            sta SCREEN_CHAR + 22 * 40, x
            iny
            inx
            cpx #$28
            bcc FetchNextChar
        }

        moveToNextSongLyric:
        iny
        clc
        tya
        adc TitleSongTextPointerLow
        sta TitleSongTextPointerLow
        lda TitleSongTextPointerHigh
        adc #$00
        sta TitleSongTextPointerHigh

        loop:
        {
            lda #$00
            sta SCREEN_CHAR + 22 * 40, x
            inx
            cpx #$28
            bcc loop
        }

        return: // $96C9
        rts
    }

    *= $c101
    LoadStraightToMapView:
    {    
        lda #$2f
        sta ZeroPage0
        lda #$15
        sta ZeroPage1
        lda #JOYSTICK_INPUT_ENABLED
        sta IsJoystickInputEnabled
        lda #$0a
        sta $06
        lda #$cb
        sta $08
        lda #$71
        sta $09
        lda #$fb
        sta $0b
        lda #$5d
        sta $0c

        lda #$45
        sta $18
        lda #$31
        sta $19

        lda #$01
        sta SpriteMulticolor1

        lda #$02
        sta ShouldLoadAccountScreen

        lda #$45
        sta TitleSongTextPointerLow

        lda #$64
        sta TitleSongTextPointerHigh

        lda #$49
        sta ZeroPagePointer1

        lda #$03
        sta ZeroPagePointer1 + 1

        lda #$30
        sta $26

        lda #$03
        sta $27

        lda #$1f
        sta JoystickValue
        
        lda #$08
        sta BackgroundColor

        lda #$14
        sta ZeroPagePointer2

        lda #$ea
        sta ZeroPagePointer2 + 1

        lda #05
        sta MaxGhostTraps
        sta NumberOfEmptyTraps

        lda #03
        sta RemainingGhostbusters

        lda #$99
        sta RemainingBackbackCharge

        lda #05
        sta RemainingGhostBait

        lda #%00101111    // $2f
        sta InstalledEquipment

        lda #01
        sta CarType

        lda #$49 // Set CityPKEnergy to 4900
        sta CityPKEnergy + 1

        //lda #$01
        //sta StartingAccountBalance

        //lda #$6c
        //sta PKEnergyRateIncrease

        lda #GameStates.PrepareMapScreen
        sta GameState

        lda #$1b
        sta VIC_SCREEN_CONTROL_REGISTER_1

        lda #$d7
        sta VIC_SCREEN_CONTROL_REGISTER_2

        // Render the car so it can be stored in $e000 when the city map loads
        jsr VehicleSelectionScreen.States.DisplayCar.Render

        //jsr ClearScreen

        jmp NextGameState.ReturnToMainLoop
        //jmp JumpToNextTableState
    }

    LoadStraightToCaptureGhost:
    {    
        lda #$2f
        sta ZeroPage0
        lda #$15
        sta ZeroPage1
        lda #$80
        sta $02
        lda #$0a
        sta $06
        lda #$cb
        sta $08
        lda #$71
        sta $09
        lda #$fb
        sta $0b
        lda #$5d
        sta $0c

        lda #$45
        sta $18
        lda #$31
        sta $19

        lda #$01
        sta SpriteMulticolor1

        lda #$02
        sta ShouldLoadAccountScreen

        lda #$45
        sta TitleSongTextPointerLow

        lda #$64
        sta TitleSongTextPointerHigh

        lda #$49
        sta ZeroPagePointer1

        lda #$03
        sta ZeroPagePointer1 + 1

        lda #$30
        sta $26

        lda #$03
        sta $27

        lda #$1f
        sta JoystickValue
        
        lda #$08
        sta BackgroundColor

        lda #$14
        sta ZeroPagePointer2

        lda #$ea
        sta ZeroPagePointer2 + 1

        lda #05
        sta MaxGhostTraps
        sta NumberOfEmptyTraps

        lda #03
        sta RemainingGhostbusters

        lda #$99
        sta RemainingBackbackCharge

        lda #05
        sta RemainingGhostBait

        lda #%00101111    // $2f
        sta InstalledEquipment

        lda #01
        sta CarType

        //lda #$07 // Ghost preset?
        //sta CaptureGhostVisitType

        lda #GameStates.PrepareCaptureGhostSequence1
        sta GameState

        lda #$9b
        sta VIC_SCREEN_CONTROL_REGISTER_1

        lda #$d7
        sta VIC_SCREEN_CONTROL_REGISTER_2

        lda #$fc
        sta VIC_BACKGROUND_COLOR_0

        lda #$f6
        sta VIC_BACKGROUND_COLOR_2

        lda #$f0
        sta VIC_SPRITE_MULTICOLOR_0

        // Render the car so it can be stored in $e000 when the city map loads
        //jsr StateDisplayEquipmentScreenCar.Render

        //jsr ClearScreen

        jmp NextGameState.ReturnToMainLoop
        //jmp JumpToNextTableState
    }
}