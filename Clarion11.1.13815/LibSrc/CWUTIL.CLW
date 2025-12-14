  MEMBER
  INCLUDE ('ERRORS.CLW')

DELETE                    EQUATE(00010000h)
READ_CONTROL              EQUATE(00020000h)
WRITE_DAC                 EQUATE(00040000h)
WRITE_OWNER               EQUATE(00080000h)
SYNCHRONIZE               EQUATE(00100000h)

STANDARD_RIGHTS_REQUIRED  EQUATE(000F0000h)

STANDARD_RIGHTS_READ      EQUATE(READ_CONTROL)
STANDARD_RIGHTS_WRITE     EQUATE(READ_CONTROL)
STANDARD_RIGHTS_EXECUTE   EQUATE(READ_CONTROL)

STANDARD_RIGHTS_ALL       EQUATE(001F0000h)

SPECIFIC_RIGHTS_ALL       EQUATE(0000FFFFh)

!! Equates for API

GENERIC_READ              EQUATE(80000000h)
GENERIC_WRITE             EQUATE(40000000h)
GENERIC_EXECUTE           EQUATE(20000000h)
GENERIC_ALL               EQUATE(10000000h)

FILE_ATTRIBUTE_READONLY   EQUATE(00000001h)
FILE_ATTRIBUTE_HIDDEN     EQUATE(00000002h)
FILE_ATTRIBUTE_SYSTEM     EQUATE(00000004h)
FILE_ATTRIBUTE_DIRECTORY  EQUATE(00000010h)
FILE_ATTRIBUTE_ARCHIVE    EQUATE(00000020h)
FILE_ATTRIBUTE_NORMAL     EQUATE(00000080h)
FILE_ATTRIBUTE_TEMPORARY  EQUATE(00000100h)

CREATE_NEW                EQUATE(1)
CREATE_ALWAYS             EQUATE(2)
OPEN_EXISTING             EQUATE(3)
OPEN_ALWAYS               EQUATE(4)
TRUNCATE_EXISTING         EQUATE(5)

SHARE_NONE                EQUATE(0)
INVALID_LONG_VALUE        EQUATE(4294967295)
INVALID_LONG              EQUATE( -1 )
SM_REMOTESESSION          EQUATE(01000h)
SM_MAXIMUMTOUCHES         EQUATE(95)


!! Type DEFS for API

  !! File Stuff
FILETIME                        GROUP,TYPE
dwLowDateTime                     ULONG
dwHighDateTime                    ULONG
                                END

WIN32_FIND_DATA                 GROUP,TYPE
dwFileAttributes                  ULONG
ftCreationTime                    GROUP(FILETIME).
ftLastAccessTime                  GROUP(FILETIME).
ftLastWriteTime                   GROUP(FILETIME).
nFileSizeHigh                     ULONG
nFileSizeLow                      ULONG
dwReserved0                       ULONG
dwReserved1                       ULONG
cFileName                         CSTRING( FILE:MaxFilePath )
cAlternateFileName                CSTRING( 14 )
                                END

SYSTEMTIME                      GROUP,TYPE
wYear                             USHORT
wMonth                            USHORT
wDayOfWeek                        USHORT
wDay                              USHORT
wHour                             USHORT
wMinute                           USHORT
wSecond                           USHORT
wMilliseconds                     USHORT
                                END

SPI_GETDRAGFULLWINDOWS          EQUATE(38)
SPI_SETDRAGFULLWINDOWS          EQUATE(37)
SPIF_UPDATEINIFILE              EQUATE(1)
SPIF_SENDWININICHANGE           EQUATE(2)

HexDigitsUp                     STRING('0123456789ABCDEF'),PRIVATE
HexDigitsLow                    STRING('0123456789abcdef'),PRIVATE


  MAP
    MODULE('C Library')
      mkdir (*CSTRING),SIGNED,PROC,RAW,NAME('_mkdir')
      rmdir (*CSTRING),SIGNED,PROC,RAW,NAME('_rmdir')
    END
    MODULE('win32')
      FindFirstFile( *CSTRING lpFileName, *WIN32_FIND_DATA ),LONG,RAW,PASCAL,NAME('FindFirstFileA')
      FindClose( LONG hFindFile ),BOOL,RAW,PASCAL,PROC
      GetLastError(),ULONG,PASCAL,RAW
      FindWindow( <*CSTRING>, *CSTRING ),UNSIGNED,PASCAL,RAW,NAME( 'FindWindowA' )
      FileTimeToSystemTime(*FILETIME lpFileTime, *SYSTEMTIME lpSystemTime),BOOL,RAW,PASCAL,PROC
      FileTimeToLocalFileTime(*FILETIME lpFileTime, *FILETIME lpLocalFileTime),BOOL,RAW,PASCAL,PROC
      CreateFile( *CSTRING lpFileName, ULONG dwDesiredAccess, ULONG dwShareMode, LONG lpSecurityAttributes, ULONG dwCreationDisposition, ULONG dwFlagsAndAttributes, LONG hTemplateFile), LONG,RAW,PASCAL,NAME('CreateFileA')
      WriteFile( LONG hFile, *STRING lpBuffer, ULONG nNumberOfBytesToWrite, *ULONG lpNumberOfBytesWritten, LONG lpOverlapped ),BOOL,RAW,PASCAL
      CloseHandle( LONG hObject ),BOOL,RAW,PASCAL,PROC
      WNetGetUser( <*CSTRING lpName>, *CSTRING lpUserName, *ULONG lpnLength ),ULONG,RAW,PASCAL,PROC,NAME('WNetGetUserA')
      CreateEvent( <*?>, BOOL bManualReset, BOOL bInitialState, *CSTRING lpName ),LONG,RAW,PASCAL,NAME('CreateEventA')
      GetSystemMetrics( SIGNED nIndex ),SIGNED,RAW,PASCAL
      GetTempPath( LONG nBufferLength, *? lpBuffer ),LONG,RAW,PASCAL,NAME('GetTempPathA')
      GetTempFileName( *CSTRING lpPathName, *CSTRING lpPrefixString, UNSIGNED uUnique, *CSTRING lpTempFileName ),UNSIGNED,RAW,PASCAL,NAME('GetTempFileNameA')

      SystemParametersInfo( LONG uAction, LONG uParam, *? lpvParam, LONG fuWinIni ), LONG, RAW, PASCAL, DLL(TRUE), NAME('SystemParametersInfoA'),PROC
      GetSysColor(signed nIndex),long,pascal,NAME('GetSysColor')
      SV_ShellExecuteURL(LONG hwnd,*CSTRING lpOperation,*CSTRING lpFile,*CSTRING lpParameters,*CSTRING lpDirectory,SIGNED nShowCmd),ULONG,PASCAL,RAW,NAME('ShellExecuteA')
    END
    INCLUDE('CWUTIL.INC'),ONCE

    GetFileSystemTimeDate (STRING FileName, BYTE which, *SYSTEMTIME systime),BOOL,PRIVATE
  END


!-----------------------------------------------------------------------------!
!OSVersion
! Return the Current OS Version (Windows 95, Windows 98 or Windows NT)
!-----------------------------------------------------------------------------!

OSVersion  PROCEDURE()
  CODE
  RETURN SYSTEM {PROP:WindowsVersion}

