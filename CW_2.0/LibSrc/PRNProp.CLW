!----------------------------------------------------------
! Built-in property constants for CW
!----------------------------------------------------------*/

PROPPRINT:devmode         EQUATE(07B00H)  ! Entire devmode structure - see WINDOWS SDK
PROPPRINT:paper           EQUATE(07B01H)  ! standard paper size (PAPER:xxx)
PROPPRINT:paperheight     EQUATE(07B02H)  ! paper height (in 10th mm)
PROPPRINT:paperwidth      EQUATE(07B03H)  ! paper width (in 10th mm)
PROPPRINT:percent         EQUATE(07B04H)  ! scaling factor
PROPPRINT:copies          EQUATE(07B05H)  ! number of copies
PROPPRINT:paperbin        EQUATE(07B06H)  ! paper source (PAPERBIN:xxx)
PROPPRINT:resolution      EQUATE(07B07H)  ! in DPI or RESOLUTION:xxx)
PROPPRINT:color           EQUATE(07B08H)  ! 1=mono, 2=color
PROPPRINT:duplex          EQUATE(07B09H)  ! duplex mode (DUPLEX::xxx)
PROPPRINT:yresolution     EQUATE(07B0AH)  ! in DPI
PROPPRINT:fontmode        EQUATE(07B0BH)  ! TrueType font mode (FONTMODE:xxx)

PROPPRINT:printtofile     EQUATE(07B20H)  ! 0 or 1
PROPPRINT:printtoname     EQUATE(07B21H)  ! output filename
PROPPRINT:frompage        EQUATE(07B22H)  ! specify -1 to print from start
PROPPRINT:topage          EQUATE(07B23H)  ! specify -1 to print to end
PROPPRINT:frommax         EQUATE(07B24H)  ! for compatibility with 1002!
PROPPRINT:frommin         EQUATE(07B24H)  ! specify -1 to disable ranges
PROPPRINT:tomax           EQUATE(07B25H)  ! specify -1 to disable ranges
PROPPRINT:collate         EQUATE(07B26H)  ! 0 or 1
PROPPRINT:driver          EQUATE(07B27H)  ! driver DLL filename (no extension)
PROPPRINT:device          EQUATE(07B28H)  ! driver description
PROPPRINT:port            EQUATE(07B29H)  ! output port name
PROPPRINT:context         EQUATE(07B2AH)  ! handle to printer device context or

! paper sizes - values as in windows.h

