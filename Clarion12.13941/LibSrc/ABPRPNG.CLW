    MEMBER
INCLUDE('ABPRPNG.INC'),ONCE
INCLUDE('ABERROR.INC'),ONCE
    PRAGMA('link(EXP_PNG.ICO)')
    MAP
!      INCLUDE('CWUTIL.INC'),ONCE
     MODULE('Core')
       PathSplit(CONST *CSTRING path, <*CSTRING drive>, <*CSTRING dir>, <*CSTRING file>, <*CSTRING ext>), SIGNED, PROC, RAW, NAME('_fnsplit')
     END
    END
!region PNGReportGenerator
PNGReportGenerator.CONSTRUCT            PROCEDURE()
 CODE
    SELF.ClaRunExt  &= NEW ClaRunExtClass
    SELF.Output     &= NEW TargetGenerator
    SELF.ImageResolution = PNGImageResolution:Normal
    
PNGReportGenerator.DESTRUCT                             PROCEDURE()
 CODE
    DISPOSE(SELF.Output)
    DISPOSE(SELF.ClaRunExt)

PNGReportGenerator.Init                    PROCEDURE(<STRING TargetFileName>)
 CODE
    IF OMITTED(2) THEN
       SELF.Output.Init()
    ELSE
       SELF.Output.Init(TargetFileName)
    END
    SELF.Setup()

PNGReportGenerator.SetUp                   PROCEDURE()
 CODE

PNGReportGenerator.SetFileName              PROCEDURE(STRING pFileName)
 CODE
    SELF.Output.SetOriginalFileName(pFileName)

PNGReportGenerator.GetFileName              PROCEDURE()
 CODE
    RETURN SELF.Output.GetOriginalFileName()
PNGReportGenerator.SetImageResolution   PROCEDURE(USHORT imageRes)
 CODE
    IF imageRes > 2400
       SELF.ImageResolution = 2400
    ELSE
       SELF.ImageResolution = imageRes
    END
    
PNGReportGenerator.GetImageResolution   PROCEDURE()
 CODE
    RETURN SELF.ImageResolution

PNGReportGenerator.OpenDocument            PROCEDURE()
 CODE
    SELF.PageNo = 0

PNGReportGenerator.CloseDocument PROCEDURE()
 CODE

PNGReportGenerator.StartPage     PROCEDURE()
lIndex  SHORT
 CODE
    SELF.PageNo+=1
    SELF.PageOpen = True
    !GENERATE FILE NAME
    SELF.Output.SetFileNameFromOriginal(SELF.PageNo,SELF.TotalPageNo)
    SELF.Output.OpenFile()

PNGReportGenerator.EndPage                 PROCEDURE()
 CODE
    SELF.Output.CloseFile()
    SELF.Output.SetFileName('')
    SELF.PageOpen = False
    
!endregion
!region IReportGenerator
PNGReportGenerator.IReportGenerator.Init                PROCEDURE(<ErrorClass EC>)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessBand         PROCEDURE(STRING type, BYTE start)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.OpenDocument        PROCEDURE(UNSIGNED TotalPages)
 CODE
     SELF.TotalPageNo = TotalPages
     SELF.OpenDocument()
     RETURN Level:Benign

PNGReportGenerator.IReportGenerator.CloseDocument       PROCEDURE()
 CODE
     SELF.CloseDocument()
     SELF.SetFileName('')
     RETURN Level:Benign

PNGReportGenerator.IReportGenerator.SupportPageProcessing PROCEDURE()
 CODE
    RETURN TRUE

PNGReportGenerator.IReportGenerator.OpenPage PROCEDURE(STRING pPageName)
 CODE
    RETURN Level:Benign