!-----------------------------------------------------------------------------!
!FileExists
! Return wether a file exists or not (TRUE = Exists, FALSE = Does NOT)
!-----------------------------------------------------------------------------!

FileExists         PROCEDURE ( STRING sFile )

bRetVal            BYTE,AUTO
hFindHandle        SIGNED,AUTO
szFindFile         CSTRING(FILE:MaxFileName),AUTO
gFileFind          LIKE (WIN32_FIND_DATA),AUTO

  CODE
  hFindHandle = 0
  bRetVal     = FALSE
  szFindFile  = CLIP (sFile)
  CLEAR (gFileFind)

  hFindHandle = FindFirstFile (szFindFile, gFileFind)
  bRetVal = CHOOSE (NOT (hFindHandle = INVALID_LONG_VALUE OR hFindHandle <= 0))

  FindClose (hFindHandle)
  RETURN bRetVal

!-----------------------------------------------------------------------------!
!WindowExists
! Return wether a window exists or not (TRUE = Exists, FALSE = Does NOT)
!-----------------------------------------------------------------------------!

WindowExists       PROCEDURE (STRING sWindow)

hWnd               UNSIGNED,AUTO
szWindowName       CSTRING (128),AUTO

  CODE
  szWindowName = CLIP (sWindow)
  hWnd = FindWindow (,szWindowName)
  RETURN CHOOSE (hWnd <> 0)

!-----------------------------------------------------------------------------!
!ValidateOLE
! Validate that the OLE Control Created
!-----------------------------------------------------------------------------!
ValidateOLE        PROCEDURE( SIGNED OleControl, <STRING OleFileName>, <STRING OleCreateName> )

lCallRet           LONG

  CODE
  IF NOT OleControl{PROP:OLE} AND OleControl{PROP:Object} = ''
    IF ~OMITTED( 2 )
      OleControl{PROP:Create} = CLIP( OleCreateName )
      IF OleControl{PROP:OLE} = FALSE AND OleControl{PROP:Object} = ''
        IF ~OMITTED( 3 )
          lCallRet = CALL( CLIP( OleFileName ),'DllRegisterServer' )
          IF lCallRet
            MESSAGE('Can not Register OLE Control ' & CLIP( OleFileName ) & ' Error: ' & CLIP( lCallRet ) & '.  Please check the installation of the control.','Fatal OLE Error',ICON:Exclamation)
            RETURN FALSE
          END
          UNLOAD( CLIP( OleFileName ) )
          OleControl{PROP:Create} = CLIP( OleCreateName )
        ELSE
          RETURN FALSE
        END
        IF NOT OleControl{PROP:OLE} AND OleControl{PROP:Object} = ''
          MESSAGE('Can not Find OLE Control ' & CLIP( OleFileName ) & ' !  Please re-install.','Fatal OLE Error',ICON:Exclamation)
          RETURN FALSE
        ELSE
          RETURN TRUE
        END
      END
    ELSE
      RETURN FALSE
    END
  ELSE
    RETURN TRUE
  END

!-----------------------------------------------------------------------------!
!GetUserName
! Return the network username
!-----------------------------------------------------------------------------!
GetUserName        PROCEDURE()

sRetUser           CSTRING(128)
dwUserLen          ULONG,AUTO

  CODE
  dwUserLen = SIZE ( sRetUser )
  IF WNetGetUser (, sRetUser, dwUserLen ) = 0
    RETURN CLIP (sRetUser)
  ELSE
    RETURN ''
  END

!-----------------------------------------------------------------------------!
!BeginUnique
! Set APP to run in Single Process
!-----------------------------------------------------------------------------!
BeginUnique        PROCEDURE( STRING sAppName )

szEventName        CSTRING(FILE:MaxFilePath),AUTO
hEvent             LONG,AUTO

  CODE
  szEventName = CLIP( sAppName ) & '_UEvent'

  hEvent = CreateEvent (, 0, 0, szEventName )
  IF hEvent = 0 OR GetLastError() = 183             !Already Exists
    RETURN 0
  ELSE
    RETURN hEvent
  END

!-----------------------------------------------------------------------------!
!EndUnique
! Un Set APP to run in Single Process
!-----------------------------------------------------------------------------!
EndUnique          PROCEDURE( LONG hUnique )

  CODE
  CloseHandle ( hUnique )
  RETURN


!-----------------------------------------------------------------------------!
!IsTermServer
! Is this application running on terminal server
!-----------------------------------------------------------------------------!
IsTermServer       PROCEDURE()

  CODE
  RETURN CHOOSE (GetSystemMetrics( SM_REMOTESESSION ) <> 0)


!-----------------------------------------------------------------------------!
!HasTouchInput
! Returns TRUE if the the maximum number of contacts supported by any digitizer in the system is > 0
!-----------------------------------------------------------------------------!
HasTouchInput       PROCEDURE()
  CODE
  RETURN CHOOSE (GetSystemMetrics( SM_MAXIMUMTOUCHES ) <> 0)


!-----------------------------------------------------------------------------!
!GetFileSystemTimeDate
! Get the system File Time and Date for the specified file.
!-----------------------------------------------------------------------------!
GetFileSystemTimeDate PROCEDURE (STRING FileName, BYTE which, *SYSTEMTIME systime)

hFindHandle        LONG,AUTO
gFileFind          GROUP( WIN32_FIND_DATA ),AUTO.
szFindFile         CSTRING(FILE:MaxFileName),AUTO
gTempLocalTime     GROUP(FILETIME),AUTO.

  CODE
  hFindHandle = 0
  szFindFile  = CLIP (FileName)
  CLEAR (gFileFind)

  hFindHandle = FindFirstFile( szFindFile, gFileFind )
  IF hFindHandle = INVALID_LONG_VALUE OR hFindHandle <= 0
    RETURN FALSE
  END

  FindClose (hFindHandle)

  CASE which
  OF 0
    FileTimeToLocalFileTime( gFileFind.ftLastWriteTime, gTempLocalTime )
  OF 1
    FileTimeToLocalFileTime( gFileFind.ftCreationTime, gTempLocalTime )
  OF 2
    FileTimeToLocalFileTime( gFileFind.ftLastAccessTime, gTempLocalTime )
  END

  FileTimeToSystemTime ( gTempLocalTime, systime )
  RETURN TRUE

!-----------------------------------------------------------------------------!
!GetFileTime
! Get the File Time for the specified file.
!-----------------------------------------------------------------------------!
GetFileTime        PROCEDURE ( STRING iFile, BYTE bType=0 )

gTempSystemTime    GROUP(SYSTEMTIME),AUTO.

  CODE
  IF GetFileSystemTimeDate (iFile, bType, gTempSystemTime)
    RETURN DEFORMAT( gTempSystemTime.wHour & ':' & gTempSystemTime.wMinute & ':' & gTempSystemTime.wSecond, @t4 )
  END

  RETURN 0

!-----------------------------------------------------------------------------!
!GetFileDate
! Get the File Date for the specified file.
!-----------------------------------------------------------------------------!
GetFileDate        PROCEDURE ( STRING iFile, BYTE bType=0 )

gTempSystemTime    GROUP(SYSTEMTIME),AUTO.

  CODE
  IF GetFileSystemTimeDate (iFile, bType, gTempSystemTime)
    RETURN DEFORMAT( gTempSystemTime.wMonth & '/' & gTempSystemTime.wDay & '/' & gTempSystemTime.wYear, @d2 )
  END

  RETURN 0

