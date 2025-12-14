#TEMPLATE(SVReportToPDFSupport, 'Report To PDF Support'),FAMILY('ABC','CW20')
#HELP('ClarionHelp.chm')
#!
#EXTENSION(SVReportToPDFGlobal, 'Report to PDF - Global'),APPLICATION(SVReportToPDF(SVReportToPDFSupport)),HLP('~TPLExtensionGlobalReportToPDF.htm')
#DISPLAY
#DISPLAY(' Report to PDF'),AT(3,,187), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
#DISPLAY
#DISPLAY('This template has added an extension to each report.')
#DISPLAY('Settings are modified at the procedure level.')
#PROMPT('Default PDF Library to Use:',DROP('Clarion[CLARION]|Image 2 PDF[I2PDF]')),%GlobalDefaultPDFLibrary,DEFAULT('CLARION')
#PREPARE
    #IF(%GlobalDefaultPDFLibrary='CLARION')
      #CALL(%SetTargetGlobalPrompt,'PDF','PDFReporter','PDFReportGenerator')
    #ELSE
      #CALL(%SetTargetGlobalPrompt,'PDF','PDFReporter','I2PDFReportGenerator')
    #ENDIF
#ENDPREPARE
#INSERT(%TargetGlobalPrompts)
#!
#EXTENSION(SVReportToPDF,'Report to PDF'),PROCEDURE,REQ(SVReportToPDFGlobal),HLP('~TPLExtensionLocalReportToPDF.htm')
#RESTRICT
  #IF(UPPER(%ProcedureTemplate)='REPORT')
    #ACCEPT
  #ELSE
    #REJECT
  #ENDIF
#ENDRESTRICT
#PREPARE
  #CALL(%SetTargetLocalPromptFromGlobal)
  #CALL(%ReadABCFiles)
  #CALL(%SetClassDefaults, %TargetLocalObjectName,%TargetLocalObjectName,%TargetLocalObjectClass)
