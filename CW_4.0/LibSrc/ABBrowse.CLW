! Server routines for browse windows
  MEMBER
_ABCDllMode_  EQUATE(0)
_ABCLinkMode_ EQUATE(1)
  MAP
  .
  INCLUDE('ABBROWSE.inc')
  INCLUDE('Errors.clw')
  INCLUDE('Keycodes.clw')
  INCLUDE('ABBROWSE.trn')
  INCLUDE('ABWINDOW.INC')

MouseLeft2Index EQUATE(252)

Scroll:Alpha     STRING('  AFANATB BFBNBTC CFCNCT'|
                       &'D DFDNDTE EFENETF FFFNFT'|
                       &'G GFGNGTH HFHNHTI IFINIT'|
                       &'J JFJNJTK KFKNKTL LFLNLT'|
                       &'M MFMNMTN NFNNNTO OFONOT'|
                       &'P PFPNPTQ QNR RFRNRTS SF'|
                       &'SNSTT TFTNTTU UFUNUTV VF'|
                       &'VNVTW WFWNWTX XFXNXTY YF'|
                       &'YNYTZ ZN')

Scroll:Name      STRING('   ALBAMEARNBAKBATBENBIABOBBRA'|
                       &'BROBUACACCARCENCHRCOECONCORCRU'|
                       &'DASDELDIADONDURELDEVEFELFISFLO'|
                       &'FREFUTGARGIBGOLGOSGREGUTHAMHEM'|
                       &'HOBHOTINGJASJONKAGKEAKIRKORKYO'|
                       &'LATLEOLIGLOUMACMAQMARMAUMCKMER'|
                       &'MILMONMORNATNOLOKEPAGPAUPETPIN'|
                       &'PORPULRAUREYROBROSRUBSALSCASCH'|
                       &'SCRSHASIGSKISNASOUSTESTISUNTAY'|
                       &'TIRTUCVANWACWASWEIWIEWIMWOLYOR')

OverrideCharacters   STRING('`!"£$%%^&*()''-=_+][#;~@:/.,?\| ')

StepClass.Init PROCEDURE(BYTE Controls)
  CODE
    SELF.Controls = Controls

StepClass.Kill PROCEDURE
  CODE

StepClass.GetPercentile PROCEDURE(? Value)
  CODE
    RETURN 50

StepClass.GetValue PROCEDURE(BYTE Percentile)
  CODE
    RETURN ''

StepClass.SetLimit PROCEDURE(? L,? H)
  CODE

StepClass.SetLimitNeeded PROCEDURE
  CODE
    RETURN 1

StepLongClass.GetPercentile PROCEDURE(? Value)
R BYTE,AUTO
  CODE
    IF SELF.Low = SELF.High
      RETURN 50
    END
    R = (Value - SELF.Low) * (100 / (SELF.High - SELF.Low))
    IF BAND(SELF.Controls,ScrollSort:Descending)
      R = 100 - R
    END
    RETURN CHOOSE(R = 0,1,R)

StepLongClass.GetValue PROCEDURE(BYTE P)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      P = 100 - P
    END
    RETURN SELF.Low + (SELF.High - SELF.Low) * (P / 100)

StepLongClass.SetLimit PROCEDURE(? low,? high)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      SELF.Low = High
      SELF.High = Low
    ELSE
      SELF.Low = Low
      SELF.High = High
    END

StepRealClass.GetPercentile PROCEDURE(? Value)
R BYTE,AUTO
  CODE
    IF SELF.Low = SELF.High
      RETURN 50
    END
    R = ((Value - SELF.Low) * 100) / (SELF.High - SELF.Low)
    IF BAND(SELF.Controls,ScrollSort:Descending)
      R = 100 - R
    END
    RETURN CHOOSE(R = 0,1,R)

StepRealClass.GetValue PROCEDURE(BYTE P)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      P = 100 - P
    END
    RETURN SELF.Low + (SELF.High - SELF.Low) * P / 100

StepRealClass.SetLimit PROCEDURE(? low,? high)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      SELF.Low = High
      SELF.High = Low
    ELSE
      SELF.Low = Low
      SELF.High = High
    END

StepCustomClass.AddItem PROCEDURE(STRING s)
  CODE
    ASSERT(~(SELF.Entries &= NULL))
    SELF.Entries.Item &= NEW CSTRING(LEN(s)+1)
    SELF.Entries.Item = s
    ADD(SELF.Entries)

StepStringClass.Init PROCEDURE(BYTE Controls,BYTE Mode)
ValidChars CSTRING(255)
I UNSIGNED,AUTO
  CODE
    SELF.LookupMode = Mode
    PARENT.Init(Controls)
    CASE Mode
    OF ScrollBy:Name
      SELF.Ref &= Scroll:Name
      SELF.TestLen = 3
    OF ScrollBy:Alpha
      SELF.Ref &= Scroll:Alpha
      SELF.TestLen = 2
    OF ScrollBy:Runtime
      SELF.Ref &= NEW STRING(400)
      SELF.TestLen = 4
      LOOP I = 1 TO 255   ! Compute string of valid sort characters
        IF BAND(Controls,ScrollSort:AllowAlt) AND INSTRING(CHR(I),OverrideCharacters) OR |
           BAND(Controls,ScrollSort:AllowNumeric) AND CHR(I) >= '0' AND CHR(I) <= '9' OR |
           BAND(Controls,ScrollSort:AllowAlpha) AND ISALPHA(CHR(I)) AND |
               (BAND(Controls,ScrollSort:CaseSensitive) OR ISUPPER(CHR(I)))
          ValidChars = ValidChars & CHR(I)
        END
      END
      SELF.SortChars &= NEW CSTRING(LEN(ValidChars)+1)
      SELF.SortChars = ValidChars
    END

StepCustomClass.Init PROCEDURE(BYTE Controls)
  CODE
    PARENT.Init(Controls)
    SELF.Entries &= NEW CStringList

StepStringClass.Kill PROCEDURE
  CODE
    IF SELF.LookupMode = ScrollBy:RunTime
      DISPOSE(SELF.Ref)
    END
    DISPOSE(SELF.SortChars)

StepCustomClass.Kill PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Entries)
      GET(SELF.Entries,I)
      DISPOSE(SELF.Entries.Item)
    END
    DISPOSE(SELF.Entries)

StepStringClass.Unhash PROCEDURE(LONG l)
RetVal STRING(4),AUTO
I BYTE,AUTO
Base USHORT,AUTO
  CODE
    Base = LEN(SELF.SortChars)
    ASSERT(Base)
    LOOP I = 4 TO 1 BY -1
      RetVal[I] = SELF.SortChars[L%Base + 1]
      L /= Base
    END
    RETURN RetVal

