  MEMBER

_ABCDllMode_  EQUATE(0)
_ABCLinkMode_ EQUATE(1)


FileIDType        EQUATE(LONG)                  !Data type for unique reference to file

    MAP
GetFileID         PROCEDURE(File ThisFile),FileIDType,PRIVATE
AddFileMapping    PROCEDURE(FileManager FM),PRIVATE
GetFileMapping    PROCEDURE(FileIDType FileLabel),PRIVATE
RemoveFileMapping PROCEDURE(FileIdType FileLabel),PRIVATE
RemoveFileMapping PROCEDURE(FileManager FM),PRIVATE
ViewFileStatus    PROCEDURE(<STRING Txt>)

      ConcatGetComponents(KeyFieldQueue,*CSTRING,BYTE HowMany),PRIVATE
      DupString(STRING),*STRING
      CasedValue(STRING FieldName,*? Field,? FieldValue),STRING
    .

    INCLUDE('ABFILE.INC')
    INCLUDE('ERRORS.CLW')


FileMapping                   QUEUE              ! This queue maps file labels <-> filemanagers
FileLabel                       FileIDType
FileManager                     &FileManager
                              END

FileThreadQueue               QUEUE,TYPE         ! QUEUE of status of all file buffers
Id                              SIGNED           ! Thread number
Used                            BYTE             ! Set True when file is -actually- opened
Opened                          USHORT           ! File opened counter
AtEOF                           BYTE             ! End of File flag
AutoIncDone                     BYTE             ! Auto-increment done or not flag
LastError                       BYTE             ! Last error identifier
                              END

KeyFieldQueue                 QUEUE,TYPE         ! QUEUE of all key components
Field                           ANY              ! Key component
FieldName                       &STRING          ! This should contain the UPPER for a case insensitive field
Ascend                          BYTE             ! Ascending/descending flag
                              END

FileKeyQueue                  QUEUE,TYPE         ! QUEUE of all keys in a file
Key                             &KEY             ! Reference to a KEY
Description                     STRING(80)       ! Key description text (from Data dictionary)
Fields                          &KeyFieldQueue   ! Reference to key components queue
AutoInc                         BYTE             ! Auto-increment flag (from Data dictionary)
Dups                            BYTE             ! Duplicates allowed flag (from Data dictionary)
NoCase                          BYTE             ! Case sensitive flag (from Data dictionary)
                              END

RelationQueue                 QUEUE,TYPE              ! List of all related files
File                            &RelationManager      ! Related file
Fields                          &BufferedPairsClass   ! List of linking fields
HisKey                          &KEY                  ! Only filled in for 1:MANY relationships
UpdateMode                      BYTE                  ! Action on Update RI flag
DeleteMode                      BYTE                  ! Action on Delete RI flag
                              END

SaveQueue QUEUE,TYPE
Buffer  USHORT
Id      USHORT
WHeld   BYTE
WWatch  BYTE
Pos     STRING(512)
Key     &KEY
  END

Epoc LONG(1)


AddFileMapping PROCEDURE(FileManager FM)

  CODE
    FileMapping.FileLabel=GetFileID(FM.File)
    GET(FileMapping,FileMapping.FileLabel)
    ASSERT(ERRORCODE())                               !Mapping for file already exists
    FileMapping.FileLabel=GetFileID(FM.File)
    FileMapping.FileManager &= FM
    ADD(FileMapping,FileMapping.FileLabel)
    ASSERT(~ERRORCODE())                              !Error appending to ordered queue


RemoveFileMapping PROCEDURE(FileManager FM)

  CODE
    RemoveFileMapping(GetFileID(FM.File))


RemoveFileMapping PROCEDURE(FileIDType FileLabel)

  CODE
    FileMapping.FileLabel=FileLabel
    GET(FileMapping,FileMapping.FileLabel)
    ASSERT(~ERRORCODE())                              !File mapping not found
    DELETE(FileMapping)
    ASSERT(~ERRORCODE())                              !Delete failed on queue


GetFileMapping PROCEDURE(FileIDType FileLabel)

  CODE
    FileMapping.FileLabel=FileLabel
    GET(FileMapping,FileMapping.FileLabel)
    ASSERT(~ERRORCODE())


!The following procedure returns a unique, application global, file ID

GetFileID PROCEDURE(FILE ThisFile)

MyGrp   GROUP                                         !DABMORE - the word HACK springs to mind FILE{PROP:Label} would be better
Fr        &FILE
        END
MyHash  LONG,OVER(MyGrp)

  CODE
  MyGrp.Fr &= ThisFile
  RETURN MyHash


  COMPILE('***',_DEBUGLAZYFILES_)
ViewFIleStatus PROCEDURE(<STRING Txt>)

i     USHORT,AUTO
j     USHORT,AUTO
Q     QUEUE
ID      FileIDType
Name    STRING(64)
Lazy    BYTE
Thrd    BYTE
Opened  USHORT
Used    BYTE
AtEOF   BYTE
LErr    BYTE
      END

window WINDOW('File Open Status'),AT(,,341,135),FONT('MS Sans Serif',8,,FONT:regular),CENTER,SYSTEM,GRAY, |
         DOUBLE
       LIST,AT(4,4,334,114),USE(?List),FORMAT('49L(1)|~ID~L(2)@S16@122L(1)|~Prop:Name~L(2)S(255)@S64@21L(1)|~Lazy~L(2)@n1@20L(1' &|
           ')|~Thrd~L(2)@n2@36L(1)|~Open Cnt~L(2)@N3@23L(1)|~Used~L(2)@N1@27L(1)|~AtEOF~L(2)' &|
           '@N1@20L(1)|~Lst Err~L(2)@N3@'),FROM(Q)
       BUTTON('&Close'),AT(284,120,56,14),USE(?Close),STD(STD:Close),DEFAULT
     END

  CODE
  j=POINTER(FileMapping)
  LOOP i=1 TO RECORDS(FileMapping)
    GET(FileMapping,i)
    ASSERT(~ERRORCODE())
    FileMapping.FileManager.SetThread
    Q.ID=FileMapping.FileLabel
    Q.Name=FileMapping.FileManager.File{PROP:Name}
    Q.Lazy=FileMapping.FileManager.LazyOpen
    Q.Thrd=FileMapping.FileManager.Info.ID
    Q.Opened=FileMapping.FileManager.Info.Opened
    Q.Used=FileMapping.FileManager.Info.Used
    Q.AtEOF=FileMapping.FileManager.Info.AtEOF
    Q.LErr=FileMapping.FileManager.Info.LastError
    ADD(Q)
    ASSERT(~ERRORCODE())
  END
  IF j
    GET(FileMapping,j)
    ASSERT(~ERRORCODE())
  END
  OPEN(Window)
  IF ~OMITTED(1) THEN Window{PROP:Text}=Window{PROP:Text}&', '&Txt.
  ACCEPT
  END
  CLOSE(Window)
  ***

  OMIT('***',_DEBUGLAZYFILES_)
ViewFileStatus PROCEDURE(<STRING Txt>)

  CODE
  ***


! Add a record to a file. Make sure record is valid and perform any
! required autoincrement operations.
! This function must handle errors itself to get the job done
FileManager.Insert PROCEDURE
  CODE
    RETURN SELF.InsertServer(1)

FileManager.AddKey PROCEDURE(KEY k,STRING Desc,BYTE AutoInc)
CF  UNSIGNED,AUTO
FB  CSTRING(1000),AUTO
I   BYTE,AUTO
  CODE
    SELF.Keys.Key &= k
    SELF.Keys.Description = Desc
    SELF.Keys.Fields &= NEW KeyFieldQueue
    SELF.Keys.AutoInc = AutoInc
    IF AutoInc
      SELF.HasAutoInc = 1
    END
    SELF.Keys.Dups = k{PROP:Dup}
    SELF.Keys.NoCase = k{PROP:NoCase}
    ADD(SELF.Keys)
    IF k{PROP:Primary}
      SELF.PrimaryKey = RECORDS(SELF.Keys)
    END
    LOOP I = 1 TO K{PROP:Components}
      CLEAR(SELF.Keys.Fields)
      SELF.Keys.Fields.Ascend = K{PROP:Ascending,I}
      CF = K{PROP:Field,I}
      SELF.Keys.Fields.Field &= WHAT(SELF.Buffer,CF)
      FB = SELF.File{PROP:Label,CF}
      SELF.Keys.Fields.FieldName &= DupString(CHOOSE(SELF.Keys.NoCase AND IsString(SELF.Keys.Fields.Field),'UPPER('&FB&')',FB))
      ADD(SELF.Keys.Fields)
    END