#ENDPREPARE
  #BOXED,HIDE
    #INSERT(%TargetLocalPrompts)
    #PROMPT('',CHECK),%UseImageToPDFLibrary,DEFAULT(%False)    
    #INSERT(%OOPHiddenPrompts)
  #ENDBOXED
  #DISPLAY(' Report to PDF'),AT(3,,190), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
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
           #TAB('General'),HLP('~TPLExtensionLocalReportToPDF.htm#General')
             #PROMPT('PDF Library to Use:',DROP('Global Setting[GLOBAL]|Clarion[CLARION]|Image 2 PDF[I2PDF]')),%LocalPDFLibrary,DEFAULT('GLOBAL'),WHENACCEPTED(%SetTargetLocalPromptFromGlobal())
               #BOXED,SECTION
                  #BOXED,WHERE(%LocalPDFLibrary<>'GLOBAL'),AT(0,0)
                     #BOXED,WHERE(%LocalPDFLibrary='CLARION'),AT(0,0)
                        #DISPLAY('[Using Clarion Library to generate the PDF.]'),AT(185)
                     #ENDBOXED
                     #BOXED,WHERE(%LocalPDFLibrary<>'CLARION'),AT(0,0)
                        #DISPLAY('[Using Image2PDF Library to generate the PDF.]'),AT(185)
                     #ENDBOXED
                  #ENDBOXED
                  #BOXED,WHERE(%LocalPDFLibrary='GLOBAL'),SECTION,AT(0,0)
                     #BOXED,WHERE(%GlobalDefaultPDFLibrary='CLARION'),AT(0,0)
                        #DISPLAY('[Using Clarion Library set at the global template.]'),AT(185)
                     #ENDBOXED
                     #BOXED,WHERE(%GlobalDefaultPDFLibrary<>'CLARION'),AT(0,0)
                        #DISPLAY('[Using Image2PDF Library set at the global template.]'),AT(185)
                     #ENDBOXED
                  #ENDBOXED
               #ENDBOXED
             #PROMPT('Output Name Type:',DROP('Fixed|Variable|Runtime')),%OutputNameType,DEFAULT('Runtime')
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
             #BOXED('PDF Options')
               #PROMPT('Document Title:',EXPR),%DocumentTitle,REQ,DEFAULT('CW Report')
               #PROMPT('Application Name:',EXPR),%ApplicationName,REQ,DEFAULT(%Application)
               #PROMPT('Program Name:',EXPR),%ProgramName,REQ,DEFAULT(%Procedure)
               #PROMPT('Subject:',EXPR),%PDFSubject,DEFAULT(%Procedure)
               #PROMPT('Author:',EXPR),%PDFAuthor,DEFAULT('')
               #PROMPT('Keywords:',EXPR),%PDFKeywords,DEFAULT('')              
               #PROMPT('Use Scan Copy Mode?',CHECK),%UseScanCopyMode,AT(10),DEFAULT(%False)
                  #BOXED,SECTION
                      #BOXED,WHERE(%UseScanCopyMode),AT(0,0)
                        #PROMPT('Scan Copy Resolution:',DROP('Original|Draft|Normal|Good|Detail')),%ScanCopyModeRes,DEFAULT('Original')
                        #BOXED,SECTION
                           #BOXED,WHERE(%ScanCopyModeRes='Original'),AT(0,0)
                               #DISPLAY('Use the original printer resolution to create the PDF')
                           #ENDBOXED
                           #BOXED,WHERE(%ScanCopyModeRes='Draft'),AT(0,0)
                               #DISPLAY('Use a low resolution to create the PDF fast (small PDF)')
                           #ENDBOXED
                           #BOXED,WHERE(%ScanCopyModeRes='Normal'),AT(0,0)
                               #DISPLAY('Most text and images will look good (big PDF)')
                           #ENDBOXED
                           #BOXED,WHERE(%ScanCopyModeRes='Good'),AT(0,0)
                               #DISPLAY('Special fonts like barcode will look good in PDF (large PDF)')
                           #ENDBOXED
                           #BOXED,WHERE(%ScanCopyModeRes='Detail'),AT(0,0)
                               #DISPLAY('Vector images will look good in PDF (extra large PDF, slow)')
                           #ENDBOXED
                        #ENDBOXED
                      #ENDBOXED
                      #BOXED,WHERE(NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary),AT(0,0)
                        #PROMPT('Compress Text?',CHECK),%CompressText,AT(10),DEFAULT(%True)
                        #PROMPT('Compress Images?',CHECK),%CompressImages,AT(10),DEFAULT(%True)
                      #ENDBOXED
                  #ENDBOXED
               #BOXED,WHERE(NOT %UseImageToPDFLibrary)
                  #PROMPT('Use Pages as Parent Bookmark?',CHECK),%PagesAsParentBookmark,AT(10),DEFAULT(%False)
               #ENDBOXED
               #BUTTON('Security')
                 #PROMPT('Encrypt Document',DROP('Always|Conditional|Never')),%Encryptdoc,DEFAULT('Never')
                 #ENABLE(%Encryptdoc='Conditional')
                   #PROMPT('Condition:',EDIT),%EncryptDocCondition,WHENACCEPTED(%SVExpresionEditor(%EncryptDocCondition))
                 #ENDENABLE
                 #ENABLE(%Encryptdoc<>'Never')
                   #PROMPT('Password:',EXPR),%PDFPassword,DEFAULT(''),REQ
                   #ENABLE(%PDFPassword)
                     #PROMPT('Use a variable to specify user access rights?',CHECK),%PDFUseVariableAccess,AT(10),DEFAULT(%False)
                     #ENABLE(%PDFUseVariableAccess)
                       #PROMPT('Expression:',EDIT(256)),%PDFVariableAccess,WHENACCEPTED(%SVExpresionEditor(%PDFVariableAccess))
                     #ENDENABLE
                     #ENABLE(NOT %PDFUseVariableAccess)
                       #PROMPT('Allow Printing',CHECK),%PDFAccessPrint,AT(10),DEFAULT(%True)
                       #PROMPT('Allow document contents to be modified',CHECK),%PDFAccessModifyContent,AT(10),DEFAULT(%True)
                       #PROMPT('Allow Copying of Text and Graphics',CHECK),%PDFAccessCopy,AT(10),DEFAULT(%True)
                       #PROMPT('Allow text annotations to be modified and entry',CHECK),%PDFAccessModifyAnnotations,AT(10),DEFAULT(%True)
                       #DISPLAY('of interactive form fields'),AT(22)
                     #ENDENABLE
                   #ENDENABLE
                 #ENDENABLE
               #ENDBUTTON
             #ENDBOXED
             #BOXED,HIDE
               #PROMPT('Temp PDF Instance:',@n5),%PDFTempControlInstance
               #PROMPT('Temp ReportControl:',FROM(%ReportControl)),%PDFTempReportControl
             #ENDBOXED
           #ENDTAB
           #TAB('Controls'),HLP('~TPLExtensionLocalReportToPDF.htm#Controls'),WHERE(NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
             #BUTTON('Control''s PDF Properties'),FROM(%ReportControl,%GetTagDisplay()),INLINE,WHERE(%PDFIsValidControl()),HLP('~TPLExtensionLocalReportToPDF.htm#Controls')
               #DISPLAY(' Control: '&%ReportControl),AT(3,,190), PROP(PROP:FontColor, 0FFFFFFH), PROP(PROP:Color,0808080H)
               #BOXED('')
                 #BOXED,SECTION
                   #BOXED,WHERE(%True),AT(0,0)
                     #PROMPT('HIDE (Omit printing) ',CHECK),%PDFHideControl,DEFAULT(%False),AT(10)
                     #PROMPT('SKIP (Omit processing) ',CHECK),%PDFSkipControl,DEFAULT(%False),AT(10)
                     #DISPLAY
                     #PROMPT('HIDE ON PDF (Omit show it on PDF) ',CHECK),%PDFHideControlOnPDF,DEFAULT(%False),AT(10)
                   #ENDBOXED
                   #BOXED,WHERE(%False),AT(0,0,0,0)
                     #PROMPT('Possible text Origin:',@s100),%PDFPossibleTextOrigin,DEFAULT('Control Text[Text]|HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #PROMPT('Possible Bookmark text Origin:',@s100),%PDFPossibleBookmarkTextOrigin,DEFAULT('Control Text[Text]|HardCoded[HardCoded]|Dynamic[Dynamic]')
                   #ENDBOXED
                 #ENDBOXED
                 #PREPARE
                   #CASE(%ReportControlType)
                   #OF('LINE')
                   #OROF('BOX')
                   #OROF('ELLIPSE')
                   #OROF('IMAGE')
                     #SET(%PDFPossibleTextOrigin,'HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #SET(%PDFPossibleBookmarkTextOrigin,'HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #IF(NOT %PDFBookmarkOrigin OR %PDFBookmarkOrigin='Text')
                       #SET(%PDFBookmarkOrigin,'HardCoded')
                     #ENDIF
                     #IF(NOT %PDFTargetOrigin OR %PDFTargetOrigin='Text')
                       #SET(%PDFTargetOrigin,'HardCoded')
                     #ENDIF
                     #IF(NOT %PDFAnnotationOrigin OR %PDFAnnotationOrigin='Text')
                       #SET(%PDFAnnotationOrigin,'HardCoded')
                     #ENDIF
                   #OF('TEXT')
                     #SET(%PDFPossibleBookmarkTextOrigin,'HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #SET(%PDFPossibleTextOrigin,'Control Text[Text]|HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #IF(NOT %PDFBookmarkOrigin OR %PDFBookmarkOrigin='Text')
                       #SET(%PDFBookmarkOrigin,'HardCoded')
                     #ENDIF
                     #IF(NOT %PDFTargetOrigin)
                       #SET(%PDFTargetOrigin,'Text')
                     #ENDIF
                     #IF(NOT %PDFAnnotationOrigin)
                       #SET(%PDFAnnotationOrigin,'Text')
                     #ENDIF
                   #ELSE
                     #SET(%PDFPossibleBookmarkTextOrigin,'Control Text[Text]|HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #SET(%PDFPossibleTextOrigin,'Control Text[Text]|HardCoded[HardCoded]|Dynamic[Dynamic]')
                     #IF(NOT %PDFBookmarkOrigin)
                       #SET(%PDFBookmarkOrigin,'Text')
                     #ENDIF
                     #IF(NOT %PDFTargetOrigin)
                       #SET(%PDFTargetOrigin,'Text')
                     #ENDIF
                     #IF(NOT %PDFAnnotationOrigin)
                       #SET(%PDFAnnotationOrigin,'Text')
                     #ENDIF
                   #ENDCASE
                 #ENDPREPARE
                 #ENABLE(NOT %PDFSkipControl)
                   #PROMPT('Add Field Action',CHECK),%PDFFieldAction,DEFAULT(%False),AT(10)
                   #BOXED('')
                     #ENABLE(%PDFFieldAction)
                       #PROMPT('Field Action:',DROP('Hyperlink|Command Line[CommandLine]|Annotation|Page Action[PageAction]')),%PDFFieldActionType,DEFAULT('Hyperlink')
                       #BOXED,SECTION
                         #BOXED,WHERE(%PDFFieldActionType='Annotation'),AT(0,0)
                           #PROMPT('Annotation text Origin:',DROP(%PDFPossibleTextOrigin)),%PDFAnnotationOrigin
                           #BOXED,SECTION
                             #BOXED,WHERE(%PDFAnnotationOrigin='Text'),AT(0,0)
                               #DISPLAY('The Target will be the text displayed on the report')
                             #ENDBOXED
                             #BOXED,WHERE(%PDFAnnotationOrigin='HardCoded'),AT(0,0)
                               #PROMPT('Target:',EXPR),%PDFAnnotationHardCoded
                             #ENDBOXED
                             #BOXED,WHERE(%PDFAnnotationOrigin='Dynamic'),AT(0,0)
                               #PROMPT('Target:',EXPR),%PDFAnnotationDynamic
                             #ENDBOXED
                           #ENDBOXED
                         #ENDBOXED
                        #BOXED,WHERE(%PDFFieldActionType='PageAction'),AT(0,0)
                          #PROMPT('Action:',DROP('FIRST|PREV|NEXT|LAST|BACK|FORWARD')),%PDFPageAction,DEFAULT('NEXT')
                        #ENDBOXED
                        #BOXED,WHERE(%PDFFieldActionType='CommandLine'),AT(0,0)
                          #PROMPT('Command:',EXPR),%PDFTargetCommand,REQ,DEFAULT('notepad.exe')
                          #PROMPT('Parameters:',EXPR),%PDFTargetParameters,DEFAULT('note.txt')
                          #DISPLAY('Example: command space parameters')
                          #DISPLAY('command.com [ /C dir c:\\*.\* /s ]')
                        #ENDBOXED
                        #BOXED,WHERE(%PDFFieldActionType='Hyperlink'),AT(0,0)
                          #PROMPT('Target Origin:',DROP(%PDFPossibleTextOrigin)),%PDFTargetOrigin
                          #BOXED,SECTION
                            #BOXED,WHERE(%PDFTargetOrigin='Text'),AT(0,0)
                              #DISPLAY('The Target will be the text displayed on the report')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFTargetOrigin='HardCoded'),AT(0,0)
                              #PROMPT('Target:',EXPR),%PDFTargetHardCoded
                            #ENDBOXED
                            #BOXED,WHERE(%PDFTargetOrigin='Dynamic'),AT(0,0)
                              #PROMPT('Target:',EXPR),%PDFTargetDynamic
                            #ENDBOXED
                          #ENDBOXED
                          #PROMPT('Hyperlink Type:',DROP('HTTP|MAIL|FTP|NEWS|Other|Other Dynamic[Dynamic]|None')),%PDFHyperlinkType,DEFAULT('None')
                          #BOXED,SECTION
                            #BOXED,WHERE(%PDFHyperlinkType='HTTP'),AT(0,0)
                              #DISPLAY('The http:// will be added to the Hyperlink')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='MAIL'),AT(0,0)
                              #DISPLAY('The mailto: will be added to the Hyperlink')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='FTP'),AT(0,0)
                              #DISPLAY('The ftp:// will be added to the Hyperlink')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='NEWS'),AT(0,0)
                              #DISPLAY('The news: will be added to the Hyperlink')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='None'),AT(0,0)
                              #DISPLAY('The Hyperlink will be used as is')
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='Other'),AT(0,0)
                              #PROMPT('Other Type:',EXPR),%PDFHyperlinkTypeOther
                            #ENDBOXED
                            #BOXED,WHERE(%PDFHyperlinkType='Dynamic'),AT(0,0)
                              #PROMPT('Other Type:',EXPR),%PDFHyperlinkTypeOtherDynamic
                            #ENDBOXED
                          #ENDBOXED
                        #ENDBOXED
                        #BOXED,WHERE(%PDFFieldActionType='Hyperlink' OR %PDFFieldActionType='CommandLine' OR %PDFFieldActionType='PageAction')
                          #PROMPT('Hyperlink Boxed',CHECK),%PDFHyperLinkBoxed,DEFAULT(%False),AT(10)
                          #ENABLE(%PDFHyperLinkBoxed)
                            #PROMPT('Box Color:',COLOR),%PDFHyperLinkBoxColor,DEFAULT(00000FFH)
                          #ENDENABLE
                        #ENDBOXED
                      #ENDBOXED
                    #ENDENABLE
                  #ENDBOXED
                  #PROMPT('Add Bookmark',CHECK),%PDFBookmark,DEFAULT(%False),AT(10)
                  #BOXED('')
                    #ENABLE(%PDFBookmark)
                      #PROMPT('Bookmark text Origin:',DROP(%PDFPossibleBookmarkTextOrigin)),%PDFBookmarkOrigin
                      #BOXED,SECTION
                        #BOXED,WHERE(%PDFBookmarkOrigin='Text'),AT(0,0)
                          #DISPLAY('The Target will be the text displayed on the report')
                        #ENDBOXED
                        #BOXED,WHERE(%PDFBookmarkOrigin='HardCoded'),AT(0,0)
                          #PROMPT('Target:',EXPR),%PDFBookmarkHardCoded
                        #ENDBOXED
                        #BOXED,WHERE(%PDFBookmarkOrigin='Dynamic'),AT(0,0)
                          #PROMPT('Target:',EXPR),%PDFBookmarkDynamic
                        #ENDBOXED
                      #ENDBOXED
                      #PROMPT('Add Bookmark Parent',CHECK),%PDFBookmarkParent,DEFAULT(%False),AT(10)
                      #PREPARE
                        #SET(%PDFTempControlInstance,INSTANCE(%ReportControl))
                        #SET(%PDFTempReportControl,%ReportControl)
                      #ENDPREPARE
                      #ENABLE(%PDFBookmarkParent),CLEAR
                        #PROMPT('Parent Bookmark:',FROM(%ReportControl,(%PDFParentBookmark<>%PDFTempReportControl AND %PDFTempControlInstance<>INSTANCE(%ReportControl) AND %PDFBookmark AND %PDFIsValidControl()),%ReportControl)),%PDFParentBookmark,REQ
                        #VALIDATE(NOT(%IsCircularParent(%ReportControl,%PDFParentBookmark)),'This parent create a circular reference,please change the bookmark parent.')
                      #ENDENABLE
                    #ENDENABLE
                  #ENDBOXED
                  #ENABLE(%ReportControlType='TEXT' OR %ReportControlType='STRING' OR %ReportControlType='CHECK' OR %ReportControlType='RADIO' OR %ReportControlType='OPTION' OR %ReportControlType='GROUP'),CLEAR
                    #PROMPT('Use PDF Font',CHECK),%PDFUsePDFFont,DEFAULT(%False),AT(10)
                  #ENDENABLE
                  #BOXED('')
                    #ENABLE(%PDFUsePDFFont)
                      #PROMPT('Font:',DROP('COURIER|HELVETICA|TIMES-ROMAN|SYMBOL|ZAPFDINGBATS')),%PDFOriginalFont,DEFAULT('HELVETICA')
                    #ENDENABLE
                  #ENDBOXED
                #ENDENABLE
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
  #CALL(%SetTargetLocalPromptFromGlobal)
  #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
    #FOR(%ReportControl),WHERE(%PDFIsValidControl() AND %PDFHideControl)
      #CALL(%AddHidenControlToReport,'PDF',%ReportControl)
    #ENDFOR
    #CALL(%SetClassDefaults,%TargetLocalObjectName,%TargetLocalObjectName,%TargetLocalObjectClass)
    #IF(%Populate='Conditional')
      #CALL(%AddTargetToReport,%TargetLocalName,%TargetLocalObjectName,%TargetLocalObjectClass,%PopulateCondition)
    #ELSE
      #CALL(%AddTargetToReport,%TargetLocalName,%TargetLocalObjectName,%TargetLocalObjectClass,'')
    #ENDIF
  #ENDIF
  #DECLARE(%AttributeObjectName)
  #IF(%AppTemplateFamily='CLARION')
    #SET(%AttributeObjectName,'LocalAttribute')
  #ELSE
    #SET(%AttributeObjectName,'SELF.Attribute')
  #ENDIF
