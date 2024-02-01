//==============================================================================
//                 Ghostbusters
//==============================================================================

// Includes
#import "../Library/libDefines.asm"
#import "Constants.asm"
#import "Variables.asm"
#import "GameMain.asm"
#import "GameShared.asm"
#import "GameData.asm"
#import "SoundEffects.asm"
#import "Interrupts.asm"
#import "/Screens/MainTitleScreen/MainTitleScreenInit.asm"
#import "/Screens/TextScreens/TextScreenShared.asm"
#import "/Screens/CityMapScreen/CityMapScreen.asm"
#import "/Screens/DrivingScreen/DrivingScreen.asm"
#import "/Screens/BuildingScreens/BuildingScreenShared.asm"
#import "/Unused.asm"

//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
{
    BasicUpstart2(CopyCarDataRam)
}  

CopyCarDataRam:
{
    sei
    lda #$7f
    sta CIA1_INTERRUPT_CONTROL
    sta CIA2_INTERRUPT_CONTROL
    
    // Copy car1 charset from $5000-$52ff to $0300-$04ff
    Set16BitAddress(ZeroPageLow, $50, $00);
    Set16BitAddress(ZeroPageLow2, $02, $00);
    ldx #$03 // Copy 2 blocks of 255 bytes
    jsr CopyBytesToBasicRam

    // Copy car2 charset from $5300-$55ff to $0500-$07ff
    Set16BitAddress(ZeroPageLow, $53, $00);
    Set16BitAddress(ZeroPageLow2, $05, $00);
    ldx #$03 // Copy 3 blocks of 255 bytes
    jsr CopyBytesToBasicRam

    // Copy car3 charset from $5600-$57ff to $0900-$0aff
    Set16BitAddress(ZeroPageLow, $56, $00);
    Set16BitAddress(ZeroPageLow2, $09, $00);
    ldx #$02 // Copy 2 blocks of 255 bytes
    jsr CopyBytesToBasicRam

    // Copy car4 charset from $5800-$5aff to $0b00-$0dff
    Set16BitAddress(ZeroPageLow, $58, $00);
    Set16BitAddress(ZeroPageLow2, $0b, $00);
    ldx #$03 // Copy 2 blocks of 255 bytes
    jsr CopyBytesToBasicRam

    jmp InitialCleanArea
}

CopyBytesToBasicRam: 
{
    ldy #$00
    loop:
    {
        lda (ZeroPageLow),y
        sta (ZeroPageLow2),y
        iny
        bne loop
    }
    inc ZeroPageHigh
    inc ZeroPageHigh2
    dex
    bne loop

    rts
}

.macro Set16BitAddress(addressPointer, highAddress, lowAddress)
{
    lda #lowAddress
    sta addressPointer
    lda #highAddress
    sta addressPointer + 1
}

*= $c000
InitialCleanArea:
{
    // clean car charset 3
    ldx #0
    txa
    loop:
    {
        sta $0800,x
        inx
        bne loop
    }

    jmp GameMainInit
}

//==============================================================================
// Variables

//============================================================================== 
// Initialize

*= $6000 "Code"
GameMainInit:
{
    sei
    ldx #$ff
    txs
    lda #$08
    sta VIC_SCREEN_CONTROL_REGISTER_1
    jsr ciaInit

    ConfigureNMI()
    ConfigureVIC()
    ConfigureCia2DataPortA()
    ClearRemainingZeroPageData()
    ClearScreenAndCharset()
    UnknownDataWrite_E700ToE7FF()
    UnknownDataWrite_E600ToE6FF()
    CopyTitleScreenCharDataToScreenRam()
    CopyActivisionLogoToScreenRam()
    ClearMemoryLocations()
    UnknownDataWrite_EB00ToEB78()
    CopySpriteDataToScreenRam()
}

