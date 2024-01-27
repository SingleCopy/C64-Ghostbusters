#importonce 
#import "SoundEffectsData.asm"

.namespace SoundEffects 
{
   *= $3d24
    PlaySoundEffect: // $3d24
    {
        txa
        pha
        lda $e8
        bne continue
        ldx #$01
        stx $ea81
        dex
        stx SID_VOICE_3_PULSE_AD
        stx SID_VOICE_3_PULSE_SVR
        stx SID_VOICE_3_PULSE_WIDTH_HIGH
        stx SID_VOICE_3_PULSE_WIDTH_LOW
        stx SID_VOICE_3_CONTROL_REGISTER
        stx $ea7d
        stx $ea7e
        stx $ea84
        dex
        stx $98
        stx $ea80
        lda SoundEffectsLow, y
        sta $e7
        lda SoundEffectsHigh, y
        sta $e8
        
        continue:
        pla
        tax
        rts
    } 

    *= $3be9
    label_3be9:
    {
        lda $e8
        beq return
        dec $ea81
        beq label_3c03
        lda $ea81
        cmp $ea80
        bne label_3c06
        lda $ea7d
        sta SID_VOICE_3_CONTROL_REGISTER
        jmp label_3c06

        label_3c03: 
        jsr label_3c31
        
        label_3c06: 
        lda $ea7e
        beq label_3c1a
        eor #$ff
        sta $ea7e
        inc $ea7e
        sec
        adc $ea83
        sta SID_VOICE_3_FREQUENCY_HIGH

        label_3c1a:
        lda $ea84
        beq return
        bmi label_3c27
        inc $ea83
        jmp label_3c2a

        label_3c27:
        dec $ea83

        label_3c2a:
        lda $ea83
        sta SID_VOICE_3_FREQUENCY_HIGH

        return:
        rts
    }

    *= $3c31
    label_3c31:
    {
        jsr label_3c61
        sta $ea7b
        and #$0f
        beq label_3c53
        tay
        lda LOOKUP_3D84_LOW - 1, y
        sta $e9
        lda LOOKUP_3D93_HIGH - 1, y
        sta $ea
        jsr label_3c5b
        lda $ea7b
        and #$0f
        cmp #$04
        bcs label_3c31
        rts
    }

    *= $3c53
    label_3c53:
    {
        sta $ea81
        sta $e8
        sta $98
        rts
    }

    *= $3c5b
    label_3c5b:
    {
        lda $ea7b
        jmp ($00e9)
    }

    *= $3c61
    label_3c61:
    {
        stx $ea7c
        ldx #$00
        lda ($e7, x)
        inc $e7
        bne label_3c6e
        inc $e8
        
        label_3c6e:
        ldx $ea7c
        rts
    }

    *= $3c72
    label_3c72:
    {
        lsr
        lsr
        lsr
        lsr
        tay
        lda LOOKUP_3D5C, y
        sta $ea81
        rts
    }

    *= $3c7e
    label_3c7e:
    {
        jsr label_3c72
        lda $ea7d
        ora #$01
        sta SID_VOICE_3_CONTROL_REGISTER
        rts
    }

    *= $3c8a
    lsmf_3c8a:
    {
        jsr label_3c7e
    }

    *= $3c8d
    lsmf_3c8d:
    {
        jsr label_3c61
        sta $ea86
        tax
        lda LOOKUP_3E5A, x
        sta SID_VOICE_3_FREQUENCY_LOW
        lda LOOKUP_3DFA, x
        sta SID_VOICE_3_FREQUENCY_HIGH
        sta $ea83
        rts
    }

    *= $3ca4
    lsmf_3ca4:
    {
        lsr
        lsr
        lsr
        lsr
        and #$07
        tax
        lda LOOKUP_3DA2_LOW, x
        sta $e9
        lda LOOKUP_3DAA_HIGH, x
        sta $ea
        jmp ($00e9)
    }

    *= $3cb8
    lsmf_3cb8:
    {
        jsr label_3c61
        sta SID_VOICE_3_PULSE_AD
        jsr label_3c61
        sta SID_VOICE_3_PULSE_SVR
        rts
    }

    *= $3cc5
    lsmf_3cc5:
    {
        lda $ea7b
        sta $ea84
        rts
    }

    lsmf_3ccc:
    {
        jsr label_3c61
        dec $ea7f
        beq return
        clc
        adc $e7
        sta $e7
        lda #$ff
        adc $e8
        sta $e8

        return:
        rts
    }

    *= $3ce0
    lsmf_3ce0:
    {
        lsr
        lsr
        lsr
        lsr
        sta $ea7e
        rts
    }

    *= $3ce8
    lsmf_3ce8:
    {
        lsr
        lsr
        lsr
        lsr
        sta $ea7f
        rts
    }

    *= $3cf0
    lsmf_3cf0:
    {
        lsr
        lsr
        lsr
        lsr
        sta SID_VOICE_3_PULSE_WIDTH_HIGH
        jsr label_3c61
        sta SID_VOICE_3_PULSE_WIDTH_LOW
        rts
    }

    *= $3cfe
    lsmf_3cfe:
    {
        lsr
        lsr
        lsr
        lsr
        tax
        lda LOOKUP_3D74, x
        sta SID_VOICE_3_CONTROL_REGISTER
        and #$fe
        sta $ea7d
        rts
    }

    *= $3d0f
    lsmf_3d0f:
    {
        php
        lsr
        lsr
        lsr
        lsr
        plp
        bpl label_3d19
        ora #$f0
    }

    *= $3d19
    label_3d19:
    {
        clc
        adc $ea83
        sta $ea83
        sta SID_VOICE_3_FREQUENCY_HIGH
        rts
    }


    *= $3d5b
    lsmf_3d5b:
    {
        rts
    }

    *= $63d7
    label_63d7: 
    {
        ldx #$02

        // Read backwards from $A7D3 to $A75B
        loop:
        {
            dec $88, x
            bpl decrementX

            // Lookup the memory address and store it in the zero page 
            lda LOOKUP_A2B7_LO, x
            sta ZeroPagePointer7
            lda LOOKUP_A2BA_HI, x
            sta ZeroPagePointer7+1

            ldy $82, x
            lda (ZeroPagePointer7), y
            asl
            tay
            lda LOOKUP_A75B, y // Store addresses $A409, $A60A, $A6B1
            sta ZeroPagePointer8
            lda LOOKUP_A75B + 1, y
            sta ZeroPagePointer8 + 1
            ldy $85, x
            lda (ZeroPagePointer8), y
            sta $dc
            and #$1f
            sta $88, x
            ldy $85, x
            bit $dc
            bpl continue

            iny
            iny
            lda (ZeroPagePointer8), y
            and #$0f
            sta $94, x
            dey

            continue:
            bvc skipDecrementY
            dey

            skipDecrementY:
            iny
            iny
            sty $85, x
            lda (ZeroPagePointer8), y
            eor #$ff

            bne decrementX
            sta $85, x
            inc $82, x

            decrementX:
            dex
            bpl loop
        }
        
        rts
    }

    *= $8db9
    TriggerSpeech: 
    {   
        sei
        inc $eb 
        pha
        lda $20
        beq continue

        ldy #$07
        lda #$ff

        loop:
        {
            sta $5FF8,y
            dey
            bpl loop
        }

        ldy #$78

        loop2: //$8dcd
        { 
            lda #$ff
            sta $576F,y
            lda #00
            sta $DB6F,y
            dey
            bne loop2
            beq label_8df2
        }

        continue: // $ddc
        ldy #$27
        
        loop3: // $8dde
        {
            ldx $57C0,y
            lda #00
            sta $57C0,y
            txa
            sta $EA8A,y
            dey
            bpl loop3
        }

        lda VIC_CURRENT_RASTER_LINE
        sta $e1

        label_8df2:
        lda #00
        sta $D404
        sta $D40B
        sta SID_VOICE_3_CONTROL_REGISTER

        lda #$07
        sta $D418

        pla
        jsr PlayGhostbustersVoice

        label_8e06: // $8E06
        lda $20
        bne label_8e27
        lda VIC_SCREEN_CONTROL_REGISTER_1
        asl
        lda VIC_CURRENT_RASTER_LINE
        ror
        cmp $e1
        sta $e1

        bcs label_8e27
        lda $08
        and #$03
        bne label_8e21
        jsr label_63d7 

        label_8e21:
        jsr _63BA
        jsr _91C8

        label_8e27:
        lda #$ff
        jsr PlayGhostbustersVoice
        lsr
        bcs label_8e06

        lda #<MainScreenInit.NMIVector
        sta NMI_ROM_VECTOR
        lda #>MainScreenInit.NMIVector
        sta NMI_ROM_VECTOR + 1

        lda ShadowSIDVolume
        sta SID_VOLUME_FILTER_MODES
        lda #$00
        sta $eb
        lda #$81
        sta INTERRUPT_STATUS_REGISTER
        lda #$b8
        sta VIC_CURRENT_RASTER_LINE
        lda VIC_SCREEN_CONTROL_REGISTER_1
        and #$7f
        sta VIC_SCREEN_CONTROL_REGISTER_1
        cli
        lda $20
        beq label_8e6a
        ldy #$78

        loop1:
        {
            lda #$00
            sta $576F, y
            lda #$01
            sta $DB6F, y
            dey
            bne loop1
            rts
        }

        label_8e6a:
        ldy #$27

        label_8e6c:
        lda $ea8a, y
        sta $57c0, y
        dey
        bpl label_8e6c
        rts
    }

    *= $f080
    PlayGhostbustersVoice: 
    {
        jmp _f42e
    }

    *= $f125
    _F125: 
    {
        jsr _F1BC
    }

    *= $f137
    IndirectJumpAddress:
    {
        jmp IndirectJumpAddress // f138
    }

    *= $f1bc
    _F1BC: 
    {
        lda tmpX:#$00 // $F1BD
        and #$20
        beq continue
        lda #$7e
        sta IndirectJumpAddress + 1
        rts

        continue:
        ldy #00
        lda ($f5),y
        sta tmpX
        ora #$f0
        sta $F4DF

        iny
        lda ($f5),y
        lsr
        lsr
        lsr
        ora #$e0
        sta $F4DE
        bcs _F251

        iny
        lda ($f5),y
        adc bMemoryAddressLow1
        sta $f9

        iny
        lda ($f5),y
        adc bMemoryAddressHigh1
        sta $fa
        
        lda #$83
        sta $F4DA

        ldy #01
        lda ($f5),y
        and #03
        tax
        cmp #02
        bpl _F22A

        ldy #0
        lda ($f5),y
        and #$40
        bne continue2
        lda #$20

        continue2:  // $F20b
        sta $F4E1

        lsr
        lsr
        lsr
        sta $F4E2

        lda #$54
        sta $F111
        sty $F4DD
        txa
        lsr
        lda #$8f
        bcs continue3
        lda #$92

        continue3:  // $F224
        sta IndirectJumpAddress + 1
        jmp _F25B
    }

    *= $f251
    _F251: 
    {
        lda #$3a
        sta $F111

        lda #$84
        sta IndirectJumpAddress + 1
    }

        *= $F22A
    _F22A:
    {
        ldy #0
        lda ($f5),y
        rol
        rol
        rol
        and #03
        tay

        lda Lookup_F24D, y
        sta $F4DC

        lda #$3c
        sta $F111
        txa
        lsr
        lda #$95
        bcs continue
        lda #$9b

        continue:
        sta IndirectJumpAddress + 1
        jmp _F25B
    }

    *= $F25B
    _F25B: 
    {
        lda $f5
        clc
        adc #$04
        sta $f5
        bcc return 
        inc $f6

        return:
        rts
    }

    *= $F42E
    _f42e: {
        cmp #$ff
        beq continue

        cmp #$fe
        beq continue3

        cmp #$fd
        beq continue4

        jsr _F496
        jsr continue3

        bmi $F46C

        lda #00
        sta $F4DB

        lda #$f2
        sta $fc

        // Make this into a macro
        lda #$f0
        sta NMI_ROM_VECTOR + 1

        lda #$c3
        sta NMI_ROM_VECTOR

        lda #01
        sta $FF

        jsr _F125
        jsr continue5

        continue: // F45F
        lda ProcessorPort
        lsr
        lsr
        lda #$80
        bcs continue2
        lda CIA2_CONTROL_TIMER_B
        and #$01
        
        continue2: // F46C
        rts

        continue3: // F46D
        lda #$90
        sta CIA2_CONTROL_TIMER_B
        jmp continue

        continue4: // F475
        stx bMemoryAddressLow1
        sty bMemoryAddressHigh1
        jmp continue

        continue5:
        lda #$91
        sta CIA2_CONTROL_TIMER_B

        lda #$65
        sta CIA2_TIMER_B_LOW_BYTE

        lda #00
        sta CIA2_TIMER_B_HIGH_BYTE

        lda #$82
        sta $DD0D
        lda $DD0D
        rts
    }

    *= $F496
    _F496: 
    {
        rol
        rol
        rol
        tax
        ror
        and #$fc
        clc
        adc bMemoryAddressLow1
        sta $f9

        txa
        and #03
        adc bMemoryAddressHigh1
        sta $fa

        ldy #00
        lda ($f9),y
        adc bMemoryAddressLow1
        sta $f7

        iny

        lda ($f9),y
        adc bMemoryAddressHigh1
        sta $f8

        lda #$ff
        sta $F4E4
        iny

        lda ($f9),y
        clc
        adc bMemoryAddressLow1
        sta $f5
        iny

        lda ($f9),y
        adc bMemoryAddressHigh1
        sta $f6

        lda #00
        sta $F1BD

        rts
    }
}