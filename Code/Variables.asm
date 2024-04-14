.label ProcessorPort    = $01
.label IsJoystickInputEnabled = $02
.label ZeroPagePointer4 = $0b
.label ZeroPagePointer5 = $0d
.label ZeroPagePointer6 = $0f
.label FireButtonPressed = $11
.label SpriteMulticolor1  = $1d
.label SpriteMulticolor2  = $1e

.label LastKeyPressed   = $17
.label DrivingStripeSpeed   = $1b
.label ShouldLoadAccountScreen = $20  // Loads the account screen when set to 1, 2 when loading the city map
.label TitleSongTextPointerLow   = $21
.label TitleSongTextPointerHigh   = $22
.label ZeroPagePointer1 = $23
.label ZeroPagePointer3 = $25
.label JoystickValue    = $33   // also used for various other things!
.label TextOutputX      = $38
.label TextOutputY      = $39
.label GameState        = $3a
.label BackgroundColor  = $3b
.label PKEnergyRateIncrease = $3c   // Determines how fast PKE increases per cycle
.label RemainingGhostbusters = $3d
.label RemainingBackbackCharge  = $3e
.label TextOutputColor  = $48   //0 = black, 1 = white, white also has special meaning to end after finished word

.label CurrentlyDisplayedText   = $4d // 00 or currently showing equipment text
.label ZeroPagePointer2         = $4e
.label NumberOfKeysInBuffer     = $50
.label StartingAccountBalance   = $51 // spans 3 bytes ($51-$53)
.label MoneyInAccount           = $57 // spans 3 bytes ($57-$59)

//*= $5a
// CityPKEnergy: .word $0000

.label CityPKEnergy         = $5a
.label CarType              = $5c // 0 to 3
.label CurrentEquipmentView = $5d // 0 to 2
.label ForkliftPositionSlot = $5f // 0, 4, 8   - equipment slot on left, 1, 5, 9 over car
.label EquipmentSlotPlusThree = $60 // 0, 1, 2  + 3 > 3,4,5
.label SelectedEquipment    = $61 // 1 to 7, 0 = empty
.label NumberOfEquipmentLoadedIntoCar   = $62
.label CarPosX              = $63
.label CarDirectionControl  = $64 // $ff moves the car left, $01 moves the car right
.label CarDrivingCurrentPos = $66
.label CarDrivingMaxLength  = $67
.label RemainingGhostBait   = $69
.label MaxGhostTraps        = $6a
.label NumberOfEmptyTraps   = $6b
.label NumberOfGhostsCaught = $6c
.label InstalledEquipment   = $6d // bit mask of installed equipment
.label CaptureGhostVisitType = $6e
 
.label CountdownTimer      = $7c   // uses for several things, also marshmallow stomp progress, when it counts down to zero, perform the next actiono
.label TitleSongElapsedTime      = $97
.label RenderNextLyricCountdown  = $9a  // Set to $15, then counts down to 0.

// sprite shadow pos (X0,Y0 X1,Y1 ...) from $a0 to $af
.label ObjectPosX       = $a0
.label ObjectPosY       = $a1

// sprite shadow pos #2 (X0,Y0 X1,Y1 ...) from $b0 to $bf (target pos?)
.label ObjectPosX2      = $b0
.label ObjectPosY2      = $b1

.label LoopTrigger      = $e2
.label ZeroPagePointer7 = $e3
.label ZeroPagePointer8 = $e5

.label KeyboardEntryBuffer  = $ea00 // 20 chars
.label AccountBalance       = $ea14
.label BallSpriteX          = $ea66
.label BallSpriteY          = $ea67
.label BallSpriteExtendedX  = $ea68
.label BallBounceTrigger    = $ea6b
.label BallLyricCountdownTimer  = $ea71
.label ShadowSIDVolume      = $ea82
.label LastMiniGameResult   = $ea7a // 0 = good, everything else bad
.label AccountName          = $eab3 // 20 chars
.label AccountNumber        = $eac7 // Account number, BCD encoded, 4 bytes, $eac7 to $eaca