#ENDAT
#AT(%GatherObjects)
  #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
    #CALL(%AddObjectList, %TargetLocalObjectName)
  #ENDIF
#ENDAT
#AT(%CustomGlobalDeclarations)
#IF(NOT %GlobalDisable AND %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
    #PROJECT('None(ClaRunExt.DLL),CopyToOutputDirectory=Always')
#ENDIF
#ENDAT
#AT(%LocalProcedures)
  #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
    #CALL(%GenerateVirtuals, %TargetLocalObjectName, 'Local Objects|Abc Objects|Report Target|'&%TargetLocalName, '%ReportTargetLocalVirtuals(SVReportToPDFSupport)')
  #ENDIF
#ENDAT
#AT(%LocalDataClasses)
   #IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
#INSERT(%GenerateClass, %TargetLocalObjectName, %TargetLocalName)
   #ENDIF
#ENDAT
#AT(%ReportTargetMethodCodeSection,%TargetLocalName),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
#IF(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
  #CALL(%GenerateParentCall)
#ENDIF
#ENDAT
#!
#AT(%ReportTargetMethodCodeSection,'PDF','Setup','()'),PRIORITY(5500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %GlobalUseABCClasess)
#DECLARE(%PDFEncryptdocAccess)
#CASE(%OutputNameType)
#OF('Fixed')
SELF.SetFileName(%(%SVStripPling(%OutputNameFixed)))
#OF('Variable')
SELF.SetFileName(%OutputNameVariable)
#OF('Runtime')
SELF.SetFileName('')
#ENDCASE
SELF.SetDocumentInfo(%(%SVStripPling(%DocumentTitle)),%(%SVStripPling(%ApplicationName)),%(%SVStripPling(%ProgramName)),%(%SVStripPling(%PDFSubject)),%(%SVStripPling(%PDFAuthor)),%(%SVStripPling(%PDFKeywords)))
#IF(NOT %UseImageToPDFLibrary)
SELF.SetPagesAsParentBookmark(%(CHOOSE(%PagesAsParentBookmark,'True','False')))
  #IF(%UseScanCopyMode)
