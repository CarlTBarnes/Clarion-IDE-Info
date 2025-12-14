  MEMBER

_ABCDllMode_  EQUATE(0)
_ABCLinkMode_ EQUATE(1)

  MAP
DeleteQueueItem PROCEDURE(TranslatorClass SELF)
  END

  INCLUDE('ABUTIL.INC')
  INCLUDE('ABUTIL.TRN')

MaxTLen EQUATE(1024)

TranslatorQueue     QUEUE,TYPE
TextProp              STRING(MaxTLen)
Replacement           STRING(MaxTLen)
ItemID                USHORT
                    END


ConstDescriptorList QUEUE,TYPE
ItemType              BYTE
Destination           ANY
                    END


ConstantClass.Init PROCEDURE(BYTE Termination)

  CODE
  SELF.Str &= NULL
  SELF.Descriptor &= NEW ConstDescriptorList
  SELF.Termination=Termination
  CLEAR(SELF.TerminatorValue)
  SELF.Reset


ConstantClass.Kill PROCEDURE

  CODE
  GET(SELF.Descriptor,1)
  LOOP WHILE ~ERRORCODE()
    SELF.Descriptor.Destination &= NULL
    GET(SELF.Descriptor,POINTER(SELF.Descriptor)+1)
  END
  DISPOSE(SELF.Descriptor)
  DISPOSE(SELF.Str)


ConstantClass.Reset PROCEDURE

  CODE
  SELF.RecordPnt=1
  SELF.CharPnt=1
  IF ~SELF.Str&=NULL
    CASE SELF.Termination
    OF Term:Byte
      SELF.Items=SELF.GetByte()
    OF Term:UShort
      SELF.Items=SELF.GetUShort()
    END
  ELSE
    SELF.Items=0
  END


ConstantClass.Set PROCEDURE(*STRING Src)

  CODE
  DISPOSE(SELF.Str)
  SELF.Str &= NEW STRING(LEN(Src))
  SELF.Str = Src
  SELF.SourceSize=LEN(SELF.Str)
  SELF.Reset


ConstantClass.AddItem PROCEDURE(BYTE ItemType,*? Dest)

  CODE
  CLEAR(SELF.Descriptor)
  SELF.Descriptor.ItemType=ItemType
  SELF.Descriptor.Destination &= Dest
  ADD(SELF.Descriptor)
  ASSERT(~ERRORCODE())


ConstantClass.Next PROCEDURE

  CODE
  ASSERT(SELF.Termination<>Term:FieldValue OR SELF.TerminatorValue)
  CASE SELF.Termination
  OF Term:Byte
  OROF Term:UShort
    IF SELF.RecordPnt>SELF.Items THEN RETURN Level:Notify.
  OF Term:EndGroup
    IF SELF.CharPnt>SELF.SourceSize THEN RETURN Level:Notify.
  END
  GET(SELF.Descriptor,1)
  LOOP WHILE ~ERRORCODE()
    CASE SELF.Descriptor.ItemType
    OF ConstType:CString
      SELF.Descriptor.Destination=SELF.GetCString()
    OF ConstType:PString
      SELF.Descriptor.Destination=SELF.GetPString()
    OF ConstType:Byte
      SELF.Descriptor.Destination=SELF.GetByte()
    OF ConstType:Short
      SELF.Descriptor.Destination=SELF.GetShort()
    OF ConstType:UShort
      SELF.Descriptor.Destination=SELF.GetUShort()
    OF ConstType:Long
      SELF.Descriptor.Destination=SELF.GetLong()
    ELSE
      ASSERT(False)
    END
    IF POINTER(SELF.Descriptor)=1 AND SELF.Termination=Term:FieldValue AND SELF.Descriptor.Destination=SELF.TerminatorValue
      RETURN Level:Notify
    END
    GET(SELF.Descriptor,POINTER(SELF.Descriptor)+1)
  END
  SELF.RecordPnt+=1
  RETURN Level:Benign


