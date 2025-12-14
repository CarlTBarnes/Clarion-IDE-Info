!----------------------------------------------------------
! Built-in property constants for CW
!----------------------------------------------------------*/


PROP:text           EQUATE(7C00H)  ! single value (parameter to control itself)
PROP:type           EQUATE(7C01H)  ! single value (CREATE:xxxx)
PROP:at             EQUATE(7C02H)  ! array valued (4 values)
PROP:xpos           EQUATE(7C02H)  ! single value, equivalent to PROP:at[1]
PROP:ypos           EQUATE(7C03H)  ! single value, equivalent to PROP:at[2]
PROP:width          EQUATE(7C04H)  ! single value, equivalent to PROP:at[3]
PROP:height         EQUATE(7C05H)  ! single value, equivalent to PROP:at[4]

PROP:center         EQUATE(7C06H)  ! 0 = off, else on
PROP:centeroffset   EQUATE(7C07H)  ! single value, equivalent to PROP:center[2]
PROP:left           EQUATE(7C08H)  ! 0 = off, else on
PROP:leftoffset     EQUATE(7C09H)  ! single value, equivalent to PROP:left[2]
PROP:decimal        EQUATE(7C0AH)  ! 0 = off, else on
PROP:decimaloffset  EQUATE(7C0BH)  ! single value, equivalent to PROP:decimal[2]
PROP:right          EQUATE(7C0CH)  ! 0 = off, else on
PROP:rightoffset    EQUATE(7C0DH)  ! single value, equivalent to PROP:right[2]

PROP:above          EQUATE(7C0AH)  ! 0 = off, else on
PROP:below          EQUATE(7C06H)  ! 0 = off, else on

PROP:class          EQUATE(7C0EH)  ! array valued (2 values)
PROP:vbxfile        EQUATE(7C0EH)  ! single value, equivalent to PROP:class[1]
PROP:vbxname        EQUATE(7C0FH)  ! single value, equivalent to PROP:class[2]

PROP:font           EQUATE(7C10H)  ! array valued (4 values)
PROP:fontname       EQUATE(7C10H)  ! single value, equivalent to PROP:font[1]
PROP:fontsize       EQUATE(7C11H)  ! single value, equivalent to PROP:font[2]
PROP:fontcolor      EQUATE(7C12H)  ! single value, equivalent to PROP:font[3]
PROP:fontstyle      EQUATE(7C13H)  ! single value, equivalent to PROP:font[4]

PROP:range          EQUATE(7C14H)  ! array valued (2 values)
PROP:rangelow       EQUATE(7C14H)  ! single value, equivalent to PROP:range[1]
PROP:rangehigh      EQUATE(7C15H)  ! single value, equivalent to PROP:range[2]

PROP:vcr            EQUATE(7C16H)  ! 0 = off, else on
PROP:vcrfeq         EQUATE(7C17H)  ! blank, feq, or picture, = PROP:vcr[2]

PROP:double         EQUATE(7C19H)  ! 0 = off, else on
PROP:resize         EQUATE(7C1AH)  ! 0 = off, else on
PROP:noframe        EQUATE(7C1BH)  ! 0 = off, else on

PROP:mm             EQUATE(7C1CH)  ! 0 = off, else on
PROP:thous          EQUATE(7C1DH)  ! 0 = off, else on
PROP:points         EQUATE(7C1EH)  ! 0 = off, else on  (reports only)
PROP:pixels         EQUATE(7C1EH)  ! 0 = off, else on  (windows only)

PROP:sum            EQUATE(7C40H)  ! 0 = off, else on
PROP:ave            EQUATE(7C41H)  ! 0 = off, else on
PROP:max            EQUATE(7C42H)  ! 0 = off, else on
PROP:min            EQUATE(7C43H)  ! 0 = off, else on
PROP:cnt            EQUATE(7C44H)  ! 0 = off, else on
PROP:pageno         EQUATE(7C45H)  ! 0 = off, else on
PROP:page           EQUATE(7C50H)  ! 0 = off, else on


