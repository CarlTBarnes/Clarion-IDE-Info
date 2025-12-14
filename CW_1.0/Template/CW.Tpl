#TEMPLATE(Clarion,'Clarion Release Templates')
#HELP('CWHELP.HLP')
#!
#APPLICATION('CW Default Application'),HLP('~TPLApplication')
#!
#!------------------------------------------------------------------------------
#!                          Template Release  1
#!------------------------------------------------------------------------------
#! CW Application Template                                       
#!------------------------------------------------------------------------------
#!                                      
#! These are the Clarion for Windows Templates.  The #PROCEDURE templates
#! included in this template set are:
#!
#! ToDo     - A default "Under Construction" procedure
#! Window   - A general purpose window handling procedure
#!  Browse  - Window copied for Browse grouping
#!  Form    - Window copied for Form grouping
#!  Frame   - Window copied for Frame grouping
#!  Menu    - Window copied for Menu grouping
#! Process  - A general purpose sequential record handler
#! Source   - A generic source procedure - Embed points only
#!
#!------------------------------------------------------------------------------
#!
#! Global Prompts - (Appear on 'Global Settings' screen-moved from #PROGRAM).
#!
#!------------------------------------------------------------------------------
#!
#PROMPT('Program &Author:',@s40),%ProgramAuthor
#PROMPT('Use field description as MSG() when MSG() is blank',CHECK),%MessageDescription,DEFAULT(%True),AT(10,,180)
#PROMPT('Generate global data as EXTERNAL',CHECK),%GlobalExternal,AT(10,,180)
#BUTTON('.INI File Settings'),AT(10,,180),HLP('~TPLApplication')
  #PROMPT('&Use .INI file to save and restore program settings',CHECK),%INIActive,AT(10,,180)
  #ENABLE(%INIActive)
    #PROMPT('.&INI File to use:',DROP('Program Name.INI|Other')),%INIFile
    #ENABLE(%INIFile='Other')
      #PROMPT('&Other File Name:',@S255),%ININame
    #ENDENABLE
  #ENDENABLE
#ENDBUTTON
#BUTTON('File Control Flags'),AT(10,,180),HLP('~TPLApplication')
  #PROMPT('Generate all file declarations',CHECK),%DefaultGenerate,AT(10,,180)
  #PROMPT('When done with a File:',DROP('Close the File|Keep the File Open')),%DefaultCloseFile,DEFAULT('Close the File')
  #PROMPT('Enclose RI code in transaction frame',CHECK),%DefaultRILogout,DEFAULT(1),AT(10,,180)
  #ENABLE(%DefaultRILogout)
    #PROMPT('Issue template warning if LOGOUT() not allowed',CHECK),%WarnOnLogoutError,DEFAULT(%True),AT(10,,180)
  #ENDENABLE
  #BOXED('File Attributes')
    #PROMPT('Threaded:',DROP('Use File Setting|All Threaded|None Threaded')),%DefaultThreaded,DEFAULT('Use File Setting')
    #PROMPT('Create:',DROP('Use File Setting|Create All|Create None')),%DefaultCreate,DEFAULT('Use File Setting')
    #PROMPT('External:',DROP('All External|None External')),%DefaultExternal,DEFAULT('None External')
    #BOXED('External Files'),WHERE(%DefaultExternal = 'All External'),AT(,90)
      #PROMPT('Declaring Module:',@S255),%DefaultExternalSource
      #PROMPT('All files are declared in another .APP',CHECK),%DefaultExternalAPP,AT(15,,140)
    #ENDBOXED
    #BOXED('Export Files'),WHERE(%DefaultExternal = 'None External' AND %ProgramExtension='DLL'),AT(,90)
      #PROMPT('Export all file declarations',CHECK),%DefaultExport,AT(25,,140)
    #ENDBOXED
  #ENDBOXED
  #BOXED('File Access')
    #PROMPT('File Open Mode:',DROP('Share|Open|Other')),%DefaultOpenMode,DEFAULT('Share')
    #ENABLE(%DefaultOpenMode='Other')
      #BOXED('Other Open Mode')
        #PROMPT('User Access:',DROP('Read/Write|Read Only|Write Only')),%DefaultUserAccess,DEFAULT('Read/Write')
        #PROMPT('Other Access:',DROP('Deny None|Deny Read|Deny Write|Deny All|Any Access')),%DefaultOtherAccess,DEFAULT('Deny None')
      #ENDBOXED
    #ENDENABLE
  #ENDBOXED
  #BUTTON('Individual File Overrides'),FROM(%File,%File & ' - ' & %FileDescription),AT(10,,180),HLP('~TPLApplication')
    #PROMPT('Generate file declaration',CHECK),%OverrideGenerate,AT(10,,180)
    #PROMPT('When Done with the File:',DROP('Use Default|Close the File|Keep the File Open')),%OverrideCloseFile,DEFAULT('Use Default')
    #PROMPT('Enclose RI code in transaction frame',CHECK),%OverrideRILogout,DEFAULT(1),AT(10,,180)
    #BOXED('File Attributes')
      #PROMPT('Threaded:',DROP('Use Default|Threaded|Not Threaded')),%OverrideThreaded,DEFAULT('Use Default')
      #PROMPT('Create:',DROP('Use Default|Use File Setting|Create File|Do Not Create File')),%OverrideCreate,DEFAULT('Use Default')
      #PROMPT('External:',DROP('Use Default|External|Not External')),%OverrideExternal,DEFAULT('Use Default')
      #BOXED('External File'),WHERE(%OverrideExternal = 'External'),AT(,80)
        #PROMPT('Declaring Module:',@S255),%OverrideExternalSource
        #PROMPT('The file is declared in another .APP',CHECK),%OverrideExternalAPP,AT(15,,140)
      #ENDBOXED
      #BOXED('Export File'),WHERE(%OverrideExternal = 'Not External'  AND %ProgramExtension='DLL'),AT(,80)
        #PROMPT('Export file declaration',CHECK),%OverrideExport,AT(20,,110)
      #ENDBOXED
    #ENDBOXED
    #BOXED('File Access')
      #PROMPT('File Open Mode:',DROP('Use Default|Share|Open|Other')),%OverrideOpenMode,DEFAULT('Use Default')
      #ENABLE(%OverRideOpenMode = 'Other')
        #BOXED('Other Open Mode')
          #PROMPT('User Access:',DROP('Use Default|Read/Write|Read Only|Write Only')),%OverrideUserAccess,DEFAULT('Use Default')
          #PROMPT('Other Access:',DROP('Use Default|Deny None|Deny Read|Deny Write|Deny All|Any Access')),%OverrideOtherAccess,DEFAULT('Use Default')
        #ENDBOXED
      #ENDENABLE
    #ENDBOXED
  #ENDBUTTON