! Add a record to a file. Make sure record is valid and perform any
! required autoincrement operations.
! This function will return upon an error setting lasterror
FileManager.TryInsert PROCEDURE
  CODE
    RETURN SELF.InsertServer(0)

! Add a record to a file. Make sure record is valid and perform any
! required autoincrement operations.
! HandleError state hinges on a parameter
FileManager.InsertServer PROCEDURE(BYTE HandleError)
I SIGNED,AUTO
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    IF SELF.ValidateRecord()
      RETURN Level:Notify
    END
    IF SELF.HasAutoInc
      IF SELF.Info.AutoIncDone
        PUT(SELF.File)
      ELSE
        IF HandleError AND SELF.PrimeAutoInc() OR ~HandleError AND SELF.TryPrimeAutoInc()
          RETURN Level:Notify
        END
      END
    ELSE
      ADD(SELF.File)
    END
    CASE ERRORCODE()
    OF NoError
      SELF.Info.AutoIncDone = 0
      PUT(Self.Info)
      ASSERT(~ERRORCODE())
      RETURN Level:Benign
    OF DupKeyErr
      IF HandleError
        IF ~SELF.HasAutoInc
          GET(SELF.File,0)      ! Flag for DUPLICATE function
        END
        LOOP I = 1 TO RECORDS(SELF.Keys)
          GET(SELF.Keys,I)
          IF DUPLICATE(SELF.Keys.Key)
            SELF.ThrowMessage(Msg:DuplicateKey,SELF.Keys.Description)
            RETURN Level:Notify
          END
        END
      ELSE
        SELF.SetError(Msg:DuplicateKey)
      END
    ELSE
      SELF.SetError(Msg:AddFailed)
      IF HandleError
        RETURN SELF.Throw()
      END
    END
    RETURN Level:Notify


! Cancel an autoincrement operation if there was one
FileManager.CancelAutoInc PROCEDURE(<RelationManager R>)
RetVal BYTE(Level:Benign)
  CODE
    IF ~SELF.UseFile()
      IF SELF.HasAutoInc AND SELF.Info.AutoIncDone
        IF R &= NULL
          DELETE(SELF.File)
        ELSE
          RetVal = R.Delete(0)
        END
        IF ~RetVal
          SELF.Info.AutoIncDone = 0
          PUT(SELF.Info)
          ASSERT(~ERRORCODE())
        END
      END
    END
    RETURN RetVal

! This routine primes the auto increment fields of a record
! A key part of the specification is that fields values
! (other than autoincrement ones) are -not- corrupted.
FileManager.PrimeAutoIncServer PROCEDURE(BYTE HandleError)
I SHORT,AUTO
J SHORT,AUTO
SaveKeys CSTRING(2000),AUTO
NewKeys  CSTRING(2000),AUTO
SaveRec  USHORT,AUTO
AutoVal  ANY
AutoIncField ANY
Attempts BYTE(0)
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    IF ~SELF.HasAutoInc OR SELF.Info.AutoIncDone
      RETURN Level:Benign
    END
    LOOP
      LOOP I = 1 TO RECORDS(SELF.Keys)
        GET(SELF.Keys,I)
        IF SELF.Keys.AutoInc
! For each key with autoincrement try to find a valid new component value
          SaveRec = SELF.SaveBuffer()
          NOMEMO(SELF.File)
          IF RECORDS(SELF.Keys.Fields) = 1
            GET(SELF.Keys.Fields,1)
            AutoIncField &= SELF.Keys.Fields.Field
            SET(SELF.Keys.Key)
            IF SELF.Keys.Fields.Ascend
              PREVIOUS(SELF.File)
            ELSE
              NEXT(SELF.File)
            END
            CASE ERRORCODE()
            OF NoError
              AutoVal = AutoIncField + 1
            OF BadRecErr
              AutoVal = 1
            ELSE
              SELF.SetError(Msg:AbortReading)
              IF HandleError
                RETURN SELF.Throw()
              ELSE
                RETURN Level:Notify
              END
            END
          ELSE
            ConcatGetComponents(SELF.Keys.Fields,SaveKeys,SELF.Keys.AutoInc-1)
            GET(SELF.Keys.Fields,SELF.Keys.AutoInc)
            AutoIncField &= SELF.Keys.Fields.Field
            CLEAR(AutoIncField,1)
            SET(SELF.Keys.Key,SELF.Keys.Key)
            IF SELF.Keys.Fields.Ascend
              PREVIOUS(SELF.File)
            ELSE
              NEXT(SELF.File)
            END
            CASE ERRORCODE()
            OF NoError
              ConcatGetComponents(SELF.Keys.Fields,NewKeys,SELF.Keys.AutoInc-1)
              IF SaveKeys = NewKeys
                AutoVal = AutoIncField + 1
              ELSE
                AutoVal = 1
              END
            OF BadRecErr
              AutoVal = 1
            ELSE
              SELF.SetError(Msg:AbortReading)
              IF HandleError
                RETURN SELF.Throw()
              ELSE
                RETURN Level:Notify
              END
            END
          END
          SELF.RestoreBuffer(SaveRec)
          AutoIncField = AutoVal
        END
      END
      ADD(SELF.File)
      IF ERRORCODE()
        Attempts += 1
      ! This probably means someone else got there first
      ! In a 'heavy' usage network a number > 3 might be useful
      ! although the machine will go 'dead' for longer
        IF Attempts = 3
          SELF.SetError(Msg:RetryAutoInc)
          IF HandleError
            IF ~Self.Throw()
              Attempts = 0
              CYCLE
            END
          END
          RETURN Level:Notify
        END
      ELSE
        SELF.Info.AutoIncDone = 1
        PUT(SELF.Info)
        RETURN Level:Benign
      END
    END
    ASSERT(0)

FileManager.PrimeAutoInc PROCEDURE
  CODE
    RETURN SELF.PrimeAutoIncServer(1)

FileManager.TryPrimeAutoInc PROCEDURE
  CODE
    RETURN SELF.PrimeAutoIncServer(0)

FileManager.BindFields PROCEDURE
  CODE
    BIND(SELF.Buffer)

FileManager.ClearKey     PROCEDURE(KEY K,BYTE LowComp,BYTE HighComp,BYTE High)
I BYTE,AUTO
  CODE
    SELF.SetKey(K)
    LOOP I = LowComp TO HighComp
      GET(SELF.Keys.Fields,I)
      IF ERRORCODE()
        RETURN
      END
      IF SELF.Keys.Fields.Ascend XOR High
        CLEAR(SELF.Keys.Fields.Field,0)
      ELSE
        CLEAR(SELF.Keys.Fields.Field,1)
      END
    END

! Close errors are considered unimportant so this routine simply
! glosses over them
FileManager.Close PROCEDURE

  CODE
    SELF.SetThread
    IF SELF.Info.Opened
      SELF.Info.Opened -= 1
      IF ~SELF.Info.Opened
        CLOSE(SELF.File)
        SELF.Info.Used=False
      END
      PUT(SELF.Info)
      ASSERT(~ERRORCODE())
    END
    ViewFileStatus('Close File')
    RETURN Level:Benign

FileManager.GetComponents PROCEDURE(KEY K)
  CODE
    SELF.SetKey(K)
    RETURN RECORDS(SELF.Keys.Fields)

FileManager.GetError PROCEDURE
  CODE
    SELF.SetThread
    RETURN SELF.Info.LastError

! Scan through list of key information and select information for given key
FileManager.SetKey PROCEDURE(KEY K)
I UNSIGNED,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Keys)
      GET(SELF.Keys,I)
    UNTIL SELF.Keys.Key &= K
    ASSERT(SELF.Keys.Key &= K)

FileManager.GetField PROCEDURE(KEY K,BYTE B)
  CODE
    SELF.SetKey(K)
    GET(SELF.Keys.Fields,B)
    ASSERT(~ERRORCODE())
    RETURN SELF.Keys.Fields.Field

FileManager.GetFieldName PROCEDURE(KEY K,BYTE B)
  CODE
    SELF.SetKey(K)
    GET(SELF.Keys.Fields,B)
    ASSERT(~ERRORCODE())
    RETURN SELF.Keys.Fields.FieldName

! The semantic for a failed get is simply to clear down the buffer
FileManager.Fetch PROCEDURE(KEY Key)
ReturnCode BYTE,AUTO
I USHORT
  CODE
    ReturnCode = SELF.TryFetch(Key)
    IF ReturnCode
      CLEAR(SELF.File)
    END
    RETURN ReturnCode

