!----------------------------------------------------------
! Built-in property constants for CW
!----------------------------------------------------------*/


PROP:Text           EQUATE(7C00H)  ! single value (parameter to control itself)
PROP:Type           EQUATE(7C01H)  ! single value (CREATE:Xxxx)
PROP:At             EQUATE(7C02H)  ! array valued (4 values)
PROP:Xpos           EQUATE(7C02H)  ! single value, equivalent to PROP:At[1]
PROP:Ypos           EQUATE(7C03H)  ! single value, equivalent to PROP:At[2]
PROP:Width          EQUATE(7C04H)  ! single value, equivalent to PROP:At[3]
PROP:Height         EQUATE(7C05H)  ! single value, equivalent to PROP:At[4]

PROP:Center         EQUATE(7C06H)  ! 0 = off, else on
PROP:CenterOffSet   EQUATE(7C07H)  ! single value, equivalent to PROP:Center[2]
PROP:Left           EQUATE(7C08H)  ! 0 = off, else on
PROP:LeftOffSet     EQUATE(7C09H)  ! single value, equivalent to PROP:Left[2]
PROP:Decimal        EQUATE(7C0AH)  ! 0 = off, else on
PROP:DecimalOffSet  EQUATE(7C0BH)  ! single value, equivalent to PROP:Decimal[2]
PROP:Right          EQUATE(7C0CH)  ! 0 = off, else on
PROP:RightOffSet    EQUATE(7C0DH)  ! single value, equivalent to PROP:Right[2]

PROP:Above          EQUATE(7C0AH)  ! 0 = off, else on
PROP:AboveSize      EQUATE(7C0BH)  ! single value, equivalent to PROP:Above, 2
PROP:Below          EQUATE(7C06H)  ! 0 = off, else on
PROP:BelowSize      EQUATE(7C07H)  ! single value, equivalent to PROP:Below, 2

PROP:Class          EQUATE(7C0EH)  ! array valued (2 values)
PROP:VBXFile        EQUATE(7C0EH)  ! single value, equivalent to PROP:Class[1]
PROP:VBXName        EQUATE(7C0FH)  ! single value, equivalent to PROP:Class[2]

PROP:Font           EQUATE(7C10H)  ! array valued (4 values)
PROP:FontName       EQUATE(7C10H)  ! single value, equivalent to PROP:Font[1]
PROP:FontSize       EQUATE(7C11H)  ! single value, equivalent to PROP:Font[2]
PROP:FontColor      EQUATE(7C12H)  ! single value, equivalent to PROP:Font[3]
PROP:FontStyle      EQUATE(7C13H)  ! single value, equivalent to PROP:Font[4]

PROP:Range          EQUATE(7C14H)  ! array valued (2 values)
PROP:RangeLow       EQUATE(7C14H)  ! single value, equivalent to PROP:Range[1]
PROP:RangeHigh      EQUATE(7C15H)  ! single value, equivalent to PROP:Range[2]

PROP:VCR            EQUATE(7C16H)  ! 0 = off, else on
PROP:VCRFeq         EQUATE(7C17H)  ! blank, feq, or picture, = PROP:Vcr[2]

PROP:Double         EQUATE(7C19H)  ! 0 = off, else on
PROP:Resize         EQUATE(7C1AH)  ! 0 = off, else on
PROP:NoFrame        EQUATE(7C1BH)  ! 0 = off, else on

PROP:MM             EQUATE(7C1CH)  ! 0 = off, else on
PROP:Thous          EQUATE(7C1DH)  ! 0 = off, else on
PROP:Points         EQUATE(7C1EH)  ! 0 = off, else on  (reports only)
PROP:Pixels         EQUATE(7C1EH)  ! 0 = off, else on  (windows only)

PROP:Sum            EQUATE(7C40H)  ! 0 = off, else on
PROP:Ave            EQUATE(7C41H)  ! 0 = off, else on
PROP:Max            EQUATE(7C42H)  ! 0 = off, else on
PROP:Min            EQUATE(7C43H)  ! 0 = off, else on
PROP:Cnt            EQUATE(7C44H)  ! 0 = off, else on
PROP:PageNo         EQUATE(7C45H)  ! 0 = off, else on
PROP:Page           EQUATE(7C50H)  ! 0 = off, else on


