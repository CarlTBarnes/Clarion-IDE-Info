@echo off
Echo Copy files from the Clarion IDE Folders into Sub Folders here
echo+
pause

Rem add new ...
Rem GOTO :SkipRest

Call :Copy_IDE_Rtn  D:\Clarion12.13941.Clean     Clarion12.13941
Call :Copy_IDE_Rtn  D:\Clarion11.1.13815.Clean   Clarion11.1.13815
Call :Copy_IDE_Rtn  D:\Clarion11.1.13744.Clean   Clarion11.1.13744
Call :Copy_IDE_Rtn  D:\Clarion11.13505.Clean     Clarion11.0.13505
Call :Copy_IDE_Rtn  D:\Clarion10.12799.clean     Clarion10.12799
Call :Copy_IDE_Rtn  D:\Clarion91                 Clarion9.1
Call :Copy_IDE_Rtn  D:\Clarion9                  Clarion9.0
Call :Copy_IDE_Rtn  D:\Clarion8                  Clarion8

:CwCopy
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\I\C6              CW_6.3.9055
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\I\C6.Gold.Clean   CW_6.0.9015
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\I\c55b      CW_5.5507
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\F\c5        CW_5.0B                    
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\F\clarion4  CW_4.0
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\F\CW20      CW_2.0
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\F\CW15      CW_1.5
Call :Copy_6_CW_Rtn  L:\ShareDriveL\Velocity2012\I\Velo_XP\F\CW1       CW_1.0

MD Documents
Copy "L:\ShareDriveL\Velocity2012\I\Velo_XP\I\C6\DOCS\61Features.pdf" Documents
Copy "L:\ShareDriveL\Velocity2012\I\Velo_XP\I\c55b\5506NewFeatures.pdf" Documents
Copy "L:\ShareDriveL\Velocity2012\I\Velo_XP\I\C55-HLP\C55_ExamplesGuide.pdf" Documents
Copy "L:\ShareDriveL\Velocity2012\I\Velo_XP\I\ClaDocs\MetaFileAccessThruPropsFromGreyMatter.pdf" Documents
Copy "L:\ShareDriveL\Velocity2012\I\Velo_XP\I\ClaDocs\ClarionEssentialsCBT.pdf" Documents

:SkipRest
@del /s *.bak
@del %0.bak
pause 
GOTO :EOF

REM  ############ End of Main Code, below are Call Routines ##############
REM  ############ End of Main Code, below are Call Routines ##############

REM ======================================= :Copy_IDE_Rtn   %1=FromFolder %2=ClarionName e.g. C:\Clarion12 Clarion12
:Copy_IDE_Rtn
ECHO Copy_IDE_Rtn From: %1 -- To: %2
ECHO ------------------------
MD .\%2
CALL :CopyLibSrcRtn %1\LibSrc\Win   .\%2\LibSrc
CALL :CopyTplzzzRtn %1\Template\Win .\%2\Template
GOTO :EOF

REM ======================================= :Copy_6_CW_Rtn   %1=FromFolder %2=ClarionName e.g. C:\C6 Clarion6 no \Win subfolder
:Copy_6_CW_Rtn
ECHO Copy_6_CW_Rtn From: %1 -- To: %2
ECHO ------------------------
MD .\%2
CALL :CopyLibSrcRtn %1\LibSrc   .\%2\LibSrc
CALL :CopyTplzzzRtn %1\Template .\%2\Template
GOTO :EOF


REM ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- Routines
REM ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- LibSrc ----- Routines
REM ======================================= :CopyLibSrcRtn  %1=FromFolder %2=ToFolder
:CopyLibSrcRtn
ECHO CopyLibSrcRtn From: %1 -- To: %2
ECHO ------------------------
MD %2
REM Copy %1 %2
CALL :CpLibSrcWorkerRtn %1 %2
GOTO :EOF
REM  ----------------------

REM ======================================= :CpLibSrcWorkerRtn %1=FromFolder %2=ToFolder
:CpLibSrcWorkerRtn
ECHO CpLibSrcWorkerRtn From: %1 -- To: %2
ECHO ------------------------

COPY /Y %1\BUILTINS.CLW   %2  & RENAME %2\builtins.clw BUILTINS.CLW
COPY /Y %1\EQUATES.CLW    %2  & RENAME %2\equates.clw  EQUATES.CLW
COPY /Y %1\KEYCODES.CLW   %2  & RENAME %2\keycodes.clw KEYCODES.CLW
COPY /Y %1\PROPERTY.CLW   %2  & RENAME %2\property.clw PROPERTY.CLW
COPY /Y %1\PRNPROP.CLW    %2  & RENAME %2\prnprop.clw  PrnProp.CLW
COPY /Y %1\ANYSCREEN.INC  %2