FileManager.TryFetch PROCEDURE(KEY Key)
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    GET(SELF.File,Key)
    IF ERRORCODE()
      RETURN Level:Notify
    ELSE
      RETURN Level:Benign
    END

FileManager.GetName PROCEDURE
  CODE
    IF SELF.FileName &= NULL
      RETURN SELF.FileNameValue
    ELSE
      RETURN SELF.FileName
    END

FileManager.GetEOF PROCEDURE
  CODE
    SELF.SetThread
    RETURN SELF.Info.AtEOF

FileManager.Init PROCEDURE(File File,ErrorClass E)
  CODE
    SELF.Errors &= E
    SELF.File &= File
    SELF.Info &= NEW FileThreadQueue
    SELF.Keys &= NEW FileKeyQueue
    SELF.Buffers &= NEW BufferQueue
    SELF.Saved &= NEW SaveQueue
    SELF.SkipHeldRecords = 0
    SELF.OpenMode = 42h
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.PrimaryKey = 0
    SELF.LazyOpen=True                              !Default dehaviour is Lazy Open enabled
    SELF.FileNameValue = SELF.File{PROP:Name}
    AddFileMapping(SELF)

FileManager.KeyToOrder PROCEDURE(KEY K,BYTE B)
I BYTE,AUTO
RetVal CSTRING(512)
  CODE
    IF NOT K &= NULL
      IF ~B
        B = 1
      END
      SELF.SetKey(K)
      LOOP I = B TO RECORDS(SELF.Keys.Fields)
        GET(SELF.Keys.Fields,I)
        RetVal = RetVal & CHOOSE(RetVal = '','',',') & CHOOSE(SELF.Keys.Fields.Ascend <> 0,'','-') & SELF.Keys.Fields.FieldName
      END
    END
    RETURN RetVal

FileManager.Kill PROCEDURE
I SIGNED,AUTO
J SIGNED,AUTO
  CODE
    RemoveFileMapping(SELF)
    DISPOSE(SELF.Info)
    IF ~SELF.Keys &= NULL
      LOOP I = 1 TO RECORDS(SELF.Keys)
        GET(SELF.Keys,I)
        LOOP J = 1 TO RECORDS(SELF.Keys.Fields)
          GET(SELF.Keys.Fields,J)
          DISPOSE(SELF.Keys.Fields.FieldName)
          SELF.Keys.Fields.Field &= NULL
        END
        DISPOSE(SELF.Keys.Fields)
      END
      DISPOSE(SELF.Keys)
    END
    IF ~SELF.Buffers &= NULL
      LOOP I = 1 TO RECORDS(SELF.Buffers)
        DISPOSE(SELF.Buffers.Buffer)
      END
      DISPOSE(SELF.Buffers)
    END
    DISPOSE(SELF.Saved)

FileManager.NextServer PROCEDURE(BYTE HandleError)
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    LOOP
      SELF.Info.AtEOF = 0
      PUT(SELF.Info)
      ASSERT(~ERRORCODE())
      NEXT(SELF.File)
      CASE ERRORCODE()
      OF BadRecErr
        SELF.Info.AtEOF = 1
        PUT(SELF.Info)
        ASSERT(~ERRORCODE())
        RETURN Level:Notify
      OF NoError
        RETURN Level:Benign
      OF IsHeldErr
        IF SELF.SkipHeldRecords
          CYCLE
        ELSE
          SELF.SetError(Msg:RecordHeld)
          IF HandleError
            RETURN SELF.Throw()
          ELSE
            RETURN Level:Notify
          END
        END
      ELSE
        SELF.SetError(Msg:AbortReading)
        IF HandleError
          RETURN SELF.Throw()
        ELSE
          RETURN Level:Fatal
        END
      END
    END

FileManager.Next PROCEDURE
  CODE
    RETURN SELF.NextServer(1)

FileManager.TryNext PROCEDURE
  CODE
    RETURN SELF.NextServer(0)

! This function 'clears' a record and performs auto-inc function where
! applicable.
FileManager.PrimeRecord PROCEDURE(BYTE SC)
BufferHandle  USHORT,AUTO
Result        BYTE,AUTO
  CODE
    IF SELF.AliasedFile&=NULL                             !
      IF ~SC
        CLEAR(SELF.File)
      END
      SELF.PrimeFields
      IF Self.HasAutoInc
        RETURN SELF.PrimeAutoInc()
      ELSE
        RETURN Level:Benign
      END
    ELSE
      BufferHandle=SELF.AliasedFile.SaveBuffer()
      Result=SELF.AliasedFile.PrimeRecord(SC)
      IF ~Result                                          !~Result == Level:Benign
        SELF.Buffer=SELF.AliasedFile.Buffer               !Copy FileManagers buffer after successful priming
      END
      SELF.AliasedFile.RestoreBuffer(BufferHandle)
      RETURN Result
    END

FileManager.PrimeFields PROCEDURE
  CODE

! Create and Open mode are public fields of the file manager class
! which should be 'defaulted' in derived classes
! In the handled-error case the function will create or build a file
! in an attempt to get things working
FileManager.OpenServer PROCEDURE(BYTE HandleError,BYTE IncrementUsage,BYTE ForceOpen)
  CODE
    SELF.SetThread
    IF ForceOpen
      DO RealOpen
    ELSE
      IF SELF.LazyOpen
        DO VirtualOpen
      ELSE
        DO RealOpen
      END
    END

VirtualOpen ROUTINE                                       !This routine 'pretends' to open the file
    IF IncrementUsage                                     !but delays actually opening the file until it is
      SELF.Info.Opened+=1                                 !really accessed
      PUT(SELF.Info)
      ASSERT(~ERRORCODE())
    END
    SELF.BindFields
    ViewFileStatus('Virtual File Open')
    RETURN Level:Benign

RealOpen ROUTINE                                          !This routine really opens the file when called
    IF SELF.Info.Opened AND ~ForceOpen                    !handling errors where appropriate
      DO OkOut
    END
    LOOP 2 TIMES  ! Allow 1 create or build cycle
      OPEN(SELF.File,SELF.OpenMode)
      IF ERRORCODE() = NoAccessErr
        SEND(SELF.File,'Recover='& SELF.LockRecover)
        OPEN(SELF.File,SELF.OpenMode)
      END
      CASE ERRORCODE()
      OF NoError OROF IsOpenErr
        SELF.Info.Used=True
        SELF.Info.AtEOF = 0
        SELF.Info.AutoIncDone = 0
        PUT(SELF.Info)
        ASSERT(~ERRORCODE())
        DO OkOut
      OF RecordLimitErr
        IF BAND(SELF.OpenMode,3)
          SELF.OpenMode = BAND(SELF.OpenMode,0F0H)
          SELF.Throw(Msg:RecordLimit)
          CYCLE
        ELSE
          DO HardError
        END
      OF NoAccessErr
        IF BAND(SELF.OpenMode,3)
          SELF.OpenMode = BAND(SELF.OpenMode,0F0H)
          SELF.Throw(Msg:AccessDenied)
          CYCLE
        ELSE
          DO HardError
        END
      OF NoFileErr
        IF SELF.Create
          CREATE(SELF.File)
          IF ~ERRORCODE()
            CYCLE
          END
        END
        SELF.SetError(Msg:CreateFailed)
        IF HandleError
          RETURN SELF.Throw()
        ELSE
          RETURN Level:Notify
        END
      OF BadKeyErr
        SELF.SetError(Msg:RebuildKey)
        IF HandleError
          SELF.Throw
          BUILD(SELF.File)
          IF ERRORCODE()
            RETURN SELF.Throw(Msg:RebuildFailed)
          END
        ELSE
          RETURN Level:Notify
        END
      ELSE
        DO HardError
      END
    END
    DO HardError

HardError ROUTINE
    SELF.SetError(Msg:OpenFailed)
    IF HandleError
      RETURN SELF.Throw()
    END
    RETURN Level:Notify

OkOut ROUTINE
    IF IncrementUsage
      SELF.Info.Opened += 1
      PUT(SELF.Info)
      ASSERT(~ERRORCODE())
    END
    SELF.BindFields
    ViewFileStatus('Real File Open')
    RETURN Level:Benign

FileManager.TryOpen PROCEDURE()
  CODE
    RETURN SELF.OpenServer(0)

FileManager.Open PROCEDURE()
  CODE
    RETURN SELF.OpenServer(1)

