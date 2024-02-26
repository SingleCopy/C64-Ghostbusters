#importonce

*= $371D
VIC_INIT_VALUES:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$0b,$37,$00,$00,$00,$08,$00
    .byte $56,$0f,$00,$00,$03,$00,$00,$00
    .byte $00,$00,$00,$0E,$00,$08,$00,$06
    .byte $04,$00,$00,$00,$00,$00

// The game state is shifted to the left, this converts the byte value to a word value for lookup. 
// e.g GameState x10 (16) becomes x20 (32), that maps to StateLoadCityMapData
*= $381a
TableGameStates:
    .word AccountScreen.States.InitIntro                            // 00  (0,1)
    .word AccountScreen.States.StoreAccountName                     // 01 => 2  (2,3)
    .word AccountScreen.States.HaveAccountQuery                     // 02 => 4  (4,5)
    .word AccountScreen.States.AccountNumberEntered                 // 03 => 6  (6, 7)
    .word AccountScreen.States.InvalidHaveAccountQueryOption        // 04  (8)
    .word AccountScreen.States.InvalidAccountNumberEntered          // 05  (10)
    .word AccountScreen.States.ClearScreenAndResetTextOutputPos     // 06  (12)
    .word VehicleSelectionScreen.States.Init                        // 07  (14)
    .word VehicleSelectionScreen.States.CalculateBalance            // 08  (16)
    .word VehicleSelectionScreen.States.ShowBalance                 // 09  (18)
    .word VehicleSelectionScreen.States.DisplayCarOptions           // 0a  (20)
    .word VehicleSelectionScreen.States.ChooseCar                   // 0b  (22)
    .word VehicleSelectionScreen.States.DisplayCar                  // 0c
    .word EquipmentScreen.States.PrepareCar                         // 0d
    .word EquipmentScreen.States.SetTextAndSprites                  // 0e
    .word EquipmentScreen.States.UpdateLoop                         // 0f
    .word CityMapScreen.States.Init                                 // x10 => 32 (32, 33)
    .word CityMapScreen.States.LoadCharData                         // x11
    .word CityMapScreen.States.UpdateLoop                           // x12
    .word DrivingScreen.States.LoadCharData                         // x13
    .word DrivingScreen.States.SetSpritePositions                   // x14
    .word DrivingScreen.States.DrivingToTarget                      // x15
    .word GhostbustingScreen.States.Init                            // x16
    .word BuildingScreenShared.States.LoadBuildingGraphics          // x17
    .word GhostbustingScreen.States.PlaceTrap                       // x18
    .word GhostbustingScreen.States.PlaceFirstGhostbuster           // x19
    .word GhostbustingScreen.States.PlaceSecondGhostbuster          // x1a
    .word GhostbustingScreen.States.ActivateProtonStreams           // x1b
    .word GhostbustingScreen.States.OpenTrap                        // x1c
    .word GhostbustingScreen.States.GhostCaptureFailed              // x1d
    .word GhostbustingScreen.States.GhostCaptureSuccessful          // x1e
    .word GhostbustingScreen.States.CaptureGhostInTrap              // x1f
    .word GhostbustingScreen.States.MoveGhostbustersTowardsTrap     // x20 (32) => 64
    .word GhostbustingScreen.States.PickUpTrap                      // x21
    .word GHQScreen.States.Init                                     // x22
    .word GHQScreen.States.MoveGhostbustersFromGHQToCar             // x23
    .word CityMapScreen.States.MashmallowManAttackIncoming          // x24
    .word CityMapScreen.States.MashmallowManDestroyingBuilding      // x25
    .word CityMapScreen.States.MashmallowManDefeated                // x26
    .word CityMapScreen.States.MoveGhostsToOriginalPositions        // x27
    .word EnterZuulScreen.States.Init                               // x28
    .word EnterZuulScreen.States.Update                             // x29
    .word EnterZuulScreen.States.PrepareEnding                      // x2a
    .word EnterZuulScreen.States.ScrollToTopOfBuilding              // x2b
    .word EnterZuulScreen.States.CrossTheStreams                    // x2c
    .word GameOverFailureScreen.States.NotEnoughMoney               // x2d
    .word GameOverFailureScreen.States.DisplayGoodTry               // x2e
    .word GameOverFailureScreen.States.CalculateAccountBalance      // x2f
    .word GameOverFailureScreen.States.FailedToClosePortal          // x30
    .word GameOverSuccessScreen.States.DisplayMadeMoreMoney         // x31
    .word GameOverSuccessScreen.States.WriteNewAccountBalance       // x32
    .word GameOverSuccessScreen.States.DisplayNewAccountNumber      // x33
    .word GameOverSuccessScreen.States.WriteNewAccountNumber        // x34
    .word GameOverSuccessScreen.States.WriteDownAccountBalance      // x35
    .word GameOverSuccessScreen.States.DisplayCongratulations       // x36
    .word GameOverSuccessScreen.States.CalculateAccountBalance      // x37
    .word GameOverSuccessScreen.States.DisplayPortalClosed          // x38
    .word TextScreenShared.States.PlayLaughOnFailure                // x39
    .word TextScreenShared.States.ResetGame                         // x3a
    .word GameOverFailureScreen.States.DisplayStartingBalanceText   // x3b
    .word GameOverFailureScreen.States.DisplayStartingBalanceAmount // x3c
    .word GameOverFailureScreen.States.DisplayEndBalanceText        // x3d
    .word GameOverFailureScreen.States.DisplayEndBalanceAmount      // x3e
    .word GameOverFailureScreen.States.SetLaughSoundState           // x3f