StepStringClass.SetLimit PROCEDURE(? l,? h)
MinLen UNSIGNED,AUTO
Common UNSIGNED,AUTO
LowValue  STRING(4),AUTO
HighValue STRING(4),AUTO
I      UNSIGNED,AUTO
Delta  LONG,AUTO
LowVal LONG,AUTO
Low CSTRING(80)
High CSTRING(80)
  CODE
    Low = CLIP(l)
    High = CLIP(h)
    IF LEN(High) < LEN(Low)
      MinLen = LEN(High)
    ELSE
      MinLen = LEN(Low)
    END
    LOOP Common = 1 TO MinLen     ! Find the common length of the limits
    UNTIL Low[Common] <> High[Common]
    SELF.Root = CHOOSE(Common > 1,Low[ 1 : Common - 1 ],'')
    LowValue = Low[ Common : LEN(Low) ]
    LOOP I = 1 + LEN(Low) - Common TO 4
      IF I     ! Handle 'underflow' case on Low (where Len(low)=0)
        LowValue[I] = SELF.SortChars[1]    ! 'Clear(,-1)'
      END
    END
    HighValue = High[ Common : LEN(High) ]
    LOOP I = 1 + LEN(High) - Common TO 4
      HighValue[I] = SELF.SortChars[LEN(SELF.SortChars)] ! 'Clear(,1)'
    END
    LowVal = SELF.Hash(LowValue)
    Delta = (SELF.Hash(HighValue) - LowVal) / 100
    IF BAND(SELF.Controls,ScrollSort:Descending)
      LOOP I = 99 TO 0 BY -1
        SELF.Ref[1+I*4 : 4+I*4] = SELF.Unhash(LowVal)
        LowVal += Delta
      END
    ELSE
      LOOP I = 0 TO 99
        SELF.Ref[1+I*4 : 4+I*4] = SELF.Unhash(LowVal)
        LowVal += Delta
      END
    END

StepStringClass.SetLimitNeeded PROCEDURE
  CODE
    RETURN CHOOSE(SELF.LookupMode = ScrollBy:RunTime)

StepStringClass.GetPercentile PROCEDURE(? Value)
I BYTE,AUTO
Match CSTRING(80)
  CODE
    IF LEN(SELF.Root)
      ASSERT(SELF.Root = SUB(Value,1,LEN(SELF.Root)))
      Match = SUB(Value,LEN(SELF.Root)+1,SELF.TestLen+1)
    ELSE
      Match = Value
    END
    IF ~BAND(SELF.Controls,ScrollSort:CaseSensitive)
      Match = UPPER(Match)
    END
    LOOP I = 0 TO 99
      IF SELF.Ref[I*SELF.TestLen+1:(I+1)*SELF.TestLen]>Match
        BREAK
      END
    END
    IF BAND(SELF.Controls,ScrollSort:Descending)
      I = 100 - I
    END
    RETURN CHOOSE(I = 0,1,I)

StepCustomClass.GetPercentile PROCEDURE(? Value)
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Entries)
      GET(SELF.Entries,I)
      IF BAND(SELF.Controls,ScrollSort:CaseSensitive)
        IF SELF.Entries.Item<Value
          BREAK
        END
      ELSE
        IF SELF.Entries.Item<UPPER(Value)
          BREAK
        END
      END
    END
    I = ((I-1)*100) / RECORDS(SELF.Entries)
    IF BAND(SELF.Controls,ScrollSort:Descending)
      I = 100 - I
    END
    RETURN CHOOSE(I = 0,1,I)

StepStringClass.GetValue PROCEDURE(BYTE P)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      P = 100 - P
    END
    IF P = 0
      P = 1
    END
    RETURN SELF.Root & SELF.Ref[P*4-3 : P*4 ]

StepCustomClass.GetValue PROCEDURE(BYTE P)
  CODE
    IF BAND(SELF.Controls,ScrollSort:Descending)
      P = 100 - P
    END
    GET(SELF.Entries,P * RECORDS(SELF.Entries) / 100)
    ASSERT(~ERRORCODE())
    RETURN SELF.Entries.Item

StepStringClass.Hash PROCEDURE(STRING Value)
Base USHORT,AUTO
Result LONG(0)
I BYTE,AUTO
  CODE
    Base = LEN(SELF.SortChars)
    IF ~BAND(SELF.Controls,ScrollSort:CaseSensitive)
      Value = UPPER(Value)
    END
    LOOP I = 1 TO 4
      Result = Result * Base + INSTRING(Value[I],SELF.SortChars)
    END
    RETURN Result

!***********************************************************************
! Edit Class, implements the edit in place functionality for a simplistic
! entry control.
! Init & Kill are called upon entry and exit from the .Ask function
! In particular Kill -must- leave the object in an Initable state.
!***********************************************************************

EditClass.Init PROCEDURE(UNSIGNED FieldNo,UNSIGNED ListBox,*? UseVar)
  CODE
  SELF.Feq = CREATE(0,CREATE:Entry)
  ASSERT(~ERRORCODE())
  SELF.Feq{PROP:Text} = ListBox{PROPLIST:Picture,FieldNo}
  SELF.Feq{PROP:Use} = UseVar
  SELF.Feq{PROP:Alrt,1} = TabKey
  SELF.Feq{PROP:Alrt,2} = ShiftTab
  SELF.Feq{PROP:Alrt,3} = EnterKey
  SELF.Feq{PROP:Alrt,4} = EscKey
  SELF.Feq{PROP:Alrt,5} = DownKey
  SELF.Feq{PROP:Alrt,6} = UpKey

EditClass.Kill          PROCEDURE
  CODE
  DESTROY(SELF.Feq)

EditClass.TakeEvent     PROCEDURE(UNSIGNED E)
  CODE
    CASE E
    OF EVENT:AlertKey
      CASE KEYCODE()
      OF EnterKey
        RETURN EditAction:Complete
      OF EscKey
        RETURN EditAction:Cancel
      OF TabKey
        RETURN EditAction:Forward
      OF ShiftTab
        RETURN EditAction:Backward
      OF  DownKey
        RETURN EditAction:Next
      OF UpKey
        RETURN EditAction:Previous
      END
    END
    RETURN EditAction:None

BrowseClass.AddEditControl PROCEDURE(EditClass EC,UNSIGNED Id,BYTE Free)
  CODE
    SELF.EditList.Control &= EC
    SELF.EditList.Field = Id
    SELF.EditList.FreeUp = Free
    ADD(SELF.EditList,SELF.EditList.Field)
    ASSERT(~ERRORCODE())

BrowseClass.AddField PROCEDURE(*? FromFile,*? FromQueue)
  CODE
    SELF.Fields.AddPair(FromFile,FromQueue)

BrowseClass.AddField PROCEDURE(*string FromFile,*string FromQueue)
  CODE
    SELF.Fields.AddPair(FromFile,FromQueue)

BrowseClass.AddField PROCEDURE(*long FromFile,*long FromQueue)
  CODE
    SELF.Fields.AddPair(FromFile,FromQueue)

BrowseClass.AddResetField PROCEDURE(*? Left)
  CODE
    ASSERT(~(SELF.Sort.Resets &= NULL))
    SELF.Sort.Resets.AddItem(Left)

BrowseClass.AddResetField PROCEDURE(*string Left)
  CODE
    ASSERT(~(SELF.Sort.Resets &= NULL))
    SELF.Sort.Resets.AddItem(Left)

BrowseClass.AddLocator PROCEDURE(LocatorClass L)
  CODE
    SELF.Sort.Locator &= L
    PUT(SELF.Sort)

BrowseClass.AddSortOrder PROCEDURE(<StepClass Th>,<Key K>)
SNum BYTE,AUTO
  CODE
    CLEAR(SELF.Sort)
    SNum = PARENT.AddSortOrder(K)
    SELF.Sort.Thumb &= Th
    SELF.Sort.Resets &= NEW FieldPairsClass
    SELF.Sort.Resets.Init
    PUT(SELF.Sort)
    ASSERT(~ERRORCODE())
    RETURN SNum

BrowseClass.AddToolbarTarget PROCEDURE(ToolbarClass T)
  CODE
    SELF.Toolbar &= T
    SELF.ToolbarItem &= NEW ToolbarListboxClass
    SELF.ToolbarItem.Browse &= SELF
    T.AddTarget(SELF.ToolbarItem,SELF.ListControl)
    SELF.UpdateToolbarButtons