*= $8FD8 "ciaInit"
//.segment BANK1 [start=$8fd8]
ciaInit: 
{
    lda #$7f
    sta CIA1_INTERRUPT_CONTROL
    sta CIA2_INTERRUPT_CONTROL
    ldx #00
    stx CIA1_CONTROL_TIMER_A
    stx CIA2_CONTROL_TIMER_A
    stx CIA1_DATA_DIRECTION_PORT_B
    stx CIA2_DATA_DIRECTION_PORT_B
    stx SID_VOICE_3_MAIN_VOLUME_CONTROL
    dex
    stx CIA1_DATA_DIRECTION_PORT_A
    stx CIA2_DATA_DIRECTION_PORT_A
    lda #$2f
    sta $00 // Store 2f at 00?
    lda #%00000010
    sta CIA2_DATA_PORT_A
    rts
}

//==============================================================================
// Macros

.macro ConfigureNMI() 
{
    lda #<MainTitleScreenInit.NMIVector
    sta NMI_ROM_VECTOR
    lda #>MainTitleScreenInit.NMIVector
    sta NMI_ROM_VECTOR + 1      //Set NMI Interrupt to $6425
    lda #<RasterInterrupt
    sta IRQ_ROM_VECTOR_LOW      // Set Interrupt address to $8E76
    lda #>RasterInterrupt
    sta IRQ_ROM_VECTOR_HIGH
    lda #$15
    sta ProcessorPort
    lda #$2f
    sta ZeroPage0 
}

.macro ConfigureVIC()
{
    ldx #$2e
    spriteInitLoop:         // Update VIC registers $D02E to $D000
    {
        lda VIC_INIT_VALUES, x // Read from staring address $371D
        sta VIC_REGISTERS, x
        dex
        bpl spriteInitLoop
    }
}

.macro ConfigureCia2DataPortA() 
{
    lda CIA2_DATA_PORT_A
    and #$fc
    ora #$02
    sta CIA2_DATA_PORT_A    // set to 10000000
}

.macro ClearRemainingZeroPageData()
{
    lda #0
    tax
    clearRemainingZeroPageData: // Clear memory from $0002 to $00FE
    {
        sta $02,x
        inx
        cpx #$fd
        bne clearRemainingZeroPageData
    } 
}

.macro ClearScreenAndCharset() 
{
    tay
    sta $23
    ldx #$40
    stx $24
    ldx #$1f

    clearScreenAndCharset:          // Write 0s charset and screen starting at $4000
    {
        sta ($23), y
        iny
        bne clearScreenAndCharset
        inc $24
        dex
        bpl clearScreenAndCharset
    }
}

.macro UnknownDataWrite_E700ToE7FF() 
{
    ldx #0
    unknownloop1:    // Writes data from $E700 to $E7FF, maybe map data?
    {
        txa
        ldy #03
        unknownloop2:
        {
            asl
            rol
            ror $23
            ror
            ror $23 
            asl
            dey
            bpl unknownloop2
        }

        lda $23
        sta $E700,x
        inx
        bne unknownloop1
    }
}

.macro UnknownDataWrite_E600ToE6FF() 
{
    ldx #0
    loop:
    {
        stx $23
        txa
        and #$55
        asl
        ora $23
        sta $23
        txa
        and #$aa
        lsr
        ora $23
        sta $E600,x
        inx
        bne loop
    }
}

.macro CopyTitleScreenCharDataToScreenRam()
{
    // Copies the charset from $D000 - $D3FF to $5800 - $5BFF
    lda $01
    and #$fb
    sta $01
    lda #$d0
    sta $24
    lda #$58
    sta $26
    lda #0
    sta $23
    sta $25
    ldx #03
    ldy #08

    loop:
    {
        lda ($23),y
        sta ($25),y
        iny
        bne loop
    }

    inc $24
    inc $26
    dex
    bpl loop
}

.macro CopyActivisionLogoToScreenRam() 
{
    // Copies the activision charset from $36A4-$374B to $58D8-$5957
    lda $01
    ora #$04
    sta $01
    ldx #0
    loop: 
    {
        lda $36A4,x
        sta $58D8,x
        inx
    }
    bpl loop

    // Replace char 0 with O
    ldx #$07
    loop2:
    {
        lda $5878,x
        sta $5980,x
        dex
        bpl loop2
    }
}