//keyboard matrix lookup?
*= $389E
keyboardMatrixLookup:
{
    .byte                               $7F, $33
    .byte $35, $37, $39, $2B, $21, $31, $0D, $57
    .byte $52, $59, $49, $50, $2A, $21, $21, $41
    .byte $44, $47, $4A, $4C, $3B, $21, $21, $34
    .byte $36, $38, $30, $2D, $21, $32, $2F, $5A
    .byte $43, $42, $4D, $2E, $21, $20, $2F, $53
    .byte $46, $48, $4B, $3A, $3D, $21, $21, $45
    .byte $54, $55, $4F, $40, $3D, $51, $21, $21
    .byte $58, $56, $4E, $2C, $21, $2F
}

*= $9051 "unknownData_1"
unknownData_1:   .byte $1f, $1f, $0f, 0, $0f, 8, 1, 0, 8, $3f, 3, $99, 0, 0, 0, 0, 0, 0

//==============================================================================

*= $36a4 "ActivisionCharset" // Add character data at the $36A4 memory location
ACTIVISION_CHARSET:
    .import binary "..\Content\TitleScreen\ActivisionCharset.bin"

*= $3714
RAINBOW_COLORS:
    .byte $08,$08,$07,$07,$05,$05,$06,$00
    .byte $00

*= $b408 "SpritesData" // Add sprite data at the $B400 memory location
    .import binary "..\Content\SpritesData.bin", 8 // Skip the first 8 bytes as this is added by spritepad

//==============================================================================

*= $643b
TITLE_RASTER_POS:    //raster pos table
    .byte $EE, $EF, $EF, $EF, $EB, $EC, $ED, $EE

*= $a200
GhostbustersThemeTune:
    .byte $7B,$01,$91,$01,$A9,$01,$C3,$01
    .byte $DD,$01,$FA,$01,$18,$02,$38,$02
    .byte $5A,$02,$7D,$02,$A3,$02,$CC,$02
    .byte $F6,$02,$23,$03,$53,$03,$86,$03
    .byte $BB,$03,$F4,$03,$30,$04,$70,$04
    .byte $B4,$04,$FB,$04,$47,$05,$98,$05
    .byte $ED,$05,$47,$06,$A7,$06,$0C,$07
    .byte $77,$07,$E9,$07,$61,$08,$E1,$08
    .byte $68,$09,$F7,$09,$8F,$0A,$30,$0B
    .byte $DA,$0B,$8F,$0C,$4E,$0D,$18,$0E
    .byte $EF,$0E,$D2,$0F,$C3,$10,$C3,$11
    .byte $D1,$12,$EF,$13,$1F,$15,$60,$16
    .byte $B5,$17,$1E,$19,$9C,$1A,$31,$1C
    .byte $DF,$1D,$A5,$1F,$87,$21,$86,$23
    .byte $A2,$25,$DF,$27,$3E,$2A,$C1,$2C
    .byte $6B,$2F,$3C,$32,$39,$35,$63,$38
    .byte $BE,$3B,$4B,$3F,$0F,$43,$0C,$47
    .byte $45,$4B,$BF,$4F,$7D,$54,$83,$59
    .byte $D6,$5E,$61,$68,$73,$6A,$C7,$70
    .byte $7C,$77,$97,$7E,$1E,$86,$18,$8E
    .byte $8B,$96,$7E,$9F,$FA,$A8,$06,$B3
    .byte $AC,$BD,$F3,$C8,$E6,$D4,$8F,$E1
    .byte $F8,$EE,$2E,$FD,$00,$07,$0E

*= $A407
Data_A407:  
    .byte $5F, $FF

*= $A41A
Data_A41A:
    .byte $83, $2F, $F5, $03, $2F, $47, $03, $39
    .byte $43, $03, $38, $43, $FF  

Data_A427:
    .byte $03, $2F, $03    
    .byte $2F, $47, $03, $39, $03, $39, $03, $38
    .byte $43 ,$FF

Data_A434:
    .byte $43, $81, $3B, $F5, $01, $3B, $23, $3F
    .byte $03, $3B, $23, $3D, $03, $39, $47, $FF

Data_A444:
    .byte $47, $01, $3B, $01, $3B, $01, $3B, $01
    .byte $3B, $23, $39, $03, $3B, $47, $FF

Data_A453:
    .byte $47, $81, $3B, $F5, $01, $3B, $01
    .byte $3B, $01, $3B, $23, $39, $03, $3D, $03
    .byte $3B, $43, $FF

Data_A465:
    .byte $03, $2F, $03, $2F, $47
    .byte $03, $3D, $43, $03, $3B, $43, $FF

Data_A471:
    .byte $03, $2F, $03, $2F, $47, $03, $3D, $03, $3D
    .byte $03, $3B, $03, $36, $FF

Data_A47F:
    .byte $85,$3E,$F2,$01,$3B,$43,$05,$3E
    .byte $01,$3B,$43,$05,$3E,$01,$3B,$FF

Data_A48F:
    .byte $43,$05,$3E
    .byte $01,$3B,$43,$03,$3E,$03,$3B,$21
    .byte $39,$21,$3A,$03,$3B,$FF

Data_A4A0:
    .byte $05
    .byte $42
    .byte $01,$3E,$43,$05,$42,$01,$3E,$43
    .byte $05,$42,$01,$3E,$FF

Data_A4AF:
    .byte $43,$05,$42
    .byte $01,$3E,$43,$03,$42,$03,$3E,$21
    .byte $3C,$21,$3D,$03,$3E,$FF