ConstantClass.Next PROCEDURE(QUEUE Q)

  CODE
  SELF.Reset
  LOOP WHILE SELF.Next()=Level:Benign
    ADD(Q)
    ASSERT(~ERRORCODE())
  END


ConstantClass.Next PROCEDURE(FILE F)

  CODE
  SELF.Reset
  LOOP WHILE SELF.Next()=Level:Benign
    ADD(F)
    ASSERT(~ERRORCODE())
  END


ConstantClass.GetByte PROCEDURE()

RVal  BYTE,AUTO

  CODE
  ASSERT(SELF.CharPnt<=LEN(SELF.Str))     !Exceeded limit of source string, probable descriptor/group structure layout mismatch
  RVal=VAL(SELF.Str[SELF.CharPnt])
  SELF.CharPnt+=1
  RETURN RVal


ConstantClass.GetUShort PROCEDURE()

RVal USHORT,AUTO

  CODE
  RVal=SELF.GetByte()
  RETURN RVal+BSHIFT(SELF.GetByte(),8)


ConstantClass.GetShort PROCEDURE()

RVal  SHORT,AUTO

  CODE
  RVal=SELF.GetUShort()            !Req'd for type conversion
  RETURN RVal


ConstantClass.GetLong PROCEDURE()

RVal  LONG,AUTO

  CODE
  RVal=SELF.GetUShort()
  RETURN RVal+BSHIFT(SELF.GetShort(),16)


ConstantClass.GetPString PROCEDURE()

i     BYTE,AUTO
RVal  STRING(256),AUTO

  CODE
  LOOP i=1 TO SELF.GetByte()
    RVal[i]=CHR(SELF.GetByte())
  END
  RETURN SUB(RVal,1,i-1)


ConstantClass.GetCString PROCEDURE()

b     BYTE,AUTO
Cnt   USHORT(0)
RVal  CSTRING(1024),AUTO

  CODE
  LOOP
    b=SELF.GetByte()
    IF ~b
      BREAK
    ELSE
      Cnt+=1
      RVal[Cnt]=CHR(b)
    END
  END
  RETURN SUB(RVal,1,Cnt)



! FieldPairs class. Manages a queue with two pairs of fields
FieldPairsClass.AddItem PROCEDURE(*? Left)
  CODE
    ASSERT(~(SELF.List &= NULL))
    CLEAR(SELF.List)
    SELF.List.Left &= Left
    SELF.List.Right = Left
    ADD(SELF.List)

FieldPairsClass.AddPair PROCEDURE(*? Left,*? Right)
  CODE
    ASSERT(~(SELF.List &= NULL))
    CLEAR(SELF.List)
    SELF.List.Left &= Left
    SELF.List.Right &= Right
    ADD(SELF.List)

FieldPairsClass.AssignLeftToRight PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.List.Right = SELF.List.Left
      PUT(SELF.List)
    END

FieldPairsClass.AssignRightToLeft PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.List.Left = SELF.List.Right
      PUT(SELF.List)
    END

FieldPairsClass.ClearLeft PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      CLEAR(SELF.List.Left)
    END

FieldPairsClass.ClearRight PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      CLEAR(SELF.List.Right)
    END

FieldPairsClass.EqualLeftRight PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      IF SELF.List.Left <> SELF.List.Right
        RETURN 0
      END
    END
    RETURN 1

FieldPairsClass.Equal PROCEDURE
  CODE
    RETURN SELF.EqualLeftRight()

FieldPairsClass.Kill PROCEDURE
  CODE
    IF ~SELF.List &= NULL
      GET(SELF.List,1)
      LOOP WHILE ~ERRORCODE()
        SELF.List.Left &= NULL
        SELF.List.Right &= NULL
        GET(SELF.List,POINTER(SELF.List)+1)
      END
      DISPOSE(SELF.List)
    END