.macro ClearMemoryLocations(){
    // Clear 255 bytes from each of these memory locations
    ldx #0
    lda #0
    loop:{
        sta $D800,x
        sta $D900,x
        sta $DA00,x
        sta $DAE8,x
        dex
        bne loop
    }

    // Write 1 to $DBC0 - $DBEF
    ldx #$27
    lda #$01
    loop2:{
        sta $DBC0,x
        dex
        bpl loop2
    }
}

.macro UnknownDataWrite_EB00ToEB78(){
    ldx #$78
    lda #$ff
    sta $EB00,x // set $EB78 to ff
    lda #$20
    dex
    loop:{
        sta $EB00,x // set $EB77-$EB00 to 20
        dex
        bpl loop
    }

}

.macro CopySpriteDataToScreenRam()
{
    // Sprite data starts at $B408
    .label SpriteDataEndAddress = $0B
    .label SpriteDataStartAddress = $0C

    // Sprite data starts at $4000
    .label ScreenRamDataEndAddress = $23
    .label ScreenRamDataStartAddress = $24

    lda #00
    sta ScreenRamDataEndAddress
    lda #$40
    sta ScreenRamDataStartAddress
    lda #$08
    sta SpriteDataEndAddress
    lda #$b4
    sta SpriteDataStartAddress
    ldy #0
    loop: // $611A
    {
        lda $0b
        cmp #$f8
        bcc copyData
        lda $0c
        cmp #$bf
        bcc copyData
        jmp CreateReverseSprites // Might be a good place to move to gameTitleScreen
  
        copyData: // $611a
        {
            lda (SpriteDataEndAddress),y 
            cmp #$11 // If we read a 11, then the next byte is how many bytes to skip before the start of the next sprite
            beq loadSpriteData
            sta (ScreenRamDataEndAddress),y
            jsr incrementSpriteAddress
            jsr incrementScreenRamAddress
            jmp loop

            loadSpriteData: // $612B
            iny
            lda (SpriteDataEndAddress),y
            tax
            lda #00
            tay

            storeSpriteData:  // $6132
            {
                sta (ScreenRamDataEndAddress),y
                jsr incrementScreenRamAddress
                dex
                bne storeSpriteData
            }

            jsr incrementSpriteAddress
            jsr incrementSpriteAddress
            jmp loop
        }
    }

    // $6143
    incrementSpriteAddress:
    {
        inc SpriteDataEndAddress 
        bne return
        inc SpriteDataStartAddress

        return: // $6149
        rts
    }

    // $614A
    incrementScreenRamAddress:
    {
        inc ScreenRamDataEndAddress
        bne return
        inc ScreenRamDataStartAddress

        return:
        rts
    }
}

*= $6151 "CreateReverseSprites"
CreateReverseSprites:
{
    ldx #$fc

    loop: 
    {
        ldy $4640,x
        lda $E700,y
        sta $4F02,x

        ldy $4641,x
        lda $E700,y
        sta $4F01,x

        ldy $4642,x
        lda $E700,y
        sta $4F00,x

        ldy $4740,x
        lda $E700,y
        sta $5002,x

        ldy $4741,x
        lda $E700,y
        sta $5001,x

        ldy $4742,x
        lda $E700,y
        sta $5000,x

        dex
        dex
        dex
        cpx #$fd
        beq continue
        txa
        and #$3f
        cmp #$3d
        bne loop
        dex
        bne loop
    }

    continue:
    jsr Copy18BytesFrom9051To33 
    inc $06
    jsr ResetSIDRegisters

    WriteTo5500AndD800()
    WriteToD850_D8C7()
    CopyTitleScreenCharSetToScreenRam()
    DrawGhostbustersTitle()
    LoadMoreDataTo_54FB_56C4()
    WriteDataTo_DB20_DB97_and_DBC0_DBE7()
    SetSpriteRegisters()
    jsr ClearMemory_0082_008A

    lda #$ff
    sta $88
    sta $89
    sta $8A

    jsr InitBallSpritePositionAndSoundMemoryLocation  // $6299
   
    WaitForStartOfNextRasterLine()

    cpx #$14
    bcs jumpToLoad
    lda #0
    beq jumpToStore

    jumpToLoad:
    lda #$ff

    jumpToStore:
    sta $EA73

    lda #$b8
    sta VIC_CURRENT_RASTER_LINE
    lda VIC_SCREEN_CONTROL_REGISTER_1
    and #$7f
    sta VIC_SCREEN_CONTROL_REGISTER_1

    lda #01
    sta INTERRUPT_CONTROL_REGISTER  // Enable raster interupt

    lda #$00
    sta $EA87

    lda #$18
    sta VIC_SCREEN_CONTROL_REGISTER_1

    lda #$1b
    sta VIC_SCREEN_CONTROL_REGISTER_2

    lda #01
    sta VIC_BACKGROUND_COLOR_1

    lda #02
    sta VIC_BACKGROUND_COLOR_2

    @TitleScreenInit();
}

