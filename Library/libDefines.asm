//==============================================================================
//                        Library Memory Definitions
//==============================================================================
// Includes

#importonce

//==============================================================================
// Constants

// Misc
.label SCREEN_CHAR = $5400

// Zero Page
.label ZeroPage0 = $00
.label ZeroPage1 = $01

.label ZeroPageLow     = $fb
.label ZeroPageHigh    = $fc
.label ZeroPageLow2    = $fd
.label ZeroPageHigh2   = $fe

// Character memory slots
.label CharacterSlot0000 = $00 // $0000 hex,     0 decimal
.label CharacterSlot0800 = $02 // $0800 hex,  2048 decimal
.label CharacterSlot1000 = $04 // $1000 hex,  4096 decimal
.label CharacterSlot1800 = $06 // $1800 hex,  6144 decimal
.label CharacterSlot2000 = $08 // $2000 hex,  8192 decimal
.label CharacterSlot2800 = $0A // $2800 hex, 10240 decimal
.label CharacterSlot3000 = $0C // $3000 hex, 12288 decimal
.label CharacterSlot3800 = $0E // $3800 hex, 14336 decimal

// Memory areas
.label SCREEN_RAM    = $0400
.label COLOR_RAM     = $D800
.label SPRITE_RAM    = 160 // 160 decimal * 64(sprite size) = 10240(hex $2800)
.label SPRITE_0_PTR   = SCREEN_RAM  + 1024 - 8 // $07F8, last 8 bytes of SCREENRAM are sprite ptrs

// Register names taken from 'Mapping the Commodore 64' book

// 6510 Registers
.label D6510        = $0000
.label R6510        = $0001
.label AutoStartROMCartridge = $8000

// VIC-II Registers
.label VIC_REGISTERS = $D000
.label SPRITE_X_POS  = $D000
.label SPRITE_Y_POS  = $D001

.label VIC_SPRITE_0_X   = $D000
.label VIC_SPRITE_0_Y   = $D001
.label VIC_SPRITE_1_X   = $D002
.label VIC_SPRITE_1_Y   = $D003
.label VIC_SPRITE_2_X   = $D004
.label VIC_SPRITE_2_Y   = $D005
.label VIC_SPRITE_3_X   = $D006
.label VIC_SPRITE_3_Y   = $D007
.label VIC_SPRITE_4_X   = $D008
.label VIC_SPRITE_4_Y   = $D009
.label VIC_SPRITE_5_X   = $D00A
.label VIC_SPRITE_5_Y   = $D00B
.label VIC_SPRITE_6_X   = $D00C
.label VIC_SPRITE_6_Y   = $D00D
.label VIC_SPRITE_7_X   = $D00E
.label VIC_SPRITE_7_Y   = $D00F
.label VIC_SPRITE_X_POS_EXTENDED        = $d010
.label VIC_SCREEN_CONTROL_REGISTER_1    = $d011
.const VIC_CURRENT_RASTER_LINE          = $d012
.label VIC_SPRITE_ENABLE_REGISTER       = $d015
.label VIC_SCREEN_CONTROL_REGISTER_2    = $d016
.label VIC_SPRITE_EXPAND_Y              = $d017
.label VIC_VMCSB                        = $d018
.label VIC_SPRITE_PRIORITY_REGISTER     = $d01b
.label VIC_SPRITE_MULTICOLOR_MODE_REGISTER  = $d01c
.label VIC_SPRITE_EXPAND_X              = $d01d
.label VIC_SPRITE_SPRITE_COLLISION_REGISTER = $d01e
.label VIC_SPRITE_BACKGROUND_COLLISION_REGISTER = $d01f
.label VIC_BORDER_COLOR         = $d020
.label VIC_BACKGROUND_COLOR_0   = $d021
.label VIC_BACKGROUND_COLOR_1   = $d022
.label VIC_BACKGROUND_COLOR_2   = $d023
.label VIC_BACKGROUND_COLOR_3   = $d024
.label VIC_SPRITE_MULTICOLOR_0  = $d025
.label VIC_SPRITE_MULTICOLOR_1  = $d026

.label VIC_SPRITE_COLOR         = $d027

.label VIC_SPRITE_0_COLOR       = $d027
.label VIC_SPRITE_1_COLOR       = $d028
.label VIC_SPRITE_2_COLOR       = $d029
.label VIC_SPRITE_3_COLOR       = $d02A
.label VIC_SPRITE_4_COLOR       = $d02B
.label VIC_SPRITE_5_COLOR       = $d02C
.label VIC_SPRITE_6_COLOR       = $d02D
.label VIC_SPRITE_7_COLOR       = $d02E

// IRQ Registers
.label INTERRUPT_STATUS_REGISTER    = $D019
.label INTERRUPT_CONTROL_REGISTER   = $D01A

// CIA #1 Registers (Generates IRQ's)
.label CIA1_DATA_PORT_A       = $DC00
.label CIA1_DATA_PORT_B       = $DC01
.label CIA1_DATA_DIRECTION_PORT_A = $DC02
.label CIA1_DATA_DIRECTION_PORT_B = $DC03
.label CIA1_INTERRUPT_CONTROL       = $DC0D
.label CIA1_CONTROL_TIMER_A  = $DC0E
.label CIA1_CONTROL_TIMER_B  = $DC0F

// CIA #2 Registers (Generates NMI's)
.label CIA2_DATA_PORT_A             = $DD00
.label CIA2_DATA_PORT_B       = $DD01
.label CIA2_DATA_DIRECTION_PORT_A   = $DD02
.label CIA2_DATA_DIRECTION_PORT_B   = $DD03
.label CIA2_TIMER_B_LOW_BYTE   = $DD06
.label CIA2_TIMER_B_HIGH_BYTE   = $DD07
.label CIA2_INTERRUPT_CONTROL       = $DD0D
.label CIA2_CONTROL_TIMER_A  = $DD0E
.label CIA2_CONTROL_TIMER_B  = $DD0F

// Timer Registers
.label TIMALO       = $DC04
.label TIMBHI       = $DC07

// SID Registers
.label SID_REGISTERS = $D400
.label SID_VOLUME_FILTER_MODES = $D418

// Interrupt Vectors
.label IRQRAMVECTOR = $0314
.label IRQ_ROM_VECTOR_LOW   = $FFFE
.label IRQ_ROM_VECTOR_HIGH  = $FFFF
.label NMIRAMVECTOR = $0318
.label NMI_ROM_VECTOR   = $FFFA

// Interrupt Routines
.label IRQROMROUTINE = $EA31

.label RESTOR        = $FD15
.label RAMTAS        = $FD50
.label IOINIT        = $FDA3
.label CINT          = $FF5B

// Keyboard Routines
.label XMAX             = $0289    // Max keyboard buffer size
.label RPTFLG           = $028A    // Which Keys Will Repeat?
.label SCNKEY           = $FF9F    // scan keyboard - kernal routine
.label GETIN            = $FFE4    // read keyboard buffer - kernal routine

// Sound Routines
.label SID_VOICE_3_FREQUENCY_LOW        = $d40e
.label SID_VOICE_3_FREQUENCY_HIGH       = $d40f
.label SID_VOICE_3_PULSE_WIDTH_LOW      = $d410
.label SID_VOICE_3_PULSE_WIDTH_HIGH     = $d411
.label SID_VOICE_3_CONTROL_REGISTER     = $d412
.label SID_VOICE_3_PULSE_AD             = $d413
.label SID_VOICE_3_PULSE_SVR            = $d414
.label SID_VOICE_3_MAIN_VOLUME_CONTROL  = $d418