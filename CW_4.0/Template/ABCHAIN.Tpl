#TEMPLATE(ABC,'Application Builder Class Templates'),FAMILY('ABC')
#HELP('C4HELP.HLP')
#!
#!
#SYSTEM
#DECLARE (%pClassName),UNIQUE
#DECLARE (%pClassIncFile,%pClassName)
#DECLARE (%pClassMethod,%pClassName),UNIQUE
#DECLARE (%pClassMethodPrototype,%pClassMethod),UNIQUE
#DECLARE (%pClassMethodPrivate,  %pClassMethodPrototype)
#DECLARE (%pClassMethodVirtual,  %pClassMethodPrototype)
#DECLARE (%pClassMethodProtected,%pClassMethodPrototype)
#DECLARE (%pClassMethodProcAttribute,%pClassMethodPrototype)
#DECLARE (%pClassMethodInherited,%pClassMethodPrototype)
#DECLARE (%pClassMethodReturnType,%pClassMethodPrototype)
#DECLARE (%pClassMethodParentCall,%pClassMethodPrototype)
#DECLARE (%pClassProperty,%pClassName),UNIQUE
#DECLARE (%pClassPropertyPrototype,%pClassProperty)
#DECLARE (%pClassPropertyPrivate,  %pClassProperty)
#DECLARE (%pClassPropertyProtected,%pClassProperty)
#DECLARE (%pClassPropertyInherited,%pClassProperty)
#DECLARE (%ClassMethodList),UNIQUE
#!
#DECLARE (%SysActiveInvisible)               #!These variables store the 'system default values' of user configurable options
#DECLARE (%SysAllowUnfilled)
#DECLARE (%SysRetainRow)
#DECLARE (%SysResetOnGainFocus)
#DECLARE (%SysAutoToolbar)
#DECLARE (%SysAutoRefresh)
#!
#DECLARE (%PropertyList),UNIQUE              #!These variables are used by the SetABCProperty and CallABCMethod CODE templates
#DECLARE (%MethodList),UNIQUE
#DECLARE (%ObjectList),UNIQUE
#DECLARE (%ObjectListType,%ObjectList)
#!
#!
#!
#APPLICATION('CW Default Application'),HLP('~TPLApplication'),WIZARD(ApplicationWizard(ABCWizards))
#!------------------------------------------------------------------------------
#!                          Template Release 4.0 B
#!------------------------------------------------------------------------------
#! CW Application Template
#!------------------------------------------------------------------------------
#!
#! These are the Clarion 4 Templates.  The #PROCEDURE templates
#! included in this template set are:
#!
#! ToDo     - A default "Under Construction" procedure
#! Window   - A general purpose window handling procedure
#!  Browse  - Window copied for Browse grouping
#!  Form    - Window copied for Form grouping
#!  Frame   - Window copied for Frame grouping
#!  Menu    - Window copied for Menu grouping
#! Process  - A general purpose sequential record handler
#!  Report  - A general purpose Report engine based upon sequential record handler
#! Source   - A generic source procedure - Embed points only
#!
#!------------------------------------------------------------------------------
#!
#! Global Prompts
#!
#!------------------------------------------------------------------------------
#!
#PREPARE
  #CALL(%ReadABCFiles)