// $61b2
.macro WriteTo5500AndD800() 
{   
    lda #0
    sta $23
    lda #$d8
    sta $24
    lda #$0
    sta $25
    lda #$54
    sta $26

    // Write 0 from $5500-$56FF
    // Write 9 from $D800-$D9FF
    ldx #$03
    ldy #0
    loop:
    {
        lda #0
        sta ($25),y
        lda #$9
        sta ($23),y
        dey
        bne loop
    }  
    inc $24
    inc $26
    dex
    bpl loop
}

.macro WriteToD850_D8C7(){
   // Write $0A from $D850-$D8C7
    ldx #$78
    lda #$0a
    loop:
    {
        sta $D850,x
        dex
        bpl loop
    }
}

.macro CopyTitleScreenCharSetToScreenRam()
{
    // Load data from $6960-$6f5f to $5a00-$5fff

    // Title Screen CharMap data starts at $6960
    .label CharMapEndAddress = $25
    .label CharMapStartAddress = $26

    // Title Screen CharMap data starts at $5400
    .label ScreenRamDataEndAddress = $23
    .label ScreenRamDataStartAddress = $24

    lda #0
    sta ScreenRamDataEndAddress
    lda #$5a
    sta ScreenRamDataStartAddress
    lda #$60
    sta CharMapEndAddress
    lda #$69
    sta CharMapStartAddress
    
    ldx #$05
    ldy #0
    loop: 
    {
        lda (CharMapEndAddress),y
        sta (ScreenRamDataEndAddress),y
        dey
        bne loop
    
        inc ScreenRamDataStartAddress
        inc CharMapStartAddress
        dex
        bpl loop
    }
}

 // $61fa
.macro DrawGhostbustersTitle() 
{
    ldx #$1d
    loop:
    {
        lda $6eb0, x
        sta $5455, x
        
        lda $6ece, x
        sta $547d, x

        lda $6eec, x
        sta $54a5, x

        dex
        bpl loop
    }
}

.macro LoadMoreDataTo_54FB_56C4()
{
    // Write data from $6F0A-6FE1 to $54FB-$56C4, with gaps inbetween
    lda #$0a
    sta $23
    lda #$6f
    sta $24
    lda #$fb
    sta $25
    lda #$54
    sta $26

    ldx #$0b
    
    outerLoop:
    {
        ldy #$11
        innerLoop:
        {
            lda ($23),y
            sta ($25),y
            dey
            bpl innerLoop
        }

        clc
        lda $23
        adc #$12
        sta $23

        lda $24
        adc #0
        sta $24

        lda $25
        adc #$28
        sta $25

        lda $26
        adc #0
        sta $26

        dex
        bpl outerLoop
    }
}

// $6242
.macro WriteDataTo_DB20_DB97_and_DBC0_DBE7() 
{  
    ldx #$27
    loop:
    {
        lda #01
        sta $DB20,x // Write 01 between DB20-DB47
        sta $DBC0,x // Write 01 between DBC0-DBE7

        lda #02
        sta $DB48,x // Write 02 between DB48-DB6F

        lda #02
        sta $DB70,x // Write 02 between DB70-DB97

        dex
        bpl loop
    }
}

// $6259
.macro SetSpriteRegisters() 
{ 
    lda #0
    sta $9a
    
    lda #$02
    sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER

    lda #$0d
    sta $57F8

    lda #0
    sta VIC_SPRITE_MULTICOLOR_0

    lda #1
    sta VIC_SPRITE_0_COLOR

    lda #2
    sta VIC_SPRITE_1_COLOR

    lda #$40
    sta $D000
    sta $D002

    lda #$80
    sta $D001
    sta $D003

    lda #$43
    sta $21
    lda #$64
    sta $22
}