FieldPairsClass.Init PROCEDURE
  CODE
    SELF.Kill
    SELF.List &= NEW FieldPairsQueue

! BufferedPairs class. Manages a queue with two pairs of fields
BufferedPairsClass.AddPair PROCEDURE(*? Left,*? Right)
Temp ANY
  CODE
    ASSERT(~(SELF.List &= NULL))
    CLEAR(SELF.List)
    SELF.List.Left &= Left
    SELF.List.Right &= Right
    Temp = Right                   ! Make sure Buffer has correct type
    CLEAR(Right)
    SELF.RealList.Buffer = Right
    Right = Temp
    ADD(SELF.List)

BufferedPairsClass.AssignLeftToBuffer PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.RealList.Buffer = SELF.List.Left
      PUT(SELF.RealList)
    END

BufferedPairsClass.AssignRightToBuffer PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.RealList.Buffer = SELF.List.Right
      PUT(SELF.RealList)
    END

BufferedPairsClass.AssignBufferToLeft PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.List.Left = SELF.RealList.Buffer
      PUT(SELF.RealList)
    END

BufferedPairsClass.AssignBufferToRight PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      SELF.List.Right = SELF.RealList.Buffer
      PUT(SELF.RealList)
    END

BufferedPairsClass.EqualLeftBuffer PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      IF SELF.RealList.Left <> SELF.RealList.Buffer
        RETURN 0
      END
    END
    RETURN 1

BufferedPairsClass.EqualRightBuffer PROCEDURE
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.List)
      GET(SELF.List,I)
      IF SELF.RealList.Right <> SELF.RealList.Buffer
        RETURN 0
      END
    END
    RETURN 1

BufferedPairsClass.Kill PROCEDURE
  CODE
    IF ~SELF.RealList&=NULL
      GET(SELF.RealList,1)
      LOOP WHILE ~ERRORCODE()
        SELF.RealList.Left &= NULL
        SELF.RealList.Right &= NULL
        SELF.RealList.Buffer &= NULL
        GET(SELF.RealList,POINTER(SELF.RealList)+1)
      END
      DISPOSE(SELF.RealList)
    END
    SELF.List &= SELF.RealList

BufferedPairsClass.Init PROCEDURE
  CODE
    SELF.Kill
    SELF.RealList &= NEW BufferedPairsQueue
    SELF.List &= SELF.RealList

INIClass.Init PROCEDURE(STRING S)
  CODE
    SELF.FileName = S

INIClass.Update PROCEDURE(STRING Sec,STRING Name,STRING Value)
  CODE
    PUTINI(Sec,Name,Value,SELF.FileName)

INIClass.Fetch PROCEDURE(STRING Sec,STRING Name,*? Value)
  CODE
    Value = GETINI(Sec,Name,Value,SELF.FileName)

INIClass.TryFetch PROCEDURE(STRING Sec,STRING Name)
  CODE
    RETURN GETINI(Sec,Name,'',SELF.FileName)

INIClass.Fetch PROCEDURE(STRING Sec,STRING Name)
Res CSTRING(1000),AUTO
  CODE
    Res = GETINI(Sec,Name,'---Unknown---',SELF.FileName)
    ASSERT(Res <> '---Unknown---')
    RETURN Res

INIClass.FetchField PROCEDURE(STRING Sec,STRING Name,BYTE Field)
Res CSTRING(1000),AUTO
I USHORT,AUTO
Finger USHORT(1)
  CODE
    Res = SELF.Fetch(Sec,Name)
    LOOP WHILE Field > 1
      Finger = INSTRING(',',Res,1,Finger)
      ASSERT(Finger)
      Finger += 1
      Field -= 1
    END
    I = INSTRING(',',Res,1,Finger)
    RETURN Res[Finger : CHOOSE(I = 0,LEN(Res),I-1) ]