BrowseClass.ApplyRange PROCEDURE
RVal BYTE
LI   SIGNED,AUTO
  CODE
    LI = SELF.ListControl{Prop:Items}
    IF SELF.LastItems <> LI
      SELF.LastItems = LI
      RVal = 1
    END
    IF RVal OR PARENT.ApplyRange() OR ~SELF.Sort.Resets.Equal()
      SELF.LoadPending = 1
      RVal = 1
    END
    RETURN RVal

BrowseClass.Ask PROCEDURE(BYTE Req)
Response BYTE
  CODE
  LOOP
    SELF.Window.VCRRequest = VCR:None
    IF Req=InsertRecord THEN
      SELF.PrimeRecord
    END
    IF KEYCODE() = MouseRight
      SETKEYCODE(0)
    END
    IF SELF.AskProcedure
      Response = SELF.Window.Run(SELF.AskProcedure,Req)
      SELF.ResetFromAsk(Req,Response)
    ELSE
      Response = SELF.AskRecord(Req)
    END
  UNTIL SELF.Window.VCRRequest = VCR:None
  RETURN Response

!**********************************************************************
! This is the engine for the Edit in place functionality
!**********************************************************************
BrowseClass.AskRecord PROCEDURE(BYTE Req)
I UNSIGNED,AUTO
RetVal BYTE(RequestCancelled)
Again BYTE,AUTO
Force UNSIGNED(0)     ! Relies on 0 being BUTTON:NotAButton
Column UNSIGNED(1),STATIC
LastColumn UNSIGNED   ! Avoid duplicitive SetColumns
Repost UNSIGNED
RepostField UNSIGNED
SeekForward BYTE
  CODE
  SELF.CurrentChoice = CHOICE(SELF.ListControl)
  DO ProcessReq
  DO CreateControls
  GET(SELF.ListQueue,SELF.CurrentChoice)
  SELF.ListControl{PROP:Alrt,MouseLeft2Index} = 0 ! Prevent alert short-stopping double click
  DO SetColumn
  ACCEPT
    Again = 1
    IF FIELD()
      I = 1
      LOOP   ! Optimised to pick up subsequent events from same field
        IF ~SELF.EditList.Control &= NULL AND SELF.EditList.Control.Feq = FIELD()
          DO EditClassAction
          BREAK
        END
        GET(SELF.EditList,I)
        IF ERRORCODE()  ! Not a known field
          DO AlienFieldEvent
          BREAK
        END
        I += 1
      END
    ELSE
      CASE EVENT()                    ! A window specific event
      OF EVENT:Size OROF EVENT:Iconize OROF EVENT:Maximize
        CYCLE
      OF EVENT:CloseDown OROF EVENT:CloseWindow OROF EVENT:Sized
        DO TakeFocusLoss
        Repost = EVENT()
        Again = 0
      END
    END
    IF ~Again
      BREAK
    END
  END
  LOOP I = 1 TO RECORDS(SELF.EditList)
    GET(SELF.EditList,I)
    IF SELF.EditList.Control &= NULL
      SELF.ListControl{PROPLIST:textcolor,SELF.EditList.Field} = COLOR:None
    ELSE
      SELF.EditList.Control.Kill
    END
  END
  SELF.ListControl{PROP:Alrt,MouseLeft2Index} = MouseLeft2
  SELF.ResetFromAsk(Req,RetVal)
  IF Repost
    POST(Repost,RepostField)
  END
  RETURN(RetVal)

EditClassAction ROUTINE
  DATA
Rem UNSIGNED,AUTO
SaveCol UNSIGNED,AUTO
Action UNSIGNED,AUTO
  CODE
  Action = SELF.EditList.Control.TakeEvent(EVENT())
  CASE Action
  OF EditAction:Forward
    DO UnsetColumn
    Rem = Column
    Column += 1
    SeekForward = 1
    DO SeekColumn
    IF Rem <> Column
      DO SetColumn
    ELSE
      CASE BAND(SELF.TabAction,EIPAction:Save)
      OF EIPAction:Always
        Force = BUTTON:Yes
      OF EIPAction:Never
        Force = Button:No
      ELSE
        Force = 0
      END
      DO SaveOut
      IF BAND(SELF.TabAction,EIPAction:Remain) AND ~Again
        SELF.Window.VCRRequest = VCR:Forward
      END
    END
  OF EditAction:Backward
    IF Column > 1
      DO UnsetColumn
      Rem = Column
      Column -= 1
      DO SetColumn
    END
  OF EditAction:Next OROF EditAction:Previous
    CASE BAND(SELF.ArrowAction,EIPAction:Save)
    OF EIPAction:Always OROF EIPAction:Default
      Force = BUTTON:Yes
    OF EIPAction:Never
      Force = Button:No
    ELSE
      Force = 0
    END
    SaveCol = Column
    DO SaveOut
    IF BAND(SELF.ArrowAction,EIPAction:Remain) AND ~Again
      SELF.Window.VCRRequest = CHOOSE(Action = EditAction:Next,VCR:Forward,VCR:Backward)
    END
    IF BAND(SELF.ArrowAction,EIPAction:RetainColumn) AND ~Again
      Column = SaveCol
    END
  OF EditAction:Complete
    CASE BAND(SELF.EnterAction,EIPAction:Save)
    OF EIPAction:Always OROF EIPAction:Default
      Force = BUTTON:Yes
    OF EIPAction:Never
      Force = Button:No
    ELSE
      Force = 0
    END
    DO SaveOut
    IF BAND(SELF.EnterAction,EIPAction:Remain) AND ~Again
      SELF.Window.VCRRequest = VCR:Forward
    END
  OF EditAction:Cancel
    SELF.ListControl{PROP:Edit,SELF.EditList.Field} = 0
    DO CancelRequest
    Again = 0
  END

AlienFieldEvent ROUTINE
  IF FIELD() = SELF.ListControl
    IF EVENT() = EVENT:NewSelection
      IF CHOICE(SELF.ListControl) = SELF.CurrentChoice
        IF KEYCODE() = MouseLeft       ! An in-row mouse click
          DO UnsetColumn
          Column = SELF.ListControl{PROPLIST:MouseUpField}
          DO SetColumn
        END
      ELSE                                  ! Focus change to different record
        DO TakeFocusLoss
        IF Again
          SELECT(SELF.ListControl,SELF.CurrentChoice)
        ELSE
          SELF.CurrentChoice = CHOICE(SELF.ListControl)
        END
      END
    END
  ELSE
    IF ?{PROP:Type} <> CREATE:Button OR EVENT() <> EVENT:Selected  ! Wait to post accepted for button
      Repost = EVENT()
      RepostField = FIELD()
      DO TakeFocusLoss
    END
  END

TakeFocusLoss ROUTINE
  CASE BAND(SELF.FocusLossAction,EIPAction:Save)
  OF EIPAction:Always OROF EIPAction:Default
    Force = Button:Yes
  OF EIPAction:Never
    Force = Button:No
  ELSE
    Force = 0
  END
  DO SaveOut

SaveOut ROUTINE
  DATA
