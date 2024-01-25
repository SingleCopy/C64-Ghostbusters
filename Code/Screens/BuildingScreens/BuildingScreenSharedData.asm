*= $0e00 "Car1SideViewCharset"
CAR1_SIDEVIEW_CHARSET:
.import binary "..\Content\Buildings\Car1SideView\Car1SideViewCharset.bin"
    
*= $0e60 "Car2SideViewCharset"
CAR2_SIDEVIEW_CHARSET:
.import binary "..\Content\Buildings\Car2SideView\Car2SideViewCharset.bin"

*= $0ec0 "Car3SideViewCharset"
CAR3_SIDEVIEW_CHARSET:
.import binary "..\Content\Buildings\Car3SideView\Car3SideViewCharset.bin"

*= $0f20 "Car4SideViewCharset"
CAR4_SIDEVIEW_CHARSET:
.import binary "..\Content\Buildings\Car4SideView\Car4SideViewCharset.bin"

// Pavement data?
*= $1800 "UnknownBuildingData2"
    .import binary "..\Content\Buildings\UnknownBuildingData2.bin"

*= $1f00 "UnknownBuildingData"
    .import binary "..\Content\Buildings\UnknownBuildingData.bin"

// $1fa8 - 25a8
*= BUILDING_CHARSET "BuildingCharset"
    .import binary "..\Content\Buildings\BuildingCharset.bin"

*= CAR_SIDEVIEW_CHARMAP "Car1SideViewCharMap"
    .import binary "..\Content\Buildings\Car1SideView\Car1SideViewCharMap.bin"

*= CAR_SIDEVIEW_CHARMAP + $300 "Car2SideViewCharMap"
    .import binary "..\Content\Buildings\Car2SideView\Car2SideViewCharMap.bin"

*= CAR_SIDEVIEW_CHARMAP + $600 "Car3SideViewCharMap"
    .import binary "..\Content\Buildings\Car3SideView\Car3SideViewCharMap.bin"

*= CAR_SIDEVIEW_CHARMAP + $800 "Car4SideViewCharMap"
    .import binary "..\Content\Buildings\Car4SideView\Car4SideViewCharMap.bin"

*= $375f
CAR_SIDEVIEW_CHARSETS:
    .word CAR1_SIDEVIEW_CHARSET
    .word CAR2_SIDEVIEW_CHARSET
    .word CAR3_SIDEVIEW_CHARSET
    .word CAR4_SIDEVIEW_CHARSET

*= BUILDING_2_CHARMAP "Building2CharMap"
    .import binary "..\Content\Buildings\Building2\Building2CharMap.bin"

*= BUILDING_3_CHARMAP "Building3CharMap"
    .import binary "..\Content\Buildings\Building3\Building3CharMap.bin"

*= BUILDING_4_CHARMAP "Building4CharMap"
    .import binary "..\Content\Buildings\Building4\Building4CharMap.bin"