#ENDBUTTON
#!------------------------------------------------------------------------------
#!
#! Global Template Declarations.
#!
#!------------------------------------------------------------------------------
#!
#MESSAGE('Generating ' & %Application,0)          #! Open the Message Box
#DECLARE(%CWTemplateVersion)
#SET(%CWTemplateVersion,'v1.000')
#DECLARE(%ProcFilesUsed),UNIQUE                   #!Name of file used in module
#DECLARE(%ModuleFilesUsed,%Module),UNIQUE,SAVE    #!Name of file used in module
#DECLARE(%UsedFile),UNIQUE                        #! Label of every file used
#DECLARE(%UsedDriverDLLs),UNIQUE
#DECLARE(%ModulePrintPreviewUsed,%Module),SAVE    #!Name of file used in module
#DECLARE(%PrintPreviewUsed)
#DECLARE(%FileExternalFlag)
#DECLARE(%FileThreadedFlag)
#DECLARE(%IniFileName)                            #! Used to construct INI file
#DECLARE(%GenerationCompleted,%Module),SAVE
#DECLARE(%GenerateModule)
#DECLARE(%ModuleVBXUsed,%Module),SAVE,UNIQUE
#DECLARE(%VBXUsed),UNIQUE
#!
#DECLARE(%ModuleProcs,%Module),SAVE,UNIQUE        #! Program MAP prototype
#DECLARE(%ModulePrototype,%ModuleProcs)           #! Module MAP prototype
#DECLARE(%AccessMode)                             #! File open mode equate
#DECLARE(%BuildFile)                              #! Construction filename
#DECLARE(%ModuleBuildFile)                        #! Module Build filename
#DECLARE(%ExportBuildFile)                        #! File to build Export
#DECLARE(%ExportFile)                             #! File for Export list
#DECLARE(%ValueConstruct)                         #! Constuct various strings
#DECLARE(%RegenerateGlobalModule)                 #! Will we regen the global module?
#!
#!------------------------------------------------------------------------------
#!
#! Initialization Code for Global User-defined Symbols.
#!
#!------------------------------------------------------------------------------
#!
#IF(%INIFile = 'Program Name.INI')                #! IF using program.ini
  #SET(%INIFileName, %Application & '.INI')       #! SET the file name
#ELSE                                             #! ELSE (IF NOT using Program.ini)
  #SET(%INIFileName,%ININame)                     #! SET the file name
#ENDIF                                            #! END (IF using program.ini)
#!
#!------------------------------------------------------------------------------
#!
#! Main Source Code Generation Loop.
#!
#!------------------------------------------------------------------------------
#!
#DECLARE(%GlobalRegenerate)                       #! Flag that controls generation
#IF(~%ConditionalGenerate OR %DictionaryChanged OR %RegistryChanged)
  #SET(%GlobalRegenerate,%True)                   #! Generate Everything
