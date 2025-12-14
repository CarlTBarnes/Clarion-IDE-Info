
!ABCIncludeFile


OMIT('_EndOfInclude_',_FileClassPresent_)  ! Omit this if already compiled
_FileClassPresent_         EQUATE(1)

  INCLUDE('ABUTIL.INC')

InsertRecord            EQUATE (1)             !  Add a record to table
ChangeRecord            EQUATE (2)             !  Change the current record
DeleteRecord            EQUATE (3)             !  Delete the current record
SelectRecord            EQUATE (4)             !  Select the current record
ProcessRecord           EQUATE (5)             !  Process the current record
RequestCompleted        EQUATE (1)             !  Update Completed
RequestCancelled        EQUATE (2)             !  Update Aborted

! File Access Modes

ReadOnly                EQUATE (0H)
WriteOnly               EQUATE (1H)
ReadWrite               EQUATE (2H)

AnyAccess               EQUATE (0H)
DenyAll                 EQUATE (10H)
DenyWrite               EQUATE (20H)
DenyRead                EQUATE (30H)
DenyNone                EQUATE (40H)

!---------------------------------------------------------
! The FileManager class

BufferQueue                   QUEUE,TYPE         ! QUEUE of 'saved' record buffers
Id                              LONG             ! Handle to recognise saved instance
Buffer                          &STRING          ! Reference to the record buffer
                              END