!This procedure forces the file open if it has already be 'opened' as a LazyFile
FileManager.UseFile PROCEDURE
i       BYTE(Level:Benign)
SaveID  USHORT,AUTO
  CODE
    SELF.SetThread
    IF SELF.LazyOpen
      IF ~SELF.Info.Used
        IF SELF.Info.Opened<1                 !File not previously OPENed with explicit .Open or .TryOpen call
          RETURN SELF.Throw(Msg:UseClosedFile)
        END
        SaveID=SELF.SaveBuffer()              !File buffer saved so that SET(,key) etc work ok after real open
        i=SELF.OpenServer(1,0,1)              !if driver corrupts buffer when OPENed
        SELF.RestoreBuffer(SaveID,1)
      END
    END
    RETURN i

FileManager.Position PROCEDURE
  CODE
    IF SELF.UseFile() THEN RETURN ''.
    IF SELF.PrimaryKey
      GET(SELF.Keys,SELF.PrimaryKey)
      RETURN POSITION(SELF.Keys.Key)
    ELSE
      RETURN POSITION(SELF.File)
    END


FileManager.Previous PROCEDURE
  CODE
    RETURN SELF.PreviousServer(1)


FileManager.TryPrevious PROCEDURE
  CODE
    RETURN SELF.PreviousServer(0)


FileManager.PreviousServer PROCEDURE(BYTE HandleError)
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    LOOP
      SELF.Info.AtEOF = 0
      PUT(SELF.Info)
      PREVIOUS(SELF.File)
      CASE ERRORCODE()
      OF BadRecErr
        SELF.Info.AtEOF = 1
        PUT(SELF.Info)
        RETURN Level:Notify
      OF NoError
        RETURN Level:Benign
      OF IsHeldErr
        IF SELF.SkipHeldRecords
          CYCLE
        ELSE
          SELF.SetError(Msg:RecordHeld)
          IF HandleError
            RETURN SELF.Throw()
          ELSE
            RETURN Level:Notify
          END
        END
      ELSE
        SELF.SetError(Msg:AbortReading)
        IF HandleError
          RETURN SELF.Throw()
        ELSE
          RETURN Level:Fatal
        END
      END
    END


FileManager.Update PROCEDURE
  CODE
    RETURN SELF.UpdateServer(1)


FileManager.TryUpdate PROCEDURE
  CODE
    RETURN SELF.UpdateServer(0)


! In the handled-error case the buffer is re-freshed if PUT encounters
! a WATCH violation
FileManager.UpdateServer PROCEDURE(BYTE HandleError)
Hold  STRING(512),AUTO
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    IF SELF.ValidateRecord()
      RETURN Level:Notify
    END
    Hold = SELF.Position()
    PUT(SELF.File)
    CASE ERRORCODE()
    OF NoError
      RETURN Level:Benign
    OF RecordChangedErr
      SELF.SetError(CHOOSE(HandleError = 2,Msg:ConcurrencyFailedFromForm,Msg:ConcurrencyFailed))
      IF HandleError
        SELF.Throw
      END
      WATCH(SELF.File)
      SELF.TryReget(Hold)
    ELSE
      SELF.SetError(Msg:PutFailed)
      IF HandleError
        RETURN SELF.Throw()
      END
    END
    RETURN Level:Notify


FileManager.TryReget PROCEDURE(STRING P)
  CODE
    IF SELF.UseFile() THEN RETURN Level:Fatal.
    IF SELF.PrimaryKey
      GET(SELF.Keys,SELF.PrimaryKey)
      REGET(SELF.Keys.Key,P)
    ELSE
      REGET(SELF.File,P)
    END
    RETURN CHOOSE(ERRORCODE() = 0,Level:Benign,Level:Notify)

! Regresses a buffer (and memos) to the value from handle Id.
! The handle is invalidated by this option
FileManager.RestoreBuffer PROCEDURE(*USHORT Id,BYTE DoRestore)

i SHORT,AUTO

  CODE
    IF ~Id AND ~DoRestore THEN RETURN .       ! Effectively DISPOSE(Null)
    SELF.Buffers.Id = Id
    GET(SELF.Buffers,SELF.Buffers.Id)
    ASSERT(~ERRORCODE())
    IF DoRestore
      SELF.Buffer = SELF.Buffers.Buffer
    END
    DO KillBuffer
    LOOP I = 1 TO SELF.File{PROP:Memos}
      SELF.Buffers.Id = Id + I
      GET(SELF.Buffers,SELF.Buffers.Id)
      ASSERT(~ERRORCODE())
      IF DoRestore
        SELF.File{PROP:Value,-I} = SELF.Buffers.Buffer
      END
      DO KillBuffer
    END
    Id = 0

KillBuffer ROUTINE
    DISPOSE(SELF.Buffers.Buffer)
    DELETE(SELF.Buffers)

FileManager.EqualBuffer PROCEDURE(*USHORT Id)
I SHORT,AUTO
  CODE
    IF SELF.UseFile() THEN RETURN 0.  ! Is this needed? Should a buffer compare require an open file?
    SELF.Buffers.Id = Id
    GET(SELF.Buffers,SELF.Buffers.Id)
    ASSERT(~ERRORCODE())
    IF SELF.Buffer <> SELF.Buffers.Buffer THEN RETURN 0.
    LOOP I = 1 TO SELF.File{PROP:Memos}
      SELF.Buffers.Id = Id + I
      GET(SELF.Buffers,SELF.Buffers.Id)
      ASSERT(~ERRORCODE())
      IF SELF.File{PROP:Value,-I} <> SELF.Buffers.Buffer THEN RETURN 0.
    END
    RETURN 1


FileManager.RestoreFile PROCEDURE(*USHORT Id)

  CODE
    IF ~SELF.UseFile()
      SELF.Saved.Id = Id
      GET(SELF.Saved,SELF.Saved.Id)
      ASSERT(~ERRORCODE())
      IF SELF.Saved.Key &= NULL
        RESET(SELF.File,SELF.Saved.Pos)
      ELSE
        RESET(SELF.Saved.Key,SELF.Saved.Pos)
      END
      IF SELF.Saved.WHeld
        HOLD(SELF.File)
      END
      IF SELF.Saved.WWatch
        WATCH(SELF.File)
      END
      NEXT(SELF.File)
      SELF.RestoreBuffer(SELF.Saved.Buffer)
      DELETE(SELF.Saved)
      Id = 0
    END

FileManager.SetError PROCEDURE(USHORT Err)
  CODE
    SELF.Errors.SetErrors
    SELF.Info.LastError = Err
    PUT(SELF.Info)

FileManager.SetName PROCEDURE(STRING st)
  CODE
    ASSERT(~ (SELF.FileName &= NULL))
    SELF.FileName = st

FileManager.SetThread PROCEDURE
ThisThread SIGNED,AUTO
  CODE
    ThisThread = THREAD()
    ASSERT(~(SELF.Info &= NULL))
    SELF.Info.Id = ThisThread
    GET(SELF.Info,SELF.Info.Id)
    IF ERRORCODE()
      SELF.Info.Opened = 0
      SELF.Info.AtEOF = 0
      SELF.Info.AutoIncDone = 0
      SELF.Info.LastError = 0
      SELF.Info.Used=False
      ADD(SELF.Info,SELF.Info.Id)
      ASSERT(~ERRORCODE())
    END
    ASSERT(NOT SELF.File &= NULL)
    SELF.Errors.SetFile(SELF.GetName())

FileManager.SaveBuffer PROCEDURE

Id LONG,AUTO
I  BYTE,AUTO

  CODE
    Id = RECORDS(SELF.Buffers)
    IF Id
      GET(SELF.Buffers,Id)
      ASSERT(~ERRORCODE())
      Id = SELF.Buffers.Id + 1
    ELSE
      Id = 1
    END
    SELF.Buffers.Id = Id
    SELF.Buffers.Buffer &= DupString(SELF.Buffer)
    ADD(SELF.Buffers)
    ASSERT(~ERRORCODE())
    LOOP I = 1 TO SELF.File{PROP:Memos}
      SELF.Buffers.Id = Id + I
      SELF.Buffers.Buffer &= DupString(SELF.File{PROP:Value,-I})
      ADD(SELF.Buffers)
      ASSERT(~ERRORCODE())
    END
    RETURN Id

