! Template Equates

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
Warn:LogoutError         EQUATE (34)
Warn:RecordFetchError    EQUATE (35)
Warn:ViewOpenError       EQUATE (36)

ScrollSort:Alpha         EQUATE('  AFANATB BFBNBTC CFCNCT'|
                               &'D DFDNDTE EFENETF FFFNFT'|
                               &'G GFGNGTH HFHNHTI IFINIT'|
                               &'J JFJNJTK KFKNKTL LFLNLT'|
                               &'M MFMNMTN NFNNNTO OFONOT'|
                               &'P PFPNPTQ QNR RFRNRTS SF'|
                               &'SNSTT TFTNTTU UFUNUTV VF'|
                               &'VNVTW WFWNWTX XFXNXTY YF'|
                               &'YNYTZ ZN')

ScrollSort:Name          EQUATE('   ALBAMEARNBAKBATBENBIABOBBRA'|
                               &'BROBUACACCARCENCHRCOECONCORCRU'|
                               &'DASDELDIADONDURELDEVEFELFISFLO'|
                               &'FREFUTGARGIBGOLGOSGREGUTHAMHEM'|
                               &'HOBHOTINGJASJONKAGKEAKIRKORKYO'|
                               &'LATLEOLIGLOUMACMAQMARMAUMCKMER'|
                               &'MILMONMORNATNOLOKEPAGPAUPETPIN'|
                               &'PORPULRAUREYROBROSRUBSALSCASCH'|
                               &'SCRSHASIGSKISNASOUSTESTISUNTAY'|
                               &'TIRTUCVANWACWASWEIWIEWIMWOLYOR')

ScrollSort:AllowAlpha    EQUATE(1)
ScrollSort:AllowAlt      EQUATE(2)
ScrollSort:AllowNumeric  EQUATE(4)
ScrollSort:CaseSensitive EQUATE(8)

SortRequest:SelectSort   EQUATE(1)
SortRequest:Reset        EQUATE(2)
SortRequest:LocateRecord EQUATE(3)

SortResult:Changed       EQUATE(1)
SortResult:OK            EQUATE(2)
