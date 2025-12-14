
!ABCIncludeFile

OMIT('_EndOfInclude_',_BrowsePresent_)
_BrowsePresent_ EQUATE(1)

  INCLUDE ('ABFILE.INC')
  INCLUDE ('ABPOPUP.INC')
  INCLUDE ('ABTOOLBA.INC')
  INCLUDE ('ABEIP.INC')

! Server classes for browse routines
  ITEMIZE,PRE(ScrollBy)
Name            EQUATE
Alpha           EQUATE
Runtime         EQUATE
  END
  ITEMIZE,PRE(ScrollSort)
AllowAlpha    EQUATE(1)
AllowAlt      EQUATE(2)
AllowNumeric  EQUATE(4)
CaseSensitive EQUATE(8)
Descending    EQUATE(16)
  END

StepClass CLASS,MODULE('ABBROWSE.CLW'),TYPE,LINK('ABBROWSE.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
Controls BYTE
GetPercentile  PROCEDURE(? Value),BYTE,VIRTUAL
GetValue       PROCEDURE(BYTE Percentile),STRING,VIRTUAL
Init           PROCEDURE(BYTE Controls)
Kill           PROCEDURE,VIRTUAL
SetLimit       PROCEDURE(? Low,? High),VIRTUAL
SetLimitNeeded PROCEDURE,BYTE,VIRTUAL
  END

StepLongClass CLASS(StepClass),MODULE('ABBROWSE.CLW'),TYPE,DLL(_ABCDllMode_)
Low  LONG
High LONG
GetPercentile PROCEDURE(? Value),BYTE,VIRTUAL
GetValue      PROCEDURE(BYTE Percentile),STRING,VIRTUAL
SetLimit      PROCEDURE(? Low,? High),VIRTUAL
  END

StepRealClass CLASS(StepClass),MODULE('ABBROWSE.CLW'),TYPE,DLL(_ABCDllMode_)
Low  REAL
High REAL
GetPercentile  PROCEDURE(? Value),BYTE,VIRTUAL
GetValue       PROCEDURE(BYTE Percentile),STRING,VIRTUAL
SetLimit       PROCEDURE(? Low,? High),VIRTUAL
  END

StepStringClass CLASS(StepClass),MODULE('ABBROWSE.CLW'),TYPE,DLL(_ABCDllMode_)
LookupMode  BYTE
Ref         &STRING,PRIVATE
Root        CSTRING(40)
SortChars   &CSTRING
TestLen      BYTE,PROTECTED
GetPercentile  PROCEDURE(? Value),BYTE,VIRTUAL
GetValue       PROCEDURE(BYTE Percentile),STRING,VIRTUAL
Hash           PROCEDURE(STRING Val),LONG,PRIVATE
Init           PROCEDURE(BYTE Controls,BYTE Mode)
Kill           PROCEDURE,VIRTUAL
SetLimit       PROCEDURE(? Low,? High),VIRTUAL
SetLimitNeeded PROCEDURE,BYTE,VIRTUAL
Unhash         PROCEDURE(LONG Val),STRING,PRIVATE
  END

CStringList QUEUE,TYPE
Item  &CSTRING
            END

StepCustomClass CLASS(StepClass),MODULE('ABBROWSE.CLW'),TYPE,DLL(_ABCDllMode_)
Entries       &CStringList,PROTECTED
AddItem       PROCEDURE(STRING Text)
GetPercentile PROCEDURE(? Value),BYTE,VIRTUAL
GetValue      PROCEDURE(BYTE Percentile),STRING,VIRTUAL
Init          PROCEDURE(BYTE Controls)
Kill          PROCEDURE,VIRTUAL
  END

LocatorClass CLASS,TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
ViewManager &BrowseClass
Control     SIGNED
FreeElement ANY
NoCase      BYTE
Destruct      PROCEDURE,VIRTUAL
Init          PROCEDURE(SIGNED Control = 0,*? Free,BYTE NoCase = 0,<BrowseClass BC>)
!*** Synchronises locator to current entry value (where applicable)
Reset         PROCEDURE,VIRTUAL
!*** Starts an 'empty' locator
Set           PROCEDURE,VIRTUAL
SetAlerts     PROCEDURE(SIGNED FieldEquate),VIRTUAL
SetEnabled    PROCEDURE(BYTE B)
TakeAccepted  PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
TakeKey       PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
UpdateWindow  PROCEDURE,VIRTUAL
  END

StepLocatorClass CLASS(LocatorClass),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
Set           PROCEDURE,VIRTUAL
TakeKey       PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
  END

EntryLocatorClass CLASS(LocatorClass),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
Shadow        CSTRING(40)
Init          PROCEDURE(SIGNED Control = 0,*? Free,BYTE NoCase = 0,<BrowseClass BC>)
Set           PROCEDURE,VIRTUAL
TakeAccepted  PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
TakeKey       PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
Update        PROCEDURE,PROTECTED,VIRTUAL
UpdateWindow  PROCEDURE,VIRTUAL
  END

IncrementalLocatorClass CLASS(EntryLocatorClass),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
SetAlerts     PROCEDURE(SIGNED Control),VIRTUAL
TakeKey       PROCEDURE,VIRTUAL,BYTE ! 1 for locator on value required
  END

FilterLocatorClass CLASS(IncrementalLocatorClass),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
FloatRight    BYTE
Reset         PROCEDURE,VIRTUAL
TakeAccepted  PROCEDURE,VIRTUAL,BYTE
UpdateWindow  PROCEDURE,VIRTUAL
  END


FillBackward             EQUATE(1)
FillForward              EQUATE(2)

 ITEMIZE,PRE(Reset)
Queue              EQUATE
Done               EQUATE
 END

BrowseSortOrder QUEUE(SortOrder),TYPE
Locator      &LocatorClass
Resets       &FieldPairsClass
Thumb        &StepClass
             END

BrowseEditQueue QUEUE(EditQueue),TYPE
  END

BrowseEIPManager CLASS(EIPManager),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
BC                   &BrowseClass,PROTECTED
ClearColumn          PROCEDURE,DERIVED
Init                 PROCEDURE,BYTE,DERIVED,PROC
Kill                 PROCEDURE,PROC,BYTE,DERIVED
TakeCompleted        PROCEDURE(BYTE Force),DERIVED
TakeNewSelection     PROCEDURE,DERIVED,BYTE,PROC
           END

MouseLeft2Index EQUATE(252)


BrowseClass CLASS(ViewManager),TYPE,MODULE('ABBROWSE.CLW'),DLL(_ABCDllMode_)
AddEditControl       PROCEDURE(<EditClass EC>,UNSIGNED Column,BYTE AutoFree = 0)
AddField             PROCEDURE(*? Left,*? Right)
AddField             PROCEDURE(*long Left,*long Right)
AddField             PROCEDURE(*string Left,*string Right)
AddLocator           PROCEDURE(LocatorClass LC) ! Must come -after- SortOrder added
AddResetField        PROCEDURE(*? Field)
AddResetField        PROCEDURE(*string Field)
AddSortOrder         PROCEDURE(<StepClass SC>,<Key K>),BYTE,PROC
AddToolbarTarget     PROCEDURE(ToolbarClass TC)
ApplyRange           PROCEDURE,PROC,VIRTUAL,BYTE ! 1 if action taken !*** Signal browse to 'reevaluate' resets and range limits.
Ask                  PROCEDURE(BYTE Request),BYTE,VIRTUAL,PROC ! Request in, response out
AskRecord            PROCEDURE(BYTE Request),BYTE,VIRTUAL,PROC ! Request in, response out
CheckEIP             PROCEDURE,PRIVATE
Fetch                PROCEDURE(BYTE Direction),VIRTUAL,PROTECTED
Init                 PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
Kill                 PROCEDURE,VIRTUAL
Next                 PROCEDURE,BYTE,VIRTUAL
PostNewSelection     PROCEDURE
Previous             PROCEDURE,VIRTUAL,BYTE  ! :Notify for eof, :Fatal for error condition
Records              PROCEDURE,LONG,PROC  ! Has side effect of resyncing other controls to emptyness
ResetFromAsk         PROCEDURE(*BYTE Request,*BYTE Response),PROTECTED,VIRTUAL
ResetFromBuffer      PROCEDURE,VIRTUAL
ResetFromFile        PROCEDURE,VIRTUAL
ResetFromView        PROCEDURE,VIRTUAL
ResetQueue           PROCEDURE(BYTE ResetMode),VIRTUAL
ResetResets          PROCEDURE,PROTECTED
ResetSort            PROCEDURE(BYTE Force),BYTE,VIRTUAL,PROC
ResetThumbLimits     PROCEDURE,PRIVATE
ScrollEnd            PROCEDURE(SIGNED Event),VIRTUAL,PROTECTED
ScrollOne            PROCEDURE(SIGNED Event),VIRTUAL,PROTECTED
ScrollPage           PROCEDURE(SIGNED Event),VIRTUAL,PROTECTED
SetAlerts            PROCEDURE,VIRTUAL
SetQueueRecord       PROCEDURE,VIRTUAL
SetSort              PROCEDURE(BYTE NewOrder,BYTE Force),BYTE,VIRTUAL,PROC
TakeAcceptedLocator  PROCEDURE
TakeChoiceChanged    PROCEDURE,PRIVATE
TakeEvent            PROCEDURE,VIRTUAL
TakeKey              PROCEDURE,BYTE,PROC,VIRTUAL ! 1 If action taken
TakeLocate           PROCEDURE,VIRTUAL
TakeNewSelection     PROCEDURE,VIRTUAL
TakeScroll           PROCEDURE(SIGNED Event = 0),VIRTUAL
TakeVCRScroll        PROCEDURE(SIGNED Vcr = 0),VIRTUAL
UpdateBuffer         PROCEDURE,VIRTUAL      ! Update file fields from CurrentChoice
UpdateQuery          PROCEDURE(QueryClass QC)
UpdateResets         PROCEDURE,PROTECTED
UpdateThumb          PROCEDURE
UpdateThumbFixed     PROCEDURE,PROTECTED
UpdateToolbarButtons PROCEDURE,PRIVATE
UpdateViewRecord     PROCEDURE,VIRTUAL    ! Reget on all involved files
UpdateWindow         PROCEDURE,VIRTUAL    ! Sets actual value to that stored in locator

ActiveInvisible BYTE               ! Should the browse be active when invisible
AllowUnfilled BYTE
ArrowAction   BYTE
AskProcedure  USHORT               !Procedure to call from ask, 0=>EIP
Buffer        USHORT,PRIVATE
ChangeControl SIGNED
CurrentChoice LONG,PRIVATE
CurrentEvent  LONG,PRIVATE
DeleteControl SIGNED
EditList      &BrowseEditQueue,PROTECTED
EIP           &BrowseEIPManager           ! Is freed during kill
EnterAction   BYTE
Fields        &FieldPairsClass,PROTECTED
FileLoaded    BYTE
FocusLossAction BYTE
FreeEIP       BYTE,PRIVATE
HasThumb      BYTE
HideSelect    BYTE
InsertControl SIGNED
ItemsToFill   LONG,PRIVATE
LastChoice    LONG,PRIVATE
LastItems     LONG,PRIVATE
ListControl   SIGNED
ListQueue     &QUEUE
Loaded        BYTE,PROTECTED ! Used by browse code to see if starting up
LoadPending   BYTE,PRIVATE
RetainRow     BYTE           ! Attempt to preserve highlighted row# during queue refill
PrintControl  SIGNED
PrintProcedure USHORT
Popup         &PopupClass
Query         &QueryClass
QueryControl  SIGNED
QueryResult   SIGNED,PROTECTED
QueryShared   BYTE
QuickScan     BYTE
RecordStatus  BYTE,PRIVATE
SelectControl SIGNED
Selecting     BYTE
SelectWholeRecord BYTE       ! Set to 1 if you want the -whole- record when Selecting
Sort          &BrowseSortOrder,PROTECTED    ! Is really a 'shadow' of the parent ORDER queue
StartAtCurrent BYTE          ! Jump to current file value on first browse load
TabAction     BYTE
Toolbar       &ToolbarClass
ToolControl   SIGNED
ToolbarItem   &ToolbarListboxClass
ViewPosition  &STRING,PRIVATE
Window        &WindowManager,PROTECTED
  END

_EndOfInclude_









