@echo off
Echo RoboCopy files from the Clarion IDE Folders into Sub Folders here
echo+
pause

REM RoboCopy Options
SET _Ops_= /NJS /NJH /R:2
SET _Ops_= /R:2

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

RoboCopy %_Ops_%  %1  %2  BUILTINS.CLW   
RoboCopy %_Ops_%  %1  %2  EQUATES.CLW    
RoboCopy %_Ops_%  %1  %2  KEYCODES.CLW   
RoboCopy %_Ops_%  %1  %2  PROPERTY.CLW   
RoboCopy %_Ops_%  %1  %2  PRNPROP.CLW    
RoboCopy %_Ops_%  %1  %2  ANYSCREEN.INC  

REM less important
RoboCopy %_Ops_%  %1  %2  ABBROWSE.*      
RoboCopy %_Ops_%  %1  %2  ABFILE.*       
RoboCopy %_Ops_%  %1  %2  ABPOPUP.*      

RoboCopy %_Ops_%  %1  %2  ABREPORT.*     
RoboCopy %_Ops_%  %1  %2  ABpr*.*        
RoboCopy %_Ops_%  %1  %2  ABRPTGEN.*     
RoboCopy %_Ops_%  %1  %2  ABRPATMG.*     
RoboCopy %_Ops_%  %1  %2  ABRPPSEL.*     
RoboCopy %_Ops_%  %1  %2  ABBreak.*      

RoboCopy %_Ops_%  %1  %2  ABUTIL.*       
RoboCopy %_Ops_%  %1  %2  ABWINDOW.*     
RoboCopy %_Ops_%  %1  %2  BRWEXT.*       
RoboCopy %_Ops_%  %1  %2  CLARUNEXT.*    
RoboCopy %_Ops_%  %1  %2  CLIB.*         
RoboCopy %_Ops_%  %1  %2  CSIDL*.*       
RoboCopy %_Ops_%  %1  %2  CWHELP.*       
RoboCopy %_Ops_%  %1  %2  CWHH.*         
RoboCopy %_Ops_%  %1  %2  CWSYN*.*       
RoboCopy %_Ops_%  %1  %2  CWUTIL*.*      
RoboCopy %_Ops_%  %1  %2  DEFAULTS.CLW   
RoboCopy %_Ops_%  %1  %2  ERRORS.CLW     
RoboCopy %_Ops_%  %1  %2  I64.*          
RoboCopy %_Ops_%  %1  %2  JSON.*         
RoboCopy %_Ops_%  %1  %2  MENUSTYLE.*    
RoboCopy %_Ops_%  %1  %2  RESCODE.CLW    
RoboCopy %_Ops_%  %1  %2  RESDEF.CLW     
RoboCopy %_Ops_%  %1  %2  SVAPI.INC      
RoboCopy %_Ops_%  %1  %2  SVAPIFNC.INC   
RoboCopy %_Ops_%  %1  %2  SYSTEMSTRING.* 
RoboCopy %_Ops_%  %1  %2  TPLEQU.CLW     
RoboCopy %_Ops_%  %1  %2  WINDOWS.INC    
RoboCopy %_Ops_%  %1  %2  WINEXT.*       

RENAME %2\builtins.clw BUILTINS.CLW 
RENAME %2\equates.clw  EQUATES.CLW  
RENAME %2\keycodes.clw KEYCODES.CLW 
RENAME %2\property.clw PROPERTY.CLW 
RENAME %2\prnprop.clw  PrnProp.CLW  
RENAME %2\abbrowse.clw ABBROWSE.CLW

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
RoboCopy %_Ops_%  %1  %2  ABCHAIN.TPL       
RoboCopy %_Ops_%  %1  %2  ABBLDEXP.TPW      
RoboCopy %_Ops_%  %1  %2  ABCODE.TPW        
RoboCopy %_Ops_%  %1  %2  ABCONTRL.TPW      
RoboCopy %_Ops_%  %1  %2  ABBROWSE.TPW      
RoboCopy %_Ops_%  %1  %2  ABFILE.TPW        
RoboCopy %_Ops_%  %1  %2  ABGROUP.TPW       
RoboCopy %_Ops_%  %1  %2  ABREPORT.TPW      
RoboCopy %_Ops_%  %1  %2  ABUTIL.TPW        
RoboCopy %_Ops_%  %1  %2  ABWINDOW.TPW      

RoboCopy %_Ops_%  %1  %2  CW.TPL            
RoboCopy %_Ops_%  %1  %2  BROWSE.TPW        
RoboCopy %_Ops_%  %1  %2  Brwext.tpw        
RoboCopy %_Ops_%  %1  %2  BUILDEXP.TPW      
RoboCopy %_Ops_%  %1  %2  CODE.TPW          
RoboCopy %_Ops_%  %1  %2  CONTROL.TPW       
RoboCopy %_Ops_%  %1  %2  CTLBROW.TPW       
RoboCopy %_Ops_%  %1  %2  CTLBROWA.TPW      
RoboCopy %_Ops_%  %1  %2  CwHH*.TP*         
RoboCopy %_Ops_%  %1  %2  CwUtil.tpw        
RoboCopy %_Ops_%  %1  %2  EXTENS.TPW        
RoboCopy %_Ops_%  %1  %2  FIELD.TPW         
RoboCopy %_Ops_%  %1  %2  FILE.TPW          
RoboCopy %_Ops_%  %1  %2  FILECTRL.TPW      
RoboCopy %_Ops_%  %1  %2  FORM.TPW          
RoboCopy %_Ops_%  %1  %2  FRAME.TPW         
RoboCopy %_Ops_%  %1  %2  GPPROCES.TPW      
RoboCopy %_Ops_%  %1  %2  GPREPORT.TPW      
RoboCopy %_Ops_%  %1  %2  MENU.TPW          
RoboCopy %_Ops_%  %1  %2  MODULE.TPW        
RoboCopy %_Ops_%  %1  %2  PROCESS.TPW       
RoboCopy %_Ops_%  %1  %2  PROGRAM.TPW       
RoboCopy %_Ops_%  %1  %2  REPORT.TPW        
RoboCopy %_Ops_%  %1  %2  Rtar*.tp*         
RoboCopy %_Ops_%  %1  %2  STANDARD.TPW      
RoboCopy %_Ops_%  %1  %2  STDFUNC.TPW       
RoboCopy %_Ops_%  %1  %2  Versionres.tpl    
RoboCopy %_Ops_%  %1  %2  VistaManifest.tpw 
RoboCopy %_Ops_%  %1  %2  WINDOW.TPW        

GOTO :EOF 
REM  ========================================================