PAPER:LETTER              EQUATE(1)       ! Letter 8 1/2 x 11 in
PAPER:LETTERSMALL         EQUATE(2)       ! Letter Small 8 1/2 x 11 in
PAPER:TABLOID             EQUATE(3)       ! Tabloid 11 x 17 in
PAPER:LEDGER              EQUATE(4)       ! Ledger 17 x 11 in
PAPER:LEGAL               EQUATE(5)       ! Legal 8 1/2 x 14 in
PAPER:STATEMENT           EQUATE(6)       ! Statement 5 1/2 x 8 1/2 in
PAPER:EXECUTIVE           EQUATE(7)       ! Executive 7 1/4 x 10 1/2 in	
PAPER:A3                  EQUATE(8)       ! A3 297 x 420 mm
PAPER:A4                  EQUATE(9)       ! A4 210 x 297 mm
PAPER:A4SMALL             EQUATE(10)      ! A4 Small 210 x 297 mm
PAPER:A5                  EQUATE(11)      ! A5 148 x 210 mm
PAPER:B4                  EQUATE(12)      ! B4 250 x 354
PAPER:B5                  EQUATE(13)      ! B5 182 x 257 mm
PAPER:FOLIO               EQUATE(14)      ! Folio 8 1/2 x 13 in
PAPER:QUARTO              EQUATE(15)      ! Quarto 215 x 275 mm
PAPER:10X14               EQUATE(16)      ! 10x14 in
PAPER:11X17               EQUATE(17)      ! 11x17 in
PAPER:NOTE                EQUATE(18)      ! Note 8 1/2 x 11 in
PAPER:ENV_9               EQUATE(19)      ! Envelope #9 3 7/8 x 8 7/8
PAPER:ENV_10              EQUATE(20)      ! Envelope #10 4 1/8 x 9 1/2
PAPER:ENV_11              EQUATE(21)      ! Envelope #11 4 1/2 x 10 3/8
PAPER:ENV_12              EQUATE(22)      ! Envelope #12 4 \276 x 11
PAPER:ENV_14              EQUATE(23)      ! Envelope #14 5 x 11 1/2
PAPER:CSHEET              EQUATE(24)      ! C size sheet
PAPER:DSHEET              EQUATE(25)      ! D size sheet
PAPER:ESHEET              EQUATE(26)      ! E size sheet
PAPER:ENV_DL              EQUATE(27)      ! Envelope DL 110 x 220mm
PAPER:ENV_C5              EQUATE(28)      ! Envelope C5 162 x 229 mm
PAPER:ENV_C3              EQUATE(29)      ! Envelope C3  324 x 458 mm
PAPER:ENV_C4              EQUATE(30)      ! Envelope C4  229 x 324 mm
PAPER:ENV_C6              EQUATE(31)      ! Envelope C6  114 x 162 mm
PAPER:ENV_C65             EQUATE(32)      ! Envelope C65 114 x 229 mm
PAPER:ENV_B4              EQUATE(33)      ! Envelope B4  250 x 353 mm
PAPER:ENV_B5              EQUATE(34)      ! Envelope B5  176 x 250 mm
PAPER:ENV_B6              EQUATE(35)      ! Envelope B6  176 x 125 mm
PAPER:ENV_ITALY           EQUATE(36)      ! Envelope 110 x 230 mm
PAPER:ENV_MONARCH         EQUATE(37)      ! Envelope Monarch 3.875 x 7.5 in
PAPER:ENV_PERSONAL        EQUATE(38)      ! 6 3/4 Envelope 3 5/8 x 6 1/2 in
PAPER:FANFOLD_US          EQUATE(39)      ! US Std Fanfold 14 7/8 x 11 in
PAPER:FANFOLD_STD_GERMAN  EQUATE(40)      ! German Std Fanfold 8 1/2 x 12 in
PAPER:FANFOLD_LGL_GERMAN  EQUATE(41)      ! German Legal Fanfold 8 1/2 x 13 in
PAPER:LAST                EQUATE(41)
PAPER:USER                EQUATE(256)

PAPERBIN:UPPER            EQUATE(1)
PAPERBIN:ONLYONE          EQUATE(1)
PAPERBIN:LOWER            EQUATE(2)
PAPERBIN:MIDDLE           EQUATE(3)
PAPERBIN:MANUAL           EQUATE(4)
PAPERBIN:ENVELOPE         EQUATE(5)
PAPERBIN:ENVMANUAL        EQUATE(6)
PAPERBIN:AUTO             EQUATE(7)
PAPERBIN:TRACTOR          EQUATE(8)
PAPERBIN:SMALLFMT         EQUATE(9)
PAPERBIN:LARGEFMT         EQUATE(10)
PAPERBIN:LARGECAPACITY    EQUATE(11)
PAPERBIN:CASSETTE         EQUATE(14)

RESOLUTION:DRAFT          EQUATE(-1)
RESOLUTION:LOW            EQUATE(-2)
RESOLUTION:MEDIUM         EQUATE(-3)
RESOLUTION:HIGH           EQUATE(-4)

DUPLEX:SIMPLEX            EQUATE(1)
DUPLEX:VERTICAL           EQUATE(2)
DUPLEX:HORIZONTAL         EQUATE(3)

FONTMODE:BITMAP           EQUATE(1)       ! print TT fonts as graphics
FONTMODE:DOWNLOAD         EQUATE(2)       ! download TT fonts as soft fonts
FONTMODE:SUBDEV           EQUATE(3)       ! substitute device fonts for TT fonts