SaveAns UNSIGNED,AUTO
Id      USHORT
Id1     USHORT
  CODE
  Again = 0
  DO UnsetColumn
  SaveAns = CHOOSE(Force = 0,Button:Yes,Force)
  IF SELF.Fields.Equal()
    SaveAns = Button:No
  ELSE
    IF ~Force
      SaveAns = SELF.Window.Errors.Message(Msg:SaveRecord,Button:Yes+Button:No+Button:Cancel,Button:Yes)
    END
  END
  Force = 0
  CASE SaveAns
  OF Button:Cancel
    Again = 1
  OF Button:No
    DO CancelRequest
  OF Button:Yes
    RetVal = RequestCompleted
    Id = SELF.Primary.Me.SaveBuffer()
    SELF.UpdateBuffer
    IF CHOOSE(Req = InsertRecord,SELF.Primary.Me.Insert(),SELF.Primary.Update()) <> Level:Benign
      Again = 1
      RetVal = RequestCancelled
    END
    SELF.Primary.Me.RestoreBuffer(Id,Again)
    FLUSH(SELF.View)
  END
  Column = 1
  IF Again
    DO SetColumn
  END

CancelRequest ROUTINE
  IF Req = InsertRecord
    DELETE(SELF.ListQueue)
    IF SELF.CurrentChoice
      SELF.CurrentChoice -= 1
    END
    SELF.Primary.Me.CancelAutoInc()
  END

CreateControls ROUTINE
  SELF.EditList.Field = 1
  LOOP WHILE SELF.ListControl{PROPLIST:Exists,SELF.EditList.Field}
    GET(SELF.EditList,SELF.EditList.Field)
    IF ERRORCODE()
      SELF.EditList.Control &= NEW EditClass
      SELF.AddEditControl(SELF.EditList.Control,SELF.EditList.Field,1)
    END
    GET(SELF.Fields.List,SELF.EditList.Field)
    ASSERT(~ERRORCODE())
    IF ~SELF.EditList.Control &= NULL
      SELF.EditList.Control.Init(SELF.EditList.Field,SELF.ListControl,SELF.Fields.List.Right)
    ELSE
      SELF.ListControl{PROPLIST:textcolor,SELF.EditList.Field} = COLOR:GRAYTEXT
    END
    SELF.EditList.Field += 1
  END

ProcessReq ROUTINE
  SELF.Primary.Save()
  CASE Req
  OF InsertRecord
    IF RECORDS(SELF.ListQueue)
      SELF.CurrentChoice = CHOOSE(SELF.CurrentChoice = RECORDS(SELF.ListQueue),SELF.CurrentChoice,SELF.CurrentChoice+1)
      IF RECORDS(SELF.ListQueue) >= SELF.LastItems
        GET(SELF.ListQueue,RECORDS(SELF.ListQueue))
        DELETE(SELF.ListQueue)
      END
    ELSE
      SELF.CurrentChoice = 1
    END
    SELF.SetQueueRecord
    ADD(SELF.ListQueue,SELF.CurrentChoice)
    ASSERT(~ERRORCODE())
    DISPLAY(SELF.ListControl)
    SELECT(SELF.ListControl,SELF.CurrentChoice)
    Column = 1
  OF DeleteRecord
    RetVal = CHOOSE(SELF.Primary.Delete() = Level:Benign,RequestCompleted,RequestCancelled)
    SELF.ResetFromAsk(Req,RetVal)
    RETURN RetVal
  OF ChangeRecord
    IF KEYCODE() = MouseLeft2
      Column = SELF.ListControl{PROPLIST:MouseUpField}
    END
  ELSE
    ASSERT(0)
  END

UnsetColumn ROUTINE
  IF LastColumn
    UPDATE
    PUT(SELF.ListQueue)
    ASSERT(~ERRORCODE())
    SELF.ListControl{PROP:Edit,Column} = 0
    LastColumn = 0
  END

SetColumn ROUTINE
  SETKEYCODE(0)
  DO SeekColumn
  IF Column <> LastColumn
    SELF.ListControl{PROP:Edit,SELF.EditList.Field} = SELF.EditList.Control.Feq
    SELECT(SELF.EditList.Control.Feq)
    LastColumn = Column
  END

SeekColumn ROUTINE
  DATA
Scanned BYTE
  CODE
  LOOP
    SELF.EditList.Field = Column
    GET(SELF.EditList,SELF.EditList.Field)
    IF ~ERRORCODE() AND ~SELF.EditList.Control &= NULL
      BREAK
    END
    IF SeekForward
      IF Column >= RECORDS(SELF.EditList)
        ASSERT(~Scanned)
        SeekForward = 0
        Scanned = 1
      END
      Column += 1
    ELSE
      IF Column <= 1
        SeekForward = 1
        ASSERT(~Scanned)
        Scanned = 1
      ELSE
        Column -= 1
      END
    END
  END
  SeekForward = 0

BrowseClass.Fetch PROCEDURE(BYTE Direction)
SkipFirst BYTE(0)
  CODE
  IF SELF.QuickScan AND SELF.ItemsToFill > 1
    SELF.Primary.SetQuickScan(1)
  END
  IF RECORDS(SELF.ListQueue)
    GET(SELF.ListQueue,CHOOSE(Direction = FillForward,RECORDS(SELF.ListQueue),1))
    RESET(SELF.View,SELF.ViewPosition)
    SkipFirst = 1
  END
  LOOP WHILE SELF.ItemsToFill
    CASE CHOOSE(Direction = FillForward,SELF.Next(),SELF.Previous())
    OF Level:Notify
      BREAK
    OF Level:Fatal
      RETURN
    END
    IF SkipFirst
      SkipFirst = FALSE
      IF POSITION(SELF.View)= SELF.ViewPosition
        CYCLE
      END
    END
    IF RECORDS(SELF.ListQueue) = SELF.LastItems
      GET(SELF.ListQueue,CHOOSE(Direction = FillForward,1,RECORDS(SELF.ListQueue)))
      DELETE(SELF.ListQueue)
    END
    SELF.SetQueueRecord
    IF Direction = FillForward
      ADD(SELF.ListQueue)
    ELSE
      ADD(SELF.ListQueue,1)
    END
    SELF.ItemsToFill -= 1
  END
  IF SELF.QuickScan
    SELF.Primary.SetQuickScan(0)
  END

BrowseClass.Init  PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager F,WindowManager WM)
  CODE
    SELF.Window &= WM
    SELF.ListControl = ListBox
    SELF.ListQueue &= Q
    SELF.ViewPosition &= Posit
    SELF.Sort &= NEW BrowseSortOrder
    SELF.Fields &= NEW FieldPairsClass
    SELF.Fields.Init
    SELF.Popup &= NEW PopupClass
    SELF.EditList &= NEW BrowseEditQueue
    SELF.RetainRow = 1
    ASSERT(~SELF.Popup&=NULL)
    SELF.Popup.Init
    PARENT.Init(V,F,SELF.Sort)
    WM.AddItem(SELF)

BrowseClass.Kill PROCEDURE
I UNSIGNED,AUTO
  CODE
    IF ~(SELF.Sort &= NULL)
      LOOP I = 1 TO RECORDS(SELF.Sort)
        GET(SELF.Sort,I)
        IF ~(SELF.Sort.Thumb &= NULL)
          SELF.Sort.Thumb.Kill
        END
        SELF.Sort.Resets.Kill
        DISPOSE(SELF.Sort.Resets)
      END
    END
    PARENT.Kill
    DISPOSE(SELF.Sort)
    IF ~SELF.Fields &= NULL
      SELF.Fields.Kill
      DISPOSE(SELF.Fields)
    END
    IF ~SELF.Popup &= NULL
      SELF.Popup.Kill
      DISPOSE(SELF.Popup)
    END
    DISPOSE(SELF.ToolbarItem)
    IF ~SELF.EditList &= NULL
      LOOP I = 1 TO RECORDS(SELF.EditList)
        GET(SELF.EditList,I)
        IF SELF.EditList.FreeUp
          DISPOSE(SELF.EditList.Control)
        END
      END
      DISPOSE(SELF.EditList)
    END