FileManager.SaveFile PROCEDURE
Id LONG,AUTO
I  SHORT,AUTO
  CODE
    Id = RECORDS(SELF.Saved)
    IF Id
      GET(SELF.Saved,Id)
      ASSERT(~ERRORCODE())
      Id = SELF.Saved.Id + 1
    ELSE
      Id = 1
    END
    SELF.Saved.Id = Id
    SELF.Saved.Buffer = SELF.SaveBuffer()
    SELF.Saved.Key &= SELF.File{PROP:CurrentKey}
    SELF.Saved.WHeld = SELF.File{PROP:Held}
    SELF.Saved.WWatch = SELF.File{PROP:Watched}
    IF SELF.Saved.Key &= NULL
      SELF.Saved.Pos = POSITION(SELF.File)
    ELSE
      SELF.Saved.Pos = POSITION(SELF.Saved.Key)
    END
    ADD(SELF.Saved)
    RETURN Id

FileManager.Throw PROCEDURE
  CODE
    RETURN SELF.Errors.TakeError(SELF.Info.LastError)

FileManager.Throw PROCEDURE(USHORT ErrNum)
  CODE
    SELF.SetError(ErrNum)
    RETURN SELF.Throw()

FileManager.ThrowMessage PROCEDURE(USHORT ErrNum,STRING Me)
  CODE
    RETURN SELF.Errors.ThrowMessage(ErrNum,Me)

FileManager.ValidateField PROCEDURE(UNSIGNED Field)
BufferHandle  USHORT,AUTO
RVal          BYTE(Level:Benign)
  CODE
    IF ~SELF.AliasedFile&=NULL
      ASSERT(SELF.AliasedFile.AliasedFile&=NULL)      !Cannot alias an alias
      BufferHandle=SELF.AliasedFile.SaveBuffer()
      SELF.AliasedFile.Buffer=SELF.Buffer
      RVal=SELF.AliasedFile.ValidateField(Field)
      SELF.AliasedFile.RestoreBuffer(BufferHandle)
    END
    RETURN RVal


FileManager.ValidateFields PROCEDURE(UNSIGNED Low,UNSIGNED High,<*UNSIGNED U>)
BufferHandle  USHORT,AUTO
I             UNSIGNED,AUTO
RetVal        BYTE(Level:Benign)
  CODE
    IF SELF.AliasedFile&=NULL
      LOOP I = Low TO High
        RetVal = SELF.ValidateField(I)
        IF RetVal
          IF ~OMITTED(4)
            U = I
          END
          BREAK
        END
      END
    ELSE
      ASSERT(SELF.AliasedFile.AliasedFile&=NULL)      !Cannot alias an alias
      BufferHandle=SELF.AliasedFile.SaveBuffer()
      SELF.AliasedFile.Buffer=SELF.Buffer
      RetVal=SELF.AliasedFile.ValidateFields(Low,High,U)
      SELF.AliasedFile.RestoreBuffer(BufferHandle)
    END
    RETURN RetVal


FileManager.ValidateRecord PROCEDURE(<*UNSIGNED U>)
BufferHandle  USHORT,AUTO
Result        BYTE,AUTO
  CODE
    IF SELF.AliasedFile&=NULL
      Result=SELF.ValidateFields(1,SELF.File{PROP:Fields},U)
    ELSE
      ASSERT(SELF.AliasedFile.AliasedFile&=NULL)      !Cannot alias an alias
      BufferHandle=SELF.AliasedFile.SaveBuffer()
      Result=SELF.AliasedFile.ValidateRecord(U)
      SELF.AliasedFile.RestoreBuffer(BufferHandle)
    END
    RETURN Result


ConcatGetComponents PROCEDURE(KeyFieldInfo Fields,*CSTRING Into,BYTE HowMany)
I BYTE,AUTO
  CODE
    Into = ''
    LOOP I = 1 TO HowMany
      GET(Fields,I)
      IF ERRORCODE()
        BREAK
      END
      Into = Into & Fields.Field & '|'
    END

! Choose the buffer size for a given string
! Must be at least one byte but other than that may clip
! Then allocate string and copy in value
DupString PROCEDURE(STRING St)
SizeIs SIGNED,AUTO
NS &STRING,AUTO
  CODE
    SizeIs = LEN(CLIP(St))
    NS &= NEW STRING (CHOOSE(SizeIs = 0,1,SizeIs))
    NS = St
    RETURN NS

! Dictionary definitions should not contain circular references as they
! cannot be guaranteed to work for all usages of a file scheme.
! Of course they _do_ contain circular references so we need to spot
! when we are cascading a call and get out when a cycle is hit ...
! We actually use this mechanism to side-step the 'proper' cycle of 'parent<->>child'

! Relation manager class
RelationManager.AddRelation PROCEDURE(RelationManager F)
  CODE
    ASSERT(NOT SELF.Relations &= NULL)
    CLEAR(SELF.Relations)
    SELF.Relations.File &= F
    ADD(SELF.Relations)

RelationManager.AddRelation PROCEDURE(RelationManager F,BYTE Update,BYTE Delete,KEY His)
  CODE
    SELF.AddRelation(F)
    SELF.Relations.Fields &= NEW BufferedPairsClass
    SELF.Relations.Fields.Init
    SELF.Relations.UpdateMode = Update
    SELF.Relations.DeleteMode = Delete
    SELF.Relations.HisKey &= His
    PUT(SELF.Relations)

RelationManager.AddRelationLink PROCEDURE(*? left,*? right)
  CODE
    ASSERT(NOT SELF.Relations &= NULL AND NOT SELF.Relations.Fields &= NULL)
    SELF.Relations.Fields.AddPair(left,right)

RelationManager.AddRelationLink PROCEDURE(*string left,*string right)
  CODE
    ASSERT(NOT SELF.Relations &= NULL AND NOT SELF.Relations.Fields &= NULL)
    SELF.Relations.Fields.AddPair(left,right)

RelationManager.AddRelationLink PROCEDURE(*long left,*long right)
  CODE
    ASSERT(NOT SELF.Relations &= NULL AND NOT SELF.Relations.Fields &= NULL)
    SELF.Relations.Fields.AddPair(left,right)

RelationManager.CancelAutoInc PROCEDURE
  CODE
    RETURN SELF.Me.CancelAutoInc(SELF)

RelationManager.Update PROCEDURE(BYTE FromForm)
RetVal BYTE(Level:Benign)
I LONG,AUTO
  CODE
    RetVal = SELF.Open()
    DO CheckError
    IF SELF.UseLogout
      RetVal = SELF.LogoutUpdate()
      DO CheckError
      LOGOUT(2)
    END
    IF SELF.Me.UpdateServer(1+FromForm)
      IF SELF.UseLogout
        ROLLBACK
      END
      IF SELF.Me.Info.LastError = Msg:ConcurrencyFailed OR SELF.Me.Info.LastError = Msg:ConcurrencyFailedFromForm
        RetVal = Level:Notify
      ELSE
        RetVal = Level:User
      END
      DO CheckError
    END
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.UpdateMode AND NOT SELF.Relations.Fields.EqualLeftBuffer()
        RetVal = SELF.Relations.File.UpdateSecondary(SELF.Relations.HisKey,SELF.Relations.Fields,SELF.Relations.UpdateMode)
        IF RetVal
          SELF.Relations.Fields.AssignRightToLeft
          DO CheckError
        END
      END
    END
    IF SELF.UseLogout
      COMMIT
      ASSERT(~ERRORCODE())
    END
    SELF.Close
    RETURN RetVal

CheckError ROUTINE
  IF RetVal
    SELF.Close
    RETURN RetVal
  END

RelationManager.UpdateSecondary PROCEDURE(KEY MyKey,BufferedPairsClass Fields,BYTE Mode)
RetVal BYTE(Level:Benign)
I LONG,AUTO
Preserve USHORT,AUTO
  CODE
    SELF.Me.UseFile()
    Preserve = SELF.Me.SaveFile()
    CLEAR(SELF.Me.File)
    Fields.AssignBufferToRight
    SELF.Me.ClearKey(MyKey,RECORDS(Fields.List)+1)
    SET(MyKey,MyKey)
    LOOP
      IF SELF.Me.TryNext()=Level:Fatal
        IF SELF.UseLogout
          ROLLBACK  ! ROLLBACK in case LOGOUT issued in parent
        END
        SELF.Me.Throw()
        RetVal = Level:Notify
        DO Ret
      END
      IF SELF.Me.GetEOF() OR NOT Fields.EqualRightBuffer()
        DO Ret
      END
      SELF.Save
      CASE Mode
      OF RI:Restrict
        SELF.Me.SetError(Msg:RestrictUpdate)
        IF SELF.UseLogout
          ROLLBACK
        END
        SELF.Me.Throw
        Fields.AssignBufferToLeft
        RetVal = Level:Notify
        DO Ret
      OF RI:Clear
        Fields.ClearRight
      OF RI:Cascade
        Fields.AssignLeftToRight
      ELSE
        ASSERT(0) ! I should not have been called!
        DO Ret
      END
      IF SELF.CascadeUpdates()
        RetVal = Level:Notify
        DO Ret
      END
    END
    ASSERT(0)