SELF.CompressImages = True
SELF.CompressText   = True
SELF.SetScanCopyMode(True)
SELF.SetScanCopyResolution(PNGImageResolution:%ScanCopyModeRes)
  #ELSE
SELF.SetScanCopyMode(False)
SELF.CompressText   = %(CHOOSE(%CompressText,'True','False'))
SELF.CompressImages = %(CHOOSE(%CompressImages,'True','False'))
  #ENDIF
#ELSE  
  #IF(%UseScanCopyMode)
SELF.SetScanCopyMode(True)
   #CASE(%ScanCopyModeRes)
   #OF('Draft')
SELF.SetScanCopyResolution(50)
   #OF('Original')
SELF.SetScanCopyResolution(80)
   #OF('Normal')
SELF.SetScanCopyResolution(100)
   #OF('Good')
SELF.SetScanCopyResolution(150)
   #OF('Detail')
SELF.SetScanCopyResolution(200)
   #ENDCASE
  #ELSE
SELF.SetScanCopyMode(False)
  #ENDIF
#ENDIF
#IF(%Encryptdoc<>'Never')
  #IF(%PDFUseVariableAccess)
    #SET(%PDFEncryptdocAccess,%PDFVariableAccess)
  #ELSE
    #IF(%UseImageToPDFLibrary)
       #SET(%PDFEncryptdocAccess,'I2PDF:PDF_PERMISSION_READ_ONLY')
       #IF(%PDFAccessPrint)
         #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+I2PDF:PDF_PERMISSION_PRINT')
       #ENDIF
       #IF(%PDFAccessCopy)
         #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+I2PDF:PDF_PERMISSION_COPY')
       #ENDIF
       #IF(%PDFAccessModifyContent)
         #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+I2PDF:PDF_PERMISSION_EDIT')
       #ENDIF
       #IF(%PDFAccessModifyAnnotations)
          #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+I2PDF:PDF_PERMISSION_EDIT_EXTRA')
       #ENDIF   
    #ELSE    
       #IF(%PDFAccessPrint)
         #SET(%PDFEncryptdocAccess,'PDFAccess:Print')
       #ENDIF
       #IF(%PDFAccessCopy)
         #IF(%PDFEncryptdocAccess)
           #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+PDFAccess:Copy')
         #ELSE
           #SET(%PDFEncryptdocAccess,'PDFAccess:Copy')
         #ENDIF
       #ENDIF
       #IF(%PDFAccessModifyContent)
         #IF(%PDFEncryptdocAccess)
           #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+PDFAccess:ModifyContent')
         #ELSE
           #SET(%PDFEncryptdocAccess,'PDFAccess:ModifyContent')
         #ENDIF
       #ENDIF
       #IF(%PDFAccessModifyAnnotations)
         #IF(%PDFEncryptdocAccess)
           #SET(%PDFEncryptdocAccess,%PDFEncryptdocAccess&'+PDFAccess:ModifyAnnotations')
         #ELSE
           #SET(%PDFEncryptdocAccess,'PDFAccess:ModifyAnnotations')
         #ENDIF
       #ENDIF
    #ENDIF
  #ENDIF
  #IF(%PDFEncryptdocAccess)
    #SET(%PDFEncryptdocAccess,','&%PDFEncryptdocAccess)
  #ENDIF
  #IF(%Encryptdoc='Conditional')