BrowseClass.Next PROCEDURE
Res BYTE,AUTO
  CODE
    Res = PARENT.Next()
    CASE Res
    OF Level:Notify
      SELF.UpdateResets
    OF Level:Fatal
      POST(EVENT:CloseWindow)
    END
    RETURN Res

BrowseClass.PostNewSelection PROCEDURE
  CODE
  SELF.ListControl{PROP:SelStart} = SELF.CurrentChoice
  POST(Event:NewSelection,SELF.ListControl,,1)

BrowseClass.Previous  PROCEDURE
Res BYTE,AUTO
  CODE
    Res = PARENT.Previous()
    CASE Res
    OF Level:Notify
      SELF.UpdateResets
    OF Level:Fatal
      POST(EVENT:CloseWindow)
    END
    RETURN Res

BrowseClass.Records PROCEDURE
RVal BYTE,AUTO
  CODE
    RVal = CHOOSE(RECORDS(SELF.ListQueue))
    IF ~SELF.Sort.Locator &= NULL
      SELF.Sort.Locator.SetEnabled(RVal)
    END
    IF ~RVal
      SELF.CurrentChoice = 0
    END
    RETURN RECORDS(SELF.ListQueue)

BrowseClass.ResetFromAsk PROCEDURE(*BYTE Request,*BYTE Response)
  CODE
  IF Response = RequestCompleted
    FLUSH(SELF.View)
    IF Request = DeleteRecord
      DELETE(SELF.ListQueue)
      SELF.ResetQueue(Reset:Queue)
    ELSE
      SELF.ResetFromFile
    END
  ELSE
    SELF.ResetQueue(Reset:Queue)
  END
  IF SELF.Window.VCRRequest = VCR:Insert OR SELF.Window.VCRRequest = VCR:Forward AND Request = InsertRecord
    Request = InsertRecord
    GET(SELF.Primary.Me.File,0)
    CLEAR(SELF.Primary.Me.File)
  ELSE
    SELF.TakeVCRScroll(SELF.Window.VCRRequest)
  END
  IF SELF.Window.VCRRequest = VCR:None
    SELF.ResetFromView
    SELF.UpdateWindow
    SELF.PostNewSelection
    SELECT(SELF.ListControl)
  END


BrowseClass.ResetFromBuffer PROCEDURE
  CODE
    IF SELF.Sort.MainKey &= NULL
      SELF.Reset(1)
    ELSE
      SELF.Reset(SELF.Primary.Me.GetComponents(SELF.Sort.MainKey))
    END
    SELF.ResetQueue(Reset:Done)
    SELF.UpdateWindow

BrowseClass.ResetFromFile PROCEDURE
  CODE
    RESET(SELF.View,SELF.Primary.Me.File)
    ASSERT(~ERRORCODE())
    SELF.ResetQueue(Reset:Done)

BrowseClass.ResetFromView PROCEDURE
  CODE
    SELF.ResetThumbLimits

! Strategy :
! Fill forward from starting position.
! The 'highlight' is either
!    a) The current choice (Reset:Queue)
!    b) The First record read forwards (Reset:Done)
!    c) The first record read backwards (when Reset:Done is beyond EOF)
! If ResetDone and RetainingRow it is -probably- better not to fill the whole page.
! Find where highlighted record is in current set and add records (first to beginning, then end) to fill page
! As this can possible result in too many records, start deleting, trying to move CurrentChoice to correct position
! Noteworthy tweaks :-
!   If loading from start of record set there is no point going backwards
!   If FromQueue then load from -first- element not -required- one (you will probably get lucky and find required where you want it)
!   If EOF hit on read forward then no point attempting to read forward again
BrowseClass.ResetQueue PROCEDURE(BYTE RefreshMode)
HighlightRequired UNSIGNED
TopMargin         SIGNED
HighlightedPosition      STRING(512)
FromTop           BYTE
EofHit            BYTE,AUTO
  CODE
  IF ~SELF.ActiveInvisible AND SELF.ListControl{PROP:Visible}=0
    SELF.LoadPending = 1
    RETURN
  END
  SELF.Loaded = 1
  SELF.LoadPending = 0
  SETCURSOR(Cursor:Wait)
  IF ~SELF.CurrentChoice THEN SELF.CurrentChoice = 1.
  IF RefreshMode = Reset:Done
    IF SELF.RetainRow
      TopMargin = SELF.CurrentChoice - 1
    END
  ELSE
    IF RECORDS(SELF.ListQueue)
      GET(SELF.ListQueue,SELF.CurrentChoice)
      IF ERRORCODE()
        GET(SELF.ListQueue,RECORDS(SELF.ListQueue))
      END
      HighlightedPosition = SELF.ViewPosition
      GET(SELF.ListQueue,1)
      RESET(SELF.View,SELF.ViewPosition)
    ELSE
      FromTop = 1
      SELF.Reset
    END
  END
  IF SELF.RetainRow
    HighlightRequired = SELF.CurrentChoice
  END
  FREE(SELF.ListQueue)
  SELF.ItemsToFill = SELF.LastItems-TopMargin
  SELF.Fetch(FillForward)
  EofHit = CHOOSE(SELF.ItemsToFill)
  IF ~HighlightedPosition AND RECORDS(SELF.ListQueue)
    GET(SELF.ListQueue,1)
    HighLightedPosition = SELF.ViewPosition
  END
  DO ResetCurrentChoice
  IF ~RECORDS(SELF.ListQueue)  ! Probably a locate beyond EOF
    SELF.Reset
  END
  SELF.ItemsToFill = CHOOSE(SELF.AllowUnfilled=0,SELF.LastItems - RECORDS(SELF.ListQueue),0)
  IF ~FromTop AND ( SELF.ItemsToFill OR TopMargin > 0 )
    SELF.ItemsToFill = CHOOSE(SELF.ItemsToFill > TopMargin,SELF.ItemsToFill,TopMargin)
    SELF.Fetch(FillBackward)
    IF ~HighlightedPosition AND RECORDS(SELF.ListQueue)
      GET(SELF.ListQueue,RECORDS(SELF.ListQueue))
      HighLightedPosition = SELF.ViewPosition
    END
    DO ResetCurrentChoice
  END
  IF SELF.RetainRow AND (TopMargin < 0 OR RECORDS(SELF.ListQueue) < SELF.LastItems AND ~EofHit)
    SELF.ItemsToFill = CHOOSE(-TopMargin > SELF.LastItems-RECORDS(SELF.ListQueue),-TopMargin,SELF.LastItems-RECORDS(SELF.ListQueue))
    SELF.Fetch(FillForward)
    DO ResetCurrentChoice
  END
  LOOP WHILE RECORDS(SELF.ListQueue) > SELF.LastItems ! May have happened if over-read to get row correct
    IF TopMargin < 0
      GET(SELF.ListQueue,1)
      DELETE(SELF.ListQueue)
      TopMargin += 1
      SELF.CurrentChoice -= 1
    ELSE
      GET(SELF.ListQueue,RECORDS(SELF.ListQueue))
      DELETE(SELF.ListQueue)
    END
  END
  IF ~SELF.CurrentChoice
    SELF.CurrentChoice = 1
  END
  IF SELF.Records()
    SELF.UpdateBuffer
  ELSE
    CLEAR(SELF.Primary.Me.File)
  END
  SETCURSOR()