#ENDPREPARE
#SHEET,HSCROLL
  #TAB('&General'),HLP('~TPLApplication_General')
    #PROMPT('Program &Author:',@s40),%ProgramAuthor,AT(,15),PROMPTAT(,15)
    #PROMPT('&Use field description as MSG() when MSG() is blank',CHECK),%MessageDescription,DEFAULT(%True),AT(10,,180)
    #PROMPT('&Generate template globals and ABC''s as EXTERNAL',CHECK),%GlobalExternal,AT(10,,180)
    #ENABLE(%GlobalExternal)
      #PROMPT('E&xternal Globals and ABC''s Source Module',OPTION),%ExternalSource,AT(,,180),DEFAULT('Dynamic Link Library (DLL)')
      #PROMPT('&Dynamic Link Library (DLL)',RADIO)
      #PROMPT('&Statically Linked Library (LIB)',RADIO)
    #ENDENABLE
    #PROMPT('G&enerate EMBED Comments',CHECK),%GenerateEmbedComments,AT(10,,180)
    #BOXED('.INI File Settings'),AT(10,,180)
      #PROMPT('&Use .INI file to save and restore program settings',CHECK),%INIActive,AT(10,,170)
      #ENABLE(%INIActive)
        #PROMPT('.&INI File to use:',DROP('Program Name.INI|Other')),%INIFile
        #ENABLE(%INIFile='Other')
          #PROMPT('&Other File Name:',@S255),%ININame
        #ENDENABLE
      #ENDENABLE
    #ENDBOXED
    #PROMPT('&Enable Run-Time Translation',CHECK),%EnableRunTimeTranslator,AT(10)
  #ENDTAB
  #TAB('&File Control'),HLP('~TPLApplication_FileControlFlags')
    #PROMPT('&Generate all file declarations',CHECK),%DefaultGenerate,AT(10,15,180),PROMPTAT(,15)
    #PROMPT('&Enclose RI code in transaction frame',CHECK),%DefaultRILogout,DEFAULT(1),AT(10,,180)
    #BOXED('File Manager Options'),SECTION
      #PROMPT('Use Default &FileManager',CHECK),%GlobalUseDefaultFileManager,DEFAULT(%True),AT(10)
      #ENABLE(~%GlobalUseDefaultFileManager)
        #PROMPT('&File Manager Class:',FROM(%pClassName)),%GlobalFileManagerClass,REQ
      #ENDENABLE
    #ENDBOXED
    #BOXED('Relation Manager Options'),SECTION
      #PROMPT('Use Default &RelationManager',CHECK),%GlobalUseDefaultRelationManager,DEFAULT(%True),AT(10)
      #ENABLE(~%GlobalUseDefaultRelationManager)
        #PROMPT('&Relation Manager Class:',FROM(%pClassName)),%GlobalRelationManagerClass,REQ
      #ENDENABLE
    #ENDBOXED
    #PROMPT('&Seconds for RECOVER:',SPIN(@N3,1,120,1)),%LockRecoverTime,DEFAULT(10)
    #BOXED('File Attributes')
      #PROMPT('&Threaded:',DROP('Use File Setting|All Threaded|None Threaded')),%DefaultThreaded,DEFAULT('Use File Setting')
      #PROMPT('&Create:',DROP('Use File Setting|Create All|Create None')),%DefaultCreate,DEFAULT('Use File Setting')
      #PROMPT('E&xternal:',DROP('All External|None External')),%DefaultExternal,DEFAULT('None External')
      #BOXED,SECTION
        #BOXED('External Files'),WHERE(%DefaultExternal = 'All External'),AT(,0)
          #PROMPT('Dec&laring Module:',@S255),%DefaultExternalSource
          #PROMPT('All &files are declared in another .APP',CHECK),%DefaultExternalAPP,AT(15,,156)
        #ENDBOXED
        #BOXED('Export Files'),WHERE(%DefaultExternal = 'None External' AND %ProgramExtension='DLL'),AT(,0)
          #PROMPT('Ex&port all file declarations',CHECK),%DefaultExport,AT(25,,156)
        #ENDBOXED
      #ENDBOXED
    #ENDBOXED
    #BOXED('File Access')
      #PROMPT('File Open &Mode:',DROP('Share|Open|Other')),%DefaultOpenMode,DEFAULT('Share')
      #ENABLE(%DefaultOpenMode='Other')
        #BOXED('Other Open Mode')
          #PROMPT('&User Access:',DROP('Read/Write|Read Only|Write Only')),%DefaultUserAccess,DEFAULT('Read/Write')
          #PROMPT('Ot&her Access:',DROP('Deny None|Deny Read|Deny Write|Deny All|Any Access')),%DefaultOtherAccess,DEFAULT('Deny None')
        #ENDBOXED
      #ENDENABLE
      #PROMPT('&Defer opening files until accessed',CHECK),%DefaultLazyOpen,DEFAULT(%True),AT(10)
    #ENDBOXED
  #ENDTAB
  #TAB('&Individual File Overrides'),HLP('~TPLApplication_IndividualFileOverrides')
    #BUTTON('Individual File Overrides for '&%File&' file'),FROM(%File,%File & ' - ' & %FileDescription),AT(10,15,180),HLP('~TPLApplication'),INLINE,HLP('~TPLApplication_IndividualFileOverrides')
      #PROMPT('&Generate file declaration',CHECK),%OverrideGenerate,AT(10,,180)
      #PROMPT('Us&e RI transaction frame',DROP('Use Default|Yes|No')),%OverrideRILogout,DEFAULT('Use Default')
      #BOXED('File Manager Options'),SECTION
        #PROMPT('Use Default &FileManager',CHECK),%OverrideUseDefaultFileManager,DEFAULT(%True),AT(10)
        #ENABLE(~%OverrideUseDefaultFileManager)
          #PROMPT('&File Manager Class:',FROM(%pClassName)),%OverrideFileManagerClass,REQ
        #ENDENABLE
      #ENDBOXED
      #BOXED('Relation Manager Options'),SECTION
        #PROMPT('Use Default &RelationManager',CHECK),%OverrideUseDefaultRelationManager,DEFAULT(%True),AT(10)
        #ENABLE(~%OverrideUseDefaultRelationManager)
          #PROMPT('&Relation Manager Class:',FROM(%pClassName)),%OverrideRelationManagerClass,REQ
        #ENDENABLE
      #ENDBOXED
      #BOXED('File Attributes')
        #PROMPT('&Threaded:',DROP('Use Default|Use File Setting|Threaded|Not Threaded')),%OverrideThreaded,DEFAULT('Use Default')
        #PROMPT('&Create:',DROP('Use Default|Use File Setting|Create File|Do Not Create File')),%OverrideCreate,DEFAULT('Use Default')
        #PROMPT('E&xternal:',DROP('Use Default|External|Not External')),%OverrideExternal,DEFAULT('Use Default')
        #BOXED('External File'),WHERE(%OverrideExternal = 'External'),AT(,80)
          #PROMPT('Dec&laring Module:',@S255),%OverrideExternalSource
          #PROMPT('The &file is declared in another .APP',CHECK),%OverrideExternalAPP,AT(15,,140)
        #ENDBOXED
        #BOXED('Export File'),WHERE((%OverrideExternal='Not External' OR (%OverrideExternal='Use Default' AND %DefaultExternal='None External')) AND %ProgramExtension='DLL') #!,AT(,80)
          #PROMPT('Ex&port file declaration',CHECK),%OverrideExport,AT(20,,110)
        #ENDBOXED
      #ENDBOXED
      #BOXED('File Access')
        #PROMPT('File Open &Mode:',DROP('Use Default|Share|Open|Other')),%OverrideOpenMode,DEFAULT('Use Default')
        #ENABLE(%OverRideOpenMode = 'Other')
          #BOXED('Other Open Mode')
            #PROMPT('&User Access:',DROP('Use Default|Read/Write|Read Only|Write Only')),%OverrideUserAccess,DEFAULT('Use Default')
            #PROMPT('Ot&her Access:',DROP('Use Default|Deny None|Deny Read|Deny Write|Deny All|Any Access')),%OverrideOtherAccess,DEFAULT('Use Default')
          #ENDBOXED
        #ENDENABLE
        #PROMPT('&Defer Opening File:',DROP('Use Default[Use Default]|Yes[Yes]|No[No]')),%OverrideLazyOpen,DEFAULT('Use Default')
      #ENDBOXED
    #ENDBUTTON
  #ENDTAB
  #TAB('External &Module Options'),WHERE(%AppContainsExternalLibs()),HLP('~TPLApplication_External')
    #BUTTON('External Module Options'),FROM(%Module,%Module&'  ( '&%ModuleTemplate&' )'),INLINE,WHERE(%ModuleTemplate='ExternalLIB(ABC)' OR %ModuleTemplate='ExternalDLL(ABC)')
      #PROMPT('Standard Clarion 4 LIB/DLL?',CHECK),%StandardExternalModule,DEFAULT(%True),AT(10)
    #ENDBUTTON
  #ENDTAB
  #TAB('&Classes'),HLP('~TPLApplication_Classes')
    #BUTTON('&Refresh Application Builder Class Information'),WHENACCEPTED(%ForceReadABCFiles()),AT(,,170)
    #ENDBUTTON
    #BUTTON('Application Builder Class &Viewer'),WHENACCEPTED(%ViewABCs()),AT(,,170)
    #ENDBUTTON
    #BUTTON('&General'),HLP('~TPLApplication_Classes_General')
      #PROMPT('Window Manager:',@S80),%WindowManagerType,DEFAULT('WindowManager'),REQ
      #BUTTON('&Configure'),AT(100,,90),HLP('~TPLApplication_Classes_General_Configure1')
        #PROMPT('&Reset On Gain Focus',CHECK),%ResetOnGainFocus,DEFAULT(%False)
        #PROMPT('&Auto Tool Bar',CHECK),%AutoToolbar,DEFAULT(%True)
        #PROMPT('&Auto Refresh',CHECK),%AutoRefresh,DEFAULT(%True)
      #ENDBUTTON
      #PROMPT('Error Manager:',@S80),%ErrorManagerType,DEFAULT('ErrorClass'),REQ
      #PROMPT('Popup Manager:',@S80),%PopupClass,DEFAULT('PopupClass'),REQ
      #PROMPT('DOS File Lookup:',@S80),%SelectFileClass,DEFAULT('SelectFileClass'),REQ
      #PROMPT('Resizer:',@S80),%ResizerType,DEFAULT('WindowResizeClass'),REQ
      #BUTTON('&Configure'),AT(100,,90),HLP('~TPLApplication_Classes_General_Configure2')
        #BOXED('Resizer Default Behaviour')
          #PROMPT(' Automatically find &Parent Controls? ',CHECK),%ResizerDeFaultFindParents,DEFAULT(%True),AT(35)
          #PROMPT(' Optimize &Moves? ',CHECK),%ResizerDefaultOptimizeMoves,DEFAULT(%True),AT(35)
          #PROMPT(' Optimize &Redraws? ',CHECK),%ResizerDefaultOptimizeRedraws,DEFAULT(%True),AT(35)
        #ENDBOXED
      #ENDBUTTON
      #PROMPT('Ini Manager:',@S80),%INIClass,DEFAULT('INIClass'),REQ
      #PROMPT('Run-Time Translator:',@S90),%RunTimeTranslatorType,DEFAULT('TranslatorClass'),REQ
      #BUTTON('&Configure'),AT(100,,90),HLP('~TPLApplication_Classes_General_Configure3')
        #ENABLE(%EnableRuntimeTranslator)
          #BOXED('Translator Text Extraction Options')
            #PROMPT('Extract &Filename:',SAVEDIALOG('Choose Extraction File','All Files|*.*')),%ExtractionFilename
          #ENDBOXED
        #ENDENABLE
      #ENDBUTTON
    #ENDBUTTON
    #BUTTON('&File Management'),HLP('~TPLApplication_Classes_File')
      #PROMPT('File Manager:',@S80),%FileManagerType,DEFAULT('FileManager'),REQ
      #PROMPT('View Manager:',@S80),%ViewManagerType,DEFAULT('ViewManager'),REQ
      #PROMPT('Relation Manager:',@S80),%RelationManagerType,DEFAULT('RelationManager'),REQ
    #ENDBUTTON
    #BUTTON('&Browser'),HLP('~TPLApplication_Classes_Browser')
      #PROMPT('Browser:',@S80),%BrowserType,DEFAULT('BrowseClass'),REQ
      #BUTTON('&Configure'),AT(100,,90),HLP('~TPLApplication_Classes_Browser_Configure')
        #BOXED('Database Optimizations')
          #PROMPT('&Active Invisible',CHECK),%ActiveInvisible,DEFAULT(%False)
          #PROMPT('Allow &Unfilled',CHECK),%AllowUnfilled,DEFAULT(%False)
          #PROMPT('&Retain Row',CHECK),%RetainRow,DEFAULT(%True)
          #BOXED('Restore Defaults')
            #BUTTON('&ISAM'),AT(10,,50),WHENACCEPTED(%BRWISAMDefaults())
            #ENDBUTTON
            #BUTTON('&SQL'),AT(68,,50),WHENACCEPTED(%BRWSQLDefaults())
            #ENDBUTTON
            #BUTTON('Sys&tem'),AT(126,,50),WHENACCEPTED(%BRWSystemDefaults())
            #ENDBUTTON
          #ENDBOXED
        #ENDBOXED
      #ENDBUTTON
      #PROMPT('&Edit-in-Place Class',@S80),%EditInPlaceType,DEFAULT('EditClass'),REQ
      #BOXED('Step Managers')
        #PROMPT('Abstract Step Base Class:',@S80),%StepManagerType,DEFAULT('StepClass'),REQ
        #PROMPT('Long:',@S80),%StepManagerLongType,DEFAULT('StepLongClass'),REQ
        #PROMPT('Real:',@S80),%StepManagerRealType,DEFAULT('StepRealClass'),REQ
        #PROMPT('String:',@S80),%StepManagerStringType,DEFAULT('StepStringClass'),REQ
        #PROMPT('Custom:',@S80),%StepManagerCustomType,DEFAULT('StepCustomClass'),REQ
      #ENDBOXED
      #BOXED('Locator Managers')
        #PROMPT('&Step:',@S80),%StepLocatorType,DEFAULT('StepLocatorClass'),REQ
        #PROMPT('&Entry:',@S80),%EntryLocatorType,DEFAULT('EntryLocatorClass'),REQ
        #PROMPT('&Incremental:',@S80),%IncrementalLocatorType,DEFAULT('IncrementalLocatorClass'),REQ
        #PROMPT('&Filtered:',@S80),%FilteredLocatorType,DEFAULT('FilterLocatorClass'),REQ
      #ENDBOXED
      #PROMPT('File Loaded Drop Mgr:',@S80),%FileDropManagerType,DEFAULT('FileDropClass'),REQ
      #PROMPT('File Loaded Combo Mgr:',@S80),%FileDropComboManagerType,DEFAULT('FileDropComboClass'),REQ
    #ENDBUTTON
    #BUTTON('&Process && Reports'),HLP('~TPLApplication_Classes_Process')
      #PROMPT('Process:',@S80),%ProcessType,DEFAULT('ProcessClass'),REQ
      #PROMPT('Print Previewer:',@S80),%PrintPreviewType,DEFAULT('PrintPreviewClass'),REQ
      #PROMPT('Report Manager:',@S80),%ReportManagerType,DEFAULT('ReportManager'),REQ
    #ENDBUTTON
    #BUTTON('&Ascii Viewer'),HLP('~TPLApplication_Classes_Ascii')
      #PROMPT('Ascii Viewer:',@S80),%AsciiViewerClass,DEFAULT('AsciiViewerClass'),REQ
      #PROMPT('Ascii Searcher:',@S80),%AsciiSearchClass,DEFAULT('AsciiSearchClass'),REQ
      #PROMPT('Ascii Printer:',@S80),%AsciiPrintClass,DEFAULT('AsciiPrintClass'),REQ
      #PROMPT('ASCII File Manager:',@S80),%AsciiFileManagerType,DEFAULT('AsciiFileClass'),REQ
    #ENDBUTTON
    #BUTTON('&Toolbar Managers'),HLP('~TPLApplication_Classes_Toolbar')
      #PROMPT('Toolbar Manager:',@S80),%ToolbarClass,DEFAULT('ToolbarClass'),REQ
      #PROMPT('Toolbar List Box Manager:',@S80),%ToolbarListBoxType,DEFAULT('ToolbarListboxClass'),REQ
      #PROMPT('Toolbar Relation Tree Manger:',@S80),%ToolbarRelTreeType,DEFAULT('ToolbarReltreeClass'),REQ
      #PROMPT('Toolbar Update Manager:',@S80),%ToolbarUpdateClassType,DEFAULT('ToolbarUpdateClass'),REQ
    #ENDBUTTON
  #ENDTAB