IF %EncryptDocCondition
   SELF.SetEncryption(%(%SVStripPling(%PDFPassword)&%PDFEncryptdocAccess))
END
  #ELSE
SELF.SetEncryption(%(%SVStripPling(%PDFPassword)&%PDFEncryptdocAccess))
  #ENDIF
#ENDIF
#ENDAT
#!
#AT(%SetStaticControlsAttributes),PRIORITY(4500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %AppTemplateFamily='CLARION' AND %GlobalUseABCClasess AND NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
#INSERT(%CodeSetStaticControlsAttributes)
#ENDAT
#!
#AT(%SetDynamicControlsAttributes),PRIORITY(4500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %AppTemplateFamily='CLARION' AND %GlobalUseABCClasess AND NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
#INSERT(%CodeSetDynamicControlsAttributes)
#ENDAT
#!
#AT(%WindowManagerMethodCodeSection,'SetStaticControlsAttributes','()'),PRIORITY(5500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %AppTemplateFamily='ABC' AND %GlobalUseABCClasess AND NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
#INSERT(%CodeSetStaticControlsAttributes)
#ENDAT
#!
#!
#!
#AT(%WindowManagerMethodCodeSection,'SetDynamicControlsAttributes','()'),PRIORITY(5500),WHERE(NOT %GlobalDisable AND %Populate<>'Never' AND %EnablePrintPreview AND %AppTemplateFamily='ABC' AND %GlobalUseABCClasess AND NOT %UseScanCopyMode AND NOT %UseImageToPDFLibrary)
#INSERT(%CodeSetDynamicControlsAttributes)
#ENDAT
#!
#!
#!
#!
#!
#GROUP(%GetTagDisplay),AUTO
#DECLARE(%lReturnValue)
#IF(%PDFSkipControl)
  #SET(%lReturnValue,%ReportControl&' - SKIP')