INIClass.TryFetchField PROCEDURE(STRING Sec,STRING Name,BYTE Field)
Res CSTRING(1000),AUTO
I USHORT,AUTO
Finger USHORT(1)
  CODE
    Res = SELF.TryFetch(Sec,Name)
    IF ~Res THEN RETURN '' .
    LOOP WHILE Field > 1
      Finger = INSTRING(',',Res,1,Finger)
      IF ~Finger THEN RETURN '' .
      Finger += 1
      Field -= 1
    END
    I = INSTRING(',',Res,1,Finger)
    RETURN Res[Finger : CHOOSE(I = 0,LEN(Res),I-1) ]

! Queue Layout :
! [Sector]
! Name = ItemsInQueue
! Name_1 = F1,F2,F3 etc
INIClass.FetchQueue PROCEDURE(STRING Sector,STRING Name,QUEUE Q,*? F1,<*? F2>,<*? F3>)
NItems USHORT,AUTO
I byte,auto
  CODE
    NItems = SELF.Fetch(Sector,Name)
    LOOP I = 1 TO NItems
      F1 = SELF.FetchField(Sector,Name&'_'&I,1)
      IF ~OMITTED(6)
        F2 = SELF.FetchField(Sector,Name&'_'&I,2)
      END
      IF ~OMITTED(7)
        F3 = SELF.FetchField(Sector,Name&'_'&I,3)
      END
      ADD(Q)
    END

INIClass.Update PROCEDURE(STRING ProcedureName,WINDOW W)
M  SIGNED,AUTO
   CODE
   IF ~W{PROP:Iconize}
     M = W{PROP:Maximize}
     SELF.Update(ProcedureName,'Maximize',CHOOSE(M=True,'Yes','No'))
     IF ~M
       SELF.Update(ProcedureName,'XPos',W{PROP:XPos})
       SELF.Update(ProcedureName,'YPos',W{PROP:YPos})
       SELF.Update(ProcedureName,'Height',W{PROP:Height})
       SELF.Update(ProcedureName,'Width',W{PROP:Width})
     END
   END


INIClass.Fetch PROCEDURE(STRING ProcedureName,WINDOW W)
Maximize BYTE,AUTO
  CODE
  Maximize = INLIST(SELF.TryFetch(ProcedureName,'Maximize'),'No','Yes')
  IF Maximize
    Maximize -= 1
    IF ~Maximize AND W{PROP:Maximize}
      W{PROP:Maximize} = Maximize
    END
    IF SELF.TryFetch(ProcedureName,'XPos')
      W{PROP:XPos} = SELF.Fetch(ProcedureName,'XPos')
      W{PROP:YPos} = SELF.Fetch(ProcedureName,'YPos')
      W{PROP:Width} = SELF.Fetch(ProcedureName,'Width')
      W{PROP:Height} = SELF.Fetch(ProcedureName,'Height')
    END
    IF Maximize <> W{PROP:Maximize}
      W{PROP:Maximize} = Maximize
    END
  END


SelectFileClass.Init PROCEDURE

   CODE
   SELF.WindowTitle=Dfl:DefaultWindowTitle
   SELF.Flags=Dfl:DefaultFlags


SelectFileClass.AddMask PROCEDURE(STRING FileMasks)

  CODE
  IF FileMasks
    IF SELF.MaskString
      SELF.MaskString=CLIP(SELF.MaskString)&'|'&CLIP(FileMasks)
    ELSE
      SELF.MaskString=FileMasks
    END
  END


SelectFileClass.AddMask PROCEDURE(STRING Description,STRING Pattern)

  CODE
  ASSERT(~INSTRING('|',Description,1,1) AND ~INSTRING('|',Pattern,1,1))
  SELF.AddMask(CLIP(Description)&'|'&Pattern)


SelectFileClass.SetMask PROCEDURE(STRING Description,STRING Pattern)

  CODE
  ASSERT(~INSTRING('|',Description,1,1) AND ~INSTRING('|',Pattern,1,1))
  SELF.SetMask(CLIP(Description)&'|'&Pattern)


