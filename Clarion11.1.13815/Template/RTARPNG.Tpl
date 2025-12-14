#TEMPLATE(SVReportToPNGSupport, 'Report To PNG Support'),FAMILY('ABC','CW20')
#HELP('ClarionHelp.chm')
#!
#EXTENSION(SVReportToPNGGlobal, 'Report to PNG - Global'),APPLICATION(SVReportToPNG(SVReportToPNGSupport)),HLP('~TPLExtensionGlobalReportToPNG.htm')
#DISPLAY
#DISPLAY(' Report to PNG'),AT(3,,187), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
#DISPLAY
#DISPLAY('This template has added an extension to each report.')
#DISPLAY('Settings are modified at the procedure level.')
#PREPARE
    #CALL(%SetTargetGlobalPrompt,'PNG','PNGReporter','PNGReportGenerator')
#ENDPREPARE
#INSERT(%TargetGlobalPrompts)
#ENABLE(NOT %GlobalDisable AND %GlobalUseABCClasess)
  #!BUTTON('PNG Global Image Resolution'),AT(10,,175),HLP('~TPLExtensionGlobalReportToPNGImageResolution.htm')
     #PROMPT('PNG Image Resolution:',DROP('Original|Draft|Normal|Good|Detail')),%PNGImageResGlobal,DEFAULT('Original')
     #BOXED,SECTION
        #BOXED,WHERE(%PNGImageResGlobal='Original'),AT(0,0)
            #DISPLAY('Use the original printer resolution to create the PNG')
        #ENDBOXED
        #BOXED,WHERE(%PNGImageResGlobal='Draft'),AT(0,0)
            #DISPLAY('Use a low resolution to create the PNG fast (small PNG)')
        #ENDBOXED
        #BOXED,WHERE(%PNGImageResGlobal='Normal'),AT(0,0)
            #DISPLAY('Most text and images will look good (big PNG)')
        #ENDBOXED
        #BOXED,WHERE(%PNGImageResGlobal='Good'),AT(0,0)
            #DISPLAY('Special fonts like barcode will look good in PNG (large PNG)')
        #ENDBOXED
        #BOXED,WHERE(%PNGImageResGlobal='Detail'),AT(0,0)
            #DISPLAY('Vector images will look good in PNG (extra large PNG, slow)')
        #ENDBOXED
     #ENDBOXED
  #!ENDBUTTON
#ENDENABLE
#!
#EXTENSION(SVReportToPNG,'Report to PNG'),PROCEDURE,REQ(SVReportToPNGGlobal),HLP('~TPLExtensionLocalReportToPNG.htm')
#RESTRICT
  #IF(UPPER(%ProcedureTemplate)='REPORT')
    #ACCEPT
  #ELSE
    #REJECT
  #ENDIF
#ENDRESTRICT
#PREPARE
  #CALL(%ReadABCFiles)
  #CALL(%SetClassDefaults, %lTargetObjectName,%lTargetObjectName,%lTargetObjectClass)