#ELSE
  #SET(%lReturnValue,%ReportControl)
  #IF(%PDFFieldAction)
    #CASE(%PDFFieldActionType)
    #OF('Hyperlink')
      #SET(%lReturnValue,CLIP(%lReturnValue)&' - Action:H')
    #OF('Annotation')
      #SET(%lReturnValue,CLIP(%lReturnValue)&' - Action:A')
    #OF('CommandLine')
      #SET(%lReturnValue,CLIP(%lReturnValue)&' - Action:C')
    #OF('PageAction')
      #SET(%lReturnValue,CLIP(%lReturnValue)&' - Action:P')
    #ENDCASE
  #ENDIF
  #IF(%PDFBookmark)
    #SET(%lReturnValue,CLIP(%lReturnValue)&' - Bookmark')
  #ENDIF
  #IF(%PDFUsePDFFont)
    #SET(%lReturnValue,CLIP(%lReturnValue)&' - Use Font')
  #ENDIF
#ENDIF
#RETURN(%lReturnValue)
#!
#!
#GROUP(%PDFIsParentBookmarkDynamic,%pParentBookmark),PRESERVE
#FIX(%ReportControl,%pParentBookmark)
#IF(%ReportControl)
  #IF(%PDFBookmark)
    #IF(%PDFBookmarkOrigin='Dynamic')
      #RETURN(%True)
    #ELSE
      #IF(%PDFBookmarkOrigin='Text' AND %ReportControlUse)
        #RETURN(%True)
      #ENDIF
    #ENDIF
  #ENDIF
