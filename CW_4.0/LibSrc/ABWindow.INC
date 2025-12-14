! Process server header module

!ABCIncludeFile

  OMIT('_EndOfInclude_',_WindowsPresent_)
_WindowsPresent_   EQUATE(1)

  ITEMIZE,PRE(Delete)
None EQUATE
Warn EQUATE
Form EQUATE
Auto EQUATE
  END

  ITEMIZE,PRE(Insert)
None   EQUATE
Caller EQUATE
Batch  EQUATE
Query  EQUATE
  END

  ITEMIZE,PRE(Cancel)
Cancel  EQUATE(0)
Save    EQUATE(1)
Query   EQUATE(2)   ! Bitwise-OR ed
  END

WindowManager CLASS,TYPE,MODULE('ABWINDOW.CLW'),LINK('ABWINDOW.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
AutoRefresh    BYTE
AutoToolbar    BYTE
Browses        &BrowseList,PRIVATE
Buttons        &ButtonList,PRIVATE
FileDrops      &FileDropList,PRIVATE          !File Drops and File Drop Combos
CancelAction   BYTE
ChangeAction   BYTE
Dead           BYTE,PROTECTED
DeleteAction   BYTE
Errors         &ErrorClass
Files          &FileList,PRIVATE
FirstField     SIGNED
ForcedReset    BYTE
ResetOnGainFocus  BYTE
History        &HistoryList,PRIVATE
HistoryKey     SIGNED
Inited         BYTE,PRIVATE
InsertAction   BYTE
LastInsertedPosition STRING(512),PRIVATE
OkControl      SIGNED
Opened         BYTE
OriginalRequest BYTE
Primary        &RelationManager
Request        BYTE
Resize         &WindowResizeClass,PRIVATE
Response       BYTE
Saved          USHORT,PROTECTED
Toolbar        &ToolbarClass,PRIVATE
Translator     &TranslatorClass,PROTECTED
VCRRequest     &LONG                       ! Public so 'children' can get at value
AddHistoryField PROCEDURE(SIGNED Control,SIGNED FieldNumber)
AddHistoryFile PROCEDURE(*GROUP RecBuf,*GROUP HistBuf)
AddItem        PROCEDURE(BrowseClass BC)
AddItem        PROCEDURE(SIGNED Control,BYTE Action)  ! Perform 'action' when 'control' accepted
AddItem        PROCEDURE(TranslatorClass Translator)
AddItem        PROCEDURE(ToolbarClass TC)
AddItem        PROCEDURE(ToolbarUpdateClass TF)
AddItem        PROCEDURE(WindowResizeClass RC)
AddItem        PROCEDURE(FileDropClass FD)
AddUpdateFile  PROCEDURE(FileManager FM)
Ask            PROCEDURE,VIRTUAL
Init           PROCEDURE,BYTE,VIRTUAL,PROC
Kill           PROCEDURE,PROC,BYTE,VIRTUAL    ! Level:Notify means dead already
Open           PROCEDURE,VIRTUAL
PostCompleted  PROCEDURE
PrimeFields    PROCEDURE,PROC,VIRTUAL
PrimeUpdate    PROCEDURE,PROC,BYTE,VIRTUAL
Reset          PROCEDURE(BYTE Force=0),VIRTUAL
RestoreField   PROCEDURE(SIGNED Control),VIRTUAL
Run            PROCEDURE,BYTE,VIRTUAL,PROC
Run            PROCEDURE(USHORT Number,BYTE Request),BYTE,VIRTUAL,PROC
SaveHistory    PROCEDURE,PROTECTED
SetAlerts      PROCEDURE,VIRTUAL
SetResponse    PROCEDURE(BYTE Response),VIRTUAL
TakeAccepted   PROCEDURE,VIRTUAL,BYTE,PROC
TakeCompleted  PROCEDURE,BYTE,PROC,VIRTUAL
TakeCloseEvent PROCEDURE,BYTE,PROC,VIRTUAL
TakeEvent      PROCEDURE,VIRTUAL,BYTE,PROC
TakeFieldEvent PROCEDURE,VIRTUAL,BYTE,PROC
TakeNewSelection PROCEDURE,VIRTUAL,BYTE,PROC
TakeRejected   PROCEDURE,VIRTUAL,BYTE,PROC
TakeSelected   PROCEDURE,VIRTUAL,BYTE,PROC
TakeWindowEvent  PROCEDURE,VIRTUAL,BYTE,PROC
Update         PROCEDURE,VIRTUAL
  END
  OMIT('***',_ResizePresent_)
  INCLUDE('ABRESIZE.INC')
  ***
  OMIT('***',_BrowsePresent_)
  INCLUDE('ABBROWSE.INC')
  ***
  OMIT('***',_FileDropBoxesPresent_)
  INCLUDE('ABDROPS.INC')
  ***
  OMIT('***',_ToolbarPresent_)
  INCLUDE('ABTOOLBA.INC')
  ***

_EndOfInclude_