PROP:Absolute       EQUATE(7C51H)  ! 0 = off, else on
PROP:Alone          EQUATE(7C52H)  ! 0 = off, else on
PROP:Preview        EQUATE(7C53H)  ! single queue or queuefield (write-only)
PROP:FlushPreview   EQUATE(7C54H)  ! 0 = off, else on (always 0 at open)
PROP:First          EQUATE(7C55H)  ! 0 = off, else on
PROP:Last           EQUATE(7C56H)  ! 0 = off, else on
PROP:Ins            EQUATE(7C57H)  ! 0 = off, else on
PROP:Ovr            EQUATE(7C58H)  ! 0 = off, else on
PROP:Boxed          EQUATE(7C59H)  ! 0 = off, else on
PROP:Cap            EQUATE(7C5AH)  ! 0 = off, else on
PROP:Column         EQUATE(7C5CH)  ! 0 = off, else column number
PROP:Cursor         EQUATE(7C5DH)  ! single value, empty string if not specifed
PROP:Default        EQUATE(7C5EH)  ! 0 = off, else on
PROP:Disable        EQUATE(7C5FH)  ! 0 = off, else on
PROP:Drop           EQUATE(7C60H)  ! single value, 0 if none (can't change to or from 0)
PROP:Fill           EQUATE(7C61H)  ! single value, COLORnone if none
PROP:From           EQUATE(7C62H)  ! single queue, queuefield or string (write-only)
PROP:Full           EQUATE(7C63H)  ! 0 = off, else on
PROP:Gray           EQUATE(7C64H)  ! 0 = off, else on
PROP:Hide           EQUATE(7C65H)  ! 0 = off, else on
PROP:Hlp            EQUATE(7C66H)  ! single value
PROP:HScroll        EQUATE(7C67H)  ! 0 = off, else on
PROP:Icon           EQUATE(7C68H)  ! single value, empty string if not specified
PROP:Iconize        EQUATE(7C69H)  ! 0 = off, else on
PROP:Imm            EQUATE(7C6AH)  ! 0 = off, else on
PROP:Key            EQUATE(7C6BH)  ! single value
PROP:Landscape      EQUATE(7C6CH)  ! 0 = off, else on
PROP:Mark           EQUATE(7C6DH)  ! single queue, queuefield or array (write-only)
PROP:Mask           EQUATE(7C6EH)  ! 0 = off, else on
PROP:Maximize       EQUATE(7C6FH)  ! 0 = off, else on
PROP:Mdi            EQUATE(7C70H)  ! 0 = off, else on (read only)
PROP:Meta           EQUATE(7C71H)  ! 0 = off, else on
PROP:Modal          EQUATE(7C72H)  ! 0 = off, else on (read only)
PROP:Msg            EQUATE(7C73H)  ! single value
PROP:NoBar          EQUATE(7C74H)  ! 0 = off, else on
PROP:NoMerge        EQUATE(7C75H)  ! 0 = off, else on
PROP:PageAfter      EQUATE(7C77H)  ! 0 = off, else on
PROP:PageAfterNum   EQUATE(7C77H)  ! single value, 0 if absent == pageafter[2]
PROP:PageBefore     EQUATE(7C78H)  ! 0 = off, else on
PROP:PageBeforeNum  EQUATE(7C79H)  ! single value, 0 if absent == pagebefore[2]
PROP:Password       EQUATE(7C7AH)  ! 0 = off, else on
PROP:ReadOnly       EQUATE(7C7BH)  ! 0 = off, else on
PROP:Req            EQUATE(7C7CH)  ! 0 = off, else on
PROP:Reset          EQUATE(7C7DH)  ! single value (nesting depth, or 0)
PROP:Round          EQUATE(7C7EH)  ! 0 = off, else on
PROP:Scroll         EQUATE(7C7FH)  ! 0 = off, else on
PROP:Separate       EQUATE(7C80H)  ! 0 = off, else on
PROP:Skip           EQUATE(7C81H)  ! 0 = off, else on
PROP:Std            EQUATE(7C82H)  ! single value
PROP:Step           EQUATE(7C83H)  ! single value
PROP:System         EQUATE(7C84H)  ! 0 = off, else on
PROP:Format         EQUATE(7C85H)  ! single value
PROP:Timer          EQUATE(7C86H)  ! single value, 0 if none
PROP:Check          EQUATE(7C87H)  ! 0 = off, else on
PROP:Trn            EQUATE(7C88H)  ! 0 = off, else on
PROP:Upr            EQUATE(7C89H)  ! 0 = off, else on

PROP:VScroll        EQUATE(7C8BH)  ! 0 = off, else on
PROP:WithNext       EQUATE(7C8CH)  ! single value, 0 if absent
PROP:WithPrior      EQUATE(7C8DH)  ! single value, 0 if absent
PROP:Items          EQUATE(7C8EH)  ! single value (read only, runtime only)
PROP:Selected       EQUATE(7C8FH)  ! single value (runtime only)
PROP:SelStart       EQUATE(7C8FH)  ! single value (runtime only)
PROP:SelEnd         EQUATE(7C90H)  ! single value (runtime only)
PROP:Auto           EQUATE(7C91H)  ! 0 = off, else on
PROP:ToolBox        EQUATE(7C92H)  ! 0 = off, else on
PROP:Palette        EQUATE(7C93H)  ! single value
PROP:ImageBits      EQUATE(7C94H)  ! string variable (runtime only)
PROP:Thread         EQUATE(7C95H)  ! read only, runtime only
PROP:Handle         EQUATE(7C96H)  ! read only, runtime only
PROP:Active         EQUATE(7C97H)  ! runtime only
PROP:VBXEvent       EQUATE(7C98H)  ! read only, runtime only
PROP:Follows        EQUATE(7C99H)  ! write only, runtime only
PROP:AcceptAll      EQUATE(7C9AH)  ! 0 = off, else on (runtime only, also set by SELECT() and cleared by SELECT(n))
PROP:Touched        EQUATE(7C9BH)  ! 0 = off, else on (runtime only)
PROP:VScrollPos     EQUATE(7C9EH)  ! Scroll thumb position (0-100)
PROP:ClipBits       EQUATE(7C9FH)  ! != 0 Clip image control to clipboard
PROP:Tip            EQUATE(7CA0H)  ! Tool tip text
PROP:ToolTip        EQUATE(PROP:Tip)  ! Old name (deprecated)

PROP:LFNSupport     EQUATE(7CA5H)  ! use long filenames where allowed (16-bit runtime only,system only)
PROP:Progress       EQUATE(7CA6H)  ! progress bar position (runtime only)
PROP:Visible        EQUATE(7CA7H)  ! is control visible (read-only, runtime-only)
PROP:Enabled        EQUATE(7CA8H)  ! is control enabled (read-only, runtime-only)
PROP:Wizard         EQUATE(7CA9H)  ! wizard style sheets
PROP:ChoiceFEQ      EQUATE(7CAAH)  ! current field equate value of a choice in sheet, option
PROP:ClientHandle   EQUATE(7CABH)  ! client window handle (read-only, runtime only)
PROP:LineCount      EQUATE(7CACH)  ! lines of text in a TEXT control (read-only, runtime only)
PROP:MinWidth       EQUATE(7CADH)  ! window's minimum width (runtime only)
PROP:MinHeight      EQUATE(7CAEH)  ! window's minimum height (runtime only)
PROP:MaxWidth       EQUATE(7CAFH)  ! window's maximum width (runtime only)
PROP:MaxHeight      EQUATE(7CB0H)  ! window's maximum height (runtime only)
PROP:NoTips         EQUATE(7CB1H)  ! Disable tooltips on system/window/control (runtime only)
PROP:TipDelay       EQUATE(7CB2H)  ! Delay before tips appear (16-bit runtime only, system only)
PROP:TipDisplay     EQUATE(7CB3H)  ! Time for which tips are displayed (16-bit runtime only, system only)
PROP:WNDProc        EQUATE(7CB4H)  ! Window procedure set/get (for PROP:Handle)
PROP:ClientWNDProc  EQUATE(7CB5H)  ! Window procedure set/get (for PROP:Clienthandle)
PROP:ImageBlob      EQUATE(7CB6H)  ! BLOB handle (runtime only)
PROP:Spread         EQUATE(7CB7H)  ! SPREAD attribute
PROP:Size           EQUATE(7CB9H)  ! For a BLOB
PROP:ScreenText     EQUATE(7CBAH)  ! May differ from PROP:Text for eg ENTRY
PROP:HScrollPos     EQUATE(7CBBH)  ! Horizontal scroll position
PROP:LazyDisplay    EQUATE(7CBCH)  ! Don't force update immediately
PROP:DeferMove      EQUATE(7CBDH)  ! Delay window positioning
PROP:AppInstance    EQUATE(7CBEH)  ! HINSTANCE of exe file (read only)
PROP:Value          EQUATE(7CBFH)  ! value for a radio or tab to assign to use.
                                   ! or array valued for a check
PROP:TrueValue      EQUATE(7CBFH)  ! value for check radio to assign to use.
PROP:FalseValue     EQUATE(7CC0H)  ! value for a check to assign to use.
PROP:DDETimeOut     EQUATE(7CC1H)  ! DDE timeout, in sec/100 (system property)
PROP:TabRows        EQUATE(7CC2H)  ! Num rows in a tab (read only)
PROP:NumTabs        EQUATE(7CC3H)  ! Num tabs owned by a sheet (read only)
PROP:LibVersion     EQUATE(7CC4H)  ! runtime library version
PROP:ExeVersion     EQUATE(7CC5H)  ! executable file version

PROP:Create          EQUATE(7CC6H) ! create new ole object
PROP:SaveAs          EQUATE(7CC7H)
PROP:Open            EQUATE(7CC8H)
PROP:Blob            EQUATE(7CC9H)
PROP:DoVerb          EQUATE(7CCAH) ! activate Ole Object
PROP:SizeMode        EQUATE(7CCBH) ! controls the way not runnung object is displayed
PROP:SelectInterface EQUATE(7CCCH) ! Select current ole interface
PROP:AddRef          EQUATE(7CCDH) ! Increment referenc count
PROP:Release         EQUATE(7CCEH) ! Decrement referenc count
PROP:Deactivate      EQUATE(7CCFH) ! deactivate object
PROP:Update          EQUATE(7CD0H) ! update object
PROP:Paste           EQUATE(7CD1H) ! embed object from clipboard
PROP:ReportException EQUATE(7CD2H) ! pop up ole exceptions
PROP:PasteLink       EQUATE(7CD3H) ! create link from clipboard
PROP:Copy            EQUATE(7CD4H) ! copy object to clipboard
PROP:CanPaste        EQUATE(7CD5H)
PROP:CanPasteLink    EQUATE(7CD6H)
PROP:WindowUI        EQUATE(7CD7H)
PROP:DesignMode      EQUATE(7CD8H)
PROP:Ctrl            EQUATE(7CD9H)
PROP:GrabHandles     EQUATE(7CDAH)
PROP:OLE             EQUATE(7CDBH)
PROP:IsRadio         EQUATE(7CDCH)
PROP:LastEventName   EQUATE(7CDDH)
PROP:CLSID           EQUATE(7CDEH)
PROP:ProgID          EQUATE(7CDFH)

PROP:BevelStyle     EQUATE(7CE0H)  ! kind of bevel for boxes

PROP:Join           EQUATE(7CE2H)  ! Join < > buttons
PROP:NoSheet        EQUATE(7CE3H)  ! Just display the tabs - no sheet
PROP:Bevel          EQUATE(7CE4h)  ! Array of 2 values
PROP:BevelOuter     EQUATE(7CE4H)  ! Size, direction of outer bevel == PROP:Bevel[1]
PROP:BevelInner     EQUATE(7CE5H)  ! Size, direction of inner bevel == PROP:Bevel[2]
PROP:LineWidth      EQUATE(7CE7H)  ! Pen width for a BOX or LINE
PROP:Angle          EQUATE(7CE9H)  ! Angle of text for a string control

PROP:AutoSize       EQUATE(7CEAH)  !
PROP:Clip           EQUATE(7CEBH)  !
PROP:Stretch        EQUATE(7CECH)  !
PROP:Zoom           EQUATE(7CEDH)  !
PROP:Compatibility  EQUATE(7CEEH)  !
PROP:Design         EQUATE(7CEFH)  !
PROP:Document       EQUATE(7CF0H)  ! create ole object from file (like x.doc i.e. a word document)
PROP:Link           EQUATE(7CF1H) ! as above but link
PROP:CreateFromFile   EQUATE(PROP:Document)  ! Compatability
PROP:CreateLinkToFile EQUATE(PROP:Link)      !
PROP:Align          EQUATE(7CF2H) ! vb ocx align
PROP:Cancel         EQUATE(7CF3H) ! vb ocx cancel
PROP:TextAlign      EQUATE(7CF4H) ! vb ocx ambient property 0-number right text left, 1-left, 2-center, 3-right 4-sustify
PROP:Object         EQUATE(7CF5H)
PROP:License        EQUATE(7CF6H)
PROP:Language       EQUATE(7CF8H)

PROP:Color          EQUATE(7CFAH)  ! up to three components (see below)
PROP:Background     EQUATE(7CFAH)  ! For compatibility
PROP:FillColor      EQUATE(7CFAH)  ! = PROP:Color[1]  single value, COLORnone if none
PROP:SelectedColor  EQUATE(7CFBH)  ! = PROP:Color[2]  single value, COLORnone if none
PROP:SelectedFillColor EQUATE(7CFCH)  ! = PROP:Color[3] single value, COLORnone if none
PROP:LineHeight     EQUATE(7CFDH)  ! Height of a line in a list box
PROP:DropWidth      EQUATE(7CFEH)  ! Width of a drop box
PROP:AlwaysDrop     EQUATE(7CFFH)  ! Drop control always displays the list on selection change

PROP:Up             EQUATE(7A00H)  ! Different orientations of text in a sheet
PROP:Down           EQUATE(7A01H)  ! control
PROP:UpsideDown     EQUATE(7A02H)
PROP:HeaderHeight   EQUATE(7A03H)  ! (Read-only) Height of the header on a list box
PROP:Checked        EQUATE(7A04H)  ! (Read-only) Is a check box set?
PROP:AutoPaper      EQUATE(7A05H)  ! Report engine automatically picks best paper size
PROP:Single         EQUATE(7A06H)  ! Single line text box (for Hebrew/Arabic support)
PROP:Parent         EQUATE(7A07H)  ! Field equate of parent control
PROP:Repeat         EQUATE(7A08H)  ! Repeat rate of IMM button
PROP:EventsWaiting  EQUATE(7A09H)  ! Does this window have any further events pending?
PROP:DDEmode        EQUATE(7A0AH)  ! 0 = normal, 1 = events to top window of thread, other values reserved
PROP:Threading      EQUATE(7A0BH)  ! Set to 0 to disable all threading in APP (forces SDI behaviour)
PROP:TempNameFunc   EQUATE(7A0CH)  ! Set to address of a function(signed),STRING
PROP:Delay          EQUATE(7A0FH)  ! Delay before IMM button repeats

PROP:BreakVar       EQUATE(7A10H)  ! Used to set break variable for BREAK structure in report
PROP:Use            EQUATE(7A10H)  ! Array valued: ! PROP:Use or PROP:Use,1 sets use variable
PROP:FEQ            EQUATE(7A11H)  ! PROP:Feq or PROP:Use,2 sets feq number
PROP:ListFEQ        EQUATE(7A12H)  ! PROP:Listfeq or PROP:Use,3 sets feq of list part of combo/drop
PROP:ButtonFEQ      EQUATE(7A13H)  ! PROP:Buttonfeq or PROP:Use,4 sets feq of button part of combo/drop
PROP:Flat           EQUATE(7A14H)  ! Explorer 3.0 style buttons

PROP:WallPaper      EQUATE(7A15H)  ! Background image of a window
PROP:Tiled          EQUATE(7A16H)  ! Should we tile background image?
PROP:Centered       EQUATE(7A17H)  ! Should we center background image?
PROP:TileImage      EQUATE(PROP:Tiled)    ! For C4B1 compatibility only
PROP:CenterImage    EQUATE(PROP:Centered) ! For C4B1 compatibility only

PROP:ChildIndex     EQUATE(7A18H)  ! Reverse of PROPchild,nn
PROP:InToolBar      EQUATE(7A19H)  ! Is this control on the toolbar?
PROP:PrintMode      EQUATE(7A1AH)  ! How do images print?
PROP:RejectCode     EQUATE(7A1BH)  ! If/why entry control was invalid
PROP:VLBProc        EQUATE(7A1CH)  ! "Virtual list box" proc address
PROP:VLBVal         EQUATE(7A1DH)  ! "Virtual list box" proc user id
PROP:TempImage      EQUATE(7A1EH)  ! Dumps image into temp file, returns name (read only)

PROP:TempPath       EQUATE(7A20H)  ! Array valued (2 defined so far)
PROP:TempPagePath   EQUATE(7A20H)  ! Equivalent to {PROP:Temppath, 1}
PROP:TempImagePath  EQUATE(7A21H)  ! Equivalent to {PROP:Temppath, 2}

PROP:LibHook        EQUATE(7A30H)  ! Array valued (9 defined so far)
PROP:ColorDialogHook EQUATE(7A30H)  ! Equivalent to {PROP:Libhook, 1}
PROP:FileDialogHook EQUATE(7A31H)  ! Equivalent to {PROP:Libhook, 2}
PROP:FontDialogHook EQUATE(7A32H)  ! Equivalent to {PROP:Libhook, 3}
PROP:PrinterDialogHook EQUATE(7A33H)  ! Equivalent to {PROP:Libhook, 4}
PROP:HaltHook       EQUATE(7A34H)  ! Equivalent to {PROP:Libhook, 5}
PROP:MessageHook    EQUATE(7A35H)  ! Equivalent to {PROP:Libhook, 6}
PROP:StopHook       EQUATE(7A36H)  ! Equivalent to {PROP:Libhook, 7}
PROP:AssertHook     EQUATE(7A37H)  ! Equivalent to {PROP:Libhook, 8}
PROP:FatalErrorHook EQUATE(7A38H)  ! Equivalent to {PROP:Libhook, 9}

PROP:CharSet        EQUATE(7A39H)  ! default charset - SYSTEM property
PROP:FontCharSet    EQUATE(7A3AH)  ! font charset - FONT subattribute

PROP:SystemPropHook EQUATE(7A3BH)  ! Equivalent to {PROP:libhook, 12}
PROP:AssertHook2    EQUATE(7A3CH)  ! Equivalent to {PROP:libhook, 13}
PROP:InitAStringHook EQUATE(7A3DH)  ! Equivalent to {PROP:libhook, 14}


PROP:NoWidth        EQUATE(7A40H)  ! was a width specified?
PROP:NoHeight       EQUATE(7A41H)  ! was a height specified?
PROP:NextPageNo     EQUATE(7A42H)  ! next page number in report
PROP:XOrigin        EQUATE(7A43H)  ! how much is screen/image scrolled by?
PROP:YOrigin        EQUATE(7A44H)  ! how much is screen/image scrolled by?
PROP:Target         EQUATE(7A45H)  ! reference to current target window
PROP:Together       EQUATE(7A46H)  ! don't split this detail

PROP:Dock           EQUATE(7A47H)  ! permitted dock sites
PROP:Docked         EQUATE(7A48H)  ! current dock site
PROP:BrokenTabs     EQUATE(7A49H)  ! draw tabs broken?
PROP:ImageInstance  EQUATE(7A4AH)  ! HINSTANCE of exe/dll for linked-in image files
PROP:GlobalHelp     EQUATE(7A4BH)  ! Help stays open when windows close
PROP:Buffer         EQUATE(7A4CH)  ! Buffer window repaints (less flicker, but more memory)
PROP:clientx        EQUATE(7A4DH)  ! position of client area
PROP:clienty        EQUATE(7A4EH)  ! position of client area
PROP:clientwidth    EQUATE(7A4FH)  ! size of client area
PROP:clientheight   EQUATE(7A50H)  ! size of client area
PROP:ClipASTRINGs   EQUATE(7A51H)  ! ASTRINGs auto-clipped


PROP:Status         EQUATE(7D00H)  ! array valued
PROP:StatusText     EQUATE(7D01H)  ! array valued
PROP:DragID         EQUATE(7D02H)  ! array valued
PROP:DropID         EQUATE(7D03H)  ! array valued
PROP:VBXEventArg    EQUATE(7D04H)  ! array valued
PROP:Edit           EQUATE(7D05H)  ! array valued
PROP:Alrt           EQUATE(7D06H)  ! array valued
PROP:IconList       EQUATE(7D07H)  ! array valued
PROP:Line           EQUATE(7D08H)  ! array valued, TEXT control line contents (read-only, runtime only)
PROP:Tally          EQUATE(7D09H)  ! array valued, tally attribut on report string control
PROP:Child          EQUATE(7D0AH)  ! array valued, iterate through immediate children
PROP:NextField      EQUATE(7D0BH)  ! array valued, iterate through all children of a window
                                   ! NB order is NOT defined.
PROP:SnapWidth      EQUATE(7D0CH)  ! array valued
PROP:SnapHeight     EQUATE(7D0DH)  ! array valued

PROPSTYLE:First     EQUATE(7D10H)
PROPSTYLE:FontName  EQUATE(7D10H)  ! array valued
PROPSTYLE:FontSize  EQUATE(7D11H)  ! array valued
PROPSTYLE:FontColor EQUATE(7D12H)  ! array valued
PROPSTYLE:FontStyle EQUATE(7D13H)  ! array valued
PROPSTYLE:TextColor    EQUATE (7D14H) ! array valued (same as fontcolor)
PROPSTYLE:BackColor    EQUATE (7D15H) ! array valued
PROPSTYLE:TextSelected EQUATE (7D16H) ! array valued
PROPSTYLE:BackSelected EQUATE (7D17H) ! array valued
PROPSTYLE:Picture   EQUATE(7D18H)  ! array valued
PROPSTYLE:CharSet   EQUATE(7D19H)  ! array valued
PROPSTYLE:Last      EQUATE(7D3FH)

PROPLIST:Underline      EQUATE (7E00H)
PROPLIST:Resize         EQUATE (7E01H)
PROPLIST:RightBorder    EQUATE (7E02H)
PROPLIST:Header         EQUATE (7E03H)
PROPLIST:width          EQUATE (7E04H)
PROPLIST:Picture        EQUATE (7E05H)
PROPLIST:Fixed          EQUATE (7E06H)
PROPLIST:Scroll         EQUATE (7E07H)
PROPLIST:LastOnLine     EQUATE (7E08H)
PROPLIST:Locator        EQUATE (7E09H)
PROPLIST:Exists         EQUATE (7E0AH)
PROPLIST:Resvd2         EQUATE (7E0BH)
PROPLIST:Resvd3         EQUATE (7E0CH)
PROPLIST:GroupNo        EQUATE (7E0DH)
PROPLIST:FieldNo        EQUATE (7E0EH)
PROPLIST:Format         EQUATE (7E0FH)

PROPLIST:Left           EQUATE (7E10H)
PROPLIST:LeftOffset     EQUATE (7E11H)
PROPLIST:Right          EQUATE (7E12H)
PROPLIST:RightOffset    EQUATE (7E13H)
PROPLIST:Center         EQUATE (7E14H)
PROPLIST:CenterOffset   EQUATE (7E15H)
PROPLIST:Decimal        EQUATE (7E16H)
PROPLIST:DecimalOffset  EQUATE (7E17H)

PROPLIST:HeaderLeft           EQUATE (7E18H)
PROPLIST:HeaderLeftOffset     EQUATE (7E19H)
PROPLIST:HeaderRight          EQUATE (7E1AH)
PROPLIST:HeaderRightOffset    EQUATE (7E1BH)
PROPLIST:HeaderCenter         EQUATE (7E1CH)
PROPLIST:HeaderCenterOffset   EQUATE (7E1DH)
PROPLIST:HeaderDecimal        EQUATE (7E1EH)
PROPLIST:HeaderDecimalOffset  EQUATE (7E1FH)

PROPLIST:Icon           EQUATE (7E20H) ! Corresponds to 'I' in the format string
PROPLIST:Color          EQUATE (7E21H)
PROPLIST:Tree           EQUATE (7E22H)
PROPLIST:TreeLines      EQUATE (7E23H)
PROPLIST:TreeBoxes      EQUATE (7E24H)
PROPLIST:TreeIndent     EQUATE (7E25H)
PROPLIST:TreeOffset     EQUATE (7E26H)
PROPLIST:TreeRoot       EQUATE (7E27H)
PROPLIST:DefColors      EQUATE (7E28H) ! up to four components (see below)
PROPLIST:TextColor      EQUATE (7E28H) ! Column text color
PROPLIST:BackColor      EQUATE (7E29H) ! Column background color
PROPLIST:TextSelected   EQUATE (7E2AH) ! Column text color when highlighted
PROPLIST:BackSelected   EQUATE (7E2BH) ! Column background color when highlighted
PROPLIST:CellStyle      EQUATE (7E2CH) ! Per-cell style attribute
PROPLIST:ColStyle       EQUATE (7E2DH) ! Per-column style value
PROPLIST:IconTrn        EQUATE (7E2EH) ! Transparent Icon Corresponds to 'J' in the format string (mutually exclusive with PROPLIST:Icon)


PROPLIST:Group          EQUATE (0040H)  ! add to PROPLIST property above
PROPLIST:Style          EQUATE (0080H)  ! add to PROPLIST property above

PROPLIST:MouseDownRow   EQUATE (7C20H)
PROPLIST:MouseMoveRow   EQUATE (7C21H)
PROPLIST:MouseUpRow     EQUATE (7C22H)
PROPLIST:MouseDownField EQUATE (7C23H)
PROPLIST:MouseMoveField EQUATE (7C24H)
PROPLIST:MouseUpField   EQUATE (7C25H)
PROPLIST:MouseDownZone  EQUATE (7C26H)
PROPLIST:MouseMoveZone  EQUATE (7C27H)
PROPLIST:MouseUpZone    EQUATE (7C28H)
PROPLIST:Grid           EQUATE (7C29H)
PROPLIST:BarColor       EQUATE (7C29H)  ! for compatibility with 1.5 apps

! File Properties
PROP:CurrentKey         EQUATE (7300H)  ! Get current sequential or build key
PROP:Logout             EQUATE (7301H)  ! Get/Set files logout status
PROP:Log                EQUATE (7302H)  ! Add a line to the file profile
PROP:Profile            EQUATE (7303H)  ! Set file profiling
PROP:Details            EQUATE (7329H)  ! Set tracing of record buffer
PROP:Watched            EQUATE (7304H)  ! Get record watch status
PROP:Held               EQUATE (7305H)  ! Get record hold status
PROP:ProgressEvents     EQUATE (7306H)  ! Set amount of events for BUILD
PROP:Completed          EQUATE (7307H)  ! Get BUILD completed status
PROP:Driver             EQUATE (730DH)  ! Get name of file driver
PROP:DriverLogsoutAlias EQUATE (730EH)  ! Get the capacity of LOGOUT
PROP:Keys               EQUATE (730FH)  ! Get number of keys in file
PROP:Blobs              EQUATE (7310H)  ! Get number of blobs in file
PROP:Memos              EQUATE (7311H)  ! Get number of memos in file
PROP:Fields             EQUATE (7312H)  ! Get number of fields in file (group)
PROP:Encrypt            EQUATE (7313H)  ! Get encrypt status
PROP:DriverString       EQUATE (7314H)  ! Get driver string
PROP:Owner              EQUATE (7315H)  ! Get Owner
PROP:Name               EQUATE (7316H)  ! Get file/key/memo/blob/field's name
PROP:Label              EQUATE (7317H)  ! Get file/key/memo/blob/field's label
PROP:OEM                EQUATE (7318H)  ! Get OEM attribute
PROP:Reclaim            EQUATE (7319H)  ! Get Reclaim attribute
PROP:SQLDriver          EQUATE (7344H)  ! '1' = Driver is SQL aware
PROP:FileSize           EQUATE (7347H)  ! Get the size of the file
PROP:SupportsOp         EQUATE (7348H)  ! Get which functions are supported
PROP:SupportsType       EQUATE (7349H)  ! Get which data types are supported

! Key Properies
PROP:Components         EQUATE (731AH)  ! Get number of key components
PROP:Dup                EQUATE (731BH)  ! Get DUP attribute
PROP:Opt                EQUATE (731CH)  ! Get OPT attribute
PROP:NoCase             EQUATE (731DH)  ! Get NOCASE attribute
PROP:Primary            EQUATE (731EH)  ! Get PRIMARY attribute

! Key Component Properies
PROP:Field              EQUATE (731FH)  ! Get Field number of key component n
PROP:Ascending          EQUATE (7320H)  ! Get order of key component n

! Memo Properties
PROP:Binary             EQUATE (7321H)  ! Get BINARY attribute of memo -n or blob

! Field Properties
PROP:Places             EQUATE (7322H)  ! Get Number of decimal places for field n
PROP:Dim                EQUATE (7323H)  ! Get Number of dimensions
PROP:Over               EQUATE (7324H)  ! Get the field number of the field
                                        ! this field is over
! View Properties
PROP:Order              EQUATE (7CE6H)  ! Set the order of a VIEW
PROP:Filter             EQUATE (7CB8H)  ! Set the filter of a VIEW
PROP:JoinExpression     EQUATE (7212H)  ! Set the join expression
PROP:Files              EQUATE (7325H)  ! Get number of files in view
PROP:File               EQUATE (7326H)  ! Get reference to n'th File
PROP:ProfileIntoFiles   EQUATE (7327H)  ! Set profiling of file calls from view engine
PROP:Inner              EQUATE (7328H)  ! Get/Set inner attribute of n'th join

! SQL Drivers Properties
PROP:SQL                EQUATE (7200H)
PROP:OrderAllTables     EQUATE (7211H)
PROP:SQLFilter          EQUATE (7221H)
PROP:LogFile            EQUATE (7222H)
PROP:Where              EQUATE (7223H)
PROP:FetchSize          EQUATE (7341H)
PROP:Alias              EQUATE (7244H)
PROP:Disconnect         EQUATE (7245H)
PROP:SQLOrder           EQUATE (7248H)
PROP:SQLJoinExpression  EQUATE (7249H)

! Oracle and MS SQL Driver Properties
PROP:Hint               EQUATE (7241H)

! Btrieve, AS/400, MS SQL, ODBC, SQLAnyWhere and Pervasive.SQL Driver Properties
PROP:AppendBuffer       EQUATE (7342H)

! ODBC Driver Properties
PROP:ConnectString      EQUATE (7201H)
PROP:LoginTimeOut       EQUATE (7202H)
PROP:HENV               EQUATE (7203H)
PROP:HDBC               EQUATE (7204H)
PROP:HSTMT              EQUATE (7205H)
PROP:OrderInSelect      EQUATE (7206H)
PROP:QuoteString        EQUATE (7243H)
PROP:LogonScreen        EQUATE (7246H)
PROP:AlwaysRebind       EQUATE (7247H)

! AS/400, MS SQL, ODBC, SQLAnyWhere and Pervasive.SQL Driver Properties
PROP:DBMSver            EQUATE (724AH)
PROP:IsolationLevel     EQUATE (724BH)
PROP:MaxStatements      EQUATE (724CH)

! TopSpeed Driver Properties
PROP:FullBuild          EQUATE (7230H)

! Btrieve Driver Properties
PROP:PositionBlock      EQUATE (7343H)