#ENDIF
#RETURN(%False)
#!
#!
#GROUP(%PDFGetParentBookmarkName,%pParentBookmark),PRESERVE
#FIX(%ReportControl,%pParentBookmark)
#IF(%ReportControl)
  #CASE(%PDFBookmarkOrigin)
  #OF('Text')
    #IF(%ReportControlUse)
      #RETURN(%ReportControlUse)
    #ELSE
      #IF(%ReportControlType='STRING')
        #RETURN(EXTRACT(%ReportControlStatement,'STRING',1))
      #ELSE
        #RETURN('')
      #ENDIF
    #ENDIF
  #OF('HardCoded')
    #RETURN(%SVStripPling(%PDFBookmarkHardCoded))
  #OF('Dynamic')
    #RETURN(%PDFBookmarkDynamic)
  #ENDCASE
#ENDIF
#!
#!
#GROUP(%IsCircularParent,%pOriginalReportControl,%pParentBookmark),PRESERVE
#IF(NOT %pParentBookmark)
  #RETURN(%False)
#ENDIF
#FIX(%ReportControl,%pParentBookmark)
#IF(%ReportControl)
  #IF(%PDFBookmarkParent)
    #IF(%PDFParentBookmark)
      #IF(%PDFParentBookmark=%pOriginalReportControl)
        #RETURN(%True)
      #ELSE
        #RETURN(%IsCircularParent(%pOriginalReportControl,%PDFParentBookmark))
      #ENDIF
    #ELSE
      #RETURN(%False)
    #ENDIF
  #ELSE
    #RETURN(%False)
  #ENDIF
#ELSE
  #RETURN(%False)
#ENDIF
#!
#!
#GROUP(%PDFIsValidControl),AUTO
#DECLARE(%lReturnValue)
#SET(%lReturnValue,%False)
#IF(NOT %ReportControl)
  #RETURN(%False)
#ENDIF
#CASE(%ReportControlType)
#OF('LIST')
#OROF('HEADER')
#OROF('DETAIL')
#OROF('FORM')
#OROF('FOOTER')
#OROF('BREAK')
  #SET(%lReturnValue,%False)
#OF('GROUP')
#OROF('OPTION')
  #IF(INSTRING(',BOXED',%ReportControlStatement,1,1)>0)
    #SET(%lReturnValue,%True)
  #ELSE
    #SET(%lReturnValue,%False)
  #ENDIF
#OF('LINE')
#OROF('BOX')
#OROF('ELLIPSE')
#OROF('RADIO')
#OROF('IMAGE')
#OROF('STRING')
#OROF('TEXT')
#OROF('CHECK')
  #SET(%lReturnValue,%True)
#ELSE
  #ERROR('ReportToPDF: %%PDFIsValidControl (Control not supported)')
#ENDCASE
#RETURN(%lReturnValue)
#!
#GROUP(%CodeSetStaticControlsAttributes)
#FOR(%ReportControl),WHERE(%PDFIsValidControl())
  #IF(%PDFSkipControl)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Skip,%ReportControl)
  #ELSE
    #IF(%PDFHideControlOnPDF)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Hide,True)
    #ENDIF
    #IF(%PDFUsePDFFont)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:FontName,'%'PDFOriginalFont')
    #ENDIF
    #IF(%PDFFieldAction)
      #CASE(%PDFFieldActionType)
      #OF('Hyperlink')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:PDFActionType,PDFHLType:HyperLink)
        #CASE(%PDFHyperlinkType)
        #OF('HTTP')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,'http://')
        #OF('MAIL')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,'mailto:')
        #OF('FTP')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,'ftp://')
        #OF('NEWS')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,'news:')
        #OF('Other')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,%(%SVStripPling(%PDFHyperlinkTypeOther)))
        #ENDCASE
        #!
        #CASE(%PDFTargetOrigin)
        #OF('Text')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Hyperlink,TargetAttr:Hyperlink)
        #OF('HardCoded')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Hyperlink,%(%SVStripPling(%PDFTargetHardCoded)))
        #ENDCASE
      #OF('CommandLine')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:PDFActionType,PDFHLType:Command)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:CommandLine,%(%SVStripPling(%PDFTargetCommand)))
        #IF(%PDFTargetParameters)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:CommandLineParam,%(%SVStripPling(%PDFTargetParameters)))
        #ENDIF
      #OF('PageAction')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:PDFActionType,PDFHLType:PageAction)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:PageAction,'%'PDFPageAction')
      #OF('Annotation')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:PDFActionType,PDFHLType:Annotation)
        #CASE(%PDFAnnotationOrigin)
        #OF('Text')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Annotation,TargetAttr:Annotation)
        #OF('HardCoded')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Annotation,%(%SVStripPling(%PDFAnnotationHardCoded)))
        #ENDCASE
      #ENDCASE
      #IF((%PDFFieldActionType='Hyperlink' OR %PDFFieldActionType='CommandLine' OR %PDFFieldActionType='PageAction') AND %PDFHyperLinkBoxed)
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperBoxColor,%PDFHyperLinkBoxColor)
      #ENDIF
    #ENDIF
    #IF(%PDFBookmark)
      #CASE(%PDFBookmarkOrigin)
      #OF('Text')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Bookmark,TargetAttr:Bookmark)
      #OF('HardCoded')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Bookmark,%(%SVStripPling(%PDFBookmarkHardCoded)))
      #ENDCASE
      #IF(%PDFBookmarkParent)
        #IF(NOT %PDFIsParentBookmarkDynamic(%PDFParentBookmark))
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:BookmarkParent,%(%PDFGetParentBookmarkName(%PDFParentBookmark)))
        #ENDIF
      #ENDIF
    #ENDIF
  #ENDIF