Data_A4C0:
    .byte $03,$3B,$03,$3B,$47,$03,$39,$43
    .byte $03,$38,$43,$FF

Data_A4CC:
    .byte $47,$87,$3E,$F2,$07,$3D
    .byte $27,$39,$FF

Data_A4D5:
    .byte $0F,$39,$4F,$FF

Data_A4D9:
    .byte $47,$07,$3D,$07,$39,$27,$3B,$FF

Data_A4E1:
    .byte $07,$3B,$57,$FF

Data_A4E5:
    .byte $47,$07,$3D,$07,$39,$07,$40,$FF

Data_A4ED:
    .byte $07,$3E,$07,$3D,$07,$3B,$03,$39
    .byte $03,$36,$FF

Data_A4F8:
    .byte $81,$47,$F7,$01,$47,$01,$47,$41
    .byte $87,$3E,$F2,$07,$3D,$27,$39,$FF

Data_A508:
    .byte $0F,$39,$4F,$FF

Data_A50C:
    .byte $81,$47,$F7,$01,$47,$01,$47,$41
    .byte $45,$A1,$2A,$F2,$01,$36,$01,$36
    .byte $03,$34,$07,$36,$FF

Data_A521:
    .byte $47,$87,$2A,$F5,$07,$36,$21,$39
    .byte $21,$3A,$03,$3B,$FF

Data_A52E:
    .byte $43,$05,$42,$01,$3E,$43,$0F,$47,$FF

Data_A537:
    .byte $47,$03,$3E,$03,$40,$23,$42,$21
    .byte $40,$25,$3E,$03,$3E,$FF

Data_A545:
    .byte $47,$01,$3B,$01,$3B,$01,$3B,$01
    .byte $3B,$23,$39,$03,$3D,$03,$3B,$81
    .byte $2F,$F8,$01,$2F,$FF

Data_A55A:
    .byte $03,$32,$03,$2F,$07,$32,$83,$39
    .byte $F5,$43,$03,$38,$81,$2F,$F8,$01
    .byte $2D,$FF

Data_A56C:
    .byte $03,$2F,$03,$2F,$07,$2F,$83,$39
    .byte $F5,$43,$03,$38,$43,$FF

Data_A57A:
    .byte $03,$2F,$03,$2F,$47,$03,$39,$03
    .byte $39,$03,$38,$81,$2F,$F8,$01,$2F
    .byte $FF

Data_A58B:
    .byte $03,$32,$03,$2F,$03,$32,$83
    .byte $3B,$F5,$23,$3D,$03,$39,$45,$81
    .byte $2F,$F8,$FF

Data_A59D:
    .byte $03,$2F,$03,$2F,$01
    .byte $2F,$81,$3B,$F5,$01,$3B,$01,$3B
    .byte $23,$39,$03,$3B,$43,$83,$2F,$F8
    .byte $FF

Data_A5B3:
    .byte $03,$2F,$81,$3B,$F5,$01,$3B
    .byte $23,$3F,$03,$3B,$23,$3D,$03,$39
    .byte $47,$FF

Data_A5C4:
    .byte $47,$01,$3B,$01,$3B,$01
    .byte $3B,$01,$3B,$23,$39,$03,$3D,$03
    .byte $3B,$83,$2F,$F8,$FF

Data_A5D7:
    .byte $43,$07,$32
    .byte $01,$31,$01,$2F,$07,$32,$03,$2F
    .byte $03,$2D,$FF

Data_A5E5:
    .byte $41,$01,$2D,$01,$2F
    .byte $01,$2D,$07,$2F,$4F,$FF

Data_A5F0:
    .byte $07,$36
    .byte $03,$34,$03,$32,$07,$36,$45,$01
    .byte $2F,$FF

Data_A5FC:
    .byte $01,$2F,$01,$2F,$03,$2F
    .byte $03,$2F,$03,$2D,$03,$2F,$4B,$FF

*= $A610
Data_A610:
    .byte $2F,$1E,$2F,$1D,$FF

Data_A615:
    .byte $2F,$1C,$2F,$1A,$FF

Data_A61A:
    .byte $3F,$22,$FF

Data_A61D:
    .byte $83,$17,$F1,$05,$17
    .byte $01,$1B,$03,$1E,$03,$21,$03,$21
    .byte $03,$1C,$03,$1C,$FF

Data_A62F:
    .byte $03,$17,$05
    .byte $17,$01,$1B,$03,$1E,$03,$21,$03
    .byte $21,$03,$1C,$03,$1E,$FF

Data_A640:
    .byte $07,$23
    .byte $07,$2F,$07,$23,$07,$2D,$FF

Data_A649:
    .byte $07
    .byte $21,$07,$2D,$03,$21,$03,$21,$03
    .byte $21,$03,$21,$FF

Data_A656:
    .byte $07,$20,$07,$2C
    .byte $07,$20,$07,$28,$FF

Data_A65F:
    .byte $07,$1C,$07
    .byte $28,$03,$1C,$03,$1C,$03,$1C,$03
    .byte $1C,$FF

Data_A66C:
    .byte $03,$12,$03,$12,$03,$12
    .byte $03,$12,$03,$12,$03,$12,$03,$12
    .byte $03,$19,$FF

Data_A67D:
    .byte $43,$03,$1E,$4F,$07
    .byte $19,$FF

Data_A684:
    .byte $43,$03,$1E,$57,$FF

Data_A689:
    .byte $03,$1E,$37,$1E,$03,$1E,$FF

Data_A690:
    .byte $83,$17,$F6,$37,$15,$23,$15,$FF

Data_A698:
    .byte $0B,$15
    .byte $03,$17,$03,$17,$43,$47,$FF

