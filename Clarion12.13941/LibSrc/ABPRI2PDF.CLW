    MEMBER
INCLUDE('ABPRI2PDF.INC'),ONCE
INCLUDE('ABERROR.INC'),ONCE
    PRAGMA('link(Exp_i2pdf.ico)')
    PRAGMA('link(ClaI2PDF.LIB)')
    MAP
     MODULE('Core')
       PathSplit(CONST *CSTRING path, <*CSTRING drive>, <*CSTRING dir>, <*CSTRING file>, <*CSTRING ext>), SIGNED, PROC, RAW, NAME('_fnsplit')
     END
    END
!region I2PDFReportGenerator
I2PDFReportGenerator.CONSTRUCT            PROCEDURE()
 CODE
    SELF.Output     &= NEW TargetGenerator
    SELF.ScanCopyMode  = FALSE
    SELF.ScanCopyResolution = 100

I2PDFReportGenerator.DESTRUCT                             PROCEDURE()
 CODE
    DISPOSE(SELF.Output)

I2PDFReportGenerator.SetDocumentInfo      PROCEDURE(STRING pTitle,STRING pAppName,STRING pProgName,STRING pSubject,STRING pAuthor,STRING pKeywords)
 CODE
    SELF.Title    = pTitle
    SELF.AppName  = pAppName
    SELF.ProgName = pProgName
    SELF.Subject  = pSubject
    SELF.Author   = pAuthor
    SELF.Keywords = pKeywords

I2PDFReportGenerator.SetEncryption        PROCEDURE(STRING pPasswordUser,<ULONG pAccessPermissions>)
 CODE
    IF CLIP(pPasswordUser)
       SELF.Encrypt  = True
       SELF.PasswordUser = CLIP(pPasswordUser)
       IF NOT OMITTED(3)
          SELF.AccessPermissions = pAccessPermissions
       ELSE
          SELF.AccessPermissions = I2PDF:PDF_PERMISSION_READ_ONLY
       END
    ELSE
       SELF.Encrypt = False
    END

I2PDFReportGenerator.Init                    PROCEDURE(<STRING TargetFileName>)
lErr LONG,AUTO
ltmpExt CSTRING(5),AUTO
 CODE
    IF OMITTED(2) THEN
       SELF.Output.Init()
    ELSE
       SELF.Output.Init(TargetFileName)
    END
    SELF.LastError = 0
    SELF.Encrypt = False
    SELF.Title                ='CW Report'
    SELF.AppName              =''
    SELF.ProgName             ='Clarion'
    SELF.Subject              =''
    SELF.Author               =''
    SELF.Keywords             =''
    SELF.PDFVersion           = I2PDF:PDFVersion16
    SELF.AccessPermissions    = I2PDF:PDF_PERMISSION_READ_ONLY
    SELF.PasswordUSer = ''
    SELF.UseTmpFiles = TRUE
    I2PDF_Reset()
    SELF.Setup()
    IF NOT SELF.ScanCopyMode
       I2PDF_MetaToNativePDF()
    ELSE
       lErr = I2PDF_MetaImageMaxMP_Int(SELF.ScanCopyResolution)
    END
    I2PDF_UseEMFDeviceSize()
    I2PDF_SetDPI(0) !useactualimagedpi
    I2PDF_UseEMFDeviceSize()
    I2PDF_SetCreationDate()
    IF SELF.UseTmpFiles
       ltmpExt = '.wmf'
       IF I2PDF_TreatImageTmpExtensionAs(ltmpExt)
       END
    END
    IF I2PDF_Version(SELF.PDFVersion)<>I2PDF:ReturnOk
       SELF.PDFVersion = I2PDF:PDFVersion16
       IF I2PDF_Version(SELF.PDFVersion)
       END
    END
    IF I2PDF_SetTitle(SELF.Title)<>I2PDF:ReturnOk
    END
    IF I2PDF_SetSubject(SELF.Subject)<>I2PDF:ReturnOk
    END
    IF I2PDF_SetKeywords(SELF.Keywords)<>I2PDF:ReturnOk
    END
    IF I2PDF_SetAuthor(SELF.Author)<>I2PDF:ReturnOk
    END
    IF I2PDF_SetCreator(SELF.ProgName)<>I2PDF:ReturnOk
    END
    IF SELF.Encrypt
       lErr = I2PDF_SetUserPassword(SELF.PasswordUser)
       IF lErr<>I2PDF:ReturnOk
            MESSAGE('I2PDF_SetUserPassword|('&lErr&') '&lErr,'Image2PDF Error')
       END
       lErr = I2PDF_SetPermissions(SELF.AccessPermissions)
       IF lErr<>I2PDF:ReturnOk
            MESSAGE('I2PDF_SetPermissions|('&lErr&') '&lErr,'Image2PDF Error')
       END
    END