Ret ROUTINE
  SELF.Me.RestoreFile(Preserve)
  RETURN RetVal

RelationManager.Close PROCEDURE(BYTE Cascading)
I   BYTE(1)
Res BYTE,AUTO
  CODE
    IF Cascading
      IF SELF.LastTouched = Epoc
        RETURN Level:Benign   ! We have hit a cycle, simply return
      END
    ELSE
      Epoc += 1
    END
    SELF.LastTouched = Epoc
    ASSERT(NOT SELF.Relations &= NULL)
    Res = SELF.Me.Close()
    LOOP UNTIL Res
      GET(SELF.Relations,I)
      IF ERRORCODE()
        BREAK
      END
      Res = SELF.Relations.File.Close(1)
      I += 1
    END
    RETURN Res

RelationManager.Delete PROCEDURE(BYTE Query)
Current:Position STRING(512)
RetVal BYTE,AUTO
I      LONG,AUTO
  CODE
    IF Query AND SELF.Me.Throw(Msg:ConfirmDelete) <> Level:Benign
      RETURN Level:Notify
    END
    LOOP
      SETCURSOR(Cursor:Wait)
      RetVal = Level:Benign
      Current:Position = SELF.Me.Position()
      RetVal = SELF.Open()
      DO CheckError
      IF SELF.UseLogout
        RetVal = SELF.LogoutDelete()
        DO CheckError
        LOGOUT(2)
      END
      SELF.Me.TryReget(Current:Position)
      LOOP I = 1 TO RECORDS(SELF.Relations)
        GET(SELF.Relations,I)
        IF SELF.Relations.DeleteMode
          RetVal = SELF.Relations.File.DeleteSecondary(SELF.Relations.HisKey,SELF.Relations.Fields,SELF.Relations.DeleteMode)
          DO CheckError
        END
      END
      DELETE(SELF.Me.File)
      IF ERRORCODE()
        SELF.Me.SetError(Msg:DeleteFailed)
        IF SELF.UseLogout
          ROLLBACK
        END
        SELF.Me.Throw
        RetVal = Level:Notify
      ELSE
        IF SELF.UseLogout
          COMMIT
        END
      END
      DO CloseDown
    WHILE RetVal AND SELF.Me.Throw(Msg:RetryDelete) = Level:Benign
    RETURN RetVal

CheckError ROUTINE
  IF RetVal
    DO CloseDown
    RETURN RetVal
  END

CloseDown ROUTINE
  SETCURSOR()
  SELF.Close

RelationManager.DeleteSecondary PROCEDURE(KEY MyKey,BufferedPairsClass Fields,BYTE Mode)
RetVal BYTE(Level:Benign)
I LONG,AUTO
Preserve USHORT,AUTO
  CODE
    SELF.Me.UseFile()
    Preserve = SELF.Me.SaveFile()
    CLEAR(SELF.Me.File)
    Fields.AssignLeftToRight
    SELF.Me.ClearKey(MyKey,RECORDS(Fields.List)+1)
    SET(MyKey,MyKey)
    LOOP
      IF SELF.Me.TryNext()=Level:Fatal
        IF SELF.UseLogout
          ROLLBACK
        END
        SELF.Me.Throw()
        RetVal = Level:Notify
        DO Ret
      END
      IF SELF.Me.GetEOF() OR NOT Fields.EqualLeftRight()
        DO Ret
      END
      CASE Mode
      OF RI:Restrict
        SELF.Me.SetError(Msg:RestrictDelete)
        IF SELF.UseLogout
          ROLLBACK
        END
        SELF.Me.Throw
        RetVal = Level:Notify
        DO Ret
      OF RI:Clear
        Fields.ClearRight
        IF SELF.CascadeUpdates()
          RetVal = Level:Notify
          DO Ret
        END
      OF RI:Cascade
        LOOP I = 1 TO RECORDS(SELF.Relations)
          GET(SELF.Relations,I)
          IF SELF.Relations.DeleteMode
            RetVal = SELF.Relations.File.DeleteSecondary(SELF.Relations.HisKey,SELF.Relations.Fields,SELF.Relations.DeleteMode)
            IF RetVal
              DO Ret
            END
          END
        END
        DELETE(SELF.Me.File)
        IF ERRORCODE()
          SELF.Me.SetError(Msg:DeleteFailed)
          IF SELF.UseLogout
            ROLLBACK
          END
          SELF.Me.Throw
          RetVal = Level:Notify
          DO Ret
        END
      ELSE
        ASSERT(0) ! I should not have been called!
        DO Ret
      END
    END
    ASSERT(0)

Ret ROUTINE
  SELF.Me.RestoreFile(Preserve)
  RETURN RetVal

RelationManager.CascadeUpdates PROCEDURE
I BYTE,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.UpdateMode AND NOT SELF.Relations.Fields.EqualLeftBuffer()
        IF SELF.Relations.File.UpdateSecondary(SELF.Relations.HisKey,SELF.Relations.Fields,SELF.Relations.UpdateMode)
          SELF.Relations.Fields.AssignRightToLeft
          RETURN Level:Notify
        END
      END
    END
    IF SELF.Me.TryUpdate()
      SELF.Me.SetError(Msg:PutFailed)
      IF SELF.UseLogout
        ROLLBACK
      END
      RETURN SELF.Me.Throw()
    ELSE
      RETURN Level:Benign
    END

RelationManager.Init PROCEDURE(FileManager F,BYTE Log)
  CODE
    SELF.Me &= F
    SELF.Relations &= NEW RelationQueue
    SELF.UseLogout = Log

RelationManager.Kill PROCEDURE
I UNSIGNED,AUTO
  CODE
    IF NOT SELF.Relations &= NULL
      LOOP I = 1 TO RECORDS(SELF.Relations)
        GET(SELF.Relations,I)
        IF NOT SELF.Relations.Fields &= NULL
          SELF.Relations.Fields.Kill
          DISPOSE(SELF.Relations.Fields)
        END
      END
      DISPOSE(SELF.Relations)
    END

RelationManager.SetAlias PROCEDURE(RelationManager R)
  CODE
    SELF.AliasFile &= R

RelationManager.ListLinkingFields PROCEDURE(RelationManager Him,FieldPairsClass Trgt,BYTE RightFirst)
I UNSIGNED,AUTO
J BYTE,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.File &= Him
        IF SELF.Relations.Fields &= NULL
          ASSERT(~RightFirst)
          Him.ListLinkingFields(SELF,Trgt,1)
          RETURN
        END
        ASSERT(~SELF.Relations.Fields.List &= NULL)
        LOOP J = 1 TO RECORDS(SELF.Relations.Fields.List)
          GET(SELF.Relations.Fields.List,J)
          IF RightFirst
            Trgt.AddPair(SELF.Relations.Fields.List.Left,SELF.Relations.Fields.List.Right)
          ELSE
            Trgt.AddPair(SELF.Relations.Fields.List.Right,SELF.Relations.Fields.List.Left)
          END
        END
        RETURN
      END
    END

RelationManager.LogoutPrime PROCEDURE
  CODE
    SELF.Me.UseFile()
    IF SELF.UseLogout
      SELF.Me.File{PROP:Logout} = 1
      CASE ERRORCODE()
      OF 0
      OF 80
        SELF.UseLogout = 0
        ASSERT(0) ! An assert here means your file driver does not support transaction frames
      ELSE
        SELF.Me.SetError(Msg:LogoutFailed)
        IF SELF.UseLogout
          ROLLBACK
        END
        SELF.Me.Throw
        RETURN Level:Notify
      END
    END
    RETURN Level:Benign

RelationManager.LogoutDelete PROCEDURE
RetVal BYTE,AUTO
I LONG,AUTO
  CODE
  RetVal = SELF.LogoutPrime()
  IF ~RetVal
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.DeleteMode = RI:Cascade
        RetVal = SELF.Relations.File.LogoutDelete()
      ELSIF SELF.Relations.DeleteMode = RI:Clear
        RetVal = SELF.Relations.File.LogoutDeleteClear()
      END
    UNTIL RetVal
  END
  RETURN RetVal

RelationManager.LogoutDeleteClear PROCEDURE
RetVal BYTE,AUTO
I LONG,AUTO
  CODE
  RetVal = SELF.LogoutPrime()
  IF ~RetVal
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.DeleteMode = RI:Cascade
        RetVal = SELF.Relations.File.LogoutDeleteClear()
      END
    UNTIL RetVal
  END
  RETURN RetVal