Data_A6A1:
    .byte $03,$17,$37,$1A,$03,$26,$FF

Data_A6A8:
    .byte $07,$1E,$07,$1E,$07,$12,$07,$12,$FF
*= $A6B6
Data_A6B6:
    .byte $2F,$2A,$2F,$29,$FF

Data_A6BB:
    .byte $2F,$28,$2F,$32,$FF

Data_A6C0:
    .byte $3F,$2E,$FF

Data_A6C3:
    .byte $81,$5F,$63,$01,$5F,$01,$5F
    .byte $01,$5F,$81,$5F,$93,$01,$5F,$01
    .byte $5F,$01,$5F,$81,$5F,$C3,$01,$5F
    .byte $01,$5F,$01,$5F,$81,$5F,$F3,$01
    .byte $5F,$01,$5F,$01,$5F,$FF

Data_A6E8:
    .byte $83,$5F
    .byte $F3,$03,$5F,$03,$17,$03,$5F,$03
    .byte $5F,$03,$5F,$03,$17,$03,$5F,$FF

Data_A6FA:
    .byte $81,$5F,$F3,$01,$5F,$01,$5F,$01
    .byte $5F,$01,$5F,$01,$5F,$01,$5F,$01
    .byte $5F,$01,$5F,$01,$5F,$01,$5F,$01
    .byte $5F,$01,$5F,$01,$5F,$01,$5F,$01
    .byte $5F,$FF

Data_A71C:
    .byte $87,$42,$F2,$07,$40,$07
    .byte $3E,$07,$3D,$FF

Data_A726:
    .byte $03,$5F,$03,$5F
    .byte $83,$3B,$F2,$03,$3D,$23,$3E,$21
    .byte $3D,$25,$3B,$03,$3B,$FF

Data_A738:
    .byte $03,$17
    .byte $03,$5F,$47,$01,$5F,$01,$5F,$01
    .byte $5F,$01,$5F,$01,$17,$45,$FF

Data_A749:
    .byte $83
    .byte $34,$F2,$03,$32,$03,$34,$03,$32
    .byte $05,$36,$23,$34,$21,$32,$03,$2F
    .byte $FF

*= $A75B      
LOOKUP_A75B:    
    .word Data_A407, Data_A409, Data_A41A, Data_A427
    .word Data_A434, Data_A444, Data_A453, Data_A465
    .word Data_A471, Data_A47F, Data_A48F, Data_A4A0
    .word Data_A4AF, Data_A4C0, Data_A4CC, Data_A4D5
    .word Data_A4D9, Data_A4E1, Data_A4E5, Data_A4ED
    .word Data_A4F8, Data_A508, Data_A50C, Data_A521
    .word Data_A52E, Data_A537, Data_A545, Data_A55A
    .word Data_A56C, Data_A57A, Data_A58B, Data_A59D
    .word Data_A5B3, Data_A5C4, Data_A5D7, Data_A5E5
    .word Data_A5F0, Data_A5FC, 0, 0
    .word Data_A60A, Data_A610, Data_A615, Data_A61A
    .word Data_A61D, Data_A62F, Data_A640, Data_A649
    .word Data_A656, Data_A65F, Data_A66C, Data_A67D
    .word Data_A684, Data_A689, Data_A690, Data_A698
    .word Data_A6A1, Data_A6A8, 0, 0
    .word Data_A6B1, Data_A6B6, Data_A6BB, Data_A6C0
    .word Data_A6C3, Data_A6E8, Data_A6FA, Data_A71C
    .word Data_A726, Data_A738, Data_A749

*= $A7E9

    .byte     $00,$00,$00,$00,$00,$00,$40
    .byte $00,$41,$2F,$FF,$00,$00,$00,$00
    .byte $08,$21,$28,$88,$00,$00,$00,$00
    .byte $01,$41,$2F,$FF,$02,$00,$00,$00
    .byte $08,$81,$14,$00,$00,$00,$00,$00
    .byte $08,$41,$2F,$FF,$00,$00,$00,$00
    .byte $08,$21,$26,$8F,$00,$00,$00,$00
    .byte $08,$21,$22,$AA,$00,$00,$00,$00
    .byte $08,$41,$02,$26,$00,$00,$00,$00
    .byte $08,$21,$88,$88,$03,$00,$00

*= $a837 "UnknownData" 
LOOKUP_A837:
    .byte $01,$02,$03,$04,$05,$06,$01,$02
    .byte $03,$04,$05,$06,$01,$02,$03,$04
    .byte $05,$06,$01,$02,$06,$01,$03,$04
    .byte $05,$04,$05,$06,$02,$03

*= $b3f4
TEXT_LOOKUP_LOW:
    .byte <TEXT_NO_EMPTY_TRAPS
    .byte <TEXT_NO_BACKUP_MEN
    .byte <TEXT_SORRY_NO_BAIT
    .byte <TEXT_BACKPACKS_DISCHARGED
    .byte <TEXT_MARSHMALLOW_ALERT
    .byte <TEXT_MARSHMALLOW_MAN_DAMAGE
    .byte <TEXT_MARSHMALLOW_REWARD
    .byte <TEXT_CAR_FULL
    .byte <TEXT_CROSSED_STREAMS
    .byte <TEXT_GOTO_ZUUL

TEXT_LOOKUP_HIGH:
    .byte >TEXT_NO_EMPTY_TRAPS
    .byte >TEXT_NO_BACKUP_MEN
    .byte >TEXT_SORRY_NO_BAIT
    .byte >TEXT_BACKPACKS_DISCHARGED
    .byte >TEXT_MARSHMALLOW_ALERT
    .byte >TEXT_MARSHMALLOW_MAN_DAMAGE
    .byte >TEXT_MARSHMALLOW_REWARD
    .byte >TEXT_CAR_FULL
    .byte >TEXT_CROSSED_STREAMS
    .byte >TEXT_GOTO_ZUUL