I2PDFReportGenerator.SetUp                   PROCEDURE()
 CODE

I2PDFReportGenerator.SetScanCopyMode         PROCEDURE(BYTE onOff)
 CODE
    SELF.ScanCopyMode = CHOOSE(onOff,1,0)

I2PDFReportGenerator.GetScanCopyMode         PROCEDURE()
 CODE
    RETURN SELF.ScanCopyMode

I2PDFReportGenerator.SetScanCopyResolution   PROCEDURE(ULONG imageRes)
 CODE
    IF imageRes > 200
       SELF.ScanCopyResolution = 200
    ELSE
       SELF.ScanCopyResolution = imageRes
    END

I2PDFReportGenerator.GetScanCopyResolution   PROCEDURE()
 CODE
    RETURN SELF.ScanCopyResolution

I2PDFReportGenerator.SetUseTmpFiles          PROCEDURE(BYTE pVal)
 CODE
    SELF.UseTmpFiles = CHOOSE(pVal)

I2PDFReportGenerator.SetFileName              PROCEDURE(STRING pFileName)
 CODE
    SELF.Output.SetOriginalFileName(pFileName)

I2PDFReportGenerator.GetFileName              PROCEDURE()
 CODE
    RETURN SELF.Output.GetOriginalFileName()

I2PDFReportGenerator.OpenDocument            PROCEDURE()
 CODE
    !SELF.PageNo = 0
    SELF.LastError = 0

I2PDFReportGenerator.GetLastError            PROCEDURE()
 CODE
    RETURN SELF.LastError

I2PDFReportGenerator.CloseDocument PROCEDURE()
lIdx LONG,AUTO
pdfFilename CSTRING(FILE:MaxFileName),AUTO
errorText CSTRING(256),AUTO
 CODE
   IF SELF.LastError = 0
      errorText = ''
      pdfFilename  = SELF.GetFileName()
      SELF.LastError = I2PDF_MakePDF(pdfFilename, I2PDF:OPTION_NONE, errorText, SIZE(errorText));
      IF SELF.LastError > 0
         IF (SELF.LastError = 3)
            MESSAGE('I2PDF_MakePDF|('&SELF.LastError&') '&errorText,'Image2PDF Error')
         ELSE
            MESSAGE('I2PDF_MakePDF|('&SELF.LastError&') '&errorText,'Image2PDF Error')
         END
      END
      IF NOT SELF.OutputFileQueue &= NULL
         SELF.OutputFileQueue.FileName = SELF.Output.GetFileName()
         ADD(SELF.OutputFileQueue)
      END
   END
   I2PDF_Reset()

I2PDFReportGenerator.StartPage     PROCEDURE()
lIndex  SHORT
 CODE
    SELF.PageOpen = True

I2PDFReportGenerator.EndPage                 PROCEDURE()
 CODE
    SELF.PageOpen = False

I2PDFReportGenerator.ProcessPage             PROCEDURE(STRING pTmpWMFFileName)
lWMFPageName    CSTRING(FILE:MaxFileName),AUTO
lErr LONG,AUTO
 CODE
     lWMFPageName  = CLIP(pTmpWMFFileName)

     SELF.LastError = I2PDF_AddImage(lWMFPageName)
     IF SELF.LastError <> I2PDF:OPTION_NONE
        MESSAGE('I2PDF_AddImage|Error ='& SELF.LastError &'|File Name='&lWMFPageName,'Image2PDF Error')
     END
     RETURN SELF.LastError

!endregion
!region IReportGenerator
I2PDFReportGenerator.IReportGenerator.Init                PROCEDURE(<ErrorClass EC>)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessBand         PROCEDURE(STRING type, BYTE start)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.OpenDocument        PROCEDURE(UNSIGNED TotalPages)
 CODE
     SELF.TotalPageNo = TotalPages
     SELF.OpenDocument()
     RETURN Level:Benign