#ENDSHEET
#!------------------------------------------------------------------------------
#!
#! Global Template Declarations.
#!
#!------------------------------------------------------------------------------
#!
#MESSAGE('Generating ' & %Application,0)          #! Open the Message Box
#EQUATE(%CWTemplateVersion,'v4b')
#DECLARE(%IsExternal,LONG)                        #! Flag to determin if item is external
#DECLARE(%SaveCreateLocalMap),SAVE                #! Last Local Map status
#DECLARE(%GlobalIncludeList),UNIQUE               #! List of global include statements
#DECLARE(%ModuleIncludeList),UNIQUE               #! List of module include statements
#DECLARE(%CalloutModules),UNIQUE
#DECLARE(%ClassDeclarations),MULTI                #! List of module class declaration code statements
#DECLARE(%OOPConstruct)                           #! Used to construct OOP & general purpose declaration statements
#DECLARE(%ByteCount,LONG)                         #! Used to test for filled EMBED points
#DECLARE(%IncludePrototype,LONG)                  #! Used to test for prototype requirements in class declarations
#DECLARE(%UsedFile),UNIQUE                        #! Label of every file used
#DECLARE(%ProcFilesUsed),UNIQUE                   #! Label of every file used
#DECLARE(%UsedDriverDLLs),UNIQUE
#DECLARE(%PrintPreviewUsed)
#DECLARE(%FileExternalFlag)
#DECLARE(%FileThreadedFlag)
#DECLARE(%IniFileName)                            #! Used to construct INI file
#DECLARE(%GenerationCompleted,%Module),SAVE
#DECLARE(%GenerateModule)
#DECLARE(%VBXList),UNIQUE
#DECLARE(%OLENeeded)
#DECLARE(%OCXList),UNIQUE
#DECLARE(%LastTarget32),SAVE
#DECLARE(%LastProgramExtension),SAVE
#DECLARE(%LastApplicationDebug),SAVE
#DECLARE(%LastApplicationLocalLibrary),SAVE
#!
#DECLARE(%CustomGlobalMapModule),UNIQUE
#DECLARE(%CustomGlobalMapProcedure,%CustomGlobalMapModule),MULTI
#DECLARE(%CustomGlobalMapProcedurePrototype,%CustomGlobalMapProcedure)
#DECLARE(%CustomGlobalData),UNIQUE
#DECLARE(%CustomGlobalDataDeclaration,%CustomGlobalData)
#DECLARE(%CustomGlobalDataBeforeFiles,%CustomGlobalData)
#DECLARE(%CustomGlobalDataComponent,%CustomGlobalData),MULTI
#DECLARE(%CustomGlobalDataComponentIndent,%CustomGlobalDataComponent)
#DECLARE(%CustomGlobalDataComponentDeclaration,%CustomGlobalDataComponent)
#!
#DECLARE(%CustomModuleMapModule),UNIQUE
#DECLARE(%CustomModuleMapProcedure,%CustomModuleMapModule),MULTI
#DECLARE(%CustomModuleMapProcedurePrototype,%CustomModuleMapProcedure)
#DECLARE(%CustomModuleData),UNIQUE
#DECLARE(%CustomModuleDataDeclaration,%CustomModuleData)
#DECLARE(%CustomModuleDataComponent,%CustomModuleData),MULTI
#DECLARE(%CustomModuleDataComponentIndent,%CustomModuleDataComponent)
#DECLARE(%CustomModuleDataComponentDeclaration,%CustomModuleDataComponent)
#DECLARE(%CustomGlobalMapIncludes),UNIQUE
#DECLARE(%CustomGlobalDeclarationIncludes),UNIQUE
#!
#DECLARE(%CustomFlags),UNIQUE                     #! Allows third party developers to create
#DECLARE(%CustomFlagSetting,%CustomFlags)         #! Their own "symbols"
#!
#DECLARE(%AccessMode)                             #! File open mode equate
#DECLARE(%BuildFile)                              #! Construction filenames
#DECLARE(%BuildHeader)
#DECLARE(%BuildInclude)
#DECLARE(%ExportFile)                             #! File for Export list
#DECLARE(%ValueConstruct)                         #! Construct various strings
#DECLARE(%HoldConstruct)                          #! Construct various strings
#DECLARE(%RegenerateGlobalModule)                 #! Will we regen the global module?
#DECLARE(%ClipName)
#DECLARE(%UpdateRelationPrimary),UNIQUE
#DECLARE(%UpdateRelationSecondary,%UpdateRelationPrimary),UNIQUE
#DECLARE(%UpdateAttachedFile,%UsedFile),UNIQUE
#DECLARE(%DeleteRelationPrimary),UNIQUE
#DECLARE(%DeleteRelationSecondary,%DeleteRelationPrimary),UNIQUE
#DECLARE(%DeleteAttachedFile,%UsedFile),UNIQUE
#DECLARE(%AllFile),UNIQUE
#DECLARE(%BRWList),UNIQUE
#DECLARE(%GlobalRegenerate)                       #! Flag that controls generation
#EQUATE(%FilesPerBCModule,20)                     #! No of file definitions per BC module
#EQUATE(%RelatesPerRoutine,10)                    #! No of AddRelation/AddRelationLink calls per routine in bc module(s)
#!
#!
#!
#COMMENT(55)                                      #!Set comment alignment to column 55
#!
#!
#!------------------------------------------------------------------------------
#!
#! Initialization Code for Global User-defined Symbols.
#!
#!------------------------------------------------------------------------------
#!
#EMBED(%BeforeGenerateApplication),HIDE
#!
#IF(%INIFile = 'Program Name.INI')                #! IF using program.ini
  #SET(%INIFileName,%Application & '.INI')        #! SET the file name
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
#!
#!  Global Regenerate Test
#!
#IF(~%ConditionalGenerate OR %DictionaryChanged OR %RegistryChanged OR %SaveCreateLocalMap NOT=%CreateLocalMap OR %LastTarget32 NOT=%Target32 OR %LastProgramExtension NOT=%ProgramExtension OR %LastApplicationLocalLibrary NOT=%ApplicationLocalLibrary OR %LastApplicationDebug NOT=%ApplicationDebug OR ~FILEEXISTS(%Program))
  #SET(%GlobalRegenerate,%True)
  #SET(%LastTarget32,%Target32)
  #SET(%LastProgramExtension,%ProgramExtension)
  #SET(%LastApplicationLocalLibrary,%ApplicationLocalLibrary)
  #SET(%LastApplicationDebug,%ApplicationDebug)
  #SET(%SaveCreateLocalMap,%CreateLocalMap)
