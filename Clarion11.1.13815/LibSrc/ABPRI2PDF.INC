!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_I2PDFReportGeneratorPresent_)
_I2PDFReportGeneratorPresent_ EQUATE(1)
 MAP
   INCLUDE('Image2PDF.inc')
 END
 INCLUDE('Image2PDF.EQU'),ONCE
 INCLUDE('ABPRTARG.INC'),ONCE   ! TargetClass
! INCLUDE('ABRPATMG.INC'),ONCE   ! Attr Manager
 INCLUDE('ABRPTGEN.INT'),ONCE   ! IReportGenerator Interface
 INCLUDE('ABERROR.INC'),ONCE
 !INCLUDE('ClaRunExt.INC'),ONCE

I2PDFReportGenerator    CLASS,IMPLEMENTS(IReportGenerator),MODULE('ABPRI2PDF.CLW'),TYPE,LINK('ABPRI2PDF.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
LastError               LONG,PROTECTED
TotalPageNo             SHORT(0),PROTECTED
PageOpen                BYTE,PROTECTED
UseTmpFiles BYTE,PROTECTED
Encrypt              BYTE,PROTECTED
AccessPermissions    LONG,PROTECTED
PasswordUSer         CSTRING(256),PROTECTED
Title                CSTRING(50),PROTECTED
AppName              CSTRING(50),PROTECTED
ProgName             CSTRING(50),PROTECTED
Subject              CSTRING(200),PROTECTED
Author               CSTRING(200),PROTECTED
Keywords             CSTRING(200),PROTECTED
PDFVersion           CSTRING(5),PROTECTED
ScanCopyMode            BYTE,PROTECTED
ScanCopyResolution      ULONG,PROTECTED
OpenPageName            STRING(FILE:MaxFileName),PROTECTED
Output                  &TargetGenerator,PROTECTED
OutputFileQueue         &OutputFileQueue,PROTECTED
CONSTRUCT               PROCEDURE()
DESTRUCT                PROCEDURE()
Init                    PROCEDURE(<STRING TargetFileName>),VIRTUAL
Setup                   PROCEDURE(),VIRTUAL
OpenDocument            PROCEDURE()
CloseDocument           PROCEDURE()
StartPage               PROCEDURE()
EndPage                 PROCEDURE()
ProcessPage             PROCEDURE(STRING pTmpWMFFileName),LONG
SetFileName             PROCEDURE(STRING pFileName)
GetFileName             PROCEDURE(),STRING
GetLastError            PROCEDURE(),LONG
SetUseTmpFiles          PROCEDURE(BYTE pVal)
SetEncryption           PROCEDURE(STRING pPassword,<ULONG pAccessPermissions>)
SetDocumentInfo         PROCEDURE(STRING pTitle,STRING pAppName,STRING pProgName,STRING pSubject,STRING pAuthor,STRING pKeywords)
SetScanCopyMode         PROCEDURE(BYTE onOff)
GetScanCopyMode         PROCEDURE(),BYTE
SetScanCopyResolution   PROCEDURE(ULONG imageRes)
GetScanCopyResolution   PROCEDURE(),ULONG
                       END

 _EndOfInclude_