SelectFileClass.SetMask PROCEDURE(STRING FileMask)

  CODE
  CLEAR(SELF.MaskString)
  SELF.AddMask(FileMask)


SelectFileClass.Ask PROCEDURE(BYTE KeepDir=0)

Result    CSTRING(File:MaxFilePath)

  CODE
  IF KeepDir THEN SELF.SavePath=PATH().
  IF LEN(SELF.DefaultDirectory) THEN SETPATH(SELF.DefaultDirectory).
  Result=SELF.DefaultFile
  IF ~FILEDIALOG(SELF.WindowTitle,Result,CHOOSE(SELF.MaskString='',Dfl:DefaultFileMask,SELF.MaskString),SELF.Flags) THEN CLEAR(Result).
  IF KeepDir THEN SETPATH(SELF.SavePath).
  RETURN Result


SelectFileClass.Ask   PROCEDURE(SelectFileQueue DFQ,BYTE KeepDir=0)

ActualFlags BYTE,AUTO
Found       CSTRING(10000),AUTO
Path        CSTRING(File:MaxFilePath),AUTO
Separator   STRING(1),AUTO
Pos         UNSIGNED,AUTO
NameStart   UNSIGNED,AUTO

  CODE
  FREE(DFQ)
  IF KeepDir THEN SELF.SavePath=PATH().
  IF LEN(SELF.DefaultDirectory) THEN SETPATH(SELF.DefaultDirectory).
  Found=SELF.DefaultFile
  ActualFlags=BOR(SELF.Flags,FILE:Multi)
  ActualFlags=BAND(ActualFlags,255-FILE:Save)                 !Save dialog not allowed with mutli select
  IF FILEDIALOG(SELF.WindowTitle,Found,CHOOSE(SELF.MaskString='',Dfl:DefaultFileMask,SELF.MaskString),ActualFlags)
    Separator=CHOOSE(BAND(ActualFlags,FILE:LongName)=0,' ','|')
    Pos=INSTRING(Separator,Found,1,1)
    IF Pos                                       !Multi-Selected files
      Path = Found[1 : Pos-1]&'\'
      LOOP
        NameStart = Pos+1
        Pos = INSTRING(Separator,Found,1,NameStart)
        IF ~Pos THEN Pos=LEN(Found)+1.
        DFQ.Name = Path&Found[NameStart : Pos-1]
        DFQ.ShortName = CHOOSE(BAND(ActualFlags,FILE:LongName)=0,'',SHORTPATH(DFQ.Name))
        ADD(DFQ)
        ASSERT(~ERRORCODE())
      WHILE Pos<=LEN(Found)
    ELSE
      DFQ.Name=Found                                  !Single file only selected
      DFQ.ShortName=CHOOSE(BAND(ActualFlags,FILE:LongName)=0,'',SHORTPATH(DFQ.Name))
      ADD(DFQ)
      ASSERT(~ERRORCODE())
    END
  END
  IF KeepDir THEN SETPATH(SELF.SavePath).


TranslatorClass.Init PROCEDURE

   CODE
   SELF.Queue&=NEW(TranslatorQueue)
   SELF.AddTranslation(Translation)


TranslatorClass.AddTranslation PROCEDURE(TranslatorGroup TG)

Const    ConstantClass
Pnt      SIGNED(3)
TransStr &STRING
iLen     BYTE,AUTO
Text     CSTRING(MaxTLen),AUTO
Repl     CSTRING(MaxTLen),AUTO

  CODE
    Const.Init
    Const.AddItem(ConstType:PString,Text)
    Const.AddItem(ConstType:PString,Repl)
    Const.Set(TG)
    LOOP WHILE Const.Next()=Level:Benign
      SELF.AddTranslation(Text,Repl)
    END
    Const.Kill


TranslatorClass.Kill PROCEDURE