ResetCurrentChoice ROUTINE
  IF HighlightedPosition
    LOOP SELF.CurrentChoice = 1 TO RECORDS(SELF.ListQueue)
      GET(SELF.ListQueue,SELF.CurrentChoice)
    UNTIL SELF.ViewPosition = HighLightedPosition
    IF SELF.CurrentChoice > RECORDS(SELF.ListQueue)
      SELF.CurrentChoice = 0
    END
  ELSE
    SELF.CurrentChoice = 1
  END
  IF SELF.RetainRow
    TopMargin = HighlightRequired-SELF.CurrentChoice
  END

BrowseClass.ResetResets PROCEDURE
  CODE
    SELF.Sort.Resets.AssignLeftToRight

BrowseClass.ResetSort PROCEDURE(BYTE Force)
  CODE
    RETURN SELF.SetSort(POINTER(SELF.Sort),Force)

! Thumb limits are set using the extrema of the underlying view
BrowseClass.ResetThumbLimits PROCEDURE
HighValue ANY
  CODE
  IF SELF.Sort.Thumb &= NULL OR ~SELF.Sort.Thumb.SetLimitNeeded() OR ~SELF.AllowUnfilled AND SELF.ListControl{PROP:Items} > RECORDS(SELF.ListQueue)
    RETURN
  END
  SELF.Reset
  IF SELF.Previous()
    RETURN
  END
  HighValue = SELF.Sort.FreeElement
  SELF.Reset
  IF SELF.Next()
    RETURN
  END
  SELF.Sort.Thumb.SetLimit(SELF.Sort.FreeElement,HighValue)

BrowseClass.ScrollOne PROCEDURE(SIGNED Ev)
  CODE
  SELF.CurrentEvent = Ev
  IF Ev = Event:ScrollUp AND SELF.CurrentChoice > 1
    SELF.CurrentChoice -= 1
  ELSIF Ev = Event:ScrollDown AND SELF.CurrentChoice < RECORDS(SELF.ListQueue)
    SELF.CurrentChoice += 1
  ELSE
    SELF.ItemsToFill = 1
    SELF.Fetch(CHOOSE(Ev = EVENT:ScrollUp,1,2))
  END

BrowseClass.ScrollPage PROCEDURE(SIGNED Ev)
  CODE
    SELF.CurrentEvent = Ev
    SELF.ItemsToFill = SELF.ListControl{Prop:Items}
    SELF.Fetch(CHOOSE(Ev = EVENT:PageUp,1,2))                           ! Fill with next read(s)
    IF SELF.ItemsToFill
      IF SELF.CurrentEvent = Event:PageUp
        SELF.CurrentChoice -= SELF.ItemsToFill
        IF SELF.CurrentChoice < 1
          SELF.CurrentChoice = 1
        END
      ELSE
        SELF.CurrentChoice += SELF.ItemsToFill
        IF SELF.CurrentChoice > RECORDS(SELF.ListQueue)
          SELF.CurrentChoice = RECORDS(SELF.ListQueue)
        END
      END
    END

BrowseClass.ScrollEnd PROCEDURE(SIGNED Ev)
  CODE
    SELF.CurrentEvent = Ev
    FREE(SELF.ListQueue)
    SELF.Reset
    SELF.ItemsToFill = SELF.ListControl{Prop:Items}
    SELF.Fetch(CHOOSE(SELF.CurrentEvent = Event:ScrollTop,FillForward,FillBackward))                           ! Fill with next read(s)
    SELF.CurrentChoice = CHOOSE(SELF.CurrentEvent = Event:ScrollTop,1,RECORDS(SELF.ListQueue))

BrowseClass.SetAlerts PROCEDURE
I BYTE,AUTO
  CODE
    SELF.ListControl{Prop:Alrt,MouseLeft2Index} = MouseLeft2
    SELF.HasThumb = CHOOSE(SELF.ListControl{PROP:VScroll})
    SELF.ListControl{PROP:VScroll} = 0 ! Not really the right place for this but we want to avoid the peek-a-boo scrollbar
    LOOP I = 1 TO RECORDS(SELF.Sort)
      GET(SELF.Sort,I)
      IF ~ (SELF.Sort.Locator &= NULL)
        SELF.Sort.Locator.SetAlerts(SELF.ListControl)
      END
    END
    IF SELF.InsertControl
      SELF.ListControl{Prop:Alrt,255} = InsertKey
      SELF.Popup.AddItemMimic(DefaultInsertName,SELF.InsertControl,'!'&DefaultInsertName)
    END
    IF SELF.ChangeControl
      SELF.ListControl{Prop:Alrt,253} = CtrlEnter
      SELF.Popup.AddItemMimic(DefaultChangeName,SELF.ChangeControl,'!'&DefaultChangeName)
    END
    IF SELF.DeleteControl
      SELF.ListControl{Prop:Alrt,254} = DeleteKey
      SELF.Popup.AddItemMimic(DefaultDeleteName,SELF.DeleteControl,'!'&DefaultDeleteName)
    END
    IF SELF.PrintControl
      SELF.Popup.AddItemMimic(DefaultPrintName,SELF.PrintControl,'!'&DefaultPrintName)
    END
    IF SELF.SelectControl AND SELF.Selecting
      SELF.Popup.AddItemMimic(DefaultSelectName,SELF.SelectControl,'!'&DefaultSelectName)
    END

BrowseClass.SetQueueRecord PROCEDURE
  CODE
    SELF.Fields.AssignLeftToRight
    SELF.ViewPosition = POSITION(SELF.View)

BrowseClass.SetSort PROCEDURE(BYTE B,BYTE Force)
RVal BYTE(0)
  CODE
    IF SELF.SetSort(B)
      IF ~SELF.Sort.Locator &= NULL
        SELF.Sort.Locator.Set
      END
      Rval = 1
    END
    IF SELF.ApplyRange() OR Rval OR Force OR ~SELF.Loaded OR SELF.LoadPending
      SELF.ResetResets
      SELF.ApplyOrder
      SELF.ApplyFilter
      IF (SELF.Selecting OR SELF.StartAtCurrent) AND ~SELF.Loaded
        SELF.Reset(SELF.GetFreeElementPosition())
        SELF.ResetQueue(Reset:Done)
      ELSIF RECORDS(SELF.ListQueue)
        RESET(SELF.View,SELF.ViewPosition)
        SELF.ResetQueue(Reset:Done)
      ELSE
        SELF.ResetQueue(Reset:Queue)
      END
      IF ~SELF.LoadPending
        SELF.PostNewSelection
        SELF.ResetFromView
        Rval = 1
      END
    END
    SELF.UpdateBuffer
    RETURN Rval

BrowseClass.TakeAcceptedLocator PROCEDURE
  CODE
    IF ~SELF.Sort.Locator &= NULL AND ACCEPTED() = SELF.Sort.Locator.Control
      IF SELF.Sort.Locator.TakeAccepted()
        SELF.Reset(SELF.GetFreeElementPosition())
        SELECT(SELF.ListControl)
        SELF.ResetQueue(Reset:Done)
        SELF.Sort.Locator.Reset
        SELF.UpdateWindow
      END
    END