*=$F4F8
    .byte $22,$02,$EC,$00,$72,$02,$05,$D7
    .byte $03,$17,$00,$27,$03,$B7,$05,$97
    .byte $07,$D8,$0B,$77,$0D,$C7,$0F,$C7
    .byte $11,$E7,$13,$88,$05,$C6,$00,$F7
    .byte $03,$A8,$05,$78,$0D,$B7,$0F,$A7
    .byte $11,$08,$21,$AA,$00,$07,$00,$27
    .byte $01,$58,$0B,$97,$0D,$68,$09,$C5
    .byte $00,$A7,$03,$D7,$05,$97,$01,$67
    .byte $03,$C7,$04,$77,$07,$77,$09,$37
    .byte $0B,$B7,$0D,$17,$0F,$D7,$11,$A7
    .byte $13,$67,$15,$D7,$17,$A7,$19,$A7
    .byte $1B,$A7,$1D,$08,$2B,$79,$3F,$CA
    .byte $1B,$97,$19,$96,$13,$97,$13,$18
    .byte $13,$A8,$17,$66,$0C,$97,$0A,$57
    .byte $08,$07,$09,$D7,$07,$67,$07,$A8
    .byte $0D,$87,$0F,$98,$17,$B8,$1B,$C7
    .byte $1D,$97,$1F,$97,$1E,$39,$5B,$4A
    .byte $29,$A5,$1E,$D6,$0D,$87,$0B,$B7
    .byte $0B,$B6,$05,$C7,$03,$47,$03,$38
    .byte $0F,$A7,$0D,$C7,$0D,$76,$04,$F8
    .byte $09,$97,$0B,$78,$13,$79,$21,$D5
    .byte $0B,$E5,$07,$08,$17,$99,$21,$D3
    .byte $11,$B5,$07,$08,$17,$99,$1F,$B5
    .byte $16,$98,$2F,$85,$21,$99,$2F,$76
    .byte $35,$B5,$2D,$99,$3B,$88,$2F,$85
    .byte $1F,$D6,$1D,$48,$27,$E7,$28,$78
    .byte $41,$A9,$4D,$C5,$47,$D7,$49,$C9
    .byte $51,$A8,$57,$C6,$53,$89,$1D,$07
    .byte $1B,$D7,$19,$D8,$19,$B7,$17,$47
    .byte $19,$B7,$17,$B7,$19,$D6,$16,$07
    .byte $19,$D6,$17,$37,$19,$C6,$17,$D7
    .byte $19,$C7,$1B,$D6,$17,$77,$17,$D5
    .byte $17,$C7,$17,$E5,$13,$E9,$17,$C8
    .byte $17,$87,$15,$E7,$13,$C7,$17,$D6
    .byte $15,$F7,$17,$67,$15,$C8,$19,$D5
    .byte $17,$E9,$1D,$E5,$19,$E7,$1B,$F7
    .byte $1D,$E5,$19,$D6,$17,$C7,$19,$B6
    .byte $13,$EA,$1B,$C5,$17,$D8,$1B,$B6
    .byte $17,$C9,$1A,$97,$1C,$C7,$1B,$D7
    .byte $1D,$87,$21,$A6,$1D,$27,$1D,$D6
    .byte $1B,$E7,$1C,$F7,$1F,$97,$20,$07
    .byte $21,$47,$1F,$A8,$21,$C7,$22,$27
    .byte $21,$D7,$23,$C7,$03,$D7,$05,$57
    .byte $07,$B7,$05,$D8,$07,$67,$09,$B7
    .byte $0B,$57,$0D,$B7,$0B,$D8,$0F,$D6
    .byte $0D,$87,$0F,$27,$11,$37,$12,$D7
    .byte $15,$77,$17,$C7,$19,$67,$1B,$27
    .byte $1D,$77,$1F,$C7,$21,$B7,$1F,$D7
    .byte $21,$77,$23,$C8,$25,$C8,$29,$77
    .byte $2B,$97,$29,$A7,$2B,$C9,$33,$68
    .byte $5F,$F9,$7E,$02,$5A,$8A,$16,$03
    .byte $5E,$F9,$8E,$02,$5F,$E9,$9E,$02
    .byte $5A,$FC,$00,$00,$5F,$F9,$86,$02
    .byte $5D,$BA,$8E,$03,$5E,$F9,$8E,$02
    .byte $5F,$E9,$9E,$02,$5B,$FC,$00,$00
    .byte $5F,$F9,$C6,$02,$5E,$5A,$D6,$03
    .byte $7F,$F1,$CE,$02,$5F,$F9,$7E,$02
    .byte $5A,$8A,$16,$03,$5F,$C9,$8E,$02
    .byte $58,$FC,$00,$00,$5F,$F9,$86,$02
    .byte $5C,$BA,$8E,$03,$5E,$F9,$8E,$02
    .byte $5F,$D9,$9E,$02,$5C,$FC,$00,$00
    .byte $5F,$F9,$C6,$02,$5A,$FA,$D6,$03
    .byte $4A,$42,$86,$04,$7F,$B9,$CE,$02
    .byte $5F,$E9,$46,$05,$5A,$D2,$96,$05
    .byte $5E,$C9,$5E,$05,$5A,$52,$C6,$05
    .byte $5E,$FC,$00,$00,$5E,$F2,$76,$06
    .byte $6A,$B2,$86,$06,$58,$BA,$0E,$07
    .byte $5F,$E9,$D6,$06,$5A,$D2,$56,$07
    .byte $5F,$C9,$D6,$06,$5C,$CA,$86,$07
    .byte $5F,$C9,$D6,$06,$5C,$CA,$86,$07
    .byte $5F,$C9,$D6,$06,$5C,$CA,$86,$07
    .byte $5F,$C9,$D6,$06,$5C,$CA,$86,$07
    .byte $5F,$F1,$D6,$06,$59,$FC,$00,$00
    .byte $5A,$E2,$BE,$07,$5F,$E9,$D6,$06
    .byte $5B,$F4,$00,$00,$5B,$E2,$DE,$07
    .byte $5F,$F1,$D6,$06,$58,$FC,$00,$00
    .byte $BB,$7A,$FE,$07,$19,$02,$CA,$08
    .byte $09,$32,$4A,$09,$79,$02,$B2,$09

