*= $38de
TEXT_COMPACT:
    .text "1. COMPACT:" + @"\$9b" + " $2000" + @"\$0d"
    .text "   CARRIES 5 ITEMS OF CARGO" + @"\$0d"
    .text "   TOP SPEED 75 MPH" + @"\$0d\$ff"

TEXT_1963_HEARSE:
    .text "2. 1963 HEARSE:" + @"\$9b" + " $4800" + @"\$0d"
    .text "   CARRIES 9 ITEMS OF CARGO" + @"\$0d"
    .text "   TOP SPEED 90 MPH" + @"\$0d\$ff"

TEXT_STATION_WAGON:
    .text "3. STATION WAGON:" + @"\$9b" + " $6000" + @"\$0d"
    .text "   CARRIES 11 ITEMS OF CARGO" + @"\$0d"
    .text "   TOP SPEED 110 MPH" + @"\$0d\$ff"

TEXT_HIGH_PERFORMANCE:
    .text "4. HIGH-PERFORMANCE:" + @"\$9b" +"$15000" + @"\$0d"
    .text "   CARRIES 7 ITEMS OF CARGO" + @"\$0d"
    .text "   TOP SPEED 160 MPH" + @"\$0d\$ff"

*=$a1d4
CAR_PRICE_LOW:
    .byte $20, $48, $60, $50
CAR_PRICE_HIGH:
    .byte $00, $00, $00, $01

EQUIPMENT_PRICES:
    .byte $04   // PK sensor
    .byte $08   // image intensifier
    .byte $08   // marshmallow sensor
    .byte $04   // ghost bait
    .byte $06   //  ??
    .byte $06   // traps
    .byte $05   // vaccuum
    .byte $80   // laser containment system

*=$a89d
CAR_MULTICOLOR:
    .byte $03, $06, $06, $04

*= $acc9
TEXT_VEHICLE_SELECTION:
    .text "GHOSTBUSTING VEHICLE SELECTION:" + @"\$0d\$0d"
    .text "1. COMPACT:" + @"\$9b" + " $2000" + @"\$0d\$0d"
    .text "2. 1963 HEARSE:" + @"\$9b" +" $4800" + @"\$0d\$0d"
    .text "3. STATION WAGON:" + @"\$9b" +" $6000" + @"\$0d\$0d"
    .text "4. HIGH-PERFORMANCE:" + @"\$9b" +"$15000" + @"\$0d\$0d\$ff"

TEXT_YOU_HAVE:
    .text @"\$0d\$0d" + "YOU HAVE " + @"\$ff"

TEXT_KEY_OPTIONS:
    .text @"\$0d\$0d"

TEXT_KEY_OPTIONS_NO_LINEBREAKS:
    .text "PRESS SPACE BAR TO VIEW CAR OPTIONS." + @"\$0d\$0d"

TEXT_KEY_OPTIONS_ONLY:
    .text "PRESS 1,2,3 OR 4 TO PURCHASE CAR.   " + @"\$0d"
    .text "PRESS RETURN AFTER YOU CHOOSE. " + @"\$0d\$0d"
    .text "GO AHEAD:" + @"\$ff"

*= $b3a5
CAR_NAME_TEXT_INDEX:
    .byte $14, $15, $16, $17

*= $b3a9
TEXT_EMPTY:
    .byte $FF