REM less important
COPY /Y %1\ABBROWSE.*     %2  ^ RENAME %2\abbrowse.clw ABBROWSE.CLW
COPY /Y %1\ABFILE.*       %2
COPY /Y %1\ABPOPUP.*      %2

COPY /Y %1\ABREPORT.*     %2
COPY /Y %1\ABpr*.*        %2
COPY /Y %1\ABRPTGEN.*     %2
COPY /Y %1\ABRPATMG.*     %2
COPY /Y %1\ABRPPSEL.*     %2
COPY /Y %1\ABBreak.*      %2

COPY /Y %1\ABUTIL.*       %2
COPY /Y %1\ABWINDOW.*     %2
COPY /Y %1\BRWEXT.*       %2
COPY /Y %1\CLARUNEXT.*    %2
COPY /Y %1\CLIB.*         %2
COPY /Y %1\CSIDL*.*       %2
COPY /Y %1\CWHELP.*       %2
COPY /Y %1\CWHH.*         %2
COPY /Y %1\CWSYN*.*       %2
COPY /Y %1\CWUTIL*.*      %2
COPY /Y %1\DEFAULTS.CLW   %2
COPY /Y %1\ERRORS.CLW     %2
COPY /Y %1\I64.*          %2
COPY /Y %1\JSON.*         %2
COPY /Y %1\MENUSTYLE.*    %2
COPY /Y %1\RESCODE.CLW    %2
COPY /Y %1\RESDEF.CLW     %2
COPY /Y %1\SVAPI.INC      %2
COPY /Y %1\SVAPIFNC.INC   %2
COPY /Y %1\SYSTEMSTRING.* %2
COPY /Y %1\TPLEQU.CLW     %2
COPY /Y %1\WINDOWS.INC    %2
COPY /Y %1\WINEXT.*       %2

GOTO :EOF 
REM  ========================================================


REM ----- Templates ----- Templates ----- Templates ----- Templates ----- Templates ----- Routines
REM ----- Templates ----- Templates ----- Templates ----- Templates ----- Templates ----- Routines
REM ======================================= :CopyTplzzzRtn  %1=FromFolder %2=ToFolder
:CopyTplzzzRtn
ECHO CopyTplzzzRtn From: %1 -- To: %2
ECHO ------------------------
MD %2
REM Copy %1 %2
CALL :CpTplzzzWorkerRtn %1 %2
GOTO :EOF
REM  ----------------------

REM ======================================= :CpTplzzzWorkerRtn %1=FromFolder %2=ToFolder
:CpTplzzzWorkerRtn
ECHO CpTplzzzWorkerRtn From: %1 -- To: %2
ECHO ------------------------
COPY /Y %1\ABCHAIN.TPL       %2
COPY /Y %1\ABBLDEXP.TPW      %2
COPY /Y %1\ABCODE.TPW        %2
COPY /Y %1\ABCONTRL.TPW      %2
COPY /Y %1\ABBROWSE.TPW      %2
COPY /Y %1\ABFILE.TPW        %2
COPY /Y %1\ABGROUP.TPW       %2
COPY /Y %1\ABREPORT.TPW      %2
COPY /Y %1\ABUTIL.TPW        %2
COPY /Y %1\ABWINDOW.TPW      %2

COPY /Y %1\CW.TPL            %2
COPY /Y %1\BROWSE.TPW        %2
COPY /Y %1\Brwext.tpw        %2
COPY /Y %1\BUILDEXP.TPW      %2
COPY /Y %1\CODE.TPW          %2
COPY /Y %1\CONTROL.TPW       %2
COPY /Y %1\CTLBROW.TPW       %2
COPY /Y %1\CTLBROWA.TPW      %2
COPY /Y %1\CwHH*.TP*         %2
COPY /Y %1\CwUtil.tpw        %2
COPY /Y %1\EXTENS.TPW        %2
COPY /Y %1\FIELD.TPW         %2
COPY /Y %1\FILE.TPW          %2
COPY /Y %1\FILECTRL.TPW      %2
COPY /Y %1\FORM.TPW          %2
COPY /Y %1\FRAME.TPW         %2
COPY /Y %1\GPPROCES.TPW      %2
COPY /Y %1\GPREPORT.TPW      %2
COPY /Y %1\MENU.TPW          %2
COPY /Y %1\MODULE.TPW        %2
COPY /Y %1\PROCESS.TPW       %2
COPY /Y %1\PROGRAM.TPW       %2
COPY /Y %1\REPORT.TPW        %2
COPY /Y %1\Rtar*.tp*         %2
COPY /Y %1\STANDARD.TPW      %2
COPY /Y %1\STDFUNC.TPW       %2
COPY /Y %1\Versionres.tpl    %2
COPY /Y %1\VistaManifest.tpw %2
COPY /Y %1\WINDOW.TPW        %2

GOTO :EOF 
REM  ========================================================