#ELSE
  #SET(%GlobalRegenerate,%False)
#ENDIF
#!
#!
#CALL(%ReadABCFiles)
#ADD(%GlobalIncludeList,'EQUATES.CLW')
#ADD(%GlobalIncludeList,'ERRORS.CLW')
#ADD(%GlobalIncludeList,'KEYCODES.CLW')
#CALL(%AddModuleIncludeFile,%FileManagerType,1)
#CALL(%AddModuleIncludeFile,%ErrorManagerType,1)
#CALL(%AddModuleIncludeFile,%INIClass,1)
#CALL(%AddModuleIncludeFile,%WindowManagerType,1)
#!
#!
#IF(%EnableRunTimeTranslator)
  #CALL(%AddModuleIncludeFile,%RunTimeTranslatorType,1)
  #FIX(%Driver,'ASCII')                           #!ASCII driver required when translator switched on
  #IF(%Driver NOT='ASCII')
    #ERROR('Ascii file driver MUST be registered for Translator')
    #ABORT
  #END
  #PROJECT(%DriverLIB)
#ENDIF
#IF(ITEMS(%File))
  #CALL(%AddModuleIncludeFile,%FileManagerType,1)
  #CALL(%AddModuleIncludeFile,%ViewManagerType,1)
  #CALL(%AddModuleIncludeFile,%RelationManagerType,1)