*=$F7B0
    .byte $1D,$63,$76,$5A,$33,$ED,$CC,$1C
    .byte $F9,$18,$0F,$C5,$71,$E8,$68,$D6
    .byte $83,$D3,$15,$1E,$F3,$AC,$AE,$8A
    .byte $A9,$96,$66,$71,$D4,$C6,$08,$76
    .byte $5D,$AD,$0D,$A3,$D1,$98,$27,$5E
    .byte $53,$4F,$98,$6A,$F9,$25,$1D,$8B
    .byte $97,$5C,$87,$9B,$74,$4C,$2A,$4A
    .byte $53,$3A,$A9,$4A,$4E,$51,$F4,$A0
    .byte $2F,$CB,$EA,$A4,$8B,$75,$C5,$15
    .byte $FD,$A2,$AA,$54,$4A,$D4,$94,$75

*=$F8C8
    .byte $8C,$77,$57,$64,$87,$98,$79,$D9
    .byte $9C,$99,$59,$32,$65,$88,$98,$FB
    .byte $8C,$CA,$3A,$31,$75,$77,$87,$FB
    .byte $8C,$9A,$67,$56,$75,$68,$75,$FB
    .byte $7C,$B9,$59,$54,$75,$78,$76,$DA
    .byte $7C,$A8,$69,$54,$77,$66,$76,$EA
    .byte $7C,$99,$79,$45,$86,$68,$64,$FB
    .byte $8C,$AA,$58,$33,$85,$9A,$56,$E9
    .byte $7C,$A8,$6A,$33,$A7,$57,$74,$FB
    .byte $7C,$B9,$6A,$22,$A7,$68,$85,$DB
    .byte $9C,$9A,$46,$44,$96,$9A,$55,$F9
    .byte $9C,$8A,$56,$44,$96,$9A,$46,$F8
    .byte $7C,$99,$67,$56,$86,$79,$55,$FA
    .byte $8C,$8A,$56,$44,$96,$9A,$45,$F9
    .byte $8C,$78,$77,$46,$86,$79,$55,$F9
    .byte $8C,$89,$77,$45,$96,$8A,$45,$F8
    .byte $8C,$88,$67,$34,$A6,$9B,$45,$E8
    .byte $7C,$88,$78,$45,$85,$9A,$56,$E9
    .byte $7C,$77,$78,$55,$97,$79,$66,$D9
    .byte $7C,$78,$66,$76,$87,$89,$77,$B9
    .byte $7C,$87,$77,$76,$88,$78,$87,$B9
    
*=$FA30
    .byte $5F,$32,$23,$9D,$74,$CC,$CC,$6B
    .byte $C3,$1E,$73,$98,$99,$DC,$6C,$67
    .byte $CD,$B9,$93,$99,$E5,$9C,$48,$C4
    .byte $B9,$07,$6E,$CC,$59,$66,$71,$BC
    .byte $F3,$44,$1D,$8B,$39,$99,$65,$4C
    .byte $43,$56,$96,$A9,$79,$CD,$6A,$C6
    .byte $65,$4B,$71,$C5,$63,$CE,$CD,$36
    .byte $97,$51,$66,$8C,$71,$99,$87,$39
    .byte $5D,$C6,$95,$1E,$33,$96,$71,$19
    .byte $27,$E7,$78,$CC,$33,$49,$5D,$1C
    .byte $6C,$65,$76,$77,$78,$A8,$8A,$C8
    .byte $7C,$56,$86,$77,$58,$C7,$6B,$E6
    .byte $7C,$67,$76,$78,$67,$A8,$79,$C7
    .byte $7C,$67,$65,$87,$67,$B8,$6A,$C7
    .byte $7C,$77,$66,$98,$57,$C7,$5A,$D6
    .byte $7C,$76,$88,$77,$77,$A7,$79,$B8
    .byte $7C,$77,$77,$88,$87,$77,$87,$B8
    .byte $7C,$87,$88,$88,$77,$87,$88,$B8
    .byte $7C,$78,$77,$77,$77,$77,$98,$AA
    .byte $7C,$87,$77,$66,$56,$77,$A8,$DB
    .byte $8C,$98,$88,$67,$45,$54,$A7,$DC
    .byte $9C,$89,$87,$78,$57,$44,$95,$FC
    .byte $8C,$9A,$77,$76,$78,$35,$95,$FD
    .byte $8C,$9A,$88,$77,$67,$45,$85,$FC
    .byte $8C,$99,$88,$76,$78,$45,$85,$FC
    .byte $8C,$99,$88,$76,$78,$45,$85,$FC
    .byte $7C,$A9,$78,$76,$79,$35,$74,$FC
    .byte $8C,$9A,$76,$96,$7A,$23,$85,$FC
    .byte $3C,$C8,$BE,$35,$55,$76,$87,$F9
    .byte $3C,$C8,$AF,$34,$65,$77,$76,$FA
    .byte $5C,$F8,$AE,$55,$76,$67,$64,$FA
    .byte $6C,$B7,$AB,$57,$32,$A8,$66,$FA
    .byte $9C,$56,$C9,$28,$62,$A8,$77,$F9
    .byte $9C,$46,$A6,$49,$61,$BA,$85,$EC
    .byte $8C,$56,$97,$48,$84,$8A,$97,$DB
    .byte $7C,$77,$87,$77,$88,$78,$97,$BA
    .byte $7C,$77,$77,$87,$88,$88,$88,$BA
    .byte $7C,$77,$77,$77,$88,$88,$88,$BA
    .byte $6C,$87,$78,$76,$88,$98,$78,$D8
    .byte $7C,$88,$67,$76,$88,$88,$67,$D9
    .byte $7C,$77,$77,$87,$88,$88,$88,$A9
    .byte $7C,$77,$76,$87,$88,$88,$98,$A9
    .byte $6C,$67,$76,$87,$98,$98,$98,$A9
    .byte $5C,$76,$67,$67,$85,$B8,$79,$E8
    .byte $8C,$25,$56,$88,$75,$E6,$7B,$F6
    .byte $9C,$37,$84,$86,$75,$D5,$7B,$F3
    .byte $8C,$48,$66,$A8,$84,$A7,$6C,$E3
    .byte $5C,$6A,$84,$5B,$A6,$87,$7A,$B6
    .byte $5C,$8A,$85,$78,$89,$A5,$6B,$B5
    .byte $6C,$89,$85,$79,$88,$85,$7B,$A5
   