I2PDFReportGenerator.IReportGenerator.CloseDocument       PROCEDURE()
 CODE
     SELF.CloseDocument()
     SELF.SetFileName('')
     RETURN Level:Benign

I2PDFReportGenerator.IReportGenerator.SupportPageProcessing PROCEDURE()
 CODE
    RETURN TRUE

I2PDFReportGenerator.IReportGenerator.OpenPage PROCEDURE(STRING pPageName)
 CODE
    RETURN Level:Benign

I2PDFReportGenerator.IReportGenerator.StartPageProcess            PROCEDURE(SHORT pBoxLeft,SHORT pBoxTop,SHORT pBoxRight,SHORT pBoxBottom,STRING pPageName)
 CODE
     SELF.StartPage()
     IF NOT SELF.ProcessPage(CLIP(pPageName))
        SELF.EndPage()
        RETURN Level:Benign
     END
     RETURN Level:Fatal

I2PDFReportGenerator.IReportGenerator.ClosePage           PROCEDURE()
 CODE
    RETURN Level:Benign

I2PDFReportGenerator.IReportGenerator.AskProperties       PROCEDURE(BYTE Force=0)
ReturnValue  BYTE
LOC:FileName CSTRING(FILE:MaxFilePath+1),AUTO
LExt         CSTRING(128),AUTO
 CODE
     ReturnValue = Level:Benign
     SELF.Init()
     IF NOT CLIP(SELF.Output.GetFileName()) OR Force THEN
        LOC:FileName = ''
        IF NOT FILEDIALOG('Save as PDF Files',LOC:FileName,'PDF|*.PDF|All|*.*',FILE:LongName+FILE:Save+FILE:KeepDir) THEN
           ReturnValue = Level:Notify
        ELSE
           Lext=''
           PathSplit(LOC:FileName, , , , Lext)
           IF NOT Lext THEN
              LOC:FileName=LOC:FileName&'.PDF'
           END
           SELF.Output.SetOriginalFileName(LOC:FileName)
        END
     END
     RETURN ReturnValue

I2PDFReportGenerator.IReportGenerator.WhoAmI              PROCEDURE()
 CODE
     RETURN RepGen:PDF

I2PDFReportGenerator.IReportGenerator.DisplayIcon         PROCEDURE()
 CODE
     RETURN '~Exp_i2pdf.ico'

I2PDFReportGenerator.IReportGenerator.DisplayName         PROCEDURE()
 CODE
     RETURN 'PDF'

I2PDFReportGenerator.IReportGenerator.GetFileName              PROCEDURE()
 CODE
    RETURN SELF.Output.GetOriginalFileName()

!region process function
I2PDFReportGenerator.IReportGenerator.ProcessString         PROCEDURE(*StringFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessLine         PROCEDURE(*LineFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessArc      PROCEDURE(*ArcFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessChord      PROCEDURE(*ChordFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessEllipse      PROCEDURE(*EllipseFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessRectangle    PROCEDURE(*RectFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessImage        PROCEDURE(*ImageFormatGrp pFormatGrp, STRING iName, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessCheck        PROCEDURE(*CheckFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessRadio        PROCEDURE(*RadioFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessPie          PROCEDURE(SliceFormatQueue pSliceFormatQueue, *PosGrp pPosGroup, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessPolygon  PROCEDURE(PointQueue pPointQueue, *StyleGrp pStyleGrp, STRING pExtendControlAttr)
  CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessGroup        PROCEDURE(*GroupFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

I2PDFReportGenerator.IReportGenerator.ProcessText     PROCEDURE(TextFormatQueue TextFormatQ, STRING pExtendControlAttr)
  CODE
    RETURN
!endregion

I2PDFReportGenerator.IReportGenerator.SetResultQueue      PROCEDURE(OutputFileQueue pOutputFile)
 CODE
    SELF.OutputFileQueue &= pOutputFile
    FREE(SELF.OutputFileQueue)

I2PDFReportGenerator.IReportGenerator.SupportResultQueue  PROCEDURE()
 CODE
 RETURN TRUE

I2PDFReportGenerator.IReportGenerator.SupportPageParsing  PROCEDURE()
 CODE
 RETURN FALSE

!endregion