!-----------------------------------------------------------------------------!
!CreateDirectory
! Create a directory
!-----------------------------------------------------------------------------!
CreateDirectory    PROCEDURE ( STRING sDirectory )

szDirName          CSTRING(FILE:MaxFilePath),AUTO

  CODE
  szDirName = CLIP( sDirectory )
  RETURN mkdir ( szDirName )

!-----------------------------------------------------------------------------!
!RemoveDirectory
! Remove a directory
!-----------------------------------------------------------------------------!
RemoveDirectory    PROCEDURE ( STRING sDirectory )

szDirName          CSTRING(FILE:MaxFilePath),AUTO

  CODE
  szDirName = CLIP( sDirectory )
  RETURN rmdir ( szDirName )

!-----------------------------------------------------------------------------!
!GetTempPath
! Retreive the path pointed to by TMP or TEMP
!-----------------------------------------------------------------------------!
GetTempPath        PROCEDURE()

sTmpPath           STRING(FILE:MaxFilePath),AUTO
lPathSize          LONG,AUTO

  CODE
  lPathSize = GetTempPath ( SIZE (sTmpPath), sTmpPath )
  IF lPathSize = 0 OR lPathSize > SIZE (sTmpPath)
    RETURN ''
  ELSE
    RETURN sTmpPath [ 1 : lPathSize ]
  END

!-----------------------------------------------------------------------------!
!GetTempPath
! Retreive the path pointed to by TMP or TEMP
!-----------------------------------------------------------------------------!
GetTempFileName    PROCEDURE ( STRING sPrefix, <STRING sDirectory> )

szPrefix           CSTRING( 4 ),AUTO
szPath             CSTRING(FILE:MaxFilePath),AUTO
szTempname         CSTRING(FILE:MaxFilePath),AUTO

  CODE
  IF OMITTED( 2 )
    szPath = GetTempPath()
    IF CLIP( szPath ) = ''
      szPath = '.'
    END
  ELSE
    szPath = CLIP( sDirectory )
  END
  szPrefix = CLIP( sPrefix )
  IF szPrefix = ''
    szPrefix = '$$$'
  END
  IF GetTempFileName( szPath, szPrefix, 0, szTempName ) = 0
    RETURN ''
  ELSE
    RETURN CLIP( szTempName )
  END

!-----------------------------------------------------------------------------!
!FullDrag
! Query or change full window dragging setting
!-----------------------------------------------------------------------------!
FullDrag           PROCEDURE( <LONG lDragSetting> )

lCurrentSetting    LONG

  CODE
  IF ~OMITTED( 1 )
    SystemParametersInfo(SPI_SETDRAGFULLWINDOWS, lDragSetting, lCurrentSetting, SPIF_SENDWININICHANGE+SPIF_UPDATEINIFILE)
    RETURN lDragSetting
  END
  SystemParametersInfo(SPI_GETDRAGFULLWINDOWS, 0, lCurrentSetting, SPIF_SENDWININICHANGE+SPIF_UPDATEINIFILE)
  RETURN lCurrentSetting

!-----------------------------------------------------------------------------!
!LongToHex
!ShortToHex
!ByteToHex
! Convert numeric values to hexadecimal string
!-----------------------------------------------------------------------------!

LongToHex PROCEDURE(ULONG in, BYTE LowerCase)
Out STRING(8),AUTO
Inb BYTE,DIM(4),OVER(in)
  CODE
  Out[1 : 2] = ByteToHex(Inb[4], LowerCase)
  Out[3 : 4] = ByteToHex(Inb[3], LowerCase)
  Out[5 : 6] = ByteToHex(Inb[2], LowerCase)
  Out[7 : 8] = ByteToHex(Inb[1], LowerCase)
  RETURN Out

ShortToHex PROCEDURE(USHORT in, BYTE LowerCase)
Out STRING(4),AUTO
Inb BYTE,DIM(2),OVER(in)
  CODE
  Out[1 : 2] = ByteToHex(Inb[2], LowerCase)
  Out[3 : 4] = ByteToHex(Inb[1], LowerCase)
  RETURN Out

ByteToHex PROCEDURE(BYTE in, BYTE LowerCase)
Out       STRING(2),AUTO
HEX       &STRING,AUTO
  CODE
  IF LowerCase
    HEX &= HexDigitsLow
  ELSE
    HEX &= HexDigitsUp
  END
  Out[1] = HEX [BSHIFT(in, -4) + 1]
  Out[2] = HEX [BAND(in, 0FH) + 1]
  RETURN Out

!-----------------------------------------------------------------------------!
!BLOBTOFILE
! Copy data from the BLOB field to file
!-----------------------------------------------------------------------------!

  OMIT ('=== DO LINK', lib_mode)
    PRAGMA('link(C%V%DOS%X%%L%.LIB)')
! === DO LINK

BLOBTOFILE  PROCEDURE (*BLOB b, STRING name)
OutFile FILE,DRIVER('DOS'),CREATE
          RECORD
buffer      STRING(32768)
          END
        END
sz      LONG,AUTO
start   LONG,AUTO
amount  LONG,AUTO
CurErr  SIGNED,AUTO
  CODE
  IF name = ''
    RETURN BadFileErr
  END
  sz = b{PROP:Size}
  IF sz = 0
    RETURN 0
  END
  OutFile{PROP:Name} = name
  CREATE (OutFile)
  IF ERRORCODE() THEN RETURN ERRORCODE().
  OPEN (OutFile)
  IF ERRORCODE() THEN RETURN ERRORCODE().
  SEND (OutFile, 'FILEBUFFERS=' & ROUND(sz/512, 1))

  CurErr = 0
  start  = 0
  LOOP WHILE sz <> 0
    amount = SIZE (OutFile.buffer)
    IF amount > sz
      amount = sz
    END
    OutFile.buffer [1 : amount] = b [start : start + amount - 1]
    ADD (OutFile, amount)
    CurErr = ERRORCODE()
    IF CurErr <> 0
      BREAK
    END
    start += amount
    sz    -= amount
  END

  CLOSE (OutFile)
  RETURN CurErr

!-----------------------------------------------------------------------------!
!FILETOBLOB
! Copy data from file to the BLOB field
!-----------------------------------------------------------------------------!

FILETOBLOB  PROCEDURE (STRING name, *BLOB b)
InFile  FILE,DRIVER('DOS')
          RECORD
buffer      STRING(32768)
          END
        END
sz      LONG,AUTO
start   LONG,AUTO
fetch   LONG,AUTO
CurErr  SIGNED,AUTO
  CODE
  IF name = ''
    RETURN BadFileErr
  END
  InFile{PROP:Name} = name
  OPEN (InFile,40h)
  IF ERRORCODE() THEN RETURN ERRORCODE().
  sz = BYTES(InFile)
  IF sz = 0
    CurErr = BadFileErr
  ELSE
    SEND (InFile, 'FILEBUFFERS=' & ROUND(sz/512, 1))
    b{PROP:Size} = sz
    
    CurErr = 0
    start  = 0
    LOOP WHILE sz <> 0
      fetch = SIZE (InFile.buffer)
      IF fetch > sz
        fetch = sz
      END
      GET (InFile, start + 1, fetch)
      CurErr = ERRORCODE()
      IF CurErr <> 0
        BREAK
      END
      b [start : start + fetch - 1] = InFile.buffer [1 : fetch]
      start += fetch
      sz    -= fetch
    END
  END

  CLOSE (InFile)
  RETURN CurErr

