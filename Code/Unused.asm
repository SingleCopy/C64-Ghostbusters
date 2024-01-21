// Unused data
*= $8d90
lsmf_8d90:
    .byte $0C,$06,$00,$DF,$EC,$28

// Unused data
*= $9c76
lsmf_9c76:
    .byte $b5, $b1, $38, $f5, $a1, $b0, $05, $49
    .byte $ff, $18, $69, $01, $60

*= $9cf1
// set balance to 10000$
ResetAccountBalance:
{
    lda #$01
    sta MoneyInAccount
    lda #$00
    sta MoneyInAccount + 1
    sta MoneyInAccount + 2
    rts
}