BrowseClass.TakeEvent PROCEDURE
VSP BYTE,AUTO
  CODE
    IF FIELD() = SELF.ListControl
      CASE EVENT()
      OF EVENT:ScrollUp
      OROF EVENT:ScrollDown
      OROF EVENT:PageUp
      OROF EVENT:PageDown
      OROF EVENT:ScrollTop
      OROF EVENT:ScrollBottom
        SELF.TakeScroll
      OF EVENT:ScrollDrag
        VSP = SELF.ListControl{PROP:VScrollPos}
        IF VSP <= 1
          POST(Event:ScrollTop,SELF.ListControl)
        ELSIF VSP = 100
          POST(Event:ScrollBottom,SELF.ListControl)
        ELSE
          IF ~(SELF.Sort.FreeElement &= NULL) AND ~(SELF.Sort.Thumb &= NULL)
            SELF.Sort.FreeElement = SELF.Sort.Thumb.GetValue(VSP)
            SELF.ResetFromBuffer
          ELSIF VSP < 50
            POST(Event:PageUp,SELF.ListControl)
          ELSIF VSP > 50
            POST(Event:PageDown,SELF.ListControl)
          END
        END
      OF EVENT:AlertKey
        SELF.TakeKey
      OF EVENT:NewSelection
        SELF.TakeNewSelection
      END
    END
    CASE ACCEPTED()
    OF 0
    OF SELF.DeleteControl
      SELF.Window.Update()
      SELF.Ask(DeleteRecord)
    OF SELF.ChangeControl
      SELF.Window.Update()
      SELF.Ask(ChangeRecord)
    OF SELF.InsertControl
      SELF.Window.Update()
      SELF.Ask(InsertRecord)
    OF SELF.SelectControl
      SELF.Window.Response = RequestCompleted
      POST(EVENT:CloseWindow)
    OF SELF.PrintControl
      SELF.UpdateViewRecord
      SELF.Window.Run(SELF.PrintProcedure,ProcessRecord)
    ELSE
      SELF.TakeAcceptedLocator
    END
    IF EVENT() = EVENT:CloseWindow AND SELF.Window.Response = RequestCompleted AND SELF.Selecting
      SELF.UpdateBuffer
    END

BrowseClass.TakeKey PROCEDURE
  CODE
    IF RECORDS(SELF.ListQueue)
      CASE KEYCODE()
      OF InsertKey
        DO CheckInsert
      OF DeleteKey
        IF SELF.DeleteControl
          POST(EVENT:Accepted,SELF.DeleteControl)
          DO HandledOut
        END
      OF CtrlEnter
        DO CheckChange
      OF MouseLeft2
        IF SELF.Selecting
          IF SELF.SelectControl
            POST(EVENT:Accepted,SELF.SelectControl)
            DO HandledOut
          END
        ELSE
          DO CheckChange
        END
      ELSE
        DO CheckLocator
      END
    ELSE
      DO CheckLocator
      DO CheckInsert
    END
    RETURN 0

CheckLocator ROUTINE
  IF ~(SELF.Sort.Locator &= NULL)
    IF SELF.Sort.Locator.TakeKey()
      SELF.Reset(SELF.GetFreeElementPosition())
      SELF.ResetQueue(Reset:Done)
      DO HandledOut
    ELSE
      IF RECORDS(SELF.ListQueue)
        DO HandledOut
      END
    END
  END

HandledOut ROUTINE
  SELF.UpdateWindow
  SELF.PostNewSelection
  RETURN 1

CheckInsert ROUTINE
  IF SELF.InsertControl AND KEYCODE() = InsertKey
    POST(EVENT:Accepted,SELF.InsertControl)
    DO HandledOut
  END

CheckChange ROUTINE
  IF SELF.ChangeControl
    POST(EVENT:Accepted,SELF.ChangeControl)
    SELF.UpdateBuffer
    DO HandledOut
  END

BrowseClass.TakeNewSelection PROCEDURE
  CODE
  IF RECORDS(SELF.ListQueue)
    SELF.CurrentChoice = CHOICE(SELF.ListControl)
    SELF.LastChoice = SELF.CurrentChoice
  END
  SELF.UpdateBuffer
  IF KEYCODE() = MouseRight
    SELF.Popup.Ask()
  ELSE
    SELF.Window.Reset
  END

BrowseClass.TakeScroll PROCEDURE(SIGNED E)
  CODE
  IF ~E
    E = EVENT()
  END
  IF RECORDS(SELF.ListQueue)
    CASE E
    OF Event:ScrollUp OROF Event:ScrollDown
      SELF.ScrollOne(E)
    OF Event:PageUp OROF Event:PageDown
      SELF.ScrollPage(E)
    OF Event:ScrollTop OROF Event:ScrollBottom
      SELF.ScrollEnd(E)
    END
    SELF.TakeChoiceChanged
  END

BrowseClass.TakeChoiceChanged PROCEDURE
  CODE
    SELF.PostNewSelection
    IF ~SELF.Sort.Locator &= NULL
      SELF.Sort.Locator.Set
    END
    IF SELF.Sort.Thumb &= NULL
      SELF.UpdateThumbFixed
    END

BrowseClass.TakeVCRScroll PROCEDURE(SIGNED Vcr)
  CODE
    CASE Vcr
    OF VCR:Forward
      SELF.TakeScroll(Event:ScrollDown)
    OF VCR:Backward
      SELF.TakeScroll(Event:ScrollUp)
    OF VCR:PageForward
      SELF.TakeScroll(Event:PageDown)
    OF VCR:PageBackward
      SELF.TakeScroll(Event:PageUp)
    OF VCR:First
      SELF.TakeScroll(Event:ScrollTop)
    OF VCR:Last
      SELF.TakeScroll(Event:ScrollBottom)
    ELSE
      RETURN
    END
    SELF.Window.Reset
    SELF.Window.Update

BrowseClass.UpdateBuffer PROCEDURE
  CODE
    IF RECORDS(SELF.ListQueue)
      GET(SELF.ListQueue,SELF.CurrentChoice)
      SELF.Fields.AssignRightToLeft
    ELSE
      SELF.Fields.ClearLeft
    END

BrowseClass.UpdateResets PROCEDURE
  CODE
    SELF.Sort.Resets.AssignRightToLeft

BrowseClass.UpdateThumbFixed PROCEDURE
Pos BYTE(50)
  CODE
    IF SELF.ItemsToFill
      CASE SELF.CurrentEvent
      OF Event:ScrollDown
      OROF Event:PageDown
      OROF Event:ScrollBottom
        IF SELF.CurrentChoice = RECORDS(SELF.ListQueue)
          Pos = 100
        END
      ELSE
        IF SELF.CurrentChoice = 1
          Pos = 0
        END
      END
    END
    SELF.ListControl{PROP:VScrollPos} = Pos

!|
!| This routine is used to retrieve the VIEW record that corresponds to a
!| chosen listbox record.
!|
BrowseClass.UpdateViewRecord    PROCEDURE
  CODE
    IF RECORDS(SELF.ListQueue)
      SELF.CurrentChoice = CHOICE(SELF.ListControl)
      GET(SELF.ListQueue,SELF.CurrentChoice)
      WATCH(SELF.View)
      REGET(SELF.View,SELF.ViewPosition)
    END

