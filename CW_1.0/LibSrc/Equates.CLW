! Event numbers

! Field-specific events (FIELD() returns field number)

EVENT:Accepted      EQUATE (01H)
EVENT:NewSelection  EQUATE (02H)
EVENT:ScrollUp      EQUATE (03H)
EVENT:ScrollDown    EQUATE (04H)
EVENT:PageUp        EQUATE (05H)
EVENT:PageDown      EQUATE (06H)
EVENT:ScrollTop     EQUATE (07H)
EVENT:ScrollBottom  EQUATE (08H)
EVENT:Locate        EQUATE (09H)

EVENT:MouseDown     EQUATE (01H)
EVENT:MouseUp       EQUATE (0aH)
EVENT:MouseIn       EQUATE (0bH)
EVENT:MouseOut      EQUATE (0cH)
EVENT:MouseMove     EQUATE (0dH)
EVENT:VBXevent      EQUATE (0eH)
EVENT:AlertKey      EQUATE (0fH)
EVENT:PreAlertKey   EQUATE (10H)
EVENT:Dragging      EQUATE (11H)
EVENT:Drag          EQUATE (12H)
EVENT:Drop          EQUATE (13H)
EVENT:ScrollDrag    EQUATE (14H)

EVENT:Selected      EQUATE (101H)

! Field-independent events (FIELD() returns 0)

EVENT:CloseWindow   EQUATE (201H)
EVENT:CloseDown     EQUATE (202H)
EVENT:OpenWindow    EQUATE (203H)
EVENT:OpenFailed    EQUATE (204H)
EVENT:LoseFocus     EQUATE (205H)
EVENT:GainFocus     EQUATE (206H)

EVENT:Suspend       EQUATE (208H)
EVENT:Resume        EQUATE (209H)
EVENT:Notify        EQUATE (20AH)
EVENT:Timer         EQUATE (20BH)
EVENT:DDErequest    EQUATE (20CH)
EVENT:DDEadvise     EQUATE (20DH)
EVENT:DDEdata       EQUATE (20EH)
EVENT:DDEcommand    EQUATE (20FH)    ! same as DDEexecute
EVENT:DDEexecute    EQUATE (20FH)
EVENT:DDEpoke       EQUATE (210H)
EVENT:DDEclosed     EQUATE (211H)

EVENT:Move          EQUATE (220H)
EVENT:Size          EQUATE (221H)
EVENT:Restore       EQUATE (222H)
EVENT:Maximize      EQUATE (223H)
EVENT:Iconize       EQUATE (224H)
EVENT:Completed     EQUATE (225H)
EVENT:Moved         EQUATE (230H)
EVENT:Sized         EQUATE (231H)
EVENT:Restored      EQUATE (232H)
EVENT:Maximized     EQUATE (233H)
EVENT:Iconized      EQUATE (234H)

! User-definable events

EVENT:User          EQUATE (400H)
EVENT:Last          EQUATE (0FFFH)

STD:WindowList    EQUATE (1)
STD:TileWindow    EQUATE (2)
STD:CascadeWindow EQUATE (3)
STD:ArrangeIcons  EQUATE (4)
STD:HelpIndex     EQUATE (5)
STD:HelpOnHelp    EQUATE (6)
STD:HelpSearch    EQUATE (7)
STD:Help          EQUATE (8)
STD:Cut           EQUATE (10)
STD:Copy          EQUATE (11)
STD:Paste         EQUATE (12)
STD:Clear         EQUATE (13)
STD:Undo          EQUATE (14)
STD:Close         EQUATE (15)
STD:PrintSetup    EQUATE (16)