PNGReportGenerator.IReportGenerator.StartPageProcess            PROCEDURE(SHORT pBoxLeft,SHORT pBoxTop,SHORT pBoxRight,SHORT pBoxBottom,STRING pPageName)
lOutPageName    CSTRING(FILE:MaxFileName),AUTO
lInPageName     CSTRING(FILE:MaxFileName),AUTO
 CODE
     SELF.StartPage()
     SELF.OpenPageName = pPageName
     lInPageName = CLIP(pPageName)
     lOutPageName  = CLIP(pPageName)&'.PNG'
     IF NOT SELF.ClaRunExt.ImageToPNG(lInPageName,lOutPageName, SELF.ImageResolution)
        COPY(lOutPageName,CLIP(SELF.Output.GetFileName()))
        REMOVE(lOutPageName)
        IF NOT SELF.OutputFileQueue &= NULL
           SELF.OutputFileQueue.FileName = SELF.Output.GetFileName()
           ADD(SELF.OutputFileQueue)
        END
        SELF.EndPage()
        RETURN Level:Benign
     END
     RETURN Level:Fatal

PNGReportGenerator.IReportGenerator.ClosePage           PROCEDURE()
 CODE
    RETURN Level:Benign

PNGReportGenerator.IReportGenerator.AskProperties       PROCEDURE(BYTE Force=0)
ReturnValue  BYTE
LOC:FileName CSTRING(FILE:MaxFilePath+1),AUTO
LExt         CSTRING(128),AUTO
 CODE
     ReturnValue = Level:Benign
     SELF.Init()
     IF NOT CLIP(SELF.Output.GetFileName()) OR Force THEN
        LOC:FileName = ''
        IF NOT FILEDIALOG('Save as PNG Files',LOC:FileName,'PNG|*.PNG|All|*.*',FILE:LongName+FILE:Save+FILE:KeepDir) THEN
           ReturnValue = Level:Notify
        ELSE
           Lext=''
           PathSplit(LOC:FileName, , , , Lext)
           IF NOT Lext THEN
              LOC:FileName=LOC:FileName&'.PNG'
           END
           SELF.Output.SetOriginalFileName(LOC:FileName)
        END
     END
     RETURN ReturnValue
PNGReportGenerator.IReportGenerator.WhoAmI              PROCEDURE()
 CODE
     RETURN RepGen:PDF

PNGReportGenerator.IReportGenerator.DisplayIcon         PROCEDURE()
 CODE
     RETURN '~EXP_PNG.ICO'

PNGReportGenerator.IReportGenerator.DisplayName         PROCEDURE()
 CODE
     RETURN 'PNG'

PNGReportGenerator.IReportGenerator.GetFileName              PROCEDURE()
 CODE
    RETURN SELF.Output.GetOriginalFileName()

!region process function
PNGReportGenerator.IReportGenerator.ProcessString         PROCEDURE(*StringFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN
    
PNGReportGenerator.IReportGenerator.ProcessLine         PROCEDURE(*LineFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessArc      PROCEDURE(*ArcFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessChord      PROCEDURE(*ChordFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessEllipse      PROCEDURE(*EllipseFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessRectangle    PROCEDURE(*RectFormatGrp pFormatGrp, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessImage        PROCEDURE(*ImageFormatGrp pFormatGrp, STRING iName, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessCheck        PROCEDURE(*CheckFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessRadio        PROCEDURE(*RadioFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessPie          PROCEDURE(SliceFormatQueue pSliceFormatQueue, *PosGrp pPosGroup, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessPolygon  PROCEDURE(PointQueue pPointQueue, *StyleGrp pStyleGrp, STRING pExtendControlAttr)
  CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessGroup        PROCEDURE(*GroupFormatGrp pFormatGrp, STRING Text, STRING pExtendControlAttr)
 CODE
    RETURN

PNGReportGenerator.IReportGenerator.ProcessText     PROCEDURE(TextFormatQueue TextFormatQ, STRING pExtendControlAttr)
  CODE
    RETURN
!endregion

PNGReportGenerator.IReportGenerator.SetResultQueue      PROCEDURE(OutputFileQueue pOutputFile)
 CODE
    SELF.OutputFileQueue &= pOutputFile
    FREE(SELF.OutputFileQueue)

PNGReportGenerator.IReportGenerator.SupportResultQueue  PROCEDURE()
 CODE
 RETURN TRUE

PNGReportGenerator.IReportGenerator.SupportPageParsing  PROCEDURE()
 CODE
 RETURN FALSE

!endregion