#ENDIF
#IF(~%GlobalExternal)
  #IF(%ProgramExtension='DLL')                    #!Include all TopSpeed's base classes in non-external DLL
    #FIX(%Driver,'ASCII')                         #!Required for ASCIIViewer etc...
    #PROJECT(%DriverLib)
    #FOR(%pClassName)
      #ADD(%GlobalIncludeList,%RemovePath(%pClassIncFile))
    #ENDFOR
  #ENDIF
#ENDIF
#!
#!
#IF(%GlobalRegenerate)
  #FOR(%Module)
    #SET(%GenerationCompleted,%False)
  #ENDFOR
#ENDIF                                            #! END (IF Global Change)
#!
#SET(%BuildFile,UPPER(%Application&'.B1$'))
#SET(%BuildHeader,UPPER(%Application&'.H1$'))
#SET(%BuildInclude,UPPER(%Application&'.I1$'))
#IF (%EditProcedure)                              #! Special case for editing embedded source in context
  #CREATE(%EditFilename)
  #FIND(%ModuleProcedure,%EditProcedure)
  #FIX(%Procedure,%ModuleProcedure)           #! Fix current procedure
  #MESSAGE('Generating Module:    ' & %Module,1) #! Post generation message
  #MESSAGE('Generating Procedure: ' & %Procedure,2) #! Post generation message
  #GENERATE(%Procedure)                       #! Generate procedure code
  #CLOSE
  #ABORT