ExtractFilename CSTRING(FILE:MaxFilePath),AUTO,STATIC
ExtractFile     FILE,DRIVER('ASCII'),NAME(ExtractFilename),CREATE
                  RECORD
Line                STRING(MaxTLen)
                  END
                END
c               LONG,AUTO
d               USHORT,AUTO
Items           LONG

  CODE
  IF SELF.ExtractText
    ExtractFilename=SELF.ExtractText
    CREATE(ExtractFile)
    ASSERT(~ERRORCODE())
    OPEN(ExtractFile)
    ASSERT(~ERRORCODE())
    SELF.ExtractText=NAME(ExtractFile)                            !Fully qualifies file name
    LOOP c=1 TO RECORDS(SELF.Queue)
      GET(SELF.Queue,c)
      ASSERT(~ERRORCODE())
      IF ~SELF.Queue.Replacement THEN Items+=1.
    END
    d=INSTRING('.',SELF.ExtractText,1,1)
    IF ~d THEN d=LEN(SELF.ExtractText)+1.
    LOOP c=CHOOSE(d<=LEN(SELF.ExtractText),d,d-1) TO 0 BY -1
      IF c AND SELF.ExtractText[c]='\' THEN BREAK.
    END
    ExtractFile.Line=SUB(SELF.ExtractText[c+1 : d-1],1,8)&' GROUP'
    DO AddLine
    ExtractFile.Line='Items      USHORT('&Items&')'
    DO AddLine
  END
  SORT(SELF.Queue,-SELF.Queue.TextProp)
  LOOP c=RECORDS(SELF.Queue) TO 1 BY -1
    GET(SELF.Queue,c)
    ASSERT(~ERRORCODE())
    IF ~SELF.Queue.Replacement AND SELF.ExtractText
      ExtractFile.Line=ALL(' ',11)&'PSTRING('''&CLIP(SELF.Queue.TextProp)&''')'
      DO AddLine
      ExtractFile.Line=ALL(' ',11)&'PSTRING('''')'
      DO AddLine
    END
    DeleteQueueItem(SELF)
  END
  DISPOSE(SELF.Queue)
  IF SELF.ExtractText
    ExtractFile.Line='   END'
    DO AddLine
    CLOSE(ExtractFile)
    ASSERT(~ERRORCODE())
  END

AddLine ROUTINE
  ADD(ExtractFile)
  ASSERT(~ERRORCODE())


TranslatorClass.AddTranslation PROCEDURE(STRING Source,STRING Replacement)

  CODE
  ASSERT(~SELF.Queue&=NULL)
  IF LEN(Source)
    SELF.Queue.TextProp=Source
    GET(SELF.Queue,SELF.Queue.TextProp)
    IF ~ERRORCODE()
      DeleteQueueItem(SELF)
    .
    IF Replacement
      SELF.Queue.TextProp=Source
      SELF.QUEUE.Replacement=Replacement
      ADD(SELF.Queue,SELF.Queue.TextProp)
      ASSERT(~ERRORCODE())
    END
  END


TranslatorClass.TranslateWindow PROCEDURE(<WINDOW Win>)

ThisField SHORT(0)

  CODE
  Win{PROP:Text}=SELF.TranslateString(Win{PROP:Text})
  LOOP
    ThisField=Win{PROP:NextField,ThisField}
    IF ThisField
      SELF.TranslateControl(ThisField,Win)
    ELSE
      BREAK
    END
  END


TranslatorClass.TranslateControls PROCEDURE(SHORT LowCtlID,SHORT HighCtlID,<WINDOW Win>)

ThisField SHORT(0)

  CODE
  LOOP
    ThisField=Win{PROP:NextField,ThisField}
    IF ThisField
      IF INRANGE(ThisField,LowCtlID,HighCtlID) THEN SELF.TranslateControl(ThisField,Win).
    ELSE
      BREAK
    END
  END


