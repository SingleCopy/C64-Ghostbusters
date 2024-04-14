#importonce 
#import "MainTitleScreenData.asm"
#import "MainTitleScreenShared.asm"
#import "MainTitleScreen.asm"

.namespace MainTitleScreenInit
{
    *= $62eb
    .macro @TitleScreenInit()
    {
        lda #Speech.Ghostbusters // Ghostbusters
        jsr SoundEffects.TriggerSpeech

        lda #Speech.Laugh  // Ha ha ha ha ha
        jsr SoundEffects.TriggerSpeech

        lda #$00
        sta $08
        sta TitleSongElapsedTime
        jsr ClearMemory_0082_008A
        jsr InitBallSpritePositionAndSoundMemoryLocation
        jsr UpdateBallPosition
        cli 

        // Continues to MainTitleScreen.TitleScreenLoop;
    }

    *= $6425
    NMIVector: 
    {
        pha
        lda $19
        cmp #$3f
        bne continue

        lda #$08
        sta VIC_SCREEN_CONTROL_REGISTER_1
        lda #$00
        sta $eab2
        jmp GameMainInit

        continue:
        pla
        rti
    }

    *= $f083
    _F083: // Called from the NMI Vector interrupt
    {
        pha
        lda wF000:$F000  // This value is being modified
        lsr
        sta SID_VOLUME_FILTER_MODES
        cmp CIA2_INTERRUPT_CONTROL
        dec $fd
        beq continue_F097
        inc wF000
        pla
        rti


        continue_F097: // F097
        lda #<IRQ_F0A4
        sta NMI_ROM_VECTOR

        lda wF000
        sta lookupF000
        pla
        rti

        IRQ_F0A4:
        pha
        lda lookupF000:$F000
        lsr
        sta SID_VOLUME_FILTER_MODES
        cmp CIA2_INTERRUPT_CONTROL
        dec $FE
        beq label_f0b8
        dec $f0a6
        pla
        rti
    }

    *= $f0b8
    label_f0b8:
    {
        lda $ff
        beq label_f0f2
        lda #<IRQ_F0C3
        sta NMI_ROM_VECTOR
        pla
        rti
    }

    *= $f0c3
    IRQ_F0C3:
    {
        pha
        nop
        lda #$0e
        lsr
        sta SID_VOLUME_FILTER_MODES
        cmp CIA2_INTERRUPT_CONTROL
        dec $ff
        beq label_f0f2
        lda #<IRQ_F0D9
        sta NMI_ROM_VECTOR
        pla
        rti
    }

    *= $f0d9
    IRQ_F0D9:
    {
        cmp CIA2_INTERRUPT_CONTROL
        dec $ff
        beq label_f0f1
        rti
    }

    *= $f0e1
    lsmf_f0e1:
    {
        pha
        lda #$90
        sta $dd0f
        lda #$07
        sta SID_VOLUME_FILTER_MODES
        cmp CIA2_INTERRUPT_CONTROL
        pla
        rti
    }

    *= $f0f1
    label_f0f1:
    {
        pha
    }

    *= $f0f2
    label_f0f2:
    {
        lda $F4da
        sta NMI_ROM_VECTOR
        lda $F4db
        sta $f085
        lda $F4dc
        sta $fd
        sta $fe
        lda $F4dd
        sta $ff
        cld
        inc $F4e0
        beq label_f113
        jmp label_f13a
    }

    *= $f113
    label_f113:
    {
        txa
        pha
        tya
        pha
        jsr label_f120
        pla
        tay
        pla
        tax
        pla
        rti
    }

    *= $f120
    label_f120:
    {
        inc $F4de
        bne label_f128
    }

    *= $f128
    label_f128:
    {
        lda $F4DF
        sta $F4E0

        lda $F4DB
        and #$40
        eor #$40
        tax
        clc
    }

    *= $f13a
    label_f13a:
    {
        pla
        rti
    }

    *= $f13c
    _F13C:
    {
        txa
        pha
        tya
        pha
        lda $F4e3
        cmp $F4db
        beq _f14b
        jsr _F3FC
    }

    *= $f14b
    _f14b:
    {
        jsr _F31C
        pla
        tay
        pla
        tax
        pla
        rti
    }

    *= $f154
    _f154:
    {
        lda $f4dc
        cmp #$10
        beq _f16e
        sec
        sbc $f4e2
        sta $f4dc
        lda $f4db
        clc
        adc $f4e2
        sta $f4db
        pla
        rti
    }

    *= $F16E
    _f16e:
    {
        lda $f4db
        and #$40
        sta $f4db
        lda $f4e1
        sta $f4dc
        pla
        rti
    }

    *= $F17E
    _f17e: 
    {
        lda #$E1
        sta $F4DA
        rts
    }

    *= $F184
    _f184: 
    {
        lda #$C3
        sta $F4DA
        lda #$80
        sta $F4DD
        rts
    }

    *= $F18F
    _f18F: 
    {
        jmp _F372
        jmp _F3E2
        jsr _F267
        jmp ready
        jsr _F2E4
        
        ready:
        lda $F1BD
        and #$10
        beq timeToJump
        lda $F1BD
        eor #$10
        sta $F1BD
        lda $F4E3
        sta $F4DB
        jmp _F31C
        
        timeToJump: //F1B6
        jsr _F3FC
        jmp _F31C
    }

    *= $f267
    _F267:
    {
        adc $f4dc
        sta $f2d4
        stx $f4e3

        ldy #$00
        lda ($f9), y
    }

    *= $F274
    _F274: 
    {
        sta $f2a2
        and #$03
        asl
        asl
        clc
        adc #$d4
        sta $fb
        lda $f2a2
        lsr
        lsr
        and #$03
        tay
        lda ( $fb ), y
        sta LOOKUP_F000, x
        inx
        jmp _F2AA
    }

    *= $F291
    _F291: 
    {
        ldy #$00
        lda ($f9), y
        sta $f2a2
        and #$03
        tay
        lda ($fb), y
        sta LOOKUP_F000, x
        inx
        lda #$00
        lsr
        lsr
        and #$03
        tay
        lda ($fb), y

    }

    *= $F2AA
    _F2AA: 
    {
        sta LOOKUP_F000, x
        inx
        lda $f2a2
        lsr
        lsr
        lsr
        lsr
        and #$03
        tay
        lda ( $fb ), y
        sta LOOKUP_F000, x
        inx
        lda $f2a2
        rol
        rol
        rol
        and #$03
        tay
        lda ( $fb ), y
        sta LOOKUP_F000, x
        inx
        inc $f9
        bne label_f2d3
        inc $fa

    label_f2d3:
        cpx #$00
        bne _F291
        rts
    }

    *= $F2E4
    _F2E4:
    {
        adc $F4DC
        sta countCheck
        stx $F4E3
        ldy #$00
        lda ($f9), y
        lsr
        lsr
        lsr
        and #$1e
        sta $f000, x
        inx
        jmp _F30D
        loop:
            lda ($f9), y
            asl
            and #$1e
            sta $f000, x
            inx
            lda ($f9), y
            lsr
            lsr
            lsr
            and #$1e

        _F30D:
            sta $f000, x
            inx
            inc $f9
            bne continue
            inc $fa
            
            continue:
            cpx countCheck:#$00
            bne loop

        rts
    }

    *= $f31c
    _F31C:
    {
        inc $F4e4
        beq label_f330
        lda $F4e5
        clc
        adc $F4e6
        sta $F4e5
        lsr
        sta $F4dd
        rts
    }

    *= $f330
    label_f330:
    {
        ldy #$00
        lda ( $f7 ), y
        tax
        and #$fe
        sta $F4e5
        txa
        lsr
        inc $f7
        lda ( $f7 ), y
        ror
        ror
        ror
        ror
        ora #$e0
        sta $F4e4
        lda ( $f7 ), y
        and #$0f
        tay
        lda LOOKUP_F362, y
        sta $F4e6
        inc $f7
        bne label_f35a
        inc $f8
    }

    *= $f35a
    label_f35a:
    {
        lda $F4e5
        lsr
        sta $F4dd
        rts
    }

    *= $f372
    _F372: {
        sta $F4DB
        adc $F4E1
        sta $F3AA
        
        lda $F4E1
        sta $F4DC

        ldy #$00

        lda ($F9),y
        lsr
        lsr
        tay

        lda #$0e
        bcc continue
        lda #$10
        
        continue: // F38E
        sta LOOKUP_F000,x
        inx
        jsr _F3C3
        jmp _F39F
    }

    *= $f398
    _F398: {
        ldy #$00
        lda ($f9), y
        jsr WriteSomething_F3AE
    }

    *= $f39F
    _F39F: {
        loop:
        {
            tya
            jsr WriteSomething_F3AE
            inc $f9
            bne continue
            inc $fa

            continue:
            {
                cpx #$00    // This value is updated
                bcc _F398
            }
        }
        rts
    }

    *= $f3ae
    WriteSomething_F3AE: {
        lsr
        tay
        lda #$0e
        bcc continue1
        lda #$10

    continue1:
        sta LOOKUP_F000, x
        inx
        tya
        lsr
        tay
        lda #$0e
        bcc _F3C3
        lda #$10
    }

    *= $F3C3
    _F3C3: 
    {
        sta LOOKUP_F000,x
        inx
        tya
        lsr
        tay
        lda #$0e
        bcc continue
        lda #$10

        continue: // F3D0
        sta LOOKUP_F000,x
        inx
        tya
        lsr
        tay
        lda #$0e
        bcc continue2
        lda #$10

        continue2: // F3DD
        sta LOOKUP_F000,x
        inx
        rts
    }

    *= $F3E2
    _F3E2: {
        sta $F4DB
        adc $F4E1
        sta $F2D4
        lda $F4E1
        sta $F4DC

        ldy #$00
        lda ($f9),y
        and #$fc
        ora #$01
        jmp _F274
    }

    _F3FC:
    {
        ldx #$00
        lda $F4DB
        sta $F41B
        lda $F4E3
        sta $F417
        lda $F4DB
        and #$40
        eor #$40
        ora #$20
        sta $F41F

        loop:
        {
            lda LOOKUP_F000, x
            sec
            adc LOOKUP_F000, x
            ror
            sta LOOKUP_F000, x
            inx
            cpx $F4DC
            bne loop
        }
        lda $F41F
        sta $F4DB
        rts
    }
}