CURSOR:None       EQUATE ('<0FFH,01H,00H,00H>')
CURSOR:Arrow      EQUATE ('<0FFH,01H,01H,7FH>')
CURSOR:IBeam      EQUATE ('<0FFH,01H,02H,7FH>')
CURSOR:Wait       EQUATE ('<0FFH,01H,03H,7FH>')
CURSOR:Cross      EQUATE ('<0FFH,01H,04H,7FH>')
CURSOR:UpArrow    EQUATE ('<0FFH,01H,05H,7FH>')
CURSOR:Size       EQUATE ('<0FFH,01H,81H,7FH>')
CURSOR:Icon       EQUATE ('<0FFH,01H,82H,7FH>')
CURSOR:SizeNWSE   EQUATE ('<0FFH,01H,83H,7FH>')
CURSOR:SizeNESW   EQUATE ('<0FFH,01H,84H,7FH>')
CURSOR:SizeWE     EQUATE ('<0FFH,01H,85H,7FH>')
CURSOR:SizeNS     EQUATE ('<0FFH,01H,86H,7FH>')
CURSOR:DragWE     EQUATE ('<0FFH,02H,01H,7FH>')

ICON:None         EQUATE ('<0FFH,01H,00H,00H>')
ICON:Application  EQUATE ('<0FFH,01H,01H,7FH>')
ICON:Hand         EQUATE ('<0FFH,01H,02H,7FH>')
ICON:Question     EQUATE ('<0FFH,01H,03H,7FH>')
ICON:Exclamation  EQUATE ('<0FFH,01H,04H,7FH>')
ICON:Asterisk     EQUATE ('<0FFH,01H,05H,7FH>')
ICON:Pick         EQUATE ('<0FFH,02H,01H,7FH>')
ICON:Save         EQUATE ('<0FFH,02H,02H,7FH>')
ICON:Print        EQUATE ('<0FFH,02H,03H,7FH>')
ICON:Paste        EQUATE ('<0FFH,02H,04H,7FH>')
ICON:Open         EQUATE ('<0FFH,02H,05H,7FH>')
ICON:New          EQUATE ('<0FFH,02H,06H,7FH>')
ICON:Help         EQUATE ('<0FFH,02H,07H,7FH>')
ICON:Cut          EQUATE ('<0FFH,02H,08H,7FH>')
ICON:Copy         EQUATE ('<0FFH,02H,09H,7FH>')
ICON:Child        EQUATE ('<0FFH,02H,0AH,7FH>')
ICON:Frame        EQUATE ('<0FFH,02H,0BH,7FH>')

ICON:VCRtop         EQUATE ('<0FFH,02H,81H,7FH>')
ICON:VCRrewind      EQUATE ('<0FFH,02H,82H,7FH>')
ICON:VCRback        EQUATE ('<0FFH,02H,83H,7FH>')
ICON:VCRplay        EQUATE ('<0FFH,02H,84H,7FH>')
ICON:VCRfastforward EQUATE ('<0FFH,02H,85H,7FH>')
ICON:VCRbottom      EQUATE ('<0FFH,02H,86H,7FH>')
ICON:VCRlocate      EQUATE ('<0FFH,02H,87H,7FH>')


BEEP:SystemDefault      EQUATE (0000H)
BEEP:SystemHand         EQUATE (0010H)
BEEP:SystemQuestion     EQUATE (0020H)
BEEP:SystemExclamation  EQUATE (0030H)
BEEP:SystemAsterisk     EQUATE (0040H)

INCLUDE 'property.clw'