!-----------------------------------------------------------------------------!
!ResizeImage
! Resize the image to fit the original control size
! pImagePosition set the position where the image will go
!-----------------------------------------------------------------------------!

ResizeImage PROCEDURE (SIGNED ctl, SIGNED x, SIGNED y, SIGNED w, SIGNED h, <REPORT report>)
RH    SIGNED
RW    SIGNED
NW    SIGNED
NH    SIGNED
Ratio REAL
  CODE
  IF ctl = 0
    RETURN
  END

  IF NOT OMITTED (6)
    SETTARGET (report)
  END

  RW = ctl {PROP:MaxWidth}
  RH = ctl {PROP:MaxHeight}

  IF RW = 0 OR RH = 0
    NW = w!0
    NH = h!0
  ELSE
    Ratio = RW / RH
    NW = h * Ratio

    IF NW > w
      NW = w
      NH = w / Ratio
    ELSE
      NH = h
    END

    x += (w - NW) / 2
    y += (h - NH) / 2
  END

  SETPOSITION (ctl, x, y, NW, NH)

  IF NOT OMITTED (6)
    SETTARGET
  END
  RETURN


!-----------------------------------------------------------------------------!
! ColorToHSL
! Convert a Clarion color to HSL (hue-saturation-lightness)
!-----------------------------------------------------------------------------!
ColorToHSL           PROCEDURE  (LONG pColor,*REAL H,*REAL S,*REAL L)
var_R REAL
var_G REAL
var_B REAL

var_Min REAL
var_Max REAL
del_Max REAL

del_R REAL
del_G REAL
del_B REAL


R                  BYTE
G                  BYTE
B                  BYTE
  CODE
 ColorToRGB(pColor,R,G,B)

 var_R = ( R / 255 )                     !Where RGB values = 0 .. 255
 var_G = ( G / 255 )
 var_B = ( B / 255 )

 var_Min = MinByteValue( R, G, B )/255    !Min. value of RGB
 var_Max = MaxByteValue( R, G, B )/255    !Max. value of RGB
 del_Max = var_Max - var_Min     !Delta RGB value

 L = ( var_Max + var_Min ) / 2

 IF ( del_Max = 0 )                     !This is a gray, no chroma...
   H = 0                                !HSL results = 0 .. 1
   S = 0
 ELSE                                   !Chromatic data...
   IF ( L < 0.5 )
      S = del_Max / ( var_Max + var_Min )
   ELSE
      S = del_Max / ( 2 - var_Max - var_Min )
   END

   del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
   del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
   del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

   IF ( var_R = var_Max )
      H = del_B - del_G
   ELSIF ( var_G = var_Max )
      H = ( 1 / 3 ) + del_R - del_B
   ELSIF ( var_B = var_Max )
      H = ( 2 / 3 ) + del_G - del_R
   END

   IF ( H < 0 )
      H += 1
   END
   IF ( H > 1 )
      H -= 1
   END
 END

!-----------------------------------------------------------------------------!
! ColorToRGB
! Convert a Clarion color to RGB
!-----------------------------------------------------------------------------!
ColorToRGB           PROCEDURE  (LONG pColor,*BYTE R,*BYTE G,*BYTE B)
CWColor            LONG
RGBT               GROUP,OVER(CWColor)
R                    BYTE
G                    BYTE
B                    BYTE
NotUsed              BYTE
                   END
  CODE
  CWColor = pColor
  R=RGBT.R
  G=RGBT.G
  B=RGBT.B

!-----------------------------------------------------------------------------!
! MaxByteValue
! Return the maximum byte value from the 3 bytes passed as parameters
!-----------------------------------------------------------------------------!
MaxByteValue         PROCEDURE  (BYTE A,BYTE B,BYTE C)
  CODE
  IF A>B
     IF A>C
        RETURN A
     END
  ELSE
     IF B>C
        RETURN B
     END
  END
  RETURN C

!-----------------------------------------------------------------------------!
! MinByteValue
! Return the minimum byte value from the 3 bytes passed as parameters
!-----------------------------------------------------------------------------!
MinByteValue         PROCEDURE  (BYTE A,BYTE B,BYTE C)
  CODE
  IF A<B
     IF A<C
        RETURN A
     END
  ELSE
     IF B<C
        RETURN B
     END
  END
  RETURN C

!-----------------------------------------------------------------------------!
! HSLToColor
! Convert an HSL (hue-saturation-lightness) color to a Clarion color
!-----------------------------------------------------------------------------!
HSLToColor           PROCEDURE  (REAL H,REAL S,REAL L,*LONG pColor)
CWColor            LONG
R                  BYTE
G                  BYTE
B                  BYTE

vH                 REAL
v1                 REAL
v2                 REAL
vR                 REAL
  CODE
 !HSL values = 0 to 1
 !RGB results = 0 to 255

 IF S = 0 THEN
   R = L * 255
   G = L * 255
   B = L * 255
 ELSE

   IF ( L < 0.5 ) THEN
      v2 = L * ( 1 + S )
   ELSE
      v2 = ( L + S ) - ( S * L )
   END

   v1 = 2 * L - v2

   vH = H + ( 1 / 3 )
   Do Hue_2_RGB
   R = 255 * vR

   vH = H
   Do Hue_2_RGB
   G = 255 * vR

   vH = H - ( 1 / 3 )
   Do Hue_2_RGB
   B = 255 * vR
 END
 RGBToColor(R,G,B,pColor)

!--------------------------------------------------------------------------------

Hue_2_RGB ROUTINE

   IF ( vH < 0 )
      vH += 1
   END
   IF ( vH > 1 )
      vH -= 1
   END
   IF ( ( 6 * vH ) < 1 )
      vR=( v1 + ( v2 - v1 ) * 6 * vH )
      EXIT
   END
   IF ( ( 2 * vH ) < 1 )
      vR = ( v2 )
      EXIT
   END
   IF ( ( 3 * vH ) < 2 )
      vR= ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 )
      EXIT
   END

   vR = v1

!-----------------------------------------------------------------------------!
! RGBToColor
! Convert an RGB color to a Clarion color
!-----------------------------------------------------------------------------!
RGBToColor      PROCEDURE (BYTE R, BYTE G, BYTE B, *LONG pColor)

RGBT               GROUP,OVER(pColor)
R                    BYTE
G                    BYTE
B                    BYTE
DitherMode           BYTE
                   END

  CODE
  RGBT.R = R
  RGBT.G = G
  RGBT.B = B
  RGBT.DitherMode = SYSTEM {PROP:ColorHighByte}

!-----------------------------------------------------------------------------!
! MixColors
! Mix color1 and color2 using the percentage of mix.
! If pColor1 is white the pColor2 will be the same pColor2 color but bright
! If pColor1 is black the pColor2 will be the same pColor2 color but darker
!-----------------------------------------------------------------------------!

MixColors   PROCEDURE (LONG pColor1, LONG pColor2, BYTE pPercentageMix)

CWColor1           LONG,AUTO
RGBT1              GROUP,OVER(CWColor1)
R                    BYTE
G                    BYTE
B                    BYTE
DitherMode           BYTE
                   END