#ENDFOR
#!
#GROUP(%CodeSetDynamicControlsAttributes)
#FOR(%ReportControl),WHERE(%PDFIsValidControl() AND NOT %PDFSkipControl)
  #IF(%PDFFieldAction)
    #CASE(%PDFFieldActionType)
    #OF('Hyperlink')
      #IF(%PDFHyperlinkType='Dynamic')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:HyperlinkType,%PDFHyperlinkTypeOtherDynamic)
      #ENDIF
      #IF(%PDFTargetOrigin='Dynamic')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Hyperlink,%PDFTargetDynamic)
      #ENDIF
    #OF('Annotation')
      #IF(%PDFAnnotationOrigin='Dynamic')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Annotation,%PDFAnnotationDynamic)
      #ENDIF
    #ENDCASE
  #ENDIF
  #IF(%PDFBookmark)
    #IF(%PDFBookmarkOrigin='Dynamic')
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:Bookmark,%PDFBookmarkDynamic)
    #ENDIF
    #IF(%PDFBookmarkParent)
      #IF(%PDFIsParentBookmarkDynamic(%PDFParentBookmark))
%AttributeObjectName.Set(%ReportControl,RepGen:PDF,TargetAttr:BookmarkParent,%(%PDFGetParentBookmarkName(%PDFParentBookmark)))
      #ENDIF
    #ENDIF
  #ENDIF
#ENDFOR
#!
#!
#!
#INCLUDE('rtar_srv.TPW')
#!
#GROUP(%TargetLocalClassTab)
    #TAB('&Classes'),WHERE(%False)
      #WITH(%ClassItem,%TargetLocalObjectName)
        #INSERT(%ClassPrompts)
      #ENDWITH
    #ENDTAB
#!
#!
#GROUP(%TargetLocalPrompts)
#BOXED,SECTION
  #BOXED,AT(0,0),WHERE(NOT %GlobalUseABCClasess)
    #DISPLAY('Enable the use of ABC to enable the template')
  #ENDBOXED
  #BOXED,AT(0,0),WHERE(%GlobalUseABCClasess)
    #BOXED,HIDE
      #PROMPT('TargetName',@S100),%TargetLocalName,DEFAULT('')
      #PROMPT('TargetObjectName',@S100),%TargetLocalObjectName,DEFAULT('')
      #PROMPT('TargetObjectClass',@S100),%TargetLocalObjectClass,DEFAULT('')
    #ENDBOXED
  #ENDBOXED
#ENDBOXED
#!
#!
#GROUP(%SetTargetLocalPromptFromGlobal)
  #CASE(%LocalPDFLibrary)
  #OF('GLOBAL')
    #IF(%GlobalDefaultPDFLibrary='I2PDF')
      #SET(%UseImageToPDFLibrary,%TRUE)
    #ELSE
      #SET(%UseImageToPDFLibrary,%FALSE)
    #ENDIF
  #OF('CLARION')
    #SET(%UseImageToPDFLibrary,%FALSE)
  #OF('I2PDF')
    #SET(%UseImageToPDFLibrary,%TRUE)
  #ENDCASE
  #IF(%UseImageToPDFLibrary)
     #CALL(%SetTargetLocalPrompt,'PDF','PDFReporter','I2PDFReportGenerator')
  #ELSE
     #CALL(%SetTargetLocalPrompt,'PDF','PDFReporter','PDFReportGenerator')
  #ENDIF
#!
#GROUP(%SetTargetLocalPrompt,%pTargetName,%pTargetObjectName,%pTargetObjectClass)
#SET(%TargetLocalName,%pTargetName)
#SET(%TargetLocalObjectName,%pTargetObjectName)
#SET(%TargetLocalObjectClass,%pTargetObjectClass)
#!
#!
#GROUP(%ReportTargetLocalVirtuals, %TreeText, %DataText, %CodeText)
#IF(UPPER(%pClassMethod)='SETUP' AND %pClassMethodPrototype='()')
#EMBED(%ReportTargetMethodDataSection,'Report Target Method Data Section'),%TargetLocalName,%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(%FixClassName(%FixBaseClassToUse(%TargetLocalObjectName))),TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%ReportTargetMethodCodeSection,'Report Target Method Executable Code Section'),%TargetLocalName,%pClassMethod,%pClassMethodPrototype,PREPARE(%FixClassName(%FixBaseClassToUse(%TargetLocalObjectName))),TREE(%TreeText & %CodeText)
#ENDIF
#!