#ENDPREPARE
  #BOXED,HIDE
    #INSERT(%OOPHiddenPrompts)
  #ENDBOXED
  #DISPLAY(' Report to PNG'),AT(3,,190), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
  #BOXED,SECTION
     #BOXED,WHERE(%GlobalDisable OR NOT %GlobalUseABCClasess),AT(0,0)
       #DISPLAY('This option has been disabled at the global')
       #DISPLAY('level and is not available.')
     #ENDBOXED
     #BOXED,WHERE(NOT %GlobalDisable AND NOT %EnablePrintPreview AND %GlobalUseABCClasess),AT(0,0)
       #DISPLAY('This option has been disabled because the')
       #DISPLAY('report require the preview on.')
     #ENDBOXED
     #BOXED,WHERE(NOT %GlobalDisable AND %EnablePrintPreview AND %GlobalUseABCClasess),AT(0,0)
       #PROMPT('Populate on Report',DROP('Always|Conditional|Never')),%Populate,DEFAULT('Always')
       #BOXED,SECTION
         #BOXED,WHERE(%Populate='Never' AND NOT %GlobalDisable AND %GlobalUseABCClasess),AT(0,0)
           #DISPLAY('This option will not be available for this report.')
         #ENDBOXED
         #BOXED,WHERE(%Populate<>'Never' AND NOT %GlobalDisable AND %GlobalUseABCClasess),AT(0,0)
           #ENABLE(%Populate='Conditional')
             #PROMPT('Condition:',EDIT),%PopulateCondition,WHENACCEPTED(%SVExpresionEditor(%PopulateCondition))
           #ENDENABLE
         #ENDBOXED
       #ENDBOXED
       #BOXED,WHERE(%Populate<>'Never')
         #SHEET
           #TAB('General'),HLP('~TPLExtensionLocalReportToPNGGeneral.htm')
             #PREPARE
               #IF(NOT %PNGOverrideGlobalImageResolution)
                 #CALL(%ResetImageResolutionFromGlobal)
               #ENDIF
             #ENDPREPARE
             #PROMPT('Output Name Type:',DROP('Fixed[Fixed]|Variable[Variable]|Runtime[Runtime]')),%OutputNameType,DEFAULT('Runtime')
             #BOXED,SECTION
               #BOXED,WHERE(%OutputNameType='Fixed'),AT(0,0)
                 #PROMPT('File Name:',OPENDIALOG('Pick File','All|*.*')),%OutputNameFixed
               #ENDBOXED
               #BOXED,WHERE(%OutputNameType='Variable'),AT(0,0)
                 #PROMPT('File Name:',EXPR),%OutputNameVariable,REQ
               #ENDBOXED
               #BOXED,WHERE(%OutputNameType='Runtime'),AT(0,0)
                 #DISPLAY('The User will be prompted at runtime.')
               #ENDBOXED
             #ENDBOXED
             #DISPLAY('Each file will be named as selected with the')
             #DISPLAY('page number added; e.g.')
             #DISPLAY('"SAVEnnn.PNG", where "nnn" is the page number.')
             #BOXED('PNG Options')
               #PROMPT('Override global image resolution?',CHECK),%PNGOverrideGlobalImageResolution,DEFAULT(%False),AT(10)
               #ENABLE(%PNGOverrideGlobalImageResolution)
						     #PROMPT('PNG Image Resolution:',DROP('Original|Draft|Normal|Good|Detail')),%PNGImageRes,DEFAULT('Original')
						     #BOXED,SECTION
						        #BOXED,WHERE(%PNGImageRes='Original'),AT(0,0)
						            #DISPLAY('Use the original printer resolution to create the PNG')
						        #ENDBOXED
						        #BOXED,WHERE(%PNGImageRes='Draft'),AT(0,0)
						            #DISPLAY('Use a low resolution to create the PNG fast (small PNG)')
						        #ENDBOXED
						        #BOXED,WHERE(%PNGImageRes='Normal'),AT(0,0)
						            #DISPLAY('Most text and images will look good (big PNG)')
						        #ENDBOXED
						        #BOXED,WHERE(%PNGImageRes='Good'),AT(0,0)
						            #DISPLAY('Special fonts like barcode will look good in PNG (large PNG)')
						        #ENDBOXED
						        #BOXED,WHERE(%PNGImageRes='Detail'),AT(0,0)
						            #DISPLAY('Vector images will look good in PNG (extra large PNG, slow)')
						        #ENDBOXED
						     #ENDBOXED
               #ENDENABLE
             #ENDBOXED
           #ENDTAB
           #TAB('Controls'),HLP('~TPLExtensionLocalReportToPNGControls.htm')
             #BUTTON('Control''s PNG Properties'),FROM(%ReportControl,%GetTagDisplay()),INLINE,HLP('~TPLExtensionLocalReportToPNGControlsProperties.htm')
               #DISPLAY(' Control: '&%ReportControl),AT(3,,190), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
               #BOXED('')
                 #BOXED,SECTION
                   #BOXED,WHERE(%True),AT(0,0)
                     #PROMPT('HIDE (Omit printing)',CHECK),%PNGHideControl,DEFAULT(%False),AT(10)
                   #ENDBOXED
                 #ENDBOXED
               #ENDBOXED
             #ENDBUTTON
           #ENDTAB
           #INSERT(%TargetClassTab)
         #ENDSHEET
       #ENDBOXED
     #ENDBOXED
  #ENDBOXED
#!
#!
#!
#ATSTART
 #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
    #FOR(%ReportControl),WHERE(%PNGHideControl)
        #CALL(%AddHidenControlToReport,'PNG',%ReportControl)
    #ENDFOR
    #CALL(%SetClassDefaults,%lTargetObjectName,%lTargetObjectName,%lTargetObjectClass)
    #IF(%Populate='Conditional')
       #CALL(%AddTargetToReport,%lTargetName,%lTargetObjectName,%lTargetObjectClass,%PopulateCondition)
    #ELSE
       #CALL(%AddTargetToReport,%lTargetName,%lTargetObjectName,%lTargetObjectClass,'')
    #ENDIF
 #ENDIF
#ENDAT
#AT(%GatherObjects)
#IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
    #CALL(%AddObjectList, %lTargetObjectName)
#ENDIF
#ENDAT
#AT(%LocalProcedures)
   #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
      #CALL(%GenerateVirtuals, %lTargetObjectName, 'Local Objects|Abc Objects|Report Target|'&%lTargetName, '%ReportTargetVirtuals(SVReportToPNGSupport)')
   #ENDIF
#ENDAT
#AT(%LocalDataClasses)
   #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
#INSERT(%GenerateClass, %lTargetObjectName, %lTargetName)
   #ENDIF
#ENDAT
#AT(%ReportTargetMethodCodeSection,%lTargetName),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
#IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
  #CALL(%GenerateParentCall)
#ENDIF
#ENDAT
#AT(%ReportTargetMethodCodeSection,'PNG','Setup','()'),PRIORITY(5500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
#CASE(%OutputNameType)
#OF('Fixed')
SELF.SetFileName(%(%SVStripPling(%OutputNameFixed)))
#OF('Variable')
SELF.SetFileName(%OutputNameVariable)
#OF('Runtime')
SELF.SetFileName('')
#ENDCASE
SELF.SetImageResolution(PNGImageResolution:%PNGImageRes)
#ENDAT
#!
#!
#GROUP(%GetTagDisplay),AUTO
#DECLARE(%lReturnValue)
#IF(%PNGHideControl)
   #SET(%lReturnValue,%ReportControl&' - HIDE')
#ELSE
   #SET(%lReturnValue,%ReportControl)
#ENDIF
#RETURN(%lReturnValue)
#!
#!
#!
#!
#GROUP(%ResetImageResolutionFromGlobal)
#SET(%PNGImageRes,%PNGImageResGlobal)
#!
#!
#!
#!
#INCLUDE('rtar_srv.TPW')
#!
