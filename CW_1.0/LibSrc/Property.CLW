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
PROP:points         EQUATE(7C1EH)  ! 0 = off, else on

PROP:sum            EQUATE(7C40H)  ! 0 = off, else on
PROP:ave            EQUATE(7C41H)  ! 0 = off, else on
PROP:cnt            EQUATE(7C42H)  ! 0 = off, else on
PROP:max            EQUATE(7C43H)  ! 0 = off, else on
PROP:min            EQUATE(7C44H)  ! 0 = off, else on
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
PROP:color          EQUATE(7C5BH)  ! single value, COLORnone if none
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
PROP:selstart       EQUATE(7C8FH)  ! single value (runtime only)
PROP:selend         EQUATE(7C90H)  ! single value (runtime only)
PROP:auto           EQUATE(7C91H)  ! 0 = off, else on (runtime only for now)
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

PROP:status         EQUATE(7D00H)  ! array valued
PROP:statustext     EQUATE(7D01H)  ! array valued
PROP:dragid         EQUATE(7D02H)  ! array valued
PROP:dropid         EQUATE(7D03H)  ! array valued
PROP:vbxeventarg    EQUATE(7D04H)  ! array valued
PROP:edit           EQUATE(7D05H)  ! array valued
PROP:alrt           EQUATE(7D06H)  ! array valued

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

PROPLIST:group           EQUATE (0040H)  ! add to PROPLIST property above
