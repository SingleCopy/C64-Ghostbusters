.const FIRE_BUTTON_MASK = $10 // Checks the 4th bit is set
.const PKE_INCREASE_RATE = 9
.const MINIMUM_REQUIRED_GHOSTBUSTERS = 2
.const JOYSTICK_INPUT_ENABLED = $80
.const JOYSTICK_INPUT_DISABLED = $ff

.const ZUUL_CHARSET = $0f80
.const BUILDING_CHARSET = $1fa8
.const ZUUL_CLOSE_PORTAL_CHARMAP = $1880
.const BUILDING_CHARMAP = $1f00
.const ENTER_ZUUL_CHARMAP = $2698
.const CAR_SIDEVIEW_CHARMAP = $5000
//.const ACTIVISION_CHARSET = $36a4
.const BUILDING_2_CHARMAP = $9f2c
.const BUILDING_3_CHARMAP = $a008
.const BUILDING_4_CHARMAP = $a0e4

.const FORMATTED_SCROLLER_TEXT = $e900

.namespace GameStates
{
    .label InitIntro = $01;
    .label InvalidHaveAccountQueryOption = $04;
    .label ClearScreenAndResetTextOutputPos = $06;
    .label EquipmentScreenPrepareCar = $0d;
    .label PrepareMapScreen = $11;
    .label CityMapUpdateLoop = $12;
    .label DrivingToTarget = $15;
    .label PrepareCaptureGhostSequence1 = $16;
    .label CaptureGhost_GhostCaptureFailed = $1d
    .label CaptureGhost_GhostCaptureSuccessful = $1e
    .label CaptureGhost_CaptureGhostInTrap = $1f
    .label GHQ_Enter = $22;
    .label MashmallowManAttackIncoming = $24;
    .label MoveGhostsToOriginalPositions = $27;
    .label EnterZuul_Prepare = $28;
    .label PrepareEnding = $2a;
    .label WriteDownAccountBalance = $2d;
    .label DisplayGoodTry = $2e;
    .label DisplayMadeMoreMoney = $31;
    .label DisplayCongratulations = $36;
    .label PlayLaughOnFailure = $39;
    .label DisplayStartingBalanceText = $3b;
}

.namespace DisplayText
{
    .label Intro = $01;
    .label QueryExistingAccount = $02;
    .label NewBusiness = $03;
    .label EnterAccountNumber = $04;
    .label InvalidAccountNumber = $05;
    .label VehicleSelection = $06;
    .label YouHave = $07;
    .label KeyOptions = $08;
    .label MonitoringEquipment = $09;
    .label InvalidAccount = $0c;
    .label NotEnoughMoney = $0d;
    .label GoodTry = $0e;
    .label FailedToClosePortal = $0f;
    .label MadeMoreMoney = $10;
    .label NewAccountNumber = $11;
    .label WriteDownAccountNumber = $12;
    .label Congratulations = $18;
    .label PortalClosed = $19;
    .label StartingBalance = $1a;
    .label EndBalance = $1b;
}

.namespace ScrollerText
{
    .label NoEmptyTraps = $00;
    .label NoGhostbustersAvailable = $01;
    .label NoGhostBaitRemaining = $02;
    .label BackpacksDischarged = $03;
    .label MarshmallowManAlert = $04;
    .label MarshmallowManDamage = $05;
    .label MarshmallowManReward = $06;
    .label CarFull = $07;
    .label YouCrossedTheStreams = $08;
    .label GotoZuul = $09;
}

.namespace Speech
{
    .label Ghostbusters = $01;
    .label HeSlimedMe = $02;
    .label Laugh = $03;
    .label Scream = $04;
}

.namespace SoundEffect
{

}