.macro WaitForStartOfNextRasterLine() 
{
    waitForRasterToBeGreaterThan255:
    {
        lda VIC_SCREEN_CONTROL_REGISTER_1
        bpl waitForRasterToBeGreaterThan255

        // Wait until ldy is 0
         ldy #$12
        anotherWait:
        {
            dey
            bpl anotherWait
        }

        waitTillStartOfRasterLine:{
            lda VIC_CURRENT_RASTER_LINE
            beq continue
            tax
            bne waitTillStartOfRasterLine
        }
        continue:
        lda VIC_SCREEN_CONTROL_REGISTER_1
        bmi waitForRasterToBeGreaterThan255
    }
}

*= $63af
ResetSIDRegisters: 
{
    ldx #$1F
    lda #0
    
    loop:
    {
        sta SID_REGISTERS, x
        dex
        bpl loop
    }

    rts
}

*= $9002
Copy18BytesFrom9051To33:  // copy 18 bytes from $9051 to $33
{
    ldx #$11
    CopyXBytesFrom9051To33:
    {
        lda unknownData_1,x // $9051
        sta $33,x
        dex
        cpx #$ff
        bne CopyXBytesFrom9051To33
    }

    ldx #$96
    lda #00
    sei // Disable interrupts, not sure why

    clearZeroPageData:  // Write 0 from $00DB-$0045
    {
        sta $45,x
        dex
        cpx #$ff
        bne clearZeroPageData
    }

    // write ff (255) to $0088, $0089 and $008A 
    stx $88
    stx $89
    stx $8a
    cli // Enable interrupts

    lda #00
    sta VIC_SPRITE_ENABLE_REGISTER  // disable sprites
    ldx #$0f
    clearVicRegisters: // Write 0 from $D00F-$D000 and $D40F-$D400
    {
        sta VIC_REGISTERS, x
        sta SID_REGISTERS, x
        dex
        bpl clearVicRegisters
    }

    ldx #$1d
    LoadSomething1: // Load data from $A854-$A837 and copy it to $EA45-$EA28
    {
        lda LOOKUP_A837, x
        sta $EA28, x
        dex
        bpl LoadSomething1
    }

    lda #$03
    sta VIC_SPRITE_MULTICOLOR_MODE_REGISTER // Enable multicolor mode

    // Unknown writes to the zero page
    lda #$1f
    sta $cf
    lda #$1c
    sta $d0
    lda #$14
    sta $d7

    jsr ClearScreen
    // contiue onto $9050
}

*= $9050
SimpleReturn:
{
    rts
}

*= $929C
InitBallSpritePositionAndSoundMemoryLocation: 
{
    ldx #0
    stx BallSpriteX

    ldx #$ba
    stx BallSpriteY

    ldx #0
    stx BallSpriteExtendedY
    stx $EA6B
    stx $EA71

    ldx #$92
    stx $EA6A

    ldx #$BC
    stx $EA69

    rts
}

*= $93e2
ClearMemory_0082_008A: {
    // Write 0 between $0082-$008A
    ldx #02
    loop:
    {     
        lda #00   
        sta $82, x
        sta $85, x
        sta $88, x
        
        dex
        bpl loop
    } 
    rts
}

*= $95b9 "ClearScreen"
ClearScreen: 
{
    ldx #0
    lda #0

    loop: 
    {
        sta SCREEN_CHAR, x
        sta SCREEN_CHAR + $100, x
        sta SCREEN_CHAR + $200, x
        sta SCREEN_CHAR + $2c0, x
        sta COLOR_RAM, x
        sta COLOR_RAM + $100, x
        sta COLOR_RAM + $200, x
        sta COLOR_RAM + $2c0, x
        inx
        bne loop
    }

    stx $37
    lda GameState
    cmp #GameStates.PrepareMapScreen
    bcc return

    // fill color line with white
    ldx #$26
    lda #$01

    loop2:
    {
        sta COLOR_RAM + $370, x
        dex
        bpl loop2
    }

    return:
    rts
}