#ENDIF
#FOR(%Module),WHERE (%Module <> %Program)        #! For all member modules
  #MESSAGE('Generating Module:    '&UPPER(%Module),1) #! Post generation message
  #IF(%GlobalRegenerate OR %ModuleChanged OR ~%GenerationCompleted OR ~FILEEXISTS(%Module))
    #SET(%GenerateModule,%True)
  #ELSE
    #SET(%GenerateModule,%False)
  #ENDIF
  #IF(%GenerateModule)                            #! IF module to be generated
    #GENERATE(%Module)
  #ENDIF                                          #! END (If module to be...)
#ENDFOR                                           #! END (For all member modules)
#FIX(%Module,%Program)                            #! FIX to program module
#MESSAGE('Generating Module:    ' & %Module,1)   #! Post generation message
#IF(%GlobalRegenerate OR %RegenerateGlobalModule OR %ModuleChanged OR ~%GenerationCompleted OR ~FILEEXISTS(%Module))
  #SET(%GenerateModule,%True)
#ELSE
  #SET(%GenerateModule,%False)
#ENDIF
#FREE(%UsedDriverDLLs)
#EMBED(%CustomGlobalDeclarations,'Compile Global Declarations'),HIDE
#FOR(%File)
  #IF(%DefaultGenerate OR %OverrideGenerate OR %DefaultExport OR %OverrideExport)
    #ADD(%UsedFile,%File)
  #ENDIF