BrowseClass.UpdateWindow PROCEDURE
  CODE
    IF ~(SELF.Sort.Locator &= NULL)
      SELF.Sort.Locator.UpdateWindow
    END
    IF SELF.Records()
      IF SELF.ChangeControl
        ENABLE(SELF.ChangeControl)
      END
      IF SELF.DeleteControl
        ENABLE(SELF.DeleteControl)
      END
      IF SELF.PrintControl
        ENABLE(SELF.PrintControl)
      END
    ELSE
      IF SELF.ChangeControl
        DISABLE(SELF.ChangeControl)
      END
      IF SELF.DeleteControl
        DISABLE(SELF.DeleteControl)
      END
      IF SELF.PrintControl
        DISABLE(SELF.PrintControl)
      END
    END
    IF SELF.SelectControl
      IF SELF.Selecting
        IF SELF.RECORDS() AND SELF.Window.Request = SelectRecord
          ENABLE(SELF.SelectControl)
          SELF.SelectControl{PROP:Default} = 1
        ELSE
          DISABLE(SELF.SelectControl)
        END
      ELSIF SELF.HideSelect
        DISABLE(SELF.SelectControl)   ! For the benefit of the toolbar
        HIDE(SELF.SelectControl)
      END
    END
    SELF.UpdateThumb
    IF ~SELF.Toolbar &= NULL
      SELF.Toolbar.DisplayButtons
    END
    DISPLAY(SELF.ListControl)
    SELF.ListControl{PROP:SelStart} = SELF.CurrentChoice

BrowseClass.UpdateThumb PROCEDURE
  CODE
  IF SELF.HasThumb AND RECORDS(SELF.ListQueue) >= SELF.ListControl{PROP:Items}
    SELF.ListControl{Prop:VScroll} = True
    IF SELF.Sort.Thumb &= NULL OR SELF.Sort.FreeElement &= NULL
      SELF.UpdateThumbFixed
    ELSIF SELF.Loaded AND ~SELF.LoadPending
      SELF.UpdateBuffer
      SELF.ListControl{PROP:VScrollPos} = SELF.Sort.Thumb.GetPercentile(SELF.Sort.FreeElement)
    END
  ELSE
    SELF.ListControl{Prop:VScroll} = False
  END

BrowseClass.UpdateToolbarButtons PROCEDURE
  CODE
    IF SELF.InsertControl
      SELF.ToolbarItem.InsertButton = SELF.InsertControl
    END
    IF SELF.DeleteControl
      SELF.ToolbarItem.DeleteButton = SELF.DeleteControl
    END
    IF SELF.ChangeControl
      SELF.ToolbarItem.ChangeButton = SELF.ChangeControl
    END
    IF SELF.SelectControl
      SELF.ToolbarItem.SelectButton = SELF.SelectControl
    END
    SELF.Toolbar.SetTarget(SELF.ListControl)

! Locator classes
LocatorClass.Init PROCEDURE(SIGNED Control,*? Free,BYTE NoCase,<BrowseClass VM>)
  CODE
    SELF.FreeElement &= Free
    SELF.Control = Control
    SELF.NoCase = NoCase
    SELF.ViewManager &= VM

LocatorClass.Destruct PROCEDURE
  CODE
    SELF.FreeElement &= NULL

LocatorClass.Reset PROCEDURE
  CODE

LocatorClass.SetAlerts PROCEDURE(SIGNED S)
  CODE

LocatorClass.SetEnabled PROCEDURE(BYTE E)
  CODE
    IF SELF.Control
      SELF.Control{PROP:Disable} = CHOOSE(E=0)
    END

LocatorClass.TakeAccepted PROCEDURE
  CODE
    RETURN 0

LocatorClass.TakeKey PROCEDURE
  CODE
    RETURN 0

LocatorClass.Set PROCEDURE
  CODE
    SELF.FreeElement = ''

LocatorClass.UpdateWindow PROCEDURE
  CODE
    SELF.Set ! Locators typically 'one-shot' so updateing the screen nullifies them

StepLocatorClass.Set PROCEDURE
  CODE

StepLocatorClass.TakeKey PROCEDURE
Key BYTE,AUTO
Handled BYTE(0)
  CODE
    Key = KEYCHAR()
    IF Key
      IF RECORDS(SELF.ViewManager.ListQueue)
        Handled = 1
        SELF.ViewManager.ScrollOne(EVENT:ScrollDown)
        SELF.ViewManager.UpdateBuffer
      END
      IF SELF.NoCase AND UPPER(SUB(SELF.FreeElement,1,1)) <> UPPER(CHR(Key)) OR |
         ~SELF.NoCase AND SUB(SELF.FreeElement,1,1) <> CHR(Key)
        SELF.FreeElement = CHR(Key)
        Handled = 1
      END
    END
    RETURN Handled

EntryLocatorClass.TakeAccepted PROCEDURE
  CODE
    UPDATE(SELF.Control)
    SELF.FreeElement = SELF.Shadow
    IF SELF.FreeElement
      RETURN 1
    ELSE
      RETURN 0
    END

EntryLocatorClass.TakeKey PROCEDURE
  CODE
    IF CHR(KEYCHAR()) AND SELF.Control{PROP:Enabled}
      SELECT(SELF.Control)
      PRESS(CHR(KEYCHAR()))
      RETURN 1
    ELSE
      RETURN 0
    END

EntryLocatorClass.Init PROCEDURE(SIGNED Control,*? Free,BYTE NoCase,<BrowseClass VM>)
  CODE
    PARENT.Init(Control,Free,NoCase,VM)
    Control{PROP:Use} = SELF.Shadow

EntryLocatorClass.Update PROCEDURE
  CODE
    SELF.FreeElement = SELF.Shadow
    SELF.UpdateWindow

EntryLocatorClass.Set PROCEDURE
  CODE
    CLEAR(SELF.Shadow)
    PARENT.Set
    SELF.Update

EntryLocatorClass.UpdateWindow PROCEDURE
  CODE
    DISPLAY(SELF.Control)

IncrementalLocatorClass.SetAlerts PROCEDURE(SIGNED S)
  CODE
    S{PROP:Alrt,250} = BSKey
    S{PROP:Alrt,251} = SpaceKey

IncrementalLocatorClass.TakeKey PROCEDURE
Key BYTE,AUTO
  CODE
    Key = KEYCHAR()
    IF KEYCODE() = BSKey
      IF LEN(SELF.Shadow)
        SELF.Shadow = SELF.Shadow[1:LEN(SELF.Shadow) - 1]
      END
      SELF.Update
      RETURN 1
    ELSIF KEYCODE() = SpaceKey OR Key
      SELF.Shadow = SELF.Shadow & CHOOSE(KEYCODE()=SpaceKey,' ',CHR(Key))
      SELF.Update
      RETURN 1
    END
    RETURN 0



FilterLocatorClass.Reset PROCEDURE
  CODE

FilterLocatorClass.UpdateWindow PROCEDURE
FN CSTRING(100),AUTO
SN CSTRING(100),AUTO
  CODE
    ASSERT(~SELF.ViewManager &= NULL)
    FN = SELF.ViewManager.GetFreeElementName()
    SN = CHOOSE(INSTRING('UPPER(',FN,1,1) = 0,SELF.Shadow,UPPER(SELF.Shadow))
    IF SELF.FloatRight
      SELF.ViewManager.SetFilter(CHOOSE(SN='','','INSTRING('''&SN&''','&FN&',1,1) <<> 0'),'3 Locator')
    ELSE
      SELF.ViewManager.SetFilter('SUB('&FN&',1,'&LEN(SELF.Shadow)&') = '''& SN & '''','3 Locator')
    END
    SELF.ViewManager.ApplyFilter()
    SELF.FreeElement = SELF.Shadow
    DISPLAY(SELF.Control)

FilterLocatorClass.TakeAccepted PROCEDURE
  CODE
    UPDATE(SELF.Control)
    SELF.Shadow = CLIP(CONTENTS(SELF.Control))
    IF SELF.FreeElement
      SELF.UpdateWindow
      RETURN 1
    ELSE
      RETURN 0
    END