RelationManager.LogoutUpdate PROCEDURE
RetVal BYTE,AUTO
I LONG,AUTO
  CODE
  RetVal = SELF.LogoutPrime()
  IF ~RetVal
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF SELF.Relations.UpdateMode = RI:Cascade OR SELF.Relations.UpdateMode = RI:Clear
        RetVal = SELF.Relations.File.LogoutUpdate()
      END
    UNTIL RetVal
  END
  RETURN RetVal

RelationManager.Open PROCEDURE(BYTE Cascading)
I   BYTE(1)
Res BYTE,AUTO
  CODE
    IF Cascading
      IF SELF.LastTouched = Epoc
        RETURN  Level:Benign
      END
    ELSE
      Epoc += 1
    END
    SELF.LastTouched = Epoc
    ASSERT(NOT SELF.Relations &= NULL)
    Res = SELF.Me.Open()
    IF ~Cascading THEN Res=SELF.Me.UseFile().
    LOOP UNTIL Res
      GET(SELF.Relations,I)
      IF ERRORCODE()
        BREAK
      END
      Res = SELF.Relations.File.Open(1)
      I += 1
    END
    RETURN Res

RelationManager.SetQuickScan PROCEDURE(BYTE On,BYTE Propagate)
I UNSIGNED,AUTO
  CODE
    SEND(SELF.Me.File,'QUICKSCAN=' & CHOOSE(On = 1,'on','off'))
    IF Propagate
      IF BAND(Propagate,080H)
        IF SELF.LastTouched = Epoc
          RETURN
        END
      ELSE
        Epoc += 1
        Propagate = Propagate + 80H
      END
      SELF.LastTouched = Epoc
      LOOP I = 1 TO RECORDS(SELF.Relations)
        GET(SELF.Relations,I)
        CASE Propagate
        OF Propagate:OneMany
          IF ~SELF.Relations.HisKey&=NULL THEN CYCLE .
        OF Propagate:ManyOne
          IF SELF.Relations.HisKey&=NULL THEN CYCLE .
        END
        SELF.Relations.File.SetQuickScan(On,Propagate)
      END
    END

RelationManager.Save  PROCEDURE
I LONG,AUTO
  CODE
    LOOP I = 1 TO RECORDS(SELF.Relations)
      GET(SELF.Relations,I)
      IF NOT SELF.Relations.Fields &= NULL
        SELF.Relations.Fields.AssignLeftToBuffer
      END
    END

! View manager class, handles filters, range limits and order clauses for a view

! Specify a 'current value' range limit
ViewManager.AddRange PROCEDURE(*? Field)
  CODE
    SELF.Order.LimitType = Limit:Current
    SELF.LimitMajorComponents(Field)
    SELF.Order.RangeList.AddItem(Field)
    SELF.SetFreeElement

! Single value range limit
ViewManager.AddRange PROCEDURE(*? Field,*? Value)
  CODE
    SELF.Order.LimitType = Limit:Single
    SELF.LimitMajorComponents(Field)
    SELF.Order.RangeList.AddItem(Value)
    SELF.SetFreeElement

! Pair of values range limit
ViewManager.AddRange PROCEDURE(*? Field,*? Low,*? High)
  CODE
    SELF.Order.LimitType = Limit:Pair
    SELF.LimitMajorComponents(Field)
    SELF.Order.RangeList.AddItem(Low)
    SELF.Order.RangeList.AddItem(High)
    SELF.SetFreeElement

! File base range limit
ViewManager.AddRange PROCEDURE(*? Field,RelationManager MyFile,RelationManager HisFile)
  CODE
    SELF.Order.LimitType = Limit:File
    HisFile.ListLinkingFields(MyFile,SELF.Order.RangeList)
    ASSERT(RECORDS(SELF.Order.RangeList.List))
    SELF.SetFreeElement

ViewManager.AddSortOrder PROCEDURE(<Key K>)
  CODE
    CLEAR(SELF.Order)
    SELF.Order.MainKey &= K
    SELF.Order.RangeList &= NEW BufferedPairsClass
    SELF.Order.RangeList.Init
    IF ~SELF.Order.MainKey &= NULL
      SELF.Order.FreeElement &= SELF.Primary.Me.GetField(K,1)
    END
    ADD(SELF.Order)
    ASSERT(~ERRORCODE())
    SELF.SetOrder(SELF.Primary.Me.KeyToOrder(SELF.Order.MainKey,1))
    RETURN RECORDS(SELF.Order)

ViewManager.AppendOrder PROCEDURE(STRING F)
  CODE
    IF SELF.Order.Order &= NULL
      SELF.SetOrder(F)
    ELSE
      SELF.SetOrder(SELF.Order.Order & ',' & F)
    END

ViewManager.ApplyFilter PROCEDURE
RangeFilter CSTRING(5000)
FieldName   CSTRING(500),AUTO
I           BYTE,AUTO
RRL         BYTE,AUTO
  CODE
    RRL = RECORDS(SELF.Order.RangeList.List)
    CASE SELF.Order.LimitType
    OF Limit:Current OROF Limit:Single OROF Limit:File
      LOOP I = 1 TO RRL
        GET(SELF.Order.RangeList.List,I)
        FieldName = SELF.Primary.Me.GetFieldName(SELF.Order.MainKey,I)
        RangeFilter = RangeFilter & CHOOSE(I = 1,'',' AND ') & FieldName & ' = ' & CasedValue(FieldName,SELF.Order.RangeList.List.Left,SELF.Order.RangeList.List.Right)
      END
    OF Limit:Pair
      LOOP I = 1 TO RRL-1
        GET(SELF.Order.RangeList.List,I)
        FieldName = SELF.Primary.Me.GetFieldName(SELF.Order.MainKey,I)
        CASE I
        OF RRL-1
          RangeFilter = RangeFilter & CHOOSE(RangeFilter = '','',' AND ') & FieldName & ' >= ' & CasedValue(FieldName,SELF.Order.RangeList.List.Left,SELF.Order.RangeList.List.Right)
        ELSE
          RangeFilter = RangeFilter & CHOOSE(I = 1,'',' AND ') & FieldName & ' = ' & CasedValue(FieldName,SELF.Order.RangeList.List.Left,SELF.Order.RangeList.List.Right)
        END
      END
      GET(SELF.Order.RangeList.List,RRL)
      RangeFilter = RangeFilter & ' AND ' & FieldName & ' <<= ' & CasedValue(FieldName,SELF.Order.RangeList.List.Left,SELF.Order.RangeList.List.Right)
    END
    IF ~(SELF.Order.Filter &= NULL)
      LOOP I = 1 TO RECORDS(SELF.Order.Filter)
        GET(SELF.Order.Filter,I)
        RangeFilter = RangeFilter & CHOOSE(RangeFilter = '','(',' AND (') & SELF.Order.Filter.Filter & ')'
      END
    END
    SELF.View{PROP:Filter} = RangeFilter
    IF ERRORCODE()
      SELF.Primary.Me.Throw(Msg:ViewOpenFailed)
    END

ViewManager.ApplyOrder PROCEDURE
  CODE
    SELF.View{PROP:Order} = SELF.Order.Order
    IF ERRORCODE()
      SELF.Primary.Me.Throw(Msg:ViewOpenFailed)
    END

ViewManager.ApplyRange PROCEDURE
  CODE
    CASE SELF.Order.LimitType
    OF Limit:Pair
      GET(SELF.Order.RangeList.List,RECORDS(SELF.Order.RangeList.List)-1)
      IF SELF.Order.RangeList.List.Left <> SELF.Order.RangeList.List.Right
        SELF.Order.RangeList.List.Right = SELF.Order.RangeList.List.Left
        GET(SELF.Order.RangeList.List,RECORDS(SELF.Order.RangeList.List))
        SELF.Order.RangeList.List.Right = SELF.Order.RangeList.List.Left
        SELF.ApplyFilter
        RETURN 1
      END
    OROF Limit:Single
      GET(SELF.Order.RangeList.List,RECORDS(SELF.Order.RangeList.List))
      IF SELF.Order.RangeList.List.Left <> SELF.Order.RangeList.List.Right
        SELF.Order.RangeList.List.Right = SELF.Order.RangeList.List.Left
        SELF.ApplyFilter
        RETURN 1
      END
    OF Limit:File
      IF ~SELF.Order.RangeList.EqualRightBuffer()
        SELF.Order.RangeList.AssignRightToBuffer()
        SELF.ApplyFilter
        RETURN 1
      END
    END
    RETURN 0