*=$FBF8
    .byte $8C,$78,$77,$76,$77,$77,$87,$A9
    .byte $8C,$88,$77,$76,$77,$77,$87,$A9
    .byte $8C,$99,$78,$76,$77,$66,$87,$B9
    .byte $7C,$A8,$79,$76,$88,$67,$65,$C9
    .byte $7C,$89,$87,$89,$66,$88,$55,$E8
    .byte $7C,$77,$99,$88,$77,$89,$55,$C7
    .byte $8C,$77,$98,$89,$77,$89,$34,$E7
    .byte $7C,$67,$A8,$79,$96,$49,$53,$E9
    .byte $7C,$57,$A6,$7B,$96,$4A,$51,$F9
    .byte $9C,$58,$96,$69,$66,$65,$88,$C9
    .byte $8C,$56,$97,$79,$66,$66,$98,$B8
    .byte $7C,$77,$78,$77,$77,$89,$65,$C8
    .byte $7C,$54,$A8,$89,$AA,$69,$43,$F6
    .byte $6C,$77,$88,$98,$9B,$78,$23,$F7
    .byte $8C,$77,$77,$87,$89,$67,$65,$E8
    
*=$FCA8
    .byte $8C,$88,$88,$77,$77,$77,$87,$A9
    .byte $7C,$98,$89,$77,$67,$56,$86,$CA
    .byte $7C,$78,$98,$77,$89,$56,$75,$C9
    .byte $6C,$87,$78,$87,$A9,$69,$34,$E7
    .byte $8C,$99,$88,$77,$67,$66,$87,$A9
    .byte $7C,$98,$89,$78,$67,$55,$86,$CA
    .byte $7C,$88,$88,$87,$79,$66,$66,$D8
    .byte $6C,$97,$79,$87,$88,$78,$35,$E7
    .byte $7C,$88,$78,$67,$77,$98,$89,$77
    .byte $77,$77,$76,$A8,$8C,$99,$88,$56
    .byte $76,$97,$8A,$87,$89,$56,$65,$C9
    .byte $8C,$78,$98,$89,$56,$86,$88,$88
    .byte $88,$89,$14,$F6,$8C,$77,$87,$89
    .byte $67,$87,$98,$68,$97,$8A,$13,$F7
    .byte $8C,$78,$87,$88,$77,$77,$98,$68
    .byte $97,$8A,$23,$E8,$7C,$87,$88,$77
    .byte $77,$77,$98,$68,$A7,$7A,$33,$D8
    .byte $7C,$87,$88,$88,$68,$75,$99,$67
    .byte $A8,$6A,$43,$D8,$8C,$77,$87,$88
    .byte $78,$77,$88,$77,$97,$7A,$34,$D8
    .byte $8C,$77,$88,$88,$77,$87,$88,$77
    .byte $98,$79,$33,$D8,$8C,$77,$87,$88
    .byte $67,$87,$88,$77,$98,$79,$43,$D8
    .byte $8C,$77,$88,$88,$67,$76,$88,$77
    .byte $A8,$7A,$43,$C8,$8C,$77,$87,$88
    .byte $77,$77,$88,$77,$98,$79,$44,$C8
    .byte $8C,$77,$88,$88,$67,$76,$88,$77
    .byte $A8,$79,$44,$C8,$8C,$77,$88,$88
    .byte $77,$77,$88,$67,$A8,$7A,$44,$C8
    .byte $8C,$77,$88,$88,$77,$76,$88,$67
    .byte $A8,$7A,$44,$C8,$8C,$77,$87,$88
    .byte $77,$77,$88,$67,$A8,$7A,$44,$C8
    .byte $8C,$77,$87,$88,$77,$77,$88,$77
    .byte $98,$79,$44,$C8,$7C,$77,$87,$A8
    .byte $7C,$77,$77,$A8,$8C,$86,$77,$A8
    .byte $8C,$67,$77,$B7,$7C,$77,$77,$B7
    .byte $7C,$77,$77,$B6,$7C,$88,$67,$B6
    .byte $8C,$89,$56,$C6,$8C,$88,$57,$B6
    .byte $7C,$88,$56,$C6,$7C,$78,$47,$E6
    .byte $6C,$78,$67,$B7,$7C,$79,$65,$C7
    .byte $7C,$78,$67,$B7,$7C,$97,$25,$E9
    .byte $7C,$78,$55,$C8,$7C,$78,$56,$D6
    .byte $8C,$87,$47,$C7,$7C,$88,$56,$B7
    .byte $7C,$79,$55,$B8,$7C,$89,$56,$C6
    .byte $7C,$89,$44,$F6,$7C,$79,$56,$D6
    .byte $8C,$78,$56,$C6,$7C,$79,$45,$E6
    .byte $8C,$79,$45,$D6,$7C,$79,$45,$F6
    .byte $8C,$78,$56,$D6,$7C,$78,$56,$E6
    .byte $8C,$86,$47,$C8,$8C,$79,$35,$E5
    .byte $8C,$78,$46,$D6,$8C,$68,$46,$E6
    .byte $9C,$7A,$35,$E6,$7C,$79,$45,$E6
    .byte $7C,$78,$67,$B6,$8C,$79,$45,$E6
    .byte $8C,$69,$56,$D6,$7C,$79,$44,$E7
    .byte $9C,$87,$13,$F9,$8C,$78,$56,$C6
    .byte $8C,$97,$14,$F9,$7C,$88,$56,$D6
    .byte $8C,$69,$55,$E7,$9C,$6A,$24,$F6
    .byte $8C,$86,$36,$E8,$8C,$78,$66,$B7
    .byte $7C,$79,$66,$A7,$8C,$78,$66,$B7
    .byte $7C,$78,$56,$C7,$8C,$78,$46,$D6
    .byte $7C,$78,$56,$C6,$7C,$88,$66,$A7
    .byte $7C,$6A,$74,$B9,$8C,$87,$56,$B8
    .byte $8C,$68,$66,$B7,$8C,$78,$57,$C6
    .byte $7C,$87,$47,$D7,$7C,$87,$78,$98
    .byte $78,$68,$55,$D8,$8C,$67,$76,$B9
    .byte $59,$75,$77,$A8,$7C,$87,$78,$88
    .byte $88,$77,$56,$D8,$6C,$98,$78,$87
    .byte $98,$68,$45,$D7,$7C,$87,$78,$98
    .byte $88,$78,$55,$B8,$7C,$87,$78,$88
    .byte $88,$77,$56,$C8,$6C,$87,$88,$99
    .byte $88,$68,$54,$D7,$6C,$88,$78,$97
    .byte $99,$68,$56,$C7,$6C,$88,$78,$98
    .byte $98,$69,$44,$E8,$7C,$87,$78,$98
    .byte $88,$78,$55,$B8,$7C,$87,$78,$88
    .byte $88,$77,$56,$C8,$7C,$87,$78,$87
    .byte $87,$78,$66,$C8,$7C,$88,$77,$87
    .byte $88,$77,$66,$C8,$7C,$98,$68,$87
    .byte $88,$78,$55,$D8,$7C,$97,$78,$87
    .byte $88,$78,$55,$D8,$7C,$88,$67,$87
    .byte $88,$78,$66,$B8,$7C,$88,$77,$88
    .byte $88,$77,$56,$C8,$7C,$88,$77,$88
    .byte $88,$78,$66,$B7,$7C,$88,$67,$87
    .byte $88,$78,$66,$B8,$7C,$98,$67,$87
    .byte $88,$68,$65,$C9,$7C,$87,$68,$97
    .byte $89,$78,$55,$C8,$7C,$98,$77,$87
    .byte $89,$67,$56,$D8,$7C,$97,$69,$86
    .byte $78,$78,$66,$C8,$7C,$87,$79,$85
    .byte $89,$67,$66,$B8,$7C,$87,$78,$77
    .byte $88,$77,$67,$B7,$7C,$88,$78,$77
    .byte $88,$77,$67,$B7,$7C,$88,$78,$87
    .byte $88,$77,$67,$B7,$7C,$88,$78,$86
    .byte $88,$77,$67,$B7,$7C,$88,$78,$77
    .byte $88,$77,$67,$B7,$7C,$98,$68,$87
    .byte $78,$77,$77,$A8,$7C,$98,$68,$87
    .byte $88,$67,$77,$A7,$8C,$98,$68,$76
    .byte $88,$77,$77,$A8,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $FF,$FF,$FF,$FF,$FF,$00,$FC,$FC
    .byte $FC,$00,$55,$55,$55,$55,$55,$5A
    .byte $AA,$00,$55,$55,$55,$5A,$AA,$AA
    .byte $AA,$00,$55,$55,$55,$A5,$AA,$AA
    .byte $AA,$00,$55,$55,$55,$55,$55,$A5
    .byte $AA,$00,$00,$00,$00,$00,$01,$04
    .byte $10,$40,$01,$04,$10,$40,$00,$00
    .byte $00,$00,$AA,$AA,$AA,$00,$00,$00
    .byte $00,$00,$00,$FF,$FF,$00,$00,$FF
    .byte $FF,$00,$00,$FF,$FF,$00,$00,$FF
    .byte $FC,$00,$A3,$A4,$A5,$A6,$A7,$92