#ENDFOR
#!
#!Ensure that Aliased files are included in %UsedFile to force generation of aliased file
#!
#FOR(%File),WHERE(%AliasFile AND INLIST(%File,%UsedFile))
  #ADD(%UsedFile,%AliasFile)
#ENDFOR
#FOR(%UsedFile)
  #FIX(%File,%UsedFile)
  #FOR(%Field),WHERE(%FieldLookup)
    #ADD(%UsedFile,%FieldLookup)
  #ENDFOR
#ENDFOR
#IF(%GenerateModule)
  #SET(%GenerationCompleted,%False)
  #CREATE(%BuildFile)                             #! Create temp module file
  #MESSAGE('Generating Program Code',2)           #! Post generation message
  #GENERATE(%Program)
  #FOR(%ModuleProcedure)                          #! For all procs in module
    #FIX(%Procedure,%ModuleProcedure)             #! Fix current procedure
    #MESSAGE('Generating Procedure: ' & %Procedure,2) #! Post generation message
    #GENERATE(%Procedure)                         #! Generate procedure code
  #ENDFOR                                         #! EndFor all procs in module
  #CLOSE()                                        #! Close last temp file
  #REPLACE(%Program,%BuildFile)                   #! Replace if changed
  #!INSERT(%WriteBaseMethods)
  #FOR(%UsedFile)                                   #! FOR all files used
    #FIX(%File,%UsedFile)                           #! FIX to that file
    #FIX(%Driver,%FileDriver)                       #! FIX to file's driver
    #ADD(%UsedDriverDLLs,%DriverDLL)
    #IF(~%GlobalExternal)
      #PROJECT(%DriverLIB)                          #! ADD driver LIB to project
    #ENDIF
  #ENDFOR                                           #! END (FOR all files used)
  #INSERT(%ConstructShipList)
#ELSE
  #FOR(%UsedFile)                                   #! FOR all files used
    #FIX(%File,%UsedFile)                           #! FIX to that file
    #FIX(%Driver,%FileDriver)                       #! FIX to file's driver
    #ADD(%UsedDriverDLLs,%DriverDLL)
    #IF(~%GlobalExternal)
      #PROJECT(%DriverLIB)                          #! ADD driver LIB to project
    #ENDIF
  #ENDFOR                                           #! END (FOR all files used)
#ENDIF
#REMOVE(%BuildFile)                               #! Remove the temp file
#!
#IF(~%GlobalExternal)
  #DECLARE (%BCProjectCount)
  #LOOP,FOR(%BCProjectCount,1,%BCModulesNeeded())
    #PROJECT(%MakeBCFilename(%BCProjectCount))
  #ENDLOOP
  #PROJECT(%MakeMainBCFilename())