CWColor2           LONG,AUTO
RGBT2              GROUP,OVER(CWColor2)
R                    BYTE
G                    BYTE
B                    BYTE
DitherMode           BYTE
                   END
RetCWColor         LONG
RetRGBT            GROUP,OVER(RetCWColor)
R                    BYTE
G                    BYTE
B                    BYTE
DitherMode           BYTE
                   END

DitherColors       LONG,AUTO

  CODE
  IF pPercentageMix > 100
     pPercentageMix = 100
  END

  DitherColors = SYSTEM {PROP:ColorHighByte} * 1000000h

  IF BAND (pColor1, 80000000h)
    pColor1 = GetSysColor (BAND (pColor1, 0FFFFh))
  ELSE
    pColor1 = BOR (DitherColors, BAND (pColor1, 0FFFFFFh))
  END
  IF BAND (pColor2, 80000000h)
    pColor2 = GetSysColor (BAND (pColor2, 0FFFFh))
  ELSE
    pColor2 = BOR (DitherColors, BAND (pColor2, 0FFFFFFh))
  END

  CWColor1 = pColor1
  CWColor2 = pColor2

  RetRGBT.R = (RGBT1.R + ((RGBT2.R - RGBT1.R) * pPercentageMix/100))
  RetRGBT.G = (RGBT1.G + ((RGBT2.G - RGBT1.G) * pPercentageMix/100))
  RetRGBT.B = (RGBT1.B + ((RGBT2.B - RGBT1.B) * pPercentageMix/100))
  RetRGBT.DitherMode = 0

  RETURN BOR (RetCWColor, DitherColors)

OpenFileLink PROCEDURE(STRING fileLink,<STRING path>, <STRING params>)
 CODE
    RETURN OpenUrlLink(fileLink,false,path,params)
 
OpenUrlLink PROCEDURE(STRING urlLink,BYTE forceHttp=1,<STRING path>, <STRING params>)
lWHandle         LONG
lOperation       CSTRING(255)
lFileUrl         CSTRING(255)
lPath            CSTRING(255)
lParam           CSTRING(255)
lShowCmd         LONG(1)
lRetVal          ULONG
 CODE
    IF LEFT(UPPER(urlLink),4)<>'HTTP' AND forceHttp
       lFileUrl    = 'http://'&clip(urlLink)
    ELSE
       lFileUrl    = clip(urlLink)
    END
    lWHandle    = 0{PROP:Handle}!Get the handle of the current window
    lOperation  = 'Open'    
    lPath       = path
    lParam      = params
    lShowCmd    = 1
    lRetVal = SV_ShellExecuteURL(lWHandle,lOperation,lFileUrl,lParam,lPath,lShowCmd)
    
    RETURN lRetVal