#ELSE                                             #! ELSE (If no global change)
  #SET(%GlobalRegenerate,%False)                  #! Generate changed modules only
#ENDIF                                            #! END (IF Global Change)
#SET(%BuildFile,(%Application & '.B1$'))          #! Make temp program filename
#SET(%ModuleBuildFile,(%Application & '.B2$'))    #! Make temp program filename
#FOR(%Module), WHERE (%Module <> %Program)        #! For all member modules
  #MESSAGE('Generating Module:    ' & %Module, 1) #! Post generation message
  #SET(%GenerateModule,%True)
  #IF(%ModuleExternal)
    #SET(%GenerateModule,%False)
  #ELSIF(%ModuleChanged)
  #ELSIF(%GlobalRegenerate)
  #ELSIF(NOT %GenerationCompleted)
  #ELSIF(NOT FILEEXISTS(%Module))
  #ELSE
    #SET(%GenerateModule,%False)
  #ENDIF
  #IF(%GenerateModule)                            #! IF module to be generated
    #SET(%GenerationCompleted,%False)
    #SET(%RegenerateGlobalModule,%True)           #! Flag to regen the main module
    #FREE(%ModuleVBXUsed)
    #FREE(%ModuleProcs)                           #! Clear module prototypes
    #FREE(%ModuleFilesUsed)                       #! Clear files used
    #SET(%ModulePrintPreviewUsed,%False)
    #CREATE(%BuildFile)                           #! Create temp module file
    #FOR(%ModuleProcedure)                        #! FOR all procs in module
      #FIX(%Procedure,%ModuleProcedure)           #! Fix current procedure
      #MESSAGE('Generating Procedure: ' & %Procedure, 2) #! Post generation message
      #FREE(%ProcFilesUsed)                       #! Clear file accumulator
      #GENERATE(%Procedure)                       #! Generate procedure code
    #ENDFOR                                       #! END (For all procs in module)
    #CLOSE(%BuildFile)                            #! Close last temp file
    #CREATE(%ModuleBuildFile)                     #! Create a module file
    #GENERATE(%Module)                            #! Generate module header
    #APPEND(%BuildFile)                           #! Append the temp mod file
    #CLOSE(%ModuleBuildFile)                      #! Close the module build file
    #REPLACE(%Module,%ModuleBuildFile)            #! Replace the existing file
    #SET(%GenerationCompleted,%True)
  #ENDIF                                          #! END (If module to be...)
#ENDFOR                                           #! END (For all member modules)
#FIX(%Module,%Program)                            #! FIX to program module
#MESSAGE('Generating Module:    ' & %Module, 1)   #! Post generation message
#SET(%GenerateModule,%True)
#IF(%ModuleExternal)
  #SET(%GenerateModule,%False)
#ELSIF(%RegenerateGlobalModule)
#ELSIF(%ModuleChanged)
#ELSIF(%GlobalRegenerate)
#ELSIF(NOT %GenerationCompleted)
#ELSIF(NOT FILEEXISTS(%Module))
#ELSE
  #SET(%GenerateModule,%False)
#ENDIF
#IF(%GenerateModule)
  #SET(%GenerationCompleted,%False)
  #FREE(%ModuleVBXUsed)
  #FREE(%ModuleProcs)                             #! Clear module prototypes
  #FREE(%ModuleFilesUsed)                         #! Clear files used
  #SET(%ModulePrintPreviewUsed,%False)
  #CREATE(%BuildFile)                             #! Create temp module file
  #FOR(%ModuleProcedure)                          #! For all procs in module
    #FIX(%Procedure,%ModuleProcedure)             #! Fix current procedure
    #MESSAGE('Generating Procedure: ' & %Procedure, 2) #! Post generation message
    #GENERATE(%Procedure)                         #! Generate procedure code
  #ENDFOR                                         #! EndFor all procs in module
  #CLOSE()                                        #! Close last temp file