FileManager                   CLASS,TYPE,MODULE('ABFILE.CLW'),LINK('ABFILE.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
AliasedFile                     &FileManager               ! If this manager is handling a File Alias this should point to underlying FileManager
Buffer                          &GROUP,PROTECTED           ! The record buffer
Buffers                         &BufferQueue,PROTECTED     ! QUEUE of all 'saved' buffers for this file
Create                          BYTE                       ! Create/NoCreate flag
Errors                          &ErrorClass,PRIVATE        ! The Error object for this file
File                            &File                      ! Reference to the object FILE
FileName                        ANY,PROTECTED              ! String in NAME attribute
FileNameValue                   STRING(FILE:MaxFileName),PROTECTED       ! The NAME attribute of the fil
HasAutoInc                      BYTE,PRIVATE               ! Auto-increment or not flag
Info                            &FileThreadQueue,PRIVATE   ! QUEUE of status of all buffers for this file
Keys                            &FileKeyQueue,PRIVATE      ! QUEUE of all keys for this file
LazyOpen                        BYTE                       ! Set True to enable Lazy opening for this file
LockRecover                     SHORT                      ! Wait time parameter for LOCKing this FILE
OpenMode                        BYTE                       ! File sharing flag
PrimaryKey                      BYTE,PRIVATE               ! Primary key or not flag
Saved                           &SaveQueue,PRIVATE
SkipHeldRecords                 BYTE                       ! Should a Locked record abort reading or 'skip'

AddKey                          PROCEDURE(KEY K,STRING Description,BYTE AutoInc = 0)
BindFields                      PROCEDURE,VIRTUAL
CancelAutoInc                   PROCEDURE(<RelationManager RM>),VIRTUAL,BYTE,PROC
ClearKey                        PROCEDURE(KEY K,BYTE LowComp=1,BYTE HighComp=22,BYTE High=0)
Close                           PROCEDURE,BYTE,PROC,VIRTUAL
EqualBuffer                     PROCEDURE(*USHORT Handle),BYTE,VIRTUAL
Fetch                           PROCEDURE(KEY K),BYTE,PROC
GetComponents                   PROCEDURE(KEY K),BYTE
GetEOF                          PROCEDURE,BYTE
GetError                        PROCEDURE,SIGNED
GetField                        PROCEDURE(KEY K,BYTE Component),*?
GetFieldName                    PROCEDURE(KEY K,BYTE Component),STRING
GetName                         PROCEDURE,STRING
Init                            PROCEDURE(File File,ErrorClass EC)
Insert                          PROCEDURE,BYTE,PROC
InsertServer                    PROCEDURE(BYTE HandleError),BYTE,PRIVATE
KeyToOrder                      PROCEDURE(KEY K,BYTE MajorComp),STRING
Kill                            PROCEDURE
Next                            PROCEDURE,BYTE,PROC
NextServer                      PROCEDURE(BYTE HandleError),BYTE,PRIVATE
Open                            PROCEDURE(),BYTE,PROC,VIRTUAL
OpenServer                      PROCEDURE(BYTE HandleError,BYTE IncrementUsage=True,BYTE ForceOpen=False),BYTE,PROC,PRIVATE
Position                        PROCEDURE(),STRING
Previous                        PROCEDURE,BYTE,PROC
PreviousServer                  PROCEDURE(BYTE HandleError),BYTE,PROC,PRIVATE
PrimeAutoInc                    PROCEDURE,BYTE,PROC,VIRTUAL
PrimeAutoIncServer              PROCEDURE(BYTE HandleErrors),BYTE,PROC,PRIVATE
PrimeFields                     PROCEDURE,PROC,VIRTUAL
PrimeRecord                     PROCEDURE(BYTE SuppressClear = 0),BYTE,PROC,VIRTUAL
RestoreBuffer                   PROCEDURE(*USHORT Handle,BYTE DoRestore=1)
RestoreFile                     PROCEDURE(*USHORT Handle)
SaveBuffer                      PROCEDURE,USHORT
SaveFile                        PROCEDURE,USHORT
SetError                        PROCEDURE(USHORT Number)
SetKey                          PROCEDURE(KEY K),PROTECTED
SetName                         PROCEDURE(STRING Text)
SetThread                       PROCEDURE,PRIVATE
Throw                           PROCEDURE(USHORT ErrorNumber),BYTE,PROC,VIRTUAL
Throw                           PROCEDURE,BYTE,PROC,VIRTUAL
ThrowMessage                    PROCEDURE(USHORT ErrorNumber,STRING Text),BYTE,PROC,VIRTUAL
TryFetch                        PROCEDURE(KEY K),BYTE,PROC
TryInsert                       PROCEDURE,BYTE,PROC
TryNext                         PROCEDURE,BYTE,PROC
TryOpen                         PROCEDURE(),BYTE,PROC
TryPrevious                     PROCEDURE,BYTE,PROC
TryPrimeAutoInc                 PROCEDURE,BYTE,PROC,VIRTUAL
TryReget                        PROCEDURE(STRING Position),BYTE,PROC
TryUpdate                       PROCEDURE,BYTE,PROC
Update                          PROCEDURE,BYTE,PROC
UpdateServer                    PROCEDURE(BYTE HandleError),BYTE,PROC,PRIVATE
UseFile                         PROCEDURE(),BYTE,PROC
ValidateField                   PROCEDURE(UNSIGNED Id),BYTE,PROC,VIRTUAL
ValidateFields                  PROCEDURE(UNSIGNED Low,UNSIGNED High,<*UNSIGNED Failed>),BYTE,PROTECTED,PROC,VIRTUAL
ValidateRecord                  PROCEDURE(<*UNSIGNED Failed>),BYTE,VIRTUAL
                              END



!------------------------------------------------------------------
! The RelationManager class.
! The RelationManager class behaves as a file manager -except- it
! broadcasts commands on to child classes where useful.
! This layer contains Referential Integrity (RI) code.


! Defines how actions percolate through a relation tree.
  ITEMIZE(0),PRE(Propagate)
None                EQUATE          ! Only act on primary
OneMany             EQUATE          ! Only percolate down 1-Many relations
ManyOne             EQUATE          ! Only percolate down Many-1 relations
All                 EQUATE          ! Percolate down all relations
  END


  ITEMIZE(0),PRE(RI)
None                       EQUATE
Clear                      EQUATE
Restrict                   EQUATE
Cascade                    EQUATE
  END

RelationManager               CLASS,TYPE,MODULE('ABFILE.CLW'),LINK('ABFILE.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
Me                              &FileManager               ! The FileManager object for this file???
Relations                       &RelationQueue,PRIVATE     ! QUEUE of all related files
AliasFile                       &RelationManager,PRIVATE   ! The RelationManager object for Alias file???
UseLogout                       BYTE                       ! Logout or not flag
LastTouched                     LONG,PRIVATE               ! Time file was last touched
AddRelation                     PROCEDURE(RelationManager RM),PROTECTED
AddRelation                     PROCEDURE(RelationManager RM,BYTE UpdateMode,BYTE DeleteMode,KEY His),PROTECTED
AddRelationLink                 PROCEDURE(*? Left,*? Right),PROTECTED
AddRelationLink                 PROCEDURE(*long Left,*long Right),PROTECTED
AddRelationLink                 PROCEDURE(*string Left,*string Right),PROTECTED
CancelAutoInc                   PROCEDURE(),BYTE,PROC,VIRTUAL
CascadeUpdates                  PROCEDURE,BYTE,PRIVATE
Close                           PROCEDURE(BYTE Cascading=0),BYTE,PROC,VIRTUAL
Delete                          PROCEDURE(BYTE Query=1),BYTE,VIRTUAL,PROC
DeleteSecondary                 PROCEDURE(KEY MyKey,BufferedPairsClass Links,BYTE Mode),BYTE,PRIVATE,VIRTUAL
Init                            PROCEDURE(FileManager FM,BYTE UseLogout=0)
Kill                            PROCEDURE,VIRTUAL
ListLinkingFields               PROCEDURE(RelationManager Him,FieldPairsClass Trgt,BYTE RightFirst = 0)
LogoutDelete                    PROCEDURE,BYTE,PRIVATE
LogoutDeleteClear               PROCEDURE,BYTE,PRIVATE
LogoutPrime                     PROCEDURE,BYTE,PRIVATE
LogoutUpdate                    PROCEDURE,BYTE,PRIVATE
Open                            PROCEDURE(BYTE Cascading=0),BYTE,PROC,VIRTUAL
Save                            PROCEDURE,VIRTUAL
SetAlias                        PROCEDURE(RelationManager RM)
SetQuickScan                    PROCEDURE(BYTE On,BYTE Propagate=Propagate:None),VIRTUAL
Update                          PROCEDURE(BYTE FromForm=0),BYTE,VIRTUAL,PROC
UpdateSecondary                 PROCEDURE(KEY MyKey,BufferedPairsClass Links,BYTE Mode),BYTE,PRIVATE,VIRTUAL
                              END



!---------------------------------------------------------
! The ViewManager class

  ITEMIZE(0),PRE(Record)
OK                     EQUATE          ! Record passes range and filter
OutOfRange             EQUATE          ! Record fails range test
Filtered               EQUATE          ! Record fails filter tests
  END

  ITEMIZE(0),PRE(Limit)
None                    EQUATE          ! no range limit
Current                 EQUATE          ! range limited to current value
Single                  EQUATE          ! range limited to single value
Pair                    EQUATE          ! range falls between a pair of values
File                    EQUATE          ! range limited to current value of parent file's linking field
  END

FilterQueue QUEUE,TYPE
ID                  STRING(30)                   ! By convention first char is digit 0-9 for priority
Filter              &STRING
  END

SortOrder                     QUEUE,TYPE         ! QUEUE of sort info for this file
Filter                          &FilterQueue     ! A conjunctive list of filter expressions
FreeElement                     ANY              ! The Free key element
LimitType                       BYTE             ! Range limit flag/indicator
MainKey                         &KEY             ! The KEY
Order                           &STRING          ! ORDER clause for sort order
RangeList                       &BufferedPairsClass ! List of fields in range limit
                              END

ViewManager                   CLASS,TYPE,MODULE('ABFILE.CLW'),DLL(_ABCDllMode_)
DisposeOrder                    BYTE,PRIVATE
Opened                          BYTE,PRIVATE               ! Opened or not flag
Order                           &SortOrder,PROTECTED       ! QUEUE of sort/range/filter info
PagesAhead                      USHORT
PagesBehind                     USHORT
PageSize                        USHORT
Primary                         &RelationManager,PROTECTED ! The RelationManager object for this VIEW
TimeOut                         USHORT
View                            &VIEW                      ! The object VIEW

AddRange                        PROCEDURE(*? Field)
AddRange                        PROCEDURE(*? Field,*? Limit)
AddRange                        PROCEDURE(*? Field,*? Low,*? High)
AddRange                        PROCEDURE(*? Field,RelationManager MyFile,RelationManager RelatedFile)
AddSortOrder                    PROCEDURE(<KEY K>),BYTE,PROC
AppendOrder                     PROCEDURE(STRING Order)
ApplyFilter                     PROCEDURE,VIRTUAL
ApplyOrder                      PROCEDURE,VIRTUAL
ApplyRange                      PROCEDURE,VIRTUAL,BYTE,PROC
Close                           PROCEDURE,VIRTUAL
GetFreeElementName              PROCEDURE,STRING,VIRTUAL
GetFreeElementPosition          PROCEDURE,BYTE,PROTECTED,VIRTUAL
Init                            PROCEDURE(VIEW V,RelationManager RM,<SortOrder SO>)
Kill                            PROCEDURE,VIRTUAL
LimitMajorComponents            PROCEDURE(*? Field),PRIVATE
Next                            PROCEDURE,VIRTUAL,BYTE
Open                            PROCEDURE,VIRTUAL
Previous                        PROCEDURE,VIRTUAL,BYTE
PrimeRecord                     PROCEDURE(BYTE SuppressClear = 0),VIRTUAL
Reset                           PROCEDURE(BYTE Locate),VIRTUAL
Reset                           PROCEDURE,VIRTUAL
SetFilter                       PROCEDURE(STRING Filter),VIRTUAL
SetFilter                       PROCEDURE(STRING Filter,STRING Id),VIRTUAL
SetFreeElement                  PROCEDURE,PRIVATE
SetOrder                        PROCEDURE(STRING Order),VIRTUAL
SetSort                         PROCEDURE(BYTE OrderNumber),BYTE,VIRTUAL,PROC
UseView                         PROCEDURE,PROTECTED
ValidateRecord                  PROCEDURE,BYTE,VIRTUAL
                              END

_EndOfInclude_
