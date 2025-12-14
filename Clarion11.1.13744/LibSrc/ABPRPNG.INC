!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_PNGReportGeneratorPresent_)
_PNGReportGeneratorPresent_ EQUATE(1)

 INCLUDE('ABPRTARG.INC'),ONCE   ! TargetClass
 INCLUDE('ABRPATMG.INC'),ONCE   ! Attr Manager
 INCLUDE('ABRPTGEN.INT'),ONCE   ! IReportGenerator Interface
 INCLUDE('ABERROR.INC'),ONCE
 INCLUDE('ClaRunExt.INC'),ONCE

PNGReportGenerator    CLASS,IMPLEMENTS(IReportGenerator),MODULE('ABPRPNG.CLW'),TYPE,LINK('ABPRPNG.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
PageNo                  SHORT(0),PROTECTED
TotalPageNo             SHORT(0),PROTECTED
PageOpen                BYTE,PROTECTED
ImageResolution         USHORT,PROTECTED
OpenPageName            STRING(FILE:MaxFileName),PROTECTED
Output                  &TargetGenerator,PROTECTED
ClaRunExt               &ClaRunExtClass,PROTECTED
OutputFileQueue         &OutputFileQueue,PROTECTED
CONSTRUCT               PROCEDURE()
DESTRUCT                PROCEDURE()
Init                    PROCEDURE(<STRING TargetFileName>),VIRTUAL
Setup                   PROCEDURE(),VIRTUAL
OpenDocument            PROCEDURE()
CloseDocument           PROCEDURE()
StartPage               PROCEDURE()
EndPage                 PROCEDURE()
SetFileName             PROCEDURE(STRING pFileName)
GetFileName             PROCEDURE(),STRING
SetImageResolution      PROCEDURE(USHORT imageRes)
GetImageResolution      PROCEDURE(),USHORT
                       END

 _EndOfInclude_