#ENDIF
#!
#INSERT(%ConstructExportFile)
#!
#SET(%GenerationCompleted,%True)
#!
#!------------------------------------------------------------------------------
#!
#! End of CW #APPLICATION Template
#!
#!------------------------------------------------------------------------------
#!
#!
#PROCEDURE(External,'External Procedure','External'),HLP('~TPLProcExternal')
#AT(%CustomGlobalDeclarations)
  #INSERT(%FileControlSetFlags)
#ENDAT
#!
#!
#INCLUDE('ABWINDOW.TPW')                          #! G/P window handler
#INCLUDE('ABASCII.TPW')                           #! Ascii Viewer Code/Extension/Procedure
#INCLUDE('ABBLDEXP.TPW')
#INCLUDE('ABBLDSHP.TPW')
#INCLUDE('ABBROWSE.TPW')                          #! Browse template(s)
#INCLUDE('ABCODE.TPW')                            #! Code Templates
#INCLUDE('ABCONTRL.TPW')                          #! Control Templates
#INCLUDE('ABDROPS.TPW')                           #! File loaded Drop List and Drop Combo box comtols
#INCLUDE('ABFILE.TPW')                            #! Generates the File/Relation Manager BC module
#INCLUDE('ABGROUP.TPW')                           #! Generic groups used by OOP extensions
#INCLUDE('ABMODULE.TPW')
#INCLUDE('ABPROCS.TPW')                           #! Clarion procedures that are not based on an ABC class
#INCLUDE('ABPOPUP.TPW')                           #! Popup manager templates
#INCLUDE('ABOLE.TPW')
#INCLUDE('ABPROGRM.TPW')                          #! The CW program template
#INCLUDE('ABRELTRE.TPW')
#INCLUDE('ABREPORT.TPW')                          #! Record reporting proc
#INCLUDE('ABUPDATE.TPW')                          #! Update form
#!
#!
#GROUP(%MakeModuleIncludeFile),PRESERVE              #!Makes an include file for the current %module
#MESSAGE('Local Maps: Generating Include File: '&UPPER(%ModuleBase)&'.INC',2)
#MESSAGE('',3)
#CREATE(%BuildInclude)
  MODULE('%(UPPER(%Module))')
#FOR(%ModuleProcedure)
  #FIX(%Procedure,%ModuleProcedure)
  #IF(%ProgramExtension='DLL')
    #IF(~%ProcedureExported AND %Procedure NOT=%FirstProcedure)
      #INSERT(%MakeDeclr,24,%OOPConstruct,%Procedure,%ProcedureType&%prototype)
      #IF(%ProcedureDescription)
        #INSERT(%Makedeclr,55,%OOPConstruct,%OOPConstruct,'!DLL local procedure - '&%ProcedureDescription)
      #ENDIF
%OOPConstruct
    #ENDIF
  #ELSE
    #IF(~(%ProcedureIsGlobal OR %Procedure=%FirstProcedure))
      #INSERT(%MakeDeclr,24,%OOPConstruct,%Procedure,%ProcedureType&%Prototype)
      #IF(%ProcedureDescription)
        #INSERT(%Makedeclr,55,%OOPConstruct,%OOPConstruct,'!'&%ProcedureDescription)
      #ENDIF
%OOPConstruct
    #ENDIF
  #ENDIF
#ENDFOR
  END
#CLOSE(%BuildInclude)
#REPLACE(UPPER(%ModuleBase)&'.INC',%BuildInclude)
#REMOVE(%BuildInclude)
#!
#GROUP(%ForceReadABCFiles)
#PURGE(%pClassName)
#PURGE(%pClassIncFile)
#PURGE(%pClassMethod)
#PURGE(%pClassMethodPrototype)
#PURGE(%pClassMethodPrivate)
#PURGE(%pClassMethodVirtual)
#PURGE(%pClassMethodProtected)
#PURGE(%pClassMethodProcAttribute)
#PURGE(%pClassMethodInherited)
#PURGE(%pClassProperty)
#PURGE(%pClassPropertyPrototype)
#PURGE(%pClassPropertyPrivate)
#PURGE(%pClassPropertyProtected)
#PURGE(%pClassPropertyInherited)
#PURGE(%ClassMethodList)
#SERVICE('C4TPLSRV.DLL','GenReadABCFiles')
#!
#GROUP(%ReadABCFiles)
#IF(~ITEMS(%pClassName))
  #CALL(%ForceReadABCFiles)
  #SET(%SysActiveInvisible,%False)                  #!Setup system default values
  #SET(%SysAllowUnfilled,%False)
  #SET(%SysRetainRow,%True)
  #SET(%SysResetOnGainFocus,%False)
  #SET(%SysAutoToolbar,%True)
  #SET(%SysAutoRefresh,%True)
#ENDIF
#!
#GROUP(%ViewABCs)
#SERVICE('C4TPLSRV.DLL','GenViewABCClasses')
#!
#!