ViewManager.Close PROCEDURE
  CODE
    IF SELF.Opened
      CLOSE(SELF.View)
    END
    SELF.Opened = 0

ViewManager.Init PROCEDURE(VIEW V,RelationManager F,<SortOrder S>)
  CODE
    SELF.View &= V
    SELF.Primary &= F
    IF OMITTED(4)
      SELF.Order &= NEW SortOrder
      SELF.DisposeOrder = 1
    ELSE
      SELF.Order &= S
      SELF.DisposeOrder = 0
    END
    SELF.PageSize = 20
    SELF.PagesBehind = 2
    SELF.PagesAhead = 0
    SELF.TimeOut = 60
    SELF.UseView

ViewManager.Kill PROCEDURE
I LONG,AUTO
J SIGNED,AUTO
  CODE
    IF SELF.Order &= NULL
      RETURN
    END
    LOOP I = 1 TO RECORDS(SELF.Order)
      GET(SELF.Order,I)
      SELF.Order.RangeList.Kill
      DISPOSE(SELF.Order.RangeList)
      IF ~SELF.Order.Filter &= NULL
        LOOP J = 1 TO RECORDS(SELF.Order.Filter)
          GET(SELF.Order.Filter,J)
          DISPOSE(SELF.Order.Filter.Filter)
        END
      END
      DISPOSE(SELF.Order.Filter)
      DISPOSE(SELF.Order.Order)
      SELF.Order.FreeElement &= NULL
      PUT(SELF.Order)
    END
    IF SELF.DisposeOrder
      DISPOSE(SELF.Order)
    END

ViewManager.LimitMajorComponents PROCEDURE(*? Field)
F ANY
I BYTE,AUTO
  CODE
    SELF.Order.RangeList.Init
    LOOP I = 1 TO SELF.Primary.Me.GetComponents(SELF.Order.MainKey)
      F &= SELF.Primary.Me.GetField(SELF.Order.MainKey,I)
      IF F &= Field THEN BREAK .
      SELF.Order.RangeList.AddItem(F)
    END

ViewManager.UseView PROCEDURE
i   LONG,AUTO
Fr  &File
  CODE
  ASSERT(~SELF.View&=NULL)                        !Must assign view reference before attempting Open
  LOOP i=1 TO SELF.View{PROP:Files}
    Fr &= SELF.View{PROP:File,i}
    ASSERT(~Fr&=NULL)
    GetFileMapping(GetFileID(Fr))
    IF FileMapping.FileManager.UseFile() THEN RETURN.
  END


ViewManager.Open PROCEDURE
  CODE
    IF ~SELF.Opened
      ASSERT(RECORDS(SELF.Order))                   !At least 1 view order must be specified
      SELF.UseView()
      OPEN(SELF.View)
      IF ERRORCODE()
        SELF.Primary.Me.Throw(Msg:ViewOpenFailed)
      END
      BUFFER(SELF.View,SELF.PageSize,SELF.PagesBehind,SELF.PagesAhead,SELF.TimeOut)
      SELF.Opened = 1
      SELF.ApplyOrder
      SELF.ApplyFilter
    END

ViewManager.Reset PROCEDURE
  CODE
    SELF.Reset(0)

ViewManager.Reset PROCEDURE(BYTE LocatePos)
  CODE
    SELF.Open
    SET(SELF.View,LocatePos)
    IF ERRORCODE()
      SELF.Primary.Me.Throw(Msg:ViewOpenFailed)
    END

ViewManager.SetFilter PROCEDURE(STRING F)
  CODE
    SELF.SetFilter(F,'5 Standard')

ViewManager.SetFilter PROCEDURE(STRING F,STRING Id)
  CODE
    IF SELF.Order.Filter &= NULL
      SELF.Order.Filter &= NEW FilterQueue
      PUT(SELF.Order)
    END
    SELF.Order.Filter.Id = Id
    GET(SELF.Order.Filter,-SELF.Order.Filter.Id)
    IF ~ERRORCODE()
      DISPOSE(SELF.Order.Filter.Filter)
    ELSE
      ADD(SELF.Order.Filter,-SELF.Order.Filter.Id)
    END
    IF F
      SELF.Order.Filter.Filter &= DupString(F)
      PUT(SELF.Order.Filter)
    ELSE
      DELETE(SELF.Order.Filter)
    END

ViewManager.GetFreeElementName PROCEDURE
FEP BYTE,AUTO
  CODE
    FEP = SELF.GetFreeElementPosition()
    IF FEP
      RETURN SELF.Primary.Me.GetFieldName(SELF.Order.MainKey,FEP)
    END
    RETURN ''

ViewManager.GetFreeElementPosition PROCEDURE
FEP BYTE,AUTO
  CODE
    FEP = RECORDS(SELF.Order.RangeList.List)
    IF SELF.Order.LimitType <> Limit:Pair THEN
      FEP += 1
    END
    RETURN CHOOSE(FEP <= SELF.Primary.Me.GetComponents(SELF.Order.MainKey),FEP,0)

ViewManager.SetFreeElement PROCEDURE
FEP BYTE,AUTO
  CODE
    FEP = SELF.GetFreeElementPosition()
    IF FEP
      SELF.Order.FreeElement &= SELF.Primary.Me.GetField(SELF.Order.MainKey,FEP)
    END
    SELF.SetOrder(SELF.Primary.Me.KeyToOrder(SELF.Order.MainKey,1))
    PUT(SELF.Order)


ViewManager.SetOrder PROCEDURE(STRING F)
  CODE
    DISPOSE(SELF.Order.Order)
    IF F
      SELF.Order.Order &= DupString(F)
    END
    PUT(SELF.Order)

ViewManager.ValidateRecord PROCEDURE
  CODE
    RETURN Level:Benign  ! Cannot validate primary record because of project implications

ViewManager.Next PROCEDURE
  CODE
    LOOP
      NEXT(SELF.View)
      IF ERRORCODE()
        IF ERRORCODE() = BadRecErr
          RETURN Level:Notify
        ELSE
          SELF.Primary.Me.Throw(Msg:AbortReading)
          RETURN Level:Fatal
        END
      ELSE
        CASE SELF.ValidateRecord()
        OF Record:OK
          RETURN Level:Benign
        OF Record:OutOfRange
          RETURN Level:Notify
        END
      END
    END


! This function calls the underlying file manager to prime a record
! for insertion. It then uses range-limit information to fill in other
! fields if it can.
ViewManager.PrimeRecord PROCEDURE(BYTE SC)
F ANY
I BYTE,AUTO
Delta SHORT
FR &FILE
  CODE
    IF ~SC
      LOOP i=1 TO SELF.View{PROP:Files}
        Fr &= SELF.View{PROP:File,i}
        CLEAR(FR)
      END
    END
    CASE SELF.Order.LimitType
    OF Limit:Pair
      Delta = -2
    OROF Limit:Current OROF Limit:Single OROF Limit:File
      LOOP I = 1 TO RECORDS(SELF.Order.RangeList.List) + Delta
        GET(SELF.Order.RangeList.List,I)
        F &= SELF.Primary.Me.GetField(SELF.Order.MainKey,I)
        F = SELF.Order.RangeList.List.Right
      END
    END
    SELF.Primary.Me.PrimeRecord(1)

ViewManager.Previous  PROCEDURE
  CODE
    LOOP
      PREVIOUS(SELF.View)
      IF ERRORCODE()
        IF ERRORCODE() = BadRecErr
          RETURN Level:Notify
        ELSE
          SELF.Primary.Me.Throw(Msg:AbortReading)
          RETURN Level:Fatal
        END
      ELSE
        CASE SELF.ValidateRecord()
        OF Record:OK
          RETURN Level:Benign
        OF Record:OutOfRange
          RETURN Level:Notify
        END
      END
    END

ViewManager.SetSort PROCEDURE(BYTE B)
  CODE
    IF B = 0
      B = 1
    END
    IF B = POINTER(SELF.Order)
      RETURN 0
    ELSE
      GET(SELF.Order,B)
      ASSERT(~ERRORCODE())
      RETURN 1
    END

CasedValue PROCEDURE(STRING FieldName,*? Field,? FieldValue)
Value CSTRING(2000),AUTO
EQ    BYTE,AUTO
  CODE
    IF IsString(Field)
      Value = '''' & FieldValue & ''''
      RETURN CHOOSE(INSTRING('UPPER(',FieldName,1,1) <> 0,'UPPER('&Value&')',Value)
    ELSE
      RETURN FieldValue
    END