GetMimeType            PROCEDURE(STRING fileNameExtension)
fileExtension CSTRING(256)
cfileNameExtension CSTRING(256)
 CODE
     IF CLIP(fileNameExtension) =''
        RETURN ''
     END
     cfileNameExtension = fileNameExtension
     PathSplit(cfileNameExtension, , , , fileExtension)
     IF fileExtension=''
        fileExtension = fileNameExtension
     END
     IF fileExtension[1]='.'
        fileExtension = CLIP(SUB(fileExtension,2,LEN(fileExtension)-1))
     END
     CASE LOWER(fileExtension)
     OF 'atom'; RETURN 'application/atom+xml'
     OF 'x'; RETURN 'application/directx'
     OF 'evy'; RETURN 'application/envoy'
     OF 'etl'; RETURN 'application/etl'
     OF 'fif'; RETURN 'application/fractals'
     OF 'fsscript'; RETURN 'application/fsharp-script'
     OF 'fsx'; RETURN 'application/fsharp-script'
     OF 'spl'; RETURN 'application/futuresplash'
     OF 'hta'; RETURN 'application/hta'
     OF 'acx'; RETURN 'application/internet-property-stream'
     OF 'jar'; RETURN 'application/java-archive'
     OF 'json'; RETURN 'application/json'
     OF 'jck'; RETURN 'application/liquidmotion'
     OF 'jcz'; RETURN 'application/liquidmotion'
     OF 'hqx'; RETURN 'application/mac-binhex40'
     OF 'accdb' OROF 'accde' OROF 'accdt' OROF 'ade' OROF 'adp' OROF 'mda' OROF 'mde'
        RETURN 'application/msaccess'
     OF 'accda'; RETURN 'application/msaccess.addin'
     OF 'accdc'; RETURN 'application/msaccess.cab'
     OF 'accft'; RETURN 'application/msaccess.ftemplate'
     OF 'accdr'; RETURN 'application/msaccess.runtime'
     OF 'accdw'; RETURN 'application/msaccess.webapplication'
     OF 'vsi'; RETURN 'application/ms-vsi'
     OF 'doc' OROF 'dot' OROF 'wbk' OROF 'wiz'
        RETURN 'application/msword'
     OF 'aaf' OROF 'aca' OROF 'afm' OROF 'asd' OROF 'asi' OROF 'bin' OROF 'cab' OROF 'chm' OROF 'cur' OROF 'dat' OROF 'deploy' OROF 'dsp'
     OROF 'dwp' OROF 'emz' OROF 'eot' OROF 'exe' OROF 'fla' OROF 'hhk' OROF 'hhp' OROF 'hxd' OROF 'hxh' OROF 'hxi' OROF 'hxq' OROF 'hxr'
     OROF 'hxs' OROF 'hxw' OROF 'ics' OROF 'inf' OROF 'java' OROF 'jpb' OROF 'lpk' OROF 'lzh' OROF 'mdp' OROF 'mix'
     OROF 'msi' OROF 'mso' OROF 'ocx' OROF 'pcx' OROF 'pcz' OROF 'pfb' OROF 'pfm' OROF 'prm' OROF 'prx' OROF 'psd'
     OROF 'psm' OROF 'psp' OROF 'qxd' OROF 'rar' OROF 'sea' OROF 'smi' OROF 'snp' OROF 'thn' OROF 'toc' OROF 'ttf'
     OROF 'u32' OROF 'xsn' OROF 'xtp'
        RETURN 'application/octet-stream'
     OF 'oda' OROF 'axs' OROF 'one' OROF 'onea' OROF 'onepkg' OROF 'onetmp' OROF 'onetoc' OROF 'onetoc2'
        RETURN 'application/onenote'
     OF 'osdx'; RETURN 'application/opensearchdescription+xml'
     OF 'pdf'; RETURN 'application/pdf'
     OF 'prf'; RETURN 'application/pics-rules'
     OF 'p10'; RETURN 'application/pkcs10'
     OF 'p7c' OROF 'p7m'
        RETURN 'application/pkcs7-mime'
     OF 'p7s'; RETURN 'application/pkcs7-signature'
     OF 'crl'; RETURN 'application/pkix-crl'
     OF 'ai' OROF 'eps' OROF 'ps'
        RETURN 'application/postscript'
     OF 'psc1'; RETURN 'application/powershell'
     OF 'rat'; RETURN 'application/rat-file'
     OF 'rtf'; RETURN 'application/rtf'
     OF 'sdp'; RETURN 'application/sdp'
     OF 'setpay'; RETURN 'application/set-payment-initiation'
     OF 'setreg'; RETURN 'application/set-registration-initiation'
     OF 'ssm'; RETURN 'application/streamingmedia'
     OF 'air'; RETURN 'application/vnd.adobe.air-application-installer-package+zip'
     OF 'fdf'; RETURN 'application/vnd.fdf'
     OF 'slk' OROF 'xla' OROF 'xlc' OROF 'xld' OROF 'xlk' OROF 'xll' OROF 'xlm' OROF 'xls' OROF 'xlt' OROF 'xlw' 
        RETURN 'application/vnd.ms-excel'
     OF 'xlam'; RETURN 'application/vnd.ms-excel.addin.macroEnabled.12'
     OF 'xlsb'; RETURN 'application/vnd.ms-excel.sheet.binary.macroEnabled.12'
     OF 'xlsm'; RETURN 'application/vnd.ms-excel.sheet.macroEnabled.12'
     OF 'xltm'; RETURN 'application/vnd.ms-excel.template.macroEnabled.12'
     OF 'mpf'; RETURN 'application/vnd.ms-mediapackage'
     OF 'calx'; RETURN 'application/vnd.ms-office.calx'
     OF 'thmx'; RETURN 'application/vnd.ms-officetheme'
     OF 'sst'; RETURN 'application/vnd.ms-pki.certstore'
     OF 'pko'; RETURN 'application/vnd.ms-pki.pko'
     OF 'cat'; RETURN 'application/vnd.ms-pki.seccat'
     OF 'stl'; RETURN 'application/vnd.ms-pki.stl'
     OF 'pot' OROF 'ppa' OROF 'pps' OROF 'ppt' OROF 'pwz'
        RETURN 'application/vnd.ms-powerpoint'
     OF 'ppam'; RETURN 'application/vnd.ms-powerpoint.addin.macroEnabled.12'
     OF 'pptm'; RETURN 'application/vnd.ms-powerpoint.presentation.macroEnabled.12'
     OF 'sldm'; RETURN 'application/vnd.ms-powerpoint.slide.macroEnabled.12'
     OF 'ppsm'; RETURN 'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
     OF 'potm'; RETURN 'application/vnd.ms-powerpoint.template.macroEnabled.12'
     OF 'mpp'; RETURN 'application/vnd.ms-project'
     OF 'vdx'; RETURN 'application/vnd.ms-visio.viewer'
     OF 'docm'; RETURN 'application/vnd.ms-word.document.macroEnabled.12'
     OF 'dotm'; RETURN 'application/vnd.ms-word.template.macroEnabled.12'
     OF 'wcm' OROF 'wdb' OROF 'wks' OROF 'wps' 
        RETURN 'application/vnd.ms-works'
     OF 'wpl'; RETURN 'application/vnd.ms-wpl'
     OF 'xps'; RETURN 'application/vnd.ms-xpsdocument'
     OF 'odc'; RETURN 'application/vnd.oasis.opendocument.chart'
     OF 'odb'; RETURN 'application/vnd.oasis.opendocument.database'
     OF 'odf'; RETURN 'application/vnd.oasis.opendocument.formula'
     OF 'odg'; RETURN 'application/vnd.oasis.opendocument.graphics'
     OF 'otg'; RETURN 'application/vnd.oasis.opendocument.graphics-template'
     OF 'odi'; RETURN 'application/vnd.oasis.opendocument.image'
     OF 'odp'; RETURN 'application/vnd.oasis.opendocument.presentation'
     OF 'otp'; RETURN 'application/vnd.oasis.opendocument.presentation-template'
     OF 'ods'; RETURN 'application/vnd.oasis.opendocument.spreadsheet'
     OF 'ots'; RETURN 'application/vnd.oasis.opendocument.spreadsheet-template'
     OF 'odt'; RETURN 'application/vnd.oasis.opendocument.text'
     OF 'odm'; RETURN 'application/vnd.oasis.opendocument.text-master'
     OF 'ott'; RETURN 'application/vnd.oasis.opendocument.text-template'
     OF 'oth'; RETURN 'application/vnd.oasis.opendocument.text-web'
     OF 'oxt'; RETURN 'application/vnd.openofficeorg.extension'
     OF 'pptx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
     OF 'sldx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.slide'
     OF 'ppsx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'
     OF 'potx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.template'
     OF 'xlsx'; RETURN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
     OF 'xltx'; RETURN 'application/vnd.openxmlformats-officedocument.spreadsheetml.template'
     OF 'docx'; RETURN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
     OF 'dotx'; RETURN 'application/vnd.openxmlformats-officedocument.wordprocessingml.template'
     OF 'rm'; RETURN 'application/vnd.rn-realmedia'
     OF 'rmp'; RETURN 'application/vnd.rn-rn_music_package'
     OF 'vsd' OROF 'vss' OROF 'vst' OROF 'vsw' OROF 'vsx' OROF 'vtx' 
        RETURN 'application/vnd.visio'
     OF 'wmlc'; RETURN 'application/vnd.wap.wmlc'
     OF 'wmlsc'; RETURN 'application/vnd.wap.wmlscriptc'
     OF 'vsix'; RETURN 'application/vsix'
     OF 'library-ms'; RETURN 'application/windows-library+xml'
     OF 'searchconnector-ms'; RETURN 'application/windows-search-connector+xml'
     OF 'hlp'; RETURN 'application/winhlp'
     OF 'wlmp'; RETURN 'application/wlmoviemaker'
     OF '7z'; RETURN 'application/x-7z-compressed'
     OF 'xaml'; RETURN 'application/xaml+xml'
     OF 'bcpio'; RETURN 'application/x-bcpio'
     OF 'adobebridge'; RETURN 'application/x-bridge-url'
     OF 'cdf'; RETURN 'application/x-cdf'
     OF 'z'; RETURN 'application/x-compress'
     OF 'tgz'; RETURN 'application/x-compressed'
     OF 'cpio'; RETURN 'application/x-cpio'
     OF 'csh'; RETURN 'application/x-csh'
     OF 'dcr' OROF 'dir' OROF 'dxr'
        RETURN 'application/x-director'
     OF 'dvi'; RETURN 'application/x-dvi'
     OF 'gtar'; RETURN 'application/x-gtar'
     OF 'gz'; RETURN 'application/x-gzip'
     OF 'hdf'; RETURN 'application/x-hdf'
     OF 'xht' OROF 'xhtml'
        RETURN 'application/xhtml+xml'
     OF 'ins' OROF 'isp' 
        RETURN 'application/x-internet-signup'
     OF 'iii'; RETURN 'application/x-iphone'
     OF 'ipa'; RETURN 'application/x-itunes-ipa'
     OF 'ipg'; RETURN 'application/x-itunes-ipg'
     OF 'ipsw'; RETURN 'application/x-itunes-ipsw'
     OF 'ite'; RETURN 'application/x-itunes-ite'
     OF 'itlp'; RETURN 'application/x-itunes-itlp'
     OF 'itms'; RETURN 'application/x-itunes-itms'
     OF 'itpc'; RETURN 'application/x-itunes-itpc'
     OF 'class'; RETURN 'application/x-java-applet'
     OF 'jnlp'; RETURN 'application/x-java-jnlp-file'
     OF 'js'; RETURN 'application/x-javascript'
     OF 'latex'; RETURN 'application/x-latex'
     OF 'mvc'; RETURN 'application/x-miva-compiled'
     OF 'asa' OROF 'asax' OROF 'ascx' OROF 'ashx' OROF 'asmx' OROF 'aspx' OROF 'config' OROF 'coverage' OROF 'datasource' OROF 'dgml' 
     OROF 'filters' OROF 'generictest' OROF 'hxa' OROF 'hxc' OROF 'hxe' OROF 'hxf' OROF 'hxk' OROF 'hxv' OROF 'loadtest' OROF 'master' 
     OROF 'mtx' OROF 'orderedtest' OROF 'psess' OROF 'rdlc' OROF 'resx' OROF 'ruleset' OROF 'settings' OROF 'sitemap' OROF 'skin' 
     OROF 'snippet' OROF 'svc' OROF 'testrunconfig' OROF 'testsettings' OROF 'trx' OROF 'vcproj' OROF 'vcxproj' OROF 'vscontent' OROF 'vsmdi' 
     OROF 'webtest' OROF 'wiq' OROF 'xmta' OROF 'xsc' OROF 'xss'
        RETURN 'application/xml'
     OF 'mxp'; RETURN 'application/x-mmxp'
     OF 'amc'; RETURN 'application/x-mpeg'
     OF 'mdb'; RETURN 'application/x-msaccess'
     OF 'application'; RETURN 'application/x-ms-application'
     OF 'crd'; RETURN 'application/x-mscardfile'
     OF 'clp'; RETURN 'application/x-msclip'
     OF 'dll'; RETURN 'application/x-msdownload'
     OF 'slupkg-ms'; RETURN 'application/x-ms-license'
     OF 'manifest'; RETURN 'application/x-ms-manifest'
     OF 'm13' OROF 'm14' OROF 'mvb'
        RETURN 'application/x-msmediaview'
     OF 'wmf'; RETURN 'application/x-msmetafile'
     OF 'mny'; RETURN 'application/x-msmoney'
     OF 'pub'; RETURN 'application/x-mspublisher'
     OF 'lit'; RETURN 'application/x-ms-reader'
     OF 'scd'; RETURN 'application/x-msschedule'
     OF 'trm'; RETURN 'application/x-msterminal'
     OF 'vsto'; RETURN 'application/x-ms-vsto'
     OF 'wmd'; RETURN 'application/x-ms-wmd'
     OF 'wmz'; RETURN 'application/x-ms-wmz'
     OF 'wri'; RETURN 'application/x-mswrite'
     OF 'xbap'; RETURN 'application/x-ms-xbap'
     OF 'nc'; RETURN 'application/x-netcdf'
     OF 'hhc'; RETURN 'application/x-oleobject'
     OF 'pma' OROF 'pmc' OROF 'pml' OROF 'pmr' OROF 'pmw' 
        RETURN 'application/x-perfmon'
     OF 'p12' OROF 'pfx'
        RETURN 'application/x-pkcs12'
     OF 'p7b' OROF 'spc'
        RETURN 'application/x-pkcs7-certificates'
     OF 'p7r'; RETURN 'application/x-pkcs7-certreqresp'
     OF 'pcast'; RETURN 'application/x-podcast'
     OF 'qtl'; RETURN 'application/x-quicktimeplayer'
     OF 'safariextz'; RETURN 'application/x-safari-safariextz'
     OF 'webarchive'; RETURN 'application/x-safari-webarchive'
     OF 'sgimb'; RETURN 'application/x-sgimb'
     OF 'sh'; RETURN 'application/x-sh'
     OF 'shar'; RETURN 'application/x-shar'
     OF 'mfp' OROF 'swf'
        RETURN 'application/x-shockwave-flash'
     OF 'xap'; RETURN 'application/x-silverlight-app'
     OF 'mmf'; RETURN 'application/x-smaf'
     OF 'sit'; RETURN 'application/x-stuffit'
     OF 'sv4cpio'; RETURN 'application/x-sv4cpio'
     OF 'sv4crc'; RETURN 'application/x-sv4crc'
     OF 'tar'; RETURN 'application/x-tar'
     OF 'tcl'; RETURN 'application/x-tcl'
     OF 'tex'; RETURN 'application/x-tex'
     OF 'texi'; RETURN 'application/x-texinfo'
     OF 'texinfo'; RETURN 'application/x-texinfo'
     OF 'roff'; RETURN 'application/x-troff'
     OF 't' OROF 'tr'
        RETURN 'application/x-troff'
     OF 'man'; RETURN 'application/x-troff-man'
     OF 'me'; RETURN 'application/x-troff-me'
     OF 'ms'; RETURN 'application/x-troff-ms'
     OF 'ustar'; RETURN 'application/x-ustar'
     OF 'src'; RETURN 'application/x-wais-source'
     OF 'wlpginstall3'; RETURN 'application/x-wlpg3-detect'
     OF 'wlpginstall'; RETURN 'application/x-wlpg-detect'
     OF 'cer' OROF 'crt' OROF 'der'
        RETURN 'application/x-x509-ca-cert'
     OF 'zip'; RETURN 'application/x-zip-compressed'
     OF 'aac' OROF 'adts'
        RETURN 'audio/aac'
     OF 'ac3'; RETURN 'audio/ac3'
     OF 'aifc' OROF 'aiff' OROF 'cdda' 
        RETURN 'audio/aiff'
     OF 'aa'; RETURN 'audio/audible'
     OF 'au'; RETURN 'audio/basic'
     OF 'snd'; RETURN 'audio/basic'
     OF 'm4a'; RETURN 'audio/m4a'
     OF 'm4b'; RETURN 'audio/m4b'
     OF 'm4p'; RETURN 'audio/m4p'
     OF 'mid'; RETURN 'audio/mid'
     OF 'midi' OROF 'rmi' 
        RETURN 'audio/mid'
     OF 'mp3'; RETURN 'audio/mpeg'
     OF 'pls'; RETURN 'audio/scpls'
     OF 'aax'; RETURN 'audio/vnd.audible.aax'
     OF 'adt'; RETURN 'audio/vnd.dlna.adts'
     OF 'wav' OROF 'wave' 
        RETURN 'audio/wav'
     OF 'aif'; RETURN 'audio/x-aiff'
     OF 'caf'; RETURN 'audio/x-caf'
     OF 'gsm'; RETURN 'audio/x-gsm'
     OF 'm4r'; RETURN 'audio/x-m4r'
     OF 'm3u' OROF 'm3u8'
        RETURN 'audio/x-mpegurl'
     OF 'wax'; RETURN 'audio/x-ms-wax'
     OF 'wma'; RETURN 'audio/x-ms-wma'
     OF 'ra' OROF 'ram' 
        RETURN 'audio/x-pn-realaudio'
     OF 'rpm'; RETURN 'audio/x-pn-realaudio-plugin'
     OF 'sd2'; RETURN 'audio/x-sd2'
     OF 'smd' OROF 'smx' OROF 'smz' 
        RETURN 'audio/x-smd'
     OF 'dwf'; RETURN 'drawing/x-dwf'
     OF 'bmp' OROF 'dib' 
        RETURN 'image/bmp'
     OF 'cod'; RETURN 'image/cis-cod'
     OF 'gif'; RETURN 'image/gif'
     OF 'ief'; RETURN 'image/ief'
     OF 'jpe' OROF 'jpeg' OROF 'jpg'
        RETURN 'image/jpeg'     
     OF 'pct' OROF 'pic' 
        RETURN 'image/pict'
     OF 'pict'; RETURN 'image/pict'
     OF 'jfif'; RETURN 'image/pjpeg'
     OF 'png' OROF 'pnz'
        RETURN 'image/png'
     OF 'svg'; RETURN 'image/svg+xml'
     OF 'tif' OROF 'tiff'
        RETURN 'image/tiff'
     OF 'wdp'; RETURN 'image/vnd.ms-photo'
     OF 'rf'; RETURN 'image/vnd.rn-realflash'
     OF 'wbmp'; RETURN 'image/vnd.wap.wbmp'
     OF 'ras'; RETURN 'image/x-cmu-raster'
     OF 'cmx'; RETURN 'image/x-cmx'
     OF 'ico'; RETURN 'image/x-icon'
     OF 'art'; RETURN 'image/x-jg'
     OF 'mac' OROF 'pnt'
        RETURN 'image/x-macpaint'
     OF 'pntg'; RETURN 'image/x-macpaint'
     OF 'pnm'; RETURN 'image/x-portable-anymap'
     OF 'pbm'; RETURN 'image/x-portable-bitmap'
     OF 'pgm'; RETURN 'image/x-portable-graymap'
     OF 'ppm'; RETURN 'image/x-portable-pixmap'
     OF 'qti' OROF 'qtif'
        RETURN 'image/x-quicktime'
     OF 'rgb'; RETURN 'image/x-rgb'
     OF 'xbm'; RETURN 'image/x-xbitmap'
     OF 'xpm'; RETURN 'image/x-xpixmap'
     OF 'xwd'; RETURN 'image/x-xwindowdump'
     OF 'eml' OROF 'mht'
        RETURN 'message/rfc822'
     OF 'mhtml' OROF 'nws'
        RETURN 'message/rfc822'
     OF 'css'; RETURN 'text/css'
     OF 'csv'; RETURN 'text/csv'
     OF 'dlm'; RETURN 'text/dlm'
     OF '323'; RETURN 'text/h323'
     OF 'htm' OROF 'html' OROF 'hxt' OROF 'shtml' 
        RETURN 'text/html'
     OF 'uls'; RETURN 'text/iuls'
     OF 'jsx'; RETURN 'text/jscript'
     OF 'asm' OROF 'bas' OROF 'c' OROF 'cc' OROF 'cd' OROF 'cnf' OROF 'cpp' OROF 'cs' OROF 'csdproj' OROF 'csproj' 
     OROF 'cxx' OROF 'dbproj' OROF 'def' OROF 'dsw' OROF 'h' OROF 'hpp' OROF 'hxx' OROF 'i' OROF 'idl' OROF 'inc' 
     OROF 'inl' OROF 'ipproj' OROF 'jsxbin' OROF 'lst' OROF 'mak' OROF 'map' OROF 'mk' OROF 'odh' OROF 'odl' OROF 'pkgdef' 
     OROF 'pkgundef' OROF 'rc' OROF 'rc2' OROF 'rct' OROF 'rgs' OROF 's' OROF 'sln' OROF 'sol' OROF 'sor' OROF 'srf' OROF 'tlh' 
     OROF 'tli' OROF 'txt' OROF 'user' OROF 'vb' OROF 'vbdproj' OROF 'vbproj' OROF 'vcs' OROF 'vddproj' OROF 'vdp' OROF 'vdproj' OROF 'vspscc' 
     OROF 'vsscc' OROF 'vssscc' OROF 'xdr' OROF 'xoml'
        RETURN 'text/plain'
     OF 'rtx'; RETURN 'text/richtext'
     OF 'sct' OROF 'wsc'
        RETURN 'text/scriptlet'
     OF 'sgml'; RETURN 'text/sgml'
     OF 'tsv'; RETURN 'text/tab-separated-values'
     OF 'vbs'; RETURN 'text/vbscript'
     OF 'wml'; RETURN 'text/vnd.wap.wml'
     OF 'wmls'; RETURN 'text/vnd.wap.wmlscript'
     OF 'htt'; RETURN 'text/webviewhtml'
     OF 'htc'; RETURN 'text/x-component'
     OF 'hdml'; RETURN 'text/x-hdml'
     OF 'qht' OROF 'qhtm'
        RETURN 'text/x-html-insertion'
     OF 'addin' OROF 'disco' OROF 'dll.config' OROF 'dtd' OROF 'dtsconfig' OROF 'exe.config' OROF 'mno' OROF 'ssisdeploymentmanifest' 
     OROF 'vml' OROF 'vsct' OROF 'vsixlangpack' OROF 'vsixmanifest' OROF 'vssettings' OROF 'vstemplate' OROF 'wsdl' OROF 'xml' 
     OROF 'xrm-ms' OROF 'xsd' OROF 'xsf' OROF 'xsl' OROF 'xslt'
        RETURN 'text/xml'
     OF 'contact'; RETURN 'text/x-ms-contact'
     OF 'group'; RETURN 'text/x-ms-group'
     OF 'iqy'; RETURN 'text/x-ms-iqy'
     OF 'rqy'; RETURN 'text/x-ms-rqy'
     OF 'etx'; RETURN 'text/x-setext'
     OF 'vcf'; RETURN 'text/x-vcard'
     OF '3gp' OROF '3gpp'
        RETURN 'video/3gpp'
     OF '3g2' OROF '3gp2'
        RETURN 'video/3gpp2'
     OF 'divx'; RETURN 'video/divx'
     OF 'mp4' OROF 'mp4v'
        RETURN 'video/mp4'
     OF 'm1v' OROF 'm2v' OROF 'mod' OROF 'mp2' OROF 'mp2v' OROF 'mpa' OROF 'mpe' OROF 'mpeg' OROF 'mpg' OROF 'mpv2' OROF 'vbk'
        RETURN 'video/mpeg'
     OF 'ogv'; RETURN 'video/ogg'
     OF 'mov' OROF 'mqv' OROF 'qt'
        RETURN 'video/quicktime'
     OF 'm2t' OROF 'm2ts' OROF 'mts' OROF 'ts' OROF 'tts'
        RETURN 'video/vnd.dlna.mpeg-tts'
     OF 'webm'; RETURN 'video/webm'
     OF 'dif'; RETURN 'video/x-dv'
     OF 'dv'; RETURN 'video/x-dv'
     OF 'flv'; RETURN 'video/x-flv'
     OF 'ivf'; RETURN 'video/x-ivf'
     OF 'lsf' OROF 'lsx' 
        RETURN 'video/x-la-asf'
     OF 'm4v'; RETURN 'video/x-m4v'
     OF 'asf' OROF 'asr' OROF 'asx' OROF 'nsc' 
        RETURN 'video/x-ms-asf'
     OF 'avi'; RETURN 'video/x-msvideo'
     OF 'wm'; RETURN 'video/x-ms-wm'
     OF 'wmp'; RETURN 'video/x-ms-wmp'
     OF 'wmv'; RETURN 'video/x-ms-wmv'
     OF 'wmx' OROF 'wvx'
        RETURN 'video/x-ms-wvx'
     OF 'movie'; RETURN 'video/x-sgi-movie'
     OF 'flr' OROF 'wrl' OROF 'wrz' OROF 'xaf' OROF 'xof'
        RETURN 'x-world/x-vrml'
     ELSE
         RETURN 'application/octet-stream'
     END