PROP:absolute       EQUATE(7C51H)  ! 0 = off, else on
PROP:alone          EQUATE(7C52H)  ! 0 = off, else on
PROP:preview        EQUATE(7C53H)  ! single queue or queuefield (write-only)
PROP:flushpreview   EQUATE(7C54H)  ! 0 = off, else on (always 0 at open)
PROP:first          EQUATE(7C55H)  ! 0 = off, else on
PROP:last           EQUATE(7C56H)  ! 0 = off, else on
PROP:ins            EQUATE(7C57H)  ! 0 = off, else on
PROP:ovr            EQUATE(7C58H)  ! 0 = off, else on
PROP:boxed          EQUATE(7C59H)  ! 0 = off, else on
PROP:cap            EQUATE(7C5AH)  ! 0 = off, else on
PROP:column         EQUATE(7C5CH)  ! 0 = off, else column number
PROP:cursor         EQUATE(7C5DH)  ! single value, empty string if not specifed
PROP:default        EQUATE(7C5EH)  ! 0 = off, else on
PROP:disable        EQUATE(7C5FH)  ! 0 = off, else on
PROP:drop           EQUATE(7C60H)  ! single value, 0 if none (can't change to or from 0)
PROP:fill           EQUATE(7C61H)  ! single value, COLORnone if none
PROP:from           EQUATE(7C62H)  ! single queue, queuefield or string (write-only)
PROP:full           EQUATE(7C63H)  ! 0 = off, else on
PROP:gray           EQUATE(7C64H)  ! 0 = off, else on
PROP:hide           EQUATE(7C65H)  ! 0 = off, else on
PROP:hlp            EQUATE(7C66H)  ! single value
PROP:hscroll        EQUATE(7C67H)  ! 0 = off, else on
PROP:icon           EQUATE(7C68H)  ! single value, empty string if not specified
PROP:iconize        EQUATE(7C69H)  ! 0 = off, else on
PROP:imm            EQUATE(7C6AH)  ! 0 = off, else on
PROP:key            EQUATE(7C6BH)  ! single value
PROP:landscape      EQUATE(7C6CH)  ! 0 = off, else on
PROP:mark           EQUATE(7C6DH)  ! single queue, queuefield or array (write-only)
PROP:mask           EQUATE(7C6EH)  ! 0 = off, else on
PROP:maximize       EQUATE(7C6FH)  ! 0 = off, else on
PROP:mdi            EQUATE(7C70H)  ! 0 = off, else on (read only)
PROP:meta           EQUATE(7C71H)  ! 0 = off, else on
PROP:modal          EQUATE(7C72H)  ! 0 = off, else on (read only)
PROP:msg            EQUATE(7C73H)  ! single value
PROP:nobar          EQUATE(7C74H)  ! 0 = off, else on
PROP:nomerge        EQUATE(7C75H)  ! 0 = off, else on
PROP:pageafter      EQUATE(7C77H)  ! 0 = off, else on
PROP:pageafternum   EQUATE(7C77H)  ! single value, 0 if absent == pageafter[2]
PROP:pagebefore     EQUATE(7C78H)  ! 0 = off, else on
PROP:pagebeforenum  EQUATE(7C79H)  ! single value, 0 if absent == pagebefore[2]
PROP:password       EQUATE(7C7AH)  ! 0 = off, else on
PROP:readonly       EQUATE(7C7BH)  ! 0 = off, else on
PROP:req            EQUATE(7C7CH)  ! 0 = off, else on
PROP:reset          EQUATE(7C7DH)  ! single value (nesting depth, or 0)
PROP:round          EQUATE(7C7EH)  ! 0 = off, else on
PROP:scroll         EQUATE(7C7FH)  ! 0 = off, else on
PROP:separate       EQUATE(7C80H)  ! 0 = off, else on
PROP:skip           EQUATE(7C81H)  ! 0 = off, else on
PROP:std            EQUATE(7C82H)  ! single value
PROP:step           EQUATE(7C83H)  ! single value
PROP:system         EQUATE(7C84H)  ! 0 = off, else on
PROP:format         EQUATE(7C85H)  ! single value
PROP:timer          EQUATE(7C86H)  ! single value, 0 if none
PROP:check          EQUATE(7C87H)  ! 0 = off, else on
PROP:trn            EQUATE(7C88H)  ! 0 = off, else on
PROP:upr            EQUATE(7C89H)  ! 0 = off, else on
PROP:use            EQUATE(7C8AH)  ! single variable value, write only
PROP:vscroll        EQUATE(7C8BH)  ! 0 = off, else on
PROP:withnext       EQUATE(7C8CH)  ! single value, 0 if absent
PROP:withprior      EQUATE(7C8DH)  ! single value, 0 if absent
PROP:items          EQUATE(7C8EH)  ! single value (read only, runtime only)
PROP:selected       EQUATE(7C8FH)  ! single value (runtime only)
PROP:selstart       EQUATE(7C8FH)  ! single value (runtime only)
PROP:selend         EQUATE(7C90H)  ! single value (runtime only)
PROP:auto           EQUATE(7C91H)  ! 0 = off, else on
PROP:toolbox        EQUATE(7C92H)  ! 0 = off, else on
PROP:palette        EQUATE(7C93H)  ! single value
PROP:imagebits      EQUATE(7C94H)  ! string variable (runtime only)
PROP:thread         EQUATE(7C95H)  ! read only, runtime only
PROP:handle         EQUATE(7C96H)  ! read only, runtime only
PROP:active         EQUATE(7C97H)  ! runtime only
PROP:vbxevent       EQUATE(7C98H)  ! read only, runtime only
PROP:follows        EQUATE(7C99H)  ! write only, runtime only
PROP:acceptall      EQUATE(7C9AH)  ! 0 = off, else on (runtime only, also set by SELECT() and cleared by SELECT(n))
PROP:touched        EQUATE(7C9BH)  ! 0 = off, else on (runtime only)
PROP:vscrollpos     EQUATE(7C9EH)  ! Scroll thumb position (0-100)
PROP:clipbits       EQUATE(7C9FH)  ! != 0 Clip image control to clipboard
PROP:tooltip        EQUATE(7CA0H)  ! Tool tip text

PROP:progress       EQUATE(7CA6H)  ! progress bar position (runtime only)
PROP:visible        EQUATE(7CA7H)  ! is control visible (read-only, runtime-only)
PROP:enabled        EQUATE(7CA8H)  ! is control enabled (read-only, runtime-only)
PROP:wizard         EQUATE(7CA9H)  ! wizard style sheets
PROP:choicefeq      EQUATE(7CAAH)  ! current field equate value of a choice in sheet, option
PROP:clienthandle   EQUATE(7CABH)  ! client window handle (read-only, runtime only)
PROP:linecount      EQUATE(7CACH)  ! lines of text in a TEXT control (read-only, runtime only)
PROP:minwidth       EQUATE(7CADH)  ! window's minimum width (runtime only)
PROP:minheight      EQUATE(7CAEH)  ! window's minimum height (runtime only)
PROP:maxwidth       EQUATE(7CAFH)  ! window's maximum width (runtime only)
PROP:maxheight      EQUATE(7CB0H)  ! window's maximum height (runtime only)
PROP:notips         EQUATE(7CB1H)  ! Disable tooltips on system/window/control (runtime only)
PROP:tipdelay       EQUATE(7CB2H)  ! Delay before tips appear (16-bit runtime only, system only)
PROP:tipdisplay     EQUATE(7CB3H)  ! Time for which tips are displayed (16-bit runtime only, system only)
PROP:wndproc        EQUATE(7CB4H)  ! Window procedure set/get (for PROP:handle)
PROP:clientwndproc  EQUATE(7CB5H)  ! Window procedure set/get (for PROP:clienthandle)
PROP:imageblob      EQUATE(7CB6H)  ! BLOB handle (runtime only)
PROP:spread         EQUATE(7CB7H)  ! SPREAD attribute
PROP:filter         EQUATE(7CB8H)  ! Set the filter of a VIEW
PROP:size           EQUATE(7CB9H)  ! For a BLOB
PROP:screentext     EQUATE(7CBAH)  ! May differ from PROP:text for eg ENTRY
PROP:hscrollpos     EQUATE(7CBBH)  ! Horizontal scroll position
PROP:lazydisplay    EQUATE(7CBCH)  ! Don't force update immediately
PROP:defermove      EQUATE(7CBDH)  ! Delay window positioning
PROP:appinstance    EQUATE(7CBEH)  ! HINSTANCE of exe file (read only)
PROP:value          EQUATE(7CBFH)  ! value for a radio or tab to assign to use.
                                   ! or array valued for a check
PROP:truevalue      EQUATE(7CBFH)  ! value for check radio to assign to use.
PROP:falsevalue     EQUATE(7CC0H)  ! value for a check to assign to use.
PROP:DDEtimeout     EQUATE(7CC1H)  ! DDE timeout, in sec/100 (system property)
PROP:tabrows        EQUATE(7CC2H)  ! Num rows in a tab (read only)
PROP:numtabs        EQUATE(7CC3H)  ! Num tabs owned by a sheet (read only)
PROP:libversion     EQUATE(7CC4H)  ! runtime library version
PROP:exeversion     EQUATE(7CC5H)  ! executable file version

PROP:create          EQUATE(7CC6H) ! create new ole object
PROP:saveas          EQUATE(7CC7H)
PROP:open            EQUATE(7CC8H)
PROP:blob            EQUATE(7CC9H)
PROP:doverb          EQUATE(7CCAH) ! activate Ole Object
PROP:sizemode        EQUATE(7CCBH) ! controls the way not runnung object is displayed
PROP:selectinterface EQUATE(7CCCH) ! Select currnet ole interface
PROP:addref          EQUATE(7CCDH) ! Increment referenc count
PROP:release         EQUATE(7CCEH) ! Decrement referenc count
PROP:deactivate      EQUATE(7CCFH) ! deactivate object
PROP:update          EQUATE(7CD0H) ! update object
PROP:paste           EQUATE(7CD1H) ! embed object from clipboard
PROP:reportexception EQUATE(7CD2H) ! pop up ole exceptions
PROP:pastelink       EQUATE(7CD3H) ! create link from clipboard
PROP:copy            EQUATE(7CD4H) ! copy object to clipboard
PROP:canpaste        EQUATE(7CD5H)
PROP:canpastelink    EQUATE(7CD6H)
PROP:windowui        EQUATE(7CD7H)
PROP:designmode      EQUATE(7CD8H)
PROP:ctrl            EQUATE(7CD9H)
PROP:grabhandles     EQUATE(7CDAH)
PROP:ole             EQUATE(7CDBH)
PROP:isradio         EQUATE(7CDCH)
PROP:lasteventname   EQUATE(7CDDH)
PROP:clsid           EQUATE(7CDEH)
PROP:progid          EQUATE(7CDFH)

PROP:bevelstyle     EQUATE(7CE0H)  ! kind of bevel for boxes

PROP:join           EQUATE(7CE2H)  ! Join < > buttons
PROP:nosheet        EQUATE(7CE3H)  ! Just display the tabs - no sheet
PROP:bevel          EQUATE(7CE4h)  ! Array of 2 values
PROP:bevelouter     EQUATE(7CE4H)  ! Size, direction of outer bevel == PROP:bevel[1]
PROP:bevelinner     EQUATE(7CE5H)  ! Size, direction of inner bevel == PROP:bevel[2]
PROP:order          EQUATE(7CE6H)  ! Set the order of a VIEW
PROP:linewidth      EQUATE(7CE7H)  ! Pen width for a BOX or LINE
PROP:angle          EQUATE(7CE9H)  ! Angle of text for a string control

PROP:autosize       EQUATE(7CEAH)  !
PROP:clip           EQUATE(7CEBH)  !
PROP:stretch        EQUATE(7CECH)  !
PROP:zoom           EQUATE(7CEDH)  !
PROP:compatibility  EQUATE(7CEEH)  !
PROP:design         EQUATE(7CEFH)  !
PROP:document       EQUATE(7CF0H)  ! create ole object from file (like x.doc i.e. a word document)
PROP:link           EQUATE(7CF1H) ! as above but link
PROP:createfromfile   EQUATE(PROP:document)  ! Compatability
PROP:createlinktofile EQUATE(PROP:link)      !
PROP:align          EQUATE(7CF2H) ! vb ocx align
PROP:cancel         EQUATE(7CF3H) ! vb ocx cancel
PROP:textalign      EQUATE(7CF4H) ! vb ocx ambient property 0-number right text left, 1-left, 2-center, 3-right 4-sustify
PROP:object         EQUATE(7CF5H)
PROP:license        EQUATE(7CF6H)
PROP:language       EQUATE(7CF8H)

PROP:color          EQUATE(7CFAH)  ! up to three components (see below)
PROP:background     EQUATE(7CFAH)  ! For compatibility
PROP:fillcolor      EQUATE(7CFAH)  ! = PROP:color[1]  single value, COLORnone if none
PROP:selectedcolor  EQUATE(7CFBH)  ! = PROP:color[2]  single value, COLORnone if none
PROP:selectedfillcolor EQUATE(7CFCH)  ! = PROP:color[3] single value, COLORnone if none
PROP:lineheight     EQUATE(7CFDH)  ! Height of a line in a list box
PROP:dropwidth      EQUATE(7CFEH)  ! Width of a drop box
PROP:alwaysdrop     EQUATE(7CFFH)  ! Drop control always displays the list on selection change

PROP:up             EQUATE(7A00H)  ! Different orientations of text in a sheet
PROP:down           EQUATE(7A01H)  ! control
PROP:upsidedown     EQUATE(7A02H)
PROP:headerheight   EQUATE(7A03H)  ! (Read-only) Height of the header on a list box
PROP:checked        EQUATE(7A04H)  ! (Read-only) Is a check box set?
PROP:autopaper      EQUATE(7A05H)  ! Report engine automatically picks best paper size
PROP:single         EQUATE(7A06H)  ! Single line text box (for Hebrew/Arabic support)
PROP:parent         EQUATE(7A07H)  ! Field equate of parent control
PROP:repeat         EQUATE(7A08H)  ! Repeat rate of IMM button
PROP:eventswaiting  EQUATE(7A09H)  ! Does this window have any further events pending?
PROP:DDEmode        EQUATE(7A0AH)  ! 0 = normal, 1 = events to top window of thread, other values reserved
PROP:threading      EQUATE(7A0BH)  ! Set to 0 to disable all threading in APP (forces SDI behaviour)
PROP:delay          EQUATE(7A0FH)  ! Delay before IMM button repeats

PROP:status         EQUATE(7D00H)  ! array valued
PROP:statustext     EQUATE(7D01H)  ! array valued
PROP:dragid         EQUATE(7D02H)  ! array valued
PROP:dropid         EQUATE(7D03H)  ! array valued
PROP:vbxeventarg    EQUATE(7D04H)  ! array valued
PROP:edit           EQUATE(7D05H)  ! array valued
PROP:alrt           EQUATE(7D06H)  ! array valued
PROP:iconlist       EQUATE(7D07H)  ! array valued
PROP:line           EQUATE(7D08H)  ! array valued, TEXT control line contents (read-only, runtime only)
PROP:tally          EQUATE(7D09H)  ! array valued, tally attribut on report string control

PROPLIST:underline      EQUATE (7E00H)
PROPLIST:resize         EQUATE (7E01H)
PROPLIST:rightborder    EQUATE (7E02H)
PROPLIST:header         EQUATE (7E03H)
PROPLIST:width          EQUATE (7E04H)
PROPLIST:picture        EQUATE (7E05H)
PROPLIST:fixed          EQUATE (7E06H)
PROPLIST:scroll         EQUATE (7E07H)
PROPLIST:lastonline     EQUATE (7E08H)
PROPLIST:locator        EQUATE (7E09H)
PROPLIST:resvd1         EQUATE (7E0AH)
PROPLIST:resvd2         EQUATE (7E0BH)
PROPLIST:resvd3         EQUATE (7E0CH)
PROPLIST:resvd4         EQUATE (7E0DH)

PROPLIST:left           EQUATE (7E10H)
PROPLIST:leftoffset     EQUATE (7E11H)
PROPLIST:right          EQUATE (7E12H)
PROPLIST:rightoffset    EQUATE (7E13H)
PROPLIST:center         EQUATE (7E14H)
PROPLIST:centeroffset   EQUATE (7E15H)
PROPLIST:decimal        EQUATE (7E16H)
PROPLIST:decimaloffset  EQUATE (7E17H)

PROPLIST:headerleft           EQUATE (7E18H)
PROPLIST:headerleftoffset     EQUATE (7E19H)
PROPLIST:headerright          EQUATE (7E1AH)
PROPLIST:headerrightoffset    EQUATE (7E1BH)
PROPLIST:headercenter         EQUATE (7E1CH)
PROPLIST:headercenteroffset   EQUATE (7E1DH)
PROPLIST:headerdecimal        EQUATE (7E1EH)
PROPLIST:headerdecimaloffset  EQUATE (7E1FH)

PROPLIST:icon           EQUATE (7E20H)
PROPLIST:color          EQUATE (7E21H)
PROPLIST:tree           EQUATE (7E22H)
PROPLIST:treelines      EQUATE (7E23H)
PROPLIST:treeboxes      EQUATE (7E24H)
PROPLIST:treeindent     EQUATE (7E25H)
PROPLIST:treeoffset     EQUATE (7E26H)
PROPLIST:treeroot       EQUATE (7E27H)

PROPLIST:group          EQUATE (0040H)  ! add to PROPLIST property above

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

PROP:SQL                EQUATE (7200H)
PROP:OrderAllTables     EQUATE (7211H)
PROP:JoinExpression     EQUATE (7212H)
PROP:SQLFilter          EQUATE (7221H)

! ODBC Driver Properties
PROP:ConnectString      EQUATE (7201H)
PROP:LoginTimeOut       EQUATE (7202H)
PROP:HENV               EQUATE (7203H)
PROP:HDBC               EQUATE (7204H)
PROP:HSTMT              EQUATE (7205H)

! Oracle Driver Properties
PROP:LogFile            EQUATE (7222H)
PROP:Where              EQUATE (7223H)
PROP:Hint               EQUATE (7241H)