COLOR:NONE              EQUATE (-1)
COLOR:SCROLLBAR         EQUATE (80000000H)
COLOR:BACKGROUND        EQUATE (80000001H)
COLOR:ACTIVECAPTION     EQUATE (80000002H)
COLOR:INACTIVECAPTION   EQUATE (80000003H)
COLOR:MENU              EQUATE (80000004H)
COLOR:WINDOW            EQUATE (80000005H)
COLOR:WINDOWFRAME       EQUATE (80000006H)
COLOR:MENUTEXT          EQUATE (80000007H)
COLOR:WINDOWTEXT        EQUATE (80000008H)
COLOR:CAPTIONTEXT       EQUATE (80000009H)
COLOR:ACTIVEBORDER      EQUATE (8000000AH)
COLOR:INACTIVEBORDER    EQUATE (8000000BH)
COLOR:APPWORKSPACE      EQUATE (8000000CH)
COLOR:HIGHLIGHT         EQUATE (8000000DH)
COLOR:HIGHLIGHTTEXT     EQUATE (8000000EH)
COLOR:BTNFACE           EQUATE (8000000FH)
COLOR:BTNSHADOW         EQUATE (80000010H)
COLOR:GRAYTEXT          EQUATE (80000011H)
COLOR:BTNTEXT           EQUATE (80000012H)
COLOR:INACTIVECAPTIONTEXT EQUATE (80000013H)
COLOR:BTNHIGHLIGHT        EQUATE (80000014H)

COLOR:Black             EQUATE (0000000H)
COLOR:Maroon            EQUATE (0000080H)
COLOR:Green             EQUATE (0008000H)
COLOR:Olive             EQUATE (0008080H)
COLOR:Navy              EQUATE (0800000H)
COLOR:Purple            EQUATE (0800080H)
COLOR:Teal              EQUATE (0808000H)
COLOR:Gray              EQUATE (0808080H)
COLOR:Silver            EQUATE (0C0C0C0H)
COLOR:Red               EQUATE (00000FFH)
COLOR:Lime              EQUATE (000FF00H)
COLOR:Yellow            EQUATE (000FFFFH)
COLOR:Blue              EQUATE (0FF0000H)
COLOR:Fuschia           EQUATE (0FF00FFH)
COLOR:Aqua              EQUATE (0FFFF00H)
COLOR:White             EQUATE (0FFFFFFH)

! Parameter to CREATE / Return value from PROP:type

CREATE:sstring          EQUATE (1)
CREATE:string           EQUATE (2)
CREATE:image            EQUATE (3)
CREATE:region           EQUATE (4)
CREATE:line             EQUATE (5)
CREATE:box              EQUATE (6)
CREATE:ellipse          EQUATE (7)
CREATE:entry            EQUATE (8)
CREATE:button           EQUATE (9)
CREATE:prompt           EQUATE (10)
CREATE:option           EQUATE (11)
CREATE:check            EQUATE (12)
CREATE:group            EQUATE (13)
CREATE:list             EQUATE (14)
CREATE:combo            EQUATE (15)
CREATE:spin             EQUATE (16)
CREATE:text             EQUATE (17)
CREATE:custom           EQUATE (18)
CREATE:menu             EQUATE (19)
CREATE:item             EQUATE (20)
CREATE:radio            EQUATE (21)
CREATE:application      EQUATE (24)    ! return value only
CREATE:window           EQUATE (25)    ! return value only
CREATE:report           EQUATE (26)    ! return value only
CREATE:header           EQUATE (27)    ! return value only
CREATE:footer           EQUATE (28)    ! return value only
CREATE:break            EQUATE (29)    ! return value only
CREATE:form             EQUATE (30)    ! return value only
CREATE:detail           EQUATE (31)    ! return value only
CREATE:droplist         EQUATE (33)
CREATE:dropcombo        EQUATE (34)

CREATE:TOOLBAR          EQUATE (128)

FONT:thin               EQUATE (100)
FONT:regular            EQUATE (400)
FONT:bold               EQUATE (700)
FONT:fixed              EQUATE (0800H)
FONT:italic             EQUATE (01000H)
FONT:underline          EQUATE (02000H)
FONT:strikeout          EQUATE (04000H)

PEN:solid           EQUATE (0)
PEN:dash                EQUATE (1)
PEN:dot                 EQUATE (2)
PEN:dashdot             EQUATE (3)
PEN:dashdotdot          EQUATE (4)
PEN:null                EQUATE (5)
PEN:insideframe         EQUATE (6)

FALSE                   EQUATE (0)
TRUE                    EQUATE (1)