TranslatorClass.TranslateControl PROCEDURE(SHORT CtlID,<WINDOW Win>)

   CODE
   CASE Win$CtlID{PROP:Type}
   OF CREATE:String
   OROF CREATE:Prompt
   OROF CREATE:Menu
   OROF CREATE:Item
     DO ChangePropText
   OF CREATE:Entry
   OROF CREATE:Spin
   OROF CREATE:text
     DO ChangePropMsg
   OROF CREATE:Region
     DO ChangePropToolTip
   OF CREATE:Button
   OROF CREATE:Check
   OROF CREATE:Radio
   OROF CREATE:Tab
     DO ChangePropText
     DO ChangePropMsg
     DO ChangePropToolTip
   OF CREATE:Option
   OROF CREATE:Group
     DO ChangePropText
     DO ChangePropMsg
   OF CREATE:List
   OROF CREATE:Combo
   OROF CREATE:DropList
   OROF CREATE:DropCombo
     DO ChangeListBox
   END

ChangeListBox  ROUTINE
  DATA
ColCnt      USHORT(0)
Fmt         CSTRING(2000),AUTO
i           USHORT,AUTO
  CODE
  Fmt=Win$CtlID{PROP:Format}
  LOOP i=1 TO LEN(Fmt)
    IF Fmt[i]='~' THEN ColCnt+=1.
  END
  ASSERT(ColCnt/2=INT(ColCnt/2))                        !Corrupt format string
  IF ColCnt
    ColCnt/=2
    i=0
    LOOP
      i+=1
      IF Win$CtlID{PROPList:Header,i}
        Win$CtlID{PROPList:Header,i}=SELF.TranslateString(Win$CtlID{PROPList:Header,i})
        ColCnt-=1
      ELSIF NOT Win$CtlID{PROPList:Exists,i}  !cb 12/10/98 fixed
        BREAK                                 !cb
      END
    WHILE ColCnt
  END

ChangePropText ROUTINE
   Win$CtlID{PROP:Text}=SELF.TranslateString(Win$CtlID{PROP:Text})

ChangePropMsg ROUTINE
   Win$CtlID{PROP:Msg}=SELF.TranslateString(Win$CtlID{PROP:Msg})

ChangePropToolTip ROUTINE
   Win$CtlID{PROP:ToolTip}=SELF.TranslateString(Win$CtlID{PROP:ToolTip})


TranslatorClass.TranslateString PROCEDURE(STRING LookFor)

RVal     CSTRING(MaxTLen)
Recurse  SHORT(MaxRecursion),STATIC

   CODE
   Recurse-=1
   ASSERT(Recurse)                !Assertion failure if called too many times recursively
   LookFor=LEFT(LookFor)
   IF LookFor
     SELF.Queue.TextProp=LookFor
     GET(SELF.Queue,SELF.Queue.TextProp)
     IF ERRORCODE()
       IF SELF.ExtractText
         SELF.Queue.TextProp=LookFor
         SELF.Queue.Replacement=''
         ADD(SELF.Queue,SELF.Queue.TextProp)
         ASSERT(~ERRORCODE())
       END
       RVal=LookFor
       DO ResolveMacros
     ELSE
       IF ~SELF.Queue.Replacement
         RVal=LookFor
       ELSE
         RVal=SELF.Queue.Replacement
         DO ResolveMacros
       END
     END
   END
   Recurse+=1
   RETURN RVal

ResolveMacros ROUTINE
  DATA
P  USHORT(1)
S  USHORT,AUTO
  CODE
  LOOP
    P=INSTRING('%',RVal,1,P)
    S=INSTRING('%',RVal,1,P+1)
    IF P AND S
      RVal=RVal[1 : P-1]&SELF.TranslateString(RVal[P+1 : S-1])&RVal[S+1 : LEN(Rval)]
      P=S+1
    ELSE
      BREAK
    END
  END

DeleteQueueItem PROCEDURE(TranslatorClass SELF)

   CODE
   DELETE(SELF.Queue)
