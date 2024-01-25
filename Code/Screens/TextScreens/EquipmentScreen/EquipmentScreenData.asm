*= $add2
TEXT_MONITORING_EQUIPMENT:
    .text "MONITORING EQUIPMENT:" + @"\$0d"
    .text "---------------------" + @"\$0d"
    .text "PK ENERGY DETECTOR" + @"\$9d" + "  $400" + @"\$0d"
    .text "                  " + @"\$0d\$0d\$0d"
    .text "IMAGE INTENSIFIER " + @"\$9d" + "  $800" + @"\$0d\$0d\$0d\$0d"
    .text "MARSHMALLOW SENSOR" + @"\$9d" + "  $800" + @"\$0d\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "USE JOYSTICK TO CONTROL FORKLIFT." + @"\$0d"
    .text "TYPE: 1-3 FOR MORE CHOICES, E TO END" + @"\$0d\$ff"

TEXT_CAPTURE_EQUIPMENT:
    .text "CAPTURE EQUIPMENT:   " + @"\$0d"
    .text "---------------------" + @"\$0d"
    .text "GHOST BAIT        " + @"\$9d" + "  $400" + @"\$0d"
    .text "                  " + @"\$0d\$0d\$0d"
    .text "TRAPS -REQUIRED-  " + @"\$9d" + "  $600" + @"\$0d\$0d\$0d\$0d"
    .text "GHOST VACUUM      " + @"\$9d" + "  $500" + @"\$0d\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "USE JOYSTICK TO CONTROL FORKLIFT." + @"\$0d"
    .text "TYPE: 1-3 FOR MORE CHOICES, E TO END" + @"\$0d\$ff"

TEXT_STORAGE_EQUIPMENT_3:
    .text "STORAGE EQUIPMENT:   " + @"\$0d"
    .text "---------------------" + @"\$0d"
    .text "PORTABLE LASER    " + @"\$9d" + " $8000" + @"\$0d"
    .text "CONFINEMENT SYSTEM" + @"\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "                  " + @"\$9d" + "         " + @"\$0d\$0d\$0d"
    .text "USE JOYSTICK TO CONTROL FORKLIFT." + @"\$0d"
    .text "TYPE: 1-3 FOR MORE CHOICES, E TO END" + @"\$0d\$ff"

// x,y * 3 (stapler?)
*= $a988
SPRITE_POSITIONS_EQUIPMENT_SCREEN_2:
    .byte $28, $52, $10, $52, $10, $52

// offset of equipment slot x pos (+24)
CAR_EQUIPMENT_SLOT_X_POS_OFFSET:
    .byte $00, $18, $30, $48

*= $a9a8
EQUIPMENT_FLAG:  // used for InstalledEquipment ($6d)
    .byte $01, $02, $04, $08, $00, $00, $20, $40

// stapler y positions (every 2nd byte!)
*= $a9ce
LOOKUP_A9CE:
    .byte $52,$50,$00,$00
    .byte $A4,$00,$00,$A8,$72,$00,$74,$00
    .byte $00,$96,$00,$00,$92,$00,$00,$84
    .byte $00,$00,$68,$00,$52,$4E,$00,$00
    .byte $B4,$00,$00,$BA,$72,$00,$73,$00
    .byte $00,$A4,$00,$00,$92,$00,$00,$85
    .byte $00,$00,$60,$00,$52,$4C,$00,$00
    .byte $B4,$00,$00,$B6

    .byte $72,$00,$6D,$00,$00,$A0,$00,$00,$92,$00

    .byte $00,$81
    .byte $00,$00,$5A,$00,$52,$50,$00,$00
    .byte $B5,$00,$00,$BB,$72,$00,$7F,$00
    .byte $00,$A0,$00,$00,$92,$00,$00,$91
    .byte $00,$00,$68,$00

//  0 to  7   > x offset of equipment slot     car 1
//  8 to 15   > x offset in screen 2
// 16 to 23   > x offset in screen 3
//  0 to  7   > x offset of equipment slot     car 2
//  8 to 15   > x offset in screen 2
// 16 to 23   > x offset in screen 3
//  0 to  7   > x offset of equipment slot     car 3
//  8 to 15   > x offset in screen 2
// 16 to 23   > x offset in screen 3
//  0 to  7   > x offset of equipment slot     car 4
//  8 to 15   > x offset in screen 2
// 16 to 23   > x offset in screen 3
EQUIPMENT_SCREEN_SLOT_POSITION_X:
    // car 1
    .byte $28,$69,$00,$00,$60,$00,$00,$69
    .byte $28,$00,$69,$00,$00,$69,$00,$00
    .byte $28,$00,$00,$69,$00,$00,$69,$00

    //car 2
    .byte $28,$69,$00,$00,$5d,$00,$00,$69
    .byte $28,$00,$69,$00,$00,$69,$00,$00
    .byte $28,$00,$00,$69,$00,$00,$69,$00

    // car 3
    .byte $28,$69,$00,$00,$5f,$00,$00,$69
    .byte $28,$00,$69,$00,$00,$69,$00,$00
    .byte $28,$00,$00,$69,$00,$00,$69,$00

    // car 4
    .byte $28,$69,$00,$00,$60,$00,$00,$69
    .byte $28,$00,$69,$00,$00,$69,$00,$00
    .byte $28,$00,$00,$69,$00,$00,$69,$00

// CURRENT_EQUIPMENT_SCREEN * 4 + EQUIPMENT_SLOT
EQUIPMENT_TYPE_IN_SLOT:
    .byte $01, $02, $03, $00   // view 1
    .byte $04, $05, $06, $00   // view 2
    .byte $07, $00, $00, $00   // view 3

CAR_EQUIPMENT_CAPACITY:
    .byte $05, $09, $0B, $07

// only two positions!
*= $aaa2
STAPLER_SLOT_X_POS:
    .byte $28, $4c
    .byte $4c, $4c

// x,y * 5
SPRITE_POSITIONS_EQUIPMENT_SCREEN:
    .byte $14,$52,$14,$72,$14,$92,$14,$AB,$14,$C2

HIGHEST_FORKLIFT_LOCATION_PER_EQUIPMENT_SCREEN:
    .byte $09, $09, $01

// 3 * 8 bytes per equipment screen, content?
*= $AAB3
LOOKUP_AAB3:
    .byte $33, $34, $35, $00, $00, $00, $00, $00
    .byte $36, $38, $39, $00, $00, $00, $00, $00
    .byte $3a, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $01, $02, $04, $08, $00, $20, $40