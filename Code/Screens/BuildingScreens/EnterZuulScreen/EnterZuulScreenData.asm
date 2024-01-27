*= ZUUL_CHARSET "ZuulCharset"
    .import binary "..\Content\Buildings\ZuulCharset.bin"

*= ZUUL_CLOSE_PORTAL_CHARMAP "ZuulClosePortalCharMap"
    .import binary "..\Content\Buildings\ZuulClosePortalCharMap.bin"

*= ENTER_ZUUL_CHARMAP "EnterZuulCharMap"
    .import binary "..\Content\Buildings\EnterZuulCharMap.bin"

// screen offsets while scrolling up?
*= $3456
somedata_3456: 
    .byte $27,$4F,$77

//  ;chars for windows while scrolling up?
*= $3459
somedata_3459:          
    .byte $4C,$4C,$4C,$4C,$4C
    .byte $4C,$4C,$4C,$4C,$4C,$51,$51,$51
    .byte $52,$53,$54,$52,$52,$53,$54,$52
    .byte $52,$53,$54,$52,$52,$53,$54,$52
    .byte $52,$53,$54,$52,$52,$53,$54,$52
    .byte $52,$4C,$4C,$4C,$4C,$4C,$4C,$4C
    .byte $4C,$4C,$4C,$4C,$4C,$51,$51,$51
    .byte $52,$52,$52,$52,$52,$52,$52,$52
    .byte $52,$52,$52,$52,$52,$52,$52,$52
    .byte $52,$52,$52,$52,$52,$52,$52,$52
    .byte $52,$4C,$4C,$4C,$4C,$4C,$4C,$4C
    .byte $4C,$4C,$4C,$4C,$4C,$51,$51,$51
    .byte $52,$5B,$54,$52,$52,$5B,$54,$52
    .byte $52,$5B,$54,$52,$52,$5B,$54,$52
    .byte $52,$5B,$54,$52,$52,$5B,$54,$52
    .byte $52,$4C,$4C
    
COLOR_LOOKUP:   //;zuul house top colors? or window row while scrolling up?
    .byte $0E,$0E,$0E,$0E,$0E
    .byte $0E,$0E,$0E,$0E,$0E,$08,$08,$08
    .byte $08,$0E,$08,$08,$08,$0E,$08,$08
    .byte $08,$0E,$08,$08,$08,$0E,$08,$08
    .byte $08,$0E,$08,$08,$08,$0E,$08,$08
    .byte $08,$0E,$0E

*= $a8a5
LOOKUP_A8A5:
    .byte $6C,$6C,$6C,$66,$65,$64,$63,$63
    .byte $62,$62,$62,$61,$61,$61,$61,$60
    .byte $60,$61,$61,$61,$61,$62,$62,$62
    .byte $63,$63,$64,$65,$66,$6C,$6C,$6C

*= $a8c5
LOOKUP_A8C5:
    .byte $40,$40,$40,$3E,$3F,$40,$41,$42
    .byte $43,$44,$45,$46,$47,$48,$49,$4A
    .byte $4B,$4C,$4D,$4E,$4F,$50,$51,$52
    .byte $53,$54,$55,$56,$57,$55,$55,$55

*= $a8e5
LOOKUP_A8E5:
    .byte $54,$54,$54,$04,$04,$04,$04,$04
    .byte $04,$04,$04,$04,$04,$54,$54,$54
    .byte $54,$54,$54,$50,$50,$50,$50,$50
    .byte $50,$50,$50,$50,$50,$54,$54,$54