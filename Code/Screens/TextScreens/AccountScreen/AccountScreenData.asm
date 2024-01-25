*= $3d5c
LOOKUP_3D5C: // TODO: What is this?
    .byte $02,$04,$06,$08,$0C,$10,$12,$14
    .byte $18,$1C,$20,$24,$28,$30,$00,$40
    .byte $FE,$FD,$FB,$F7,$EF,$DF,$BF
    .byte $7F

*= $9dba
LOOKUP_9DBA:
    .byte $3F, $1F, $0F, $07, $03, $01, $01, $01
    .byte $01, $01

*= $aad3
LOOKUP_AAD3:
    .byte $2D,$2D,$03,$12,$05,$04,$09
    .byte $14,$2D,$2D,$02,$09,$10,$17,$10
    .byte $10,$10,$10

*= $aae5
// contains line offset divided by 4(!) -> *4 is handled in text output routine
TEXT_LINE_OFFSET:
    .byte $00,$0A,$14,$1E,$28,$32,$3C,$46,$50,$5A,$64,$6E,$78
    .byte $82,$8C,$96,$A0,$AA,$B4,$BE,$C8,$D2,$DC,$E6,$F0,$FA

*= $ab13
TEXT_GHOSTBUSTERS_INTRO:
    .text "    GHOSTBUSTERS" + @"\$0d\$0d"
    .text @"\$85" + "FOR PROFESSIONAL" + @"\$0d"
    .text @"\$8b" + "PARANORMAL" + @"\$0d"
    .text @"\$8d" + "INVESTIGATIONS" + @"\$0d"
    .text @"\$90" + "AND ELIMINATIONS" + @"\$0d"
    .text "   " + @"\$0d" + "   "
    .text "-WE'RE READY TO BELIEVE YOU-" + @"\$0d"
    .text "   " + @"\$0d"
    .text "TO FORM A GHOSTBUSTERS FRANCHISE IN YOUR CITY PLEASE STATE YOUR NAME- LAST,FIRST: " + @"\$ff"

TEXT_QUERY_EXISTING_ACCOUNT:
    .text @"\$0d" + "DO YOU HAVE AN ACCOUNT? " + @"\$ff"

TEXT_NEW_BUSINESS:
    .text @"\$0d\$0d" + "IN THAT CASE, WELCOME TO YOUR NEW BUSINESS. " + @"\$00\$00\$00"
    .text "AS A NEW FRANCHISE OWNER THE BANK WILL ADVANCE YOU $10000 FOR EQUIPMENT. USE IT WISELY... GOOD LUCK..  " + @"\$ff"

TEXT_ENTER_ACCOUNT_NUMBER:
    .text @"\$0d" + "WHAT IS YOUR ACCOUNT NUMBER?" + @"\$ff"

TEXT_INVALID_ACCOUNT_NUMBER:
    .text "INVALID ACCOUNT NUMBER." + @"\$ff"