VBXEVENT:Click          EQUATE (0)
VBXEVENT:DblClick       EQUATE (1)
VBXEVENT:GotFocus       EQUATE (4)
VBXEVENT:KeyDown        EQUATE (5)
VBXEVENT:KeyPress       EQUATE (6)
VBXEVENT:KeyUp          EQUATE (7)
VBXEVENT:LostFocus      EQUATE (8)
VBXEVENT:MouseDown      EQUATE (9)
VBXEVENT:MouseMove      EQUATE (10)
VBXEVENT:MouseUp        EQUATE (11)

BUTTON:OK               EQUATE (01H)
BUTTON:YES              EQUATE (02H)
BUTTON:NO               EQUATE (04H)
BUTTON:ABORT            EQUATE (08H)
BUTTON:RETRY            EQUATE (10H)
BUTTON:IGNORE           EQUATE (20H)
BUTTON:CANCEL           EQUATE (40H)
BUTTON:HELP             EQUATE (80H)

!DDE link types

DDE:auto                EQUATE (0)
DDE:manual              EQUATE (-1)
DDE:remove              EQUATE (-2)

! Template Defined Action Values

InsertRecord            EQUATE (1)             !  Add a record to table
ChangeRecord            EQUATE (2)             !  Change the current record
DeleteRecord            EQUATE (3)             !  Delete the current record
SelectRecord            EQUATE (4)             !  Select the current record
RequestCompleted        EQUATE (1)             !  Update Completed
RequestCancelled        EQUATE (2)             !  Update Aborted

! Template Defined Record Status Flags

Record:OK               EQUATE(0)              !  Record passes range and filter
Record:OutOfRange       EQUATE(1)              !  Record fails range test
Record:Filtered         EQUATE(2)              !  Record fails filter tests

! File Access Modes

ReadOnly                EQUATE (0H)
WriteOnly               EQUATE (1H)
ReadWrite               EQUATE (2H)

AnyAccess               EQUATE (0H)
DenyAll                 EQUATE (10H)
DenyWrite               EQUATE (20H)
DenyRead                EQUATE (30H)
DenyNone                EQUATE (40H)

! Template Warnings

Warn:InvalidFile         EQUATE (1)
Warn:InvalidKey          EQUATE (2)
Warn:RebuildError        EQUATE (3)
Warn:CreateError         EQUATE (4)
Warn:CreateOpenError     EQUATE (5)
Warn:ProcedureToDo       EQUATE (6)
Warn:BadKeyedRec         EQUATE (7)
Warn:OutOfRangeHigh      EQUATE (8)
Warn:OutOfRangeLow       EQUATE (9)
Warn:OutOfRange          EQUATE (10)
Warn:NotInFile           EQUATE (11)
Warn:RestrictUpdate      EQUATE (12)
Warn:RestrictDelete      EQUATE (13)
Warn:InsertError         EQUATE (14)
Warn:RIUpdateError       EQUATE (15)
Warn:UpdateError         EQUATE (16)
Warn:RIDeleteError       EQUATE (17)
Warn:DeleteError         EQUATE (18)
Warn:InsertDisabled      EQUATE (19)
Warn:UpdateDisabled      EQUATE (20)
Warn:DeleteDisabled      EQUATE (21)
Warn:NoCreate            EQUATE (22)
Warn:ConfirmCancel       EQUATE (23)
Warn:DuplicateKey        EQUATE (24)
Warn:AutoIncError        EQUATE (25)
Warn:FileLoadError       EQUATE (26)
Warn:ConfirmCancelLoad   EQUATE (27)
Warn:FileZeroLength      EQUATE (28)
Warn:EndOfAsciiQueue     EQUATE (29)
Warn:DiskError           EQUATE (30)
Warn:ProcessActionError  EQUATE (31)
Warn:StandardDelete      EQUATE (32)
Warn:SaveOnCancel        EQUATE (33)