#!
#!------------------------------------------------------------------------------
#!
#! Accumulate Referential Integrity Usage Flags.
#!
#!------------------------------------------------------------------------------
#!
  #SET(%PrintPreviewUsed,%False)
  #FOR(%Module)                                   #! FOR each module
    #FOR(%ModuleFilesUsed)                        #! FOR files in the module
      #ADD(%UsedFile,%ModuleFilesUsed)            #! ADD each file to list
    #ENDFOR                                       #! END (FOR files in the module
    #FOR(%ModuleVBXUsed)
      #ADD(%VBXUsed,%ModuleVBXUsed)
    #ENDFOR
    #IF(%ModulePrintPreviewUsed)
      #SET(%PrintPreviewUsed,%True)
    #ENDIF
  #ENDFOR                                         #! END (FOR each module)
  #FREE(%UsedDriverDLLs)
  #FOR(%UsedFile)                                 #! FOR all files used
    #FIX(%File,%UsedFile)                         #! FIX to that file
    #FIX(%Driver,%FileDriver)                     #! FIX to file's driver
    #ADD(%UsedDriverDLLs,%DriverDLL)
    #PROJECT(%DriverLIB)                          #! ADD driver LIB to project
  #ENDFOR                                         #! END (FOR all files used)
#!
#!------------------------------------------------------------------------------
#!
#! Main Module Generation and Conditional Replacement.
#!
#!------------------------------------------------------------------------------
#!
  #MESSAGE('Generating Program Code',2)           #! Post generation message
  #CREATE(%ModuleBuildFile)                       #! Create new program file
  #GENERATE(%Program)                             #! Generate main program header
  #APPEND(%BuildFile)                             #! Append program procedures
  #CLOSE(%ModuleBuildFile)                        #! Close new program file
  #REPLACE(%Program,%ModuleBuildFile)             #! Replace if changed
  #SET(%GenerationCompleted,%True)
#ENDIF
#REMOVE(%BuildFile)                               #! Remove the temp file
#REMOVE(%ModuleBuildFile)                         #! Remove the temp file
#SET(%GenerationCompleted,%True)
#!
#!------------------------------------------------------------------------------
#!
#! End of CW #APPLICATION Template
#!
#!------------------------------------------------------------------------------
#!
#MODULE(GENERATED,'Generated Source Module'),HLP('~TPLModuleGenerated') #! MODULE header
%[20]Null MEMBER('%Program')                      #<! This is a MEMBER module
#EMBED(%ModuleDataSection,'Module Data Section')
#FOR(%ModuleData)
%ModuleData   %ModuleDataStatement
#ENDFOR
#MODULE(ExternalSource,'External Source Module','External','.clw'),EXTERNAL,HLP('~TPLModuleExternalObj')
#MODULE(ExternalObj,'External Object Module','External','.obj'),EXTERNAL,HLP('~TPLModuleExternalObj')
#MODULE(ExternalLib,'External Library Module','External','.lib'),EXTERNAL,HLP('~TPLModuleExternalLib')
#PROCEDURE(External,'External Procedure','External'),HLP('~TPLProcExternal')
#PROCEDURE(Source,'Source Procedure'),HLP('~TPLProcSource')#! Source procedure
#PROMPT('Parameters', @s80), %Parameters          #! Retrieve parameters used
#IF(%Parameters)                                  #! IF Parameters used
%[20]Procedure %ProcedureType %Parameters         #<! Declare Procedure
#ELSE                                             #! ELSE (IF parameters not used)
%[20]Procedure %ProcedureType                     #<! Declare Procedure
#ENDIF                                            #! END (IF parameters used)
#INSERT(%FileControlInitialize)
#INSERT(%FileControlUpdate)
#FOR(%LocalData)
%[20]LocalData %LocalDataStatement
#ENDFOR
#EMBED(%DataSection,'Data Section'),DATA          #! Embedded Source Code
  CODE                                            #<! Begin processed code
#EMBED(%ProcessedCode,'Processed Code')           #! Embedded Source Code
#!                       
#INCLUDE('Program.TPW')                           #! The CW program template
#INCLUDE('Window.TPW')                            #! G/P window handler
#INCLUDE('Browse.TPW')                            #! Browse records from a file
#INCLUDE('Form.TPW')                              #! View / Edit a file record
#INCLUDE('Frame.TPW')                             #! MDI Frame
#INCLUDE('Menu.TPW')                              #! Non-MDI menu procedure
#INCLUDE('Viewer.TPW')                            #! ASCII file viewer
#INCLUDE('Process.TPW')                           #! Record Processing Proc
#INCLUDE('Report.TPW')                            #! Record reporting proc
#INCLUDE('ToDo.TPW')                              #! Under Construction proc
#INCLUDE('Relation.TPW')                          #! Relational Integrity Code
#INCLUDE('Standard.TPW')                          #! Standard Group code
#INCLUDE('FileCtrl.TPW')                          #! Standard File Control code
#INCLUDE('Code.TPW')                              #! Code Templates
#INCLUDE('CtlBrow.TPW')                           #! Browse control template(s)
#INCLUDE('CtlView.TPW')                           #! ASCII viewer control template
#INCLUDE('Control.TPW')                           #! Control Templates
#INCLUDE('Extens.TPW')                            #! Extension Templates
#INCLUDE('Field.TPW')                             #! Generic Field Handling
