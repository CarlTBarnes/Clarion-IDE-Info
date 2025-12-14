 MEMBER

!OMIT ('=== DO LINK DOS', lib_mode)
 PRAGMA('link(C%V%DOS%X%%L%.LIB)')
! === DO LINK DOS

 INCLUDE ('ERRORS.CLW')
 INCLUDE ('SystemString.INC')
  MAP
SystemStringClass_ByteToHex PROCEDURE(BYTE inCharVal, BYTE LowerCase = FALSE),STRING
SystemStringClass_IsXDigit PROCEDURE(BYTE inCharVal),BYTE
  END


!**Base64 Data

SystemStringClass_Base64Encode  STRING('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='),PRIVATE
SystemStringClass_HexDigitsUp   STRING('0123456789ABCDEF'),PRIVATE
SystemStringClass_HexDigitsLow  STRING('0123456789abcdef'),PRIVATE




SystemStringClass.Construct PROCEDURE()
  CODE
     IF NOT SELF.s &= NULL
 	   DISPOSE(SELF.s)
 	 END
 	 SELF.strMark = '"'
     SELF.containsStr = false
 	 SELF.LastSplitDelimiter = ''
     SELF.valueSep  = '='
     SELF.pairSep   = '&'
     SELF.EOLMarker = '<13,10>'
     SELF.TokensDelimiters = ' ,;.-()][}{{_:<<>\/@#¦¬^?+í!|"'''
     SELF.SetUseLowerAsciiAsDelimiters(false)
     SELF.lines &= new SystemStringQueue()
     SELF.ResetToken()
     SELF._AppendOnCursor= FALSE
     SELF._ClipOnCursor = FALSE
     SELF.appendCursor = 1

SystemStringClass.Destruct PROCEDURE()
  CODE
  	SELF.DisposeIt()
 	IF NOT SELF.cs &= NULL
 	   DISPOSE(SELF.cs)
 	END
 	SELF.CleanSegments()
  	SELF.CleanLines()
  	DISPOSE(SELF.lines)

SystemStringClass.DisposeIt PROCEDURE()
 CODE
 	IF NOT SELF.s &= NULL
 	   DISPOSE(SELF.s)
 	   SELF.ResetToken()
 	END

SystemStringClass.DisposeItCString PROCEDURE()
 CODE
 	IF NOT SELF.cs &= NULL
 	   DISPOSE(SELF.cs)
 	END

SystemStringClass.CleanSegments PROCEDURE()
idx         LONG,AUTO
 CODE
 	IF NOT SELF.segmentsToReplace &= NULL
       IF RECORDS(SELF.segmentsToReplace)
          LOOP idx=1 TO RECORDS(SELF.segmentsToReplace)
               GET(SELF.segmentsToReplace,idx)
               IF NOT ERRORCODE()
                  DISPOSE(SELF.segmentsToReplace.Str)
               END
          END
          FREE(SELF.segmentsToReplace)
       END
       DISPOSE(SELF.segmentsToReplace)
 	END

SystemStringClass.CleanLines PROCEDURE()
 CODE
    SELF.CleanSplitQueue(SELF.lines)

SystemStringClass.CleanSplitQueue PROCEDURE(*SystemStringQueue collection)
idx         LONG,AUTO
 CODE
    IF RECORDS(collection)
       LOOP idx=1 TO RECORDS(collection)
            GET(collection,idx)
            IF NOT ERRORCODE()
               DISPOSE(collection.Str)
            END
       END
       FREE(collection)
    END

SystemStringClass.Clean PROCEDURE()
 CODE
    SELF.SetString('')
    SELF.CleanLines()

SystemStringClass.SetString PROCEDURE(STRING svalue)
 CODE
    SELF.DisposeIt()
    SELF.s &= NEW STRING(LEN(svalue))
    SELF.s = svalue
    SELF.appendCursor = LEN(svalue)+1

SystemStringClass.SetString PROCEDURE(*CSTRING svalue)
 CODE
    SELF.DisposeIt()
    SELF.cs &= NEW CSTRING(LEN(svalue)+1)
    SELF.cs = svalue
    SELF.appendCursor = LEN(svalue)+1

SystemStringClass.FromString PROCEDURE(STRING svalue)
 CODE
    SELF.SetString(svalue)

SystemStringClass.FromString PROCEDURE(*CSTRING svalue)
 CODE
    SELF.SetString(svalue)

SystemStringClass.Str PROCEDURE(SystemStringClass s)
  CODE
  SELF.Str(s.Str())

SystemStringClass.Str PROCEDURE(STRING s)
  CODE
  SELF.FromString(s)

SystemStringClass.GetString PROCEDURE()
  CODE
     RETURN SELF.Str()

SystemStringClass.Str PROCEDURE()
lstartPos   LONG,AUTO
  CODE
     IF SELF.s &= NULL
        RETURN ''
     ELSE
        IF SELF.GetAppendOnCursor() AND SELF.GetClipOnCursor()
           lstartPos = SELF.GetCursor() - 1
           IF lstartPos<=LEN(SELF.s)
              RETURN SELF.s[1: (lstartPos)]
           ELSE
              RETURN SELF.s
           END
        ELSE
           RETURN SELF.s
        END
     END

SystemStringClass.SetLength PROCEDURE(LONG pValLen)
preCursor LONG,AUTO
  CODE
    preCursor = SELF.appendCursor
    SELf.SetString(ALL(' ',pValLen))
    SELF.appendCursor = preCursor

SystemStringClass.SetLen PROCEDURE(LONG pValLen)
  CODE
    SELF.SetLength(pValLen)

SystemStringClass.Resize PROCEDURE(LONG pValLen)
tmpS &STRING
lLen LONG,AUTO
 CODE
    IF SELF.s &= NULL
       SELF.SetLen(pValLen)
    ELSE
       lLen = SELF.Length()
       IF lLen<>pValLen
          tmpS &= NEW STRING(pValLen)
          tmpS = ALL(' ',pValLen)
          IF lLen > pValLen
             !cut the string
             tmpS = SELF.s[1: pValLen ]
          ELSE
             tmpS[1: lLen ] = SELF.s
          END
          SELF.DisposeIt()
          SELF.s &= tmpS
       END
    END

SystemStringClass.ToCString PROCEDURE()
 CODE
    SELF.DisposeItCString()
    SELF.cs &= new CSTRING(LEN(SELF.s)+1)
    SELF.cs = SELF.s
    RETURN SELF.cs

SystemStringClass.FromCString PROCEDURE()
 CODE
    SELF.DisposeIt()
    IF NOT SELF.cs &= NULL
       SELF.FromString(SELF.cs)
    ELSE
       SELF.FromString('')
    END

SystemStringClass.Length PROCEDURE()
 CODE
     IF SELF.s &= NULL
        RETURN 0
     ELSE
        RETURN LEN(SELF.s)
     END

SystemStringClass.IndexOfReg              PROCEDURE(STRING regExpValue)
 CODE
    RETURN SELF.IndexOfReg(regExpValue,1,TRUE)
 
SystemStringClass.IndexOfReg              PROCEDURE(STRING regExpValue, ULONG startIndex, BYTE IgnoreCase = true)
lStrPos LONG,AUTO
 CODE
    IF CLIP(regExpValue) AND SELF.Length()>0
       IF startIndex <= SELF.Length()
          IF startIndex > 1
             lStrPos = STRPOS(SELF.s[(startIndex) : (SELF.Length())] , regExpValue, IgnoreCase)
             IF lStrPos>0
                lStrPos = startIndex + lStrPos - 1
             END
             RETURN lStrPos
          ELSE
             RETURN STRPOS(SELF.s, regExpValue, IgnoreCase)
          END
       END
    END
    RETURN 0
 
SystemStringClass.IndexOf PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.IndexOf(svalue,1)

SystemStringClass.IndexOf PROCEDURE(STRING svalue, ULONG startIndex)
lValLen LONG,AUTO
lLen    LONG,AUTO
lOpen   BYTE,AUTO
 CODE
    IF SELF.containsStr
       !Need to search form the value outside of the OPEN/CLOSE string makerd by SELF.strMark
       !The search must be done char by char
       RETURN 0!TBD
    ELSE
       RETURN INSTRING(svalue, SELF.s, 1, startIndex)
    END

SystemStringClass.GetLeftOf               PROCEDURE(STRING svalue)
lIdxOf   LONG,AUTO
 CODE
    lIdxOf = SELF.IndexOf(svalue)
    IF lIdxOf > 0
       RETURN SELF.SubstringLeft(lIdxOf)
    END
    RETURN ''
 
SystemStringClass.GetRightOf              PROCEDURE(STRING svalue)
lIdxOf   LONG,AUTO
 CODE
    lIdxOf = SELF.IndexOf(svalue)
    IF lIdxOf > 0
       RETURN SELF.Substring(lIdxOf)
    END
    RETURN ''

SystemStringClass.LastIndexOf PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.LastIndexOf(svalue, 1)

SystemStringClass.LastIndexOf PROCEDURE(STRING svalue, ULONG startIndex)
idx        LONG,AUTO
lastFoundIdx LONG,AUTO
 CODE
    lastFoundIdx = 0
    IF startIndex < SELF.Length()
       idx = startIndex
       LOOP
          !idx = INSTRING(svalue, SELF.s, 1, idx)
          idx = SELF.IndexOf(svalue,idx)
          IF idx = 0
             BREAK
          END
          lastFoundIdx = idx
          idx += 1
       END
    END
    RETURN lastFoundIdx

SystemStringClass.Prepend PROCEDURE(STRING s,BYTE pAddEOLMarker=0)
lLen        LONG,AUTO
lS          &STRING,AUTO
  CODE
  lLen = LEN(s)
  IF NOT SELF.s &= NULL
     IF lLen>0
        IF pAddEOLMarker
           lLen += LEN(SELF.EOLMarker)
        END
        lLen += SELF.Length()
        lS &= NEW STRING(lLen)
        IF pAddEOLMarker
           lS = s & SELF.EOLMarker & SELF.s
        ELSE
           lS = s & SELF.s
        END

        SELF.DisposeIt()
        SELF.s &= lS
     END
  ELSE
     IF lLen>0
        IF pAddEOLMarker
           SELF.Str(s & SELF.EOLMarker)
        ELSE
           SELF.Str(s)
        END
     END
  END

SystemStringClass.Append PROCEDURE(STRING s,BYTE pAddEOLMarker=0)
lLen        LONG,AUTO
lstartPos   LONG,AUTO
  CODE
  lLen = LEN(s)
  IF NOT SELF.s &= NULL
     IF lLen>0
         IF SELF.GetAppendOnCursor()
            lstartPos = SELF.GetCursor()
            IF lstartPos=0
               lstartPos = 1
            END
         ELSE
            lstartPos = SELF.Length() + 1
         END
         IF pAddEOLMarker
            SELF.SetSubstring(lstartPos,s & SELF.EOLMarker,true)
            lLen += LEN(SELF.EOLMarker)
         ELSE
            SELF.SetSubstring(lstartPos,s,true)
         END
         IF SELF.GetAppendOnCursor()
            SELF.SetCursor(lstartPos + lLen)
         END
     END
  ELSE
     IF lLen>0
        IF pAddEOLMarker
           SELF.Str(s & SELF.EOLMarker)
        ELSE
           SELF.Str(s)
        END
        IF SELF._AppendOnCursor
           SELF.SetCursor(SELF.Length()+1)
        END
     END
  END

SystemStringClass.Append PROCEDURE(STRING leftValue, SystemStringClass svalue, STRING rightValue)
  CODE
     SELF.Append(leftValue & svalue.ToString() & rightValue,false)

SystemStringClass.Append PROCEDURE(SystemStringClass s)
  CODE
  SELF.Append(s.ToString())

SystemStringClass.AppendLine PROCEDURE(STRING s)
 CODE
  SELF.Append(s,true)

SystemStringClass.Surround PROCEDURE(STRING leftValue, STRING rightValue)
lLen        LONG,AUTO
lS          &STRING,AUTO
  CODE
  lLen = LEN(leftValue) + LEN(rightValue)
  IF NOT SELF.s &= NULL
     IF lLen>0
        lLen += SELF.Length()
        lS &= NEW STRING(lLen)
        lS = leftValue & SELF.s & rightValue
        SELF.DisposeIt()
        SELF.s &= lS
     END
  ELSE
     IF lLen>0
        SELF.Str(leftValue & rightValue)
     END
  END

SystemStringClass.ToString PROCEDURE()
 CODE
 	RETURN SELF.Str()

SystemStringClass.ToLower PROCEDURE()
 CODE
    RETURN LOWER(SELF.Str())

SystemStringClass.ToUpper PROCEDURE()
 CODE
    RETURN UPPER(SELF.Str())

SystemStringClass.ToCapitalize PROCEDURE()
 CODE
    IF SELF.s &= NULL
       RETURN ''
    ELSE
       RETURN SELF.Capitalize(SELF.Str())
    END

SystemStringClass.Capitalize PROCEDURE(STRING cs)
idx        LONG
sLength    LONG
 CODE
       idx = 1
       sLength = LEN(cs)
       IF sLength > 0
          cs[idx] = UPPER(cs[idx])
          IF sLength > 1
             LOOP idx = 2 to sLength
                  IF cs[idx-1] = ' '
                     cs[idx] = UPPER(cs[idx])
                  END
             END
          END
       END
       RETURN cs

SystemStringClass.Contains PROCEDURE(STRING svalue)
 CODE
    IF INSTRING(svalue, SELF.Str(),1,1)
       RETURN TRUE
    ELSE
       RETURN FALSE
    END

SystemStringClass.StartsWith            PROCEDURE(SystemStringClass svalue)
 CODE
    RETURN SELF.StartsWith(svalue.Str())

SystemStringClass.StartsWith            PROCEDURE(SystemStringClass svalue, BYTE IgnoreCase)
 CODE
    RETURN SELF.StartsWith(svalue.Str(), IgnoreCase)

SystemStringClass.StartsWith PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.StartsWith(svalue,true)

SystemStringClass.StartsWith PROCEDURE(STRING svalue,BYTE IgnoreCase)
csLen LONG
svLEN LONG
 CODE
    csLen = SELF.Length()
    svLEN = LEN(svalue)
    IF svLEN > csLen
       RETURN FALSE
    ELSE
       IF IgnoreCase
          IF UPPER(svalue) = UPPER(SUB(SELF.Str(),1,svLen))
             RETURN TRUE
          ELSE
             RETURN FALSE
          END
       ELSE
          IF svalue = SUB(SELF.Str(),1,svLen)
             RETURN TRUE
          ELSE
             RETURN FALSE
          END
       END
    END

SystemStringClass.EndsWith   PROCEDURE(SystemStringClass svalue)
  CODE
     RETURN SELF.EndsWith(svalue.Str())

SystemStringClass.EndsWith                PROCEDURE(SystemStringClass svalue, BYTE IgnoreCase)
 CODE
    RETURN SELF.EndsWith(svalue.Str(), IgnoreCase)

SystemStringClass.EndsWith PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.EndsWith(svalue,true)

SystemStringClass.EndsWith PROCEDURE(STRING svalue,BYTE IgnoreCase)
csLen LONG
svLEN LONG
 CODE
    csLen = SELF.Length()
    svLEN = LEN(svalue)
    IF svLEN > csLen
       RETURN FALSE
    ELSE
       IF IgnoreCase
          IF UPPER(svalue) = UPPER(SUB(SELF.Str(),csLen - svLen + 1 ,svLen))
             RETURN TRUE
          ELSE
             RETURN FALSE
          END
       ELSE
          IF svalue = SUB(SELF.Str(),csLen - svLen + 1,svLen)
             RETURN TRUE
          ELSE
             RETURN FALSE
          END
       END
    END
SystemStringClass.Equals PROCEDURE(SystemStringClass svalue)
  CODE
     RETURN SELF.Equals(svalue.str())

SystemStringClass.Equals PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.Equals(svalue,true)

SystemStringClass.Equals PROCEDURE(STRING svalue, BYTE IgnoreCase)
 CODE
    IF IgnoreCase
      IF UPPER(SELF.Str()) = UPPER(svalue)
         RETURN TRUE
      END!if
    ELSE
      IF SELF.str() = svalue
         RETURN TRUE
      END!if
    END!if
    RETURN FALSE

SystemStringClass.ReplaceInContent          PROCEDURE(STRING oldString,STRING newString)
sstr         SystemStringClass
idxFound     LONG
prevIdxFound LONG
newStringLen LONG
oldStringLen LONG
retVal       LONG
 CODE
    retVal = 0
    newStringLen = LEN(newString)
    oldStringLen = LEN(oldString)
    IF SELF.Length()>0 AND oldStringLen>0 AND (oldString<>newString OR oldStringLen<>newStringLen)
       idxFound = INSTRING(oldString, SELF.ToString(), 1, 1)
       prevIdxFound = 1
       LOOP
          IF idxFound > 0
             IF prevIdxFound < idxFound
                sstr.Append(SUB(SELF.ToString(),prevIdxFound,idxFound - prevIdxFound  ))
             END
             IF newStringLen>0
                sstr.Append(newString)
             END
             prevIdxFound = idxFound + oldStringLen
             retVal+=1
          ELSE
             BREAK
          END
          idxFound = INSTRING(oldString, SELF.ToString(), 1, prevIdxFound)
       END
       IF idxFound = 0
          IF prevIdxFound < SELF.Length()
             retVal+=1
             sstr.Append(SUB(SELF.ToString(), prevIdxFound, LEN(SELF.ToString()) - prevIdxFound + 1))
          END
       END
       SELF.FromString(sstr.ToString())
    END
    RETURN retVal

SystemStringClass.RemoveSubStringInContent         PROCEDURE(STRING subString)
 CODE
    RETURN SELF.ReplaceInContent(subString,'')

SystemStringClass.AddReplaceInContentSegment PROCEDURE(LONG startSeg, LONG endSeg, STRING svalue)
 CODE
  	IF SELF.segmentsToReplace &= NULL
  	   SELF.segmentsToReplace &= NEW SystemStringSegmentsQueue
  	END
    SELF.segmentsToReplace.startSeg = startSeg
    SELF.segmentsToReplace.endSeg = endSeg
    IF CLIP(svalue)
       SELF.segmentsToReplace.Str &= NEW STRING(LEN(svalue))
       SELF.segmentsToReplace.Str = svalue
    END
    ADD(SELF.segmentsToReplace)

SystemStringClass.ReplaceInContentSegment        PROCEDURE()
lIdxSeg LONG
tmpStr  &SystemStringClass
lastIdx LONG
 CODE
    IF SELF.segmentsToReplace &= NULL
       RETURN
    END
    lastIdx = 1
    tmpStr &= NEW SystemStringClass
    tmpStr.SetLength(SELF.Length())
    tmpStr.SetAppendOnCursor(true)
    tmpStr.SetCursor(1)
    LOOP lIdxSeg = 1 TO RECORDS(SELF.segmentsToReplace)
         GET(SELF.segmentsToReplace,lIdxSeg)
         IF NOT ERRORCODE()
            IF SELF.segmentsToReplace.endSeg > SELF.segmentsToReplace.startSeg AND |
               SELF.segmentsToReplace.endSeg <= SELF.Length()

               !Append from last segment to the start index
               !
               IF lastIdx<SELF.segmentsToReplace.startSeg
                  tmpStr.Append(SELF.s[(lastIdx) : (SELF.segmentsToReplace.startSeg - 1)])
               END
               
               IF NOT SELF.segmentsToReplace.Str &= NULL AND CLIP(SELF.segmentsToReplace.Str)<>''
                  tmpStr.Append(SELF.segmentsToReplace.Str)
               END
               lastIdx = SELF.segmentsToReplace.endSeg + 1
            END
         END
    END
    IF lastIdx>0 AND lastIdx + 1 < SELF.Length()
       tmpStr.Append(SELF.S[ (lastIdx) : SELF.Length()])
       SELF.SetString(tmpStr.ToString())
    END
    DISPOSE(tmpStr)
    SELF.CleanSegments()
 
SystemStringClass.ReplaceInContent          PROCEDURE(LONG idxReplaceStart, LONG strReplaceLen,STRING newString)
tmpStr         SystemStringClass
 CODE
    IF idxReplaceStart>0 AND (idxReplaceStart+strReplaceLen) < SELF.Length()
       IF idxReplaceStart>1
          tmpStr.Append(SUB(SELF.ToString(),1,idxReplaceStart - 1))
       END
       tmpStr.Append(newString)
       tmpStr.Append(SUB(SELF.ToString(),idxReplaceStart+strReplaceLen,SELF.Length()-idxReplaceStart+strReplaceLen))
       SELF.FromString(tmpStr.ToString())
       RETURN TRUE
    END
    RETURN FALSE

SystemStringClass.SetSubstring        PROCEDURE(LONG idxReplaceStart, STRING newString, BYTE resizeIfneeded=FALSE)
lstrReplaceLen LONG,AUTO
lLen           LONG,AUTO
 CODE
    lstrReplaceLen = LEN(newString)
    lLen = SELF.Length()
    IF idxReplaceStart>0 AND lstrReplaceLen>0
       IF (idxReplaceStart+lstrReplaceLen-1) <= lLen
          SELF.s[(idxReplaceStart) : (idxReplaceStart+lstrReplaceLen-1)] = newString
          RETURN TRUE
       ELSE
          IF resizeIfneeded
             SELF.Resize(lLen + ((idxReplaceStart+lstrReplaceLen-1) - lLen))
             SELF.s[(idxReplaceStart) : (idxReplaceStart+lstrReplaceLen-1)] = newString
             RETURN TRUE
          END
       END
    END
    RETURN FALSE

SystemStringClass.Replace PROCEDURE(STRING oldString,STRING newString) !return the number of oldstring replaced
 CODE
    RETURN SELF.ReplaceSubString(SELF.ToString(), oldString, newString)

SystemStringClass.ReplaceSubString          PROCEDURE(STRING originalString, STRING oldString,STRING newString)!execute a replace in the internal string, does not return anything
sstr         SystemStringClass
idxFound     LONG
prevIdxFound LONG
newStringLen LONG
oldStringLen LONG
 CODE
    IF oldString<>newString OR LEN(oldString)<>LEN(newString)
       newStringLen = LEN(newString)
       oldStringLen = LEN(oldString)

       idxFound = INSTRING(oldString, originalString, 1, 1)
       prevIdxFound = 1
       LOOP
          IF idxFound > 0
             IF prevIdxFound < idxFound
                sstr.Append(SUB(originalString,prevIdxFound,idxFound - prevIdxFound  ))
             END
             IF newStringLen>0
                sstr.Append(newString)
             END
             prevIdxFound = idxFound + oldStringLen
          ELSE
             BREAK
          END
          idxFound = INSTRING(oldString, originalString, 1, prevIdxFound)
       END
       IF idxFound = 0
          IF prevIdxFound <= LEN(originalString)
             sstr.Append(SUB(originalString, prevIdxFound, LEN(originalString) - prevIdxFound + 1))
          END
       END
       RETURN sstr.ToString()
    ELSE
       RETURN originalString
    END

SystemStringClass.RemoveSubString         PROCEDURE(STRING originalString, STRING subString)!execute a replace by empty in the originalString variable, return the altered string
 CODE
    RETURN SELF.ReplaceSubString(originalString, subString, '')

SystemStringClass.RemoveSubString         PROCEDURE(STRING subString)!execute a replace by empty in the internal string, return the number of time the subString was replaced
 CODE
    RETURN SELF.ReplaceSubString(SELF.ToString(), subString, '')

SystemStringClass.Insert PROCEDURE(ULONG startIndex, STRING svalue)
csLen LONG
 CODE
    IF startIndex < 2
       RETURN svalue & SELF.s
    END   
    csLen = SELF.Length()
    IF startIndex <= csLen
       RETURN SELF.s[1 : (startIndex - 1)] & svalue & SELF.s[(startIndex) : (csLen)]
    ELSE
       RETURN SELF.s & svalue
    END

SystemStringClass.GetAppendOnCursor       PROCEDURE()
 CODE
    RETURN SELF._AppendOnCursor

SystemStringClass.SetAppendOnCursor       PROCEDURE(BYTE value=true)
 CODE
    IF value>0
       SELF._AppendOnCursor= true
       SELF.SetClipOnCursor(true)
    ELSE
       SELF._AppendOnCursor = false
    END

SystemStringClass.SetClipOnCursor         PROCEDURE(BYTE value=true)
 CODE
    IF value>0
       SELF._ClipOnCursor = true
    ELSE
       SELF._ClipOnCursor = false
    END

SystemStringClass.GetClipOnCursor         PROCEDURE()
 CODE
    RETURN SELF._ClipOnCursor

SystemStringClass.GetCursor               PROCEDURE()
 CODE
    RETURN SELF.appendCursor

SystemStringClass.SetCursor               PROCEDURE(LONG value)
 CODE
    IF SELF.Length()>=value-1
       IF value=0
          SELF.appendCursor = 1
       ELSE
          SELF.appendCursor = value
       END
    END

SystemStringClass.Remove PROCEDURE(ULONG startIndex)
csLen LONG
 CODE
    IF startIndex < 2
       RETURN ''
    END   
    csLen = SELF.Length()
    IF startIndex < csLen
       RETURN SELF.s[1 : (startIndex - 1)]
    ELSE
       RETURN SELF.s
    END

SystemStringClass.Remove PROCEDURE(ULONG startIndex, ULONG subLength)
csLen LONG
 CODE
    IF startIndex < 2
       RETURN ''
    END   
    csLen = SELF.Length()
    IF startIndex < csLen
       IF csLen <= (subLength + startIndex)
          RETURN SELF.s[1 : (startIndex - 1)]
       ELSE
          RETURN SELF.s[1 : (startIndex - 1)] & SELF.s[(startIndex + subLength) : (csLen)]
       END
    ELSE
       RETURN SELF.s
    END

SystemStringClass.Substring PROCEDURE(ULONG startIndex)
csLen LONG
 CODE
    csLen = SELF.Length()
    IF startIndex <= csLen
       RETURN SELF.s[(startIndex):(csLen)]
    ELSE
       RETURN ''
    END

SystemStringClass.Substring PROCEDURE(ULONG startIndex, ULONG subLength)
csLen LONG
 CODE
    csLen = SELF.Length()
    IF startIndex <= csLen
       IF csLen > (subLength + startIndex-1)
          RETURN SELF.s[(startIndex):(startIndex + subLength-1)]
       ELSE
          RETURN SELF.s[(startIndex):(csLen)]
       END
    ELSE
       RETURN ''
    END

SystemStringClass.GetSurrounded           PROCEDURE(STRING leftValue, STRING rightValue,ULONG startIndex=1,ULONG endIndex=0)
lIdx1   LONG,AUTO
lIdx2   LONG,AUTO
 CODE
    IF endIndex = 0
       endIndex = SELF.Length()
    END
    IF startIndex<endIndex AND endIndex<=SELF.Length()
       lIdx1 = INSTRING(leftValue, SELF.s, 1, startIndex)
       IF lIdx1 > 0
          lIdx2 = INSTRING(rightValue, SELF.s, 1, lIdx1)
          IF lIdx2 > 0 AND lIdx2<=endIndex
             RETURN SELF.s[(LEN(leftValue) + lIdx1):( lIdx2-1 )]
          END
       END
    END
    RETURN ''

SystemStringClass.SubstringLeft             PROCEDURE(ULONG startIndex)
 CODE
    RETURN SELF.SubstringLeft(startIndex, startIndex)

SystemStringClass.SubstringLeft             PROCEDURE(ULONG startIndex, ULONG subLength)
 CODE
    IF startIndex > 1 AND startIndex <= SELF.Length()
       IF startIndex = subLength OR subLength > startIndex
          RETURN SELF.s[1:(startIndex-1)]
       ELSE
          RETURN SELF.s[(startIndex - subLength ):(startIndex - 1)]
       END
    ELSE
       RETURN ''
    END

SystemStringClass.ExtractKeyValue         PROCEDURE(STRING pKey, STRING pValueSep, STRING pPairSep, *SystemStringClass pValue)
KeySearch    SystemStringClass
nValuePos    LONG
nEndValuePos LONG
nKeyLen      LONG
 CODE
    KeySearch.Str(CLIP(pKey))
    KeySearch.Append(CLIP(pValueSep))
    nKeyLen = KeySearch.Length()
    nValuePos = SELF.IndexOf(KeySearch.Str())
    IF nValuePos > 0
       nEndValuePos = SELF.IndexOf(pPairSep,nValuePos+nKeyLen)
       IF nEndValuePos = 0  !end of string
          pValue.Str(SELF.Substring(nValuePos+nKeyLen))
       ELSE
          pValue.Str(SELF.Substring(nValuePos+nKeyLen,nEndValuePos-nValuePos-nKeyLen))
       END!if
       RETURN TRUE
    END!if
    RETURN FALSE

SystemStringClass.ExtractKeyValue         PROCEDURE(STRING pKey, *SystemStringClass pValue)
 CODE
    RETURN SELF.ExtractKeyValue(pKey, SELF.valueSep, SELF.pairSep, pValue)

SystemStringClass.ReplaceKeyValue         PROCEDURE(STRING pKey, STRING pValueSep, STRING pPairSep, STRING pNewValue)
KeySearch    SystemStringClass
nValuePos    LONG
nEndValuePos LONG
nKeyLen      LONG
 CODE
    KeySearch.Str(CLIP(pKey))
    KeySearch.Append(CLIP(pValueSep))
    nKeyLen = KeySearch.Length()
    nValuePos = SELF.IndexOf(KeySearch.Str())
    IF nValuePos > 0
       nEndValuePos = SELF.IndexOf(pPairSep,nValuePos+nKeyLen)
       IF nEndValuePos = 0  !end of string
          nEndValuePos = SELF.Length()
       END!if
       SELF.ReplaceInContent(nValuePos+nKeyLen, nEndValuePos-nValuePos-nKeyLen,pNewValue)
       RETURN TRUE
    END!if
    RETURN FALSE

SystemStringClass.ReplaceKeyValue         PROCEDURE(STRING pKey, STRING pNewValue)
 CODE
    RETURN SELF.ReplaceKeyValue(pKey, SELF.valueSep, SELF.pairSep, pNewValue)

SystemStringClass.PadLeft                   PROCEDURE(ULONG totalWidth)
 CODE
    RETURN SELF.PadLeft(totalWidth, ' ')

SystemStringClass.PadLeft                   PROCEDURE(ULONG totalWidth, STRING paddingChar)
idx LONG,AUTO
 CODE
    IF SELF.Length() > totalWidth
       RETURN SELF.ToString()
    END
    RETURN ALL(paddingChar,totalWidth  - SELF.Length()) & SELF.ToString()

SystemStringClass.PadRight PROCEDURE(ULONG totalWidth)
 CODE
    RETURN SELF.PadRight(totalWidth, ' ')

SystemStringClass.PadRight PROCEDURE(ULONG totalWidth, STRING paddingChar)
 CODE
    IF SELF.Length() > totalWidth
       RETURN SELF.ToString()
    END
    RETURN SELF.ToString() & ALL(paddingChar,totalWidth - SELF.Length())

SystemStringClass.PadCenter PROCEDURE(ULONG totalWidth)
 CODE
    RETURN SELF.PadCenter(totalWidth, ' ')

SystemStringClass.PadCenter PROCEDURE(ULONG totalWidth, STRING paddingChar)
leftPadLen LONG,AUTO
rightPadLen LONG,AUTO
 CODE
    IF SELF.Length() > totalWidth
       RETURN SELF.ToString()
    END
    leftPadLen  = INT((totalWidth  - SELF.Length()) / 2)
    rightPadLen = totalWidth  - SELF.Length() - leftPadLen
    RETURN ALL(paddingChar,leftPadLen) & SELF.ToString() & ALL(paddingChar,rightPadLen)

SystemStringClass.Trim PROCEDURE()
 CODE
    RETURN CLIP(LEFT(SELF.Str()))

SystemStringClass.TrimInContext           PROCEDURE()
 CODE
    SELF.TrimInContext(0,' ')

SystemStringClass.TrimInContext           PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
idx        LONG
sLength    LONG
isIdxToTrimStart LONG
isIdxToTrimEnd LONG
tmpS &STRING
ltmpSLen LONG
 CODE
    !trimType=0 All, 1 Left, 2 Right
    sLength = SELF.Length()
    isIdxToTrimStart = 0
    isIdxToTrimEnd = sLength + 1
    IF trimType = 0 OR trimType = 1
       LOOP idx = 1 to sLength
            IF SELF.s[idx] = char1[1]
               isIdxToTrimStart = idx
            ELSE
               IF NOT OMITTED(3) AND LEN(char2)>0 !char2
                  IF SELF.s[idx] = char2[1]
                     isIdxToTrimStart = idx
                  END
               END
               IF NOT OMITTED(4) AND LEN(char3)>0 !char3
                  IF SELF.s[idx] = char3[1]
                     isIdxToTrimStart = idx
                  END
               END
               IF NOT OMITTED(5) AND LEN(char4)>0 !char4
                  IF SELF.s[idx] = char4[1]
                     isIdxToTrimStart = idx
                  END
               END
            END
            IF isIdxToTrimStart <> idx
               BREAK
            END
       END
    END
    IF trimType = 0 OR trimType = 2
       LOOP idx = sLength to 1 BY -1
            IF SELF.s[idx] = char1[1]
               isIdxToTrimEnd = idx
            ELSE
               IF NOT OMITTED(3) AND LEN(char2)>0 !char2
                  IF SELF.s[idx] = char2[1]
                     isIdxToTrimEnd = idx
                  END
               END
               IF NOT OMITTED(4) AND LEN(char3)>0 !char3
                  IF SELF.s[idx] = char3[1]
                     isIdxToTrimEnd = idx
                  END
               END
               IF NOT OMITTED(5) AND LEN(char4)>0 !char4
                  IF SELF.s[idx] = char4[1]
                     isIdxToTrimEnd = idx
                  END
               END
            END
            IF isIdxToTrimEnd <> idx
               BREAK
            END
       END
    END
    
    IF isIdxToTrimStart <> 0 OR isIdxToTrimEnd <> sLength + 1
       ltmpSLen = (isIdxToTrimEnd-1) - (isIdxToTrimStart+1) + 1
       tmpS &= NEW STRING(ltmpSLen)
       tmpS[1:ltmpSLen] = SELF.s[(isIdxToTrimStart+1):(isIdxToTrimEnd-1)]
       SELF.DisposeIt()
       SELF.s &= tmpS
    END

SystemStringClass.Trim PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
idx        LONG
sLength    LONG
isIdxToTrimStart LONG
isIdxToTrimEnd LONG
 CODE
    !trimType=0 All, 1 Left, 2 Right
    sLength = SELF.Length()
    isIdxToTrimStart = 0
    isIdxToTrimEnd = sLength + 1
    IF trimType = 0 OR trimType = 1
       LOOP idx = 1 to sLength
            IF SELF.s[idx] = char1[1]
               isIdxToTrimStart = idx
            ELSE
               IF NOT OMITTED(4) AND LEN(char2)>0 !char2
                  IF SELF.s[idx] = char2[1]
                     isIdxToTrimStart = idx
                  END
               END
               IF NOT OMITTED(5) AND LEN(char3)>0 !char3
                  IF SELF.s[idx] = char3[1]
                     isIdxToTrimStart = idx
                  END
               END
               IF NOT OMITTED(6) AND LEN(char4)>0 !char4
                  IF SELF.s[idx] = char4[1]
                     isIdxToTrimStart = idx
                  END
               END
            END
            IF isIdxToTrimStart <> idx
               BREAK
            END
       END
    END
    IF trimType = 0 OR trimType = 2
       LOOP idx = sLength to 1 BY -1
            IF SELF.s[idx] = char1[1]
               isIdxToTrimEnd = idx
            ELSE
               IF NOT OMITTED(4) AND LEN(char2)>0!char2
                  IF SELF.s[idx] = char2[1]
                     isIdxToTrimEnd = idx
                  END
               END
               IF NOT OMITTED(5) AND LEN(char3)>0 !char3
                  IF SELF.s[idx] = char3[1]
                     isIdxToTrimEnd = idx
                  END
               END
               IF NOT OMITTED(6) AND LEN(char4)>0!char4
                  IF SELF.s[idx] = char4[1]
                     isIdxToTrimEnd = idx
                  END
               END
            END
            IF isIdxToTrimEnd <> idx
               BREAK
            END
       END
    END
    RETURN SELF.s[(isIdxToTrimStart+1):(isIdxToTrimEnd-1)]

SystemStringClass.Trim PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
 CODE
    RETURN SELF.Trim(0,char1,char2,char3,char4)
SystemStringClass.TrimStart PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
 CODE
    RETURN SELF.Trim(1,char1,char2,char3,char4)
SystemStringClass.TrimEnd PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
 CODE
    RETURN SELF.Trim(2,char1,char2,char3,char4)

SystemStringClass.Split PROCEDURE(STRING lineSeparator,BYTE includeEmptyResults = false)
idxFound     LONG
lineSeparatorStringLen LONG
prevIdxFound LONG
 CODE
    SELF.CleanSplitQueue(SELF.lines)
    SELF.LastSplitDelimiter = lineSeparator
    lineSeparatorStringLen = LEN(lineSeparator)
    idxFound = INSTRING(lineSeparator, SELF.Str(), 1, 1)
    prevIdxFound = 1
    LOOP
       IF idxFound > 0
          IF prevIdxFound < idxFound
             SELF.AddLine(SUB(SELF.Str(),prevIdxFound,idxFound - prevIdxFound  ))
          ELSE
             IF includeEmptyResults AND prevIdxFound = idxFound
                SELF.AddLine('')
             END
          END
          prevIdxFound = idxFound + lineSeparatorStringLen
       ELSE
          BREAK
       END
       idxFound = INSTRING(lineSeparator, SELF.Str(), 1, prevIdxFound)
    END
    IF idxFound = 0
       IF prevIdxFound <= SELF.Length()
          SELF.AddLine(SUB(SELF.Str(),prevIdxFound,SELF.Length() - prevIdxFound + 1))
       ELSE
          IF includeEmptyResults AND prevIdxFound = SELF.Length()
             SELF.AddLine('')
          END
       END
    END

SystemStringClass.ToFile PROCEDURE(STRING fileName)
SystemStringClass_OutFile FILE,DRIVER('DOS'),CREATE
          RECORD
buffer      STRING(32768)
          END
        END
sz      LONG,AUTO
start   LONG,AUTO
amount  LONG,AUTO
CurErr  SIGNED,AUTO
 CODE
  IF fileName = ''
    RETURN BadFileErr
  END
  sz = SELF.Length()
  IF sz = 0
    RETURN 0
  END
  SystemStringClass_OutFile{PROP:Name} = fileName
  CREATE (SystemStringClass_OutFile)
  IF ERRORCODE() THEN RETURN ERRORCODE().
  OPEN (SystemStringClass_OutFile)
  IF ERRORCODE() THEN RETURN ERRORCODE().
  SEND (SystemStringClass_OutFile, 'FILEBUFFERS=' & ROUND(sz/512, 1))

  CurErr = 0
  start  = 1
  LOOP WHILE sz <> 0
    amount = SIZE (SystemStringClass_OutFile.buffer)
    IF amount > sz
      amount = sz
    END
    SystemStringClass_OutFile.buffer [1 : amount] = SELF.s [start : start + amount - 1]
    ADD (SystemStringClass_OutFile, amount)
    CurErr = ERRORCODE()
    IF CurErr <> 0
      BREAK
    END
    start += amount
    sz    -= amount
  END

  CLOSE (SystemStringClass_OutFile)
  RETURN CurErr


SystemStringClass.FromFile PROCEDURE(STRING fileName)
SystemStringClass_InFile  FILE,DRIVER('DOS')
          RECORD
buffer      STRING(32768)
          END
        END
sz      LONG,AUTO
start   LONG,AUTO
fetch   LONG,AUTO
CurErr  SIGNED,AUTO
  CODE
  IF fileName = ''
    RETURN BadFileErr
  END
  SystemStringClass_InFile{PROP:Name} = fileName
  OPEN (SystemStringClass_InFile,40h)
  IF ERRORCODE() THEN
     SELF.Str('')
     RETURN ERRORCODE()
  END
  sz = BYTES(SystemStringClass_InFile)
  IF sz = 0
    SELF.Str('')
    CurErr = BadFileErr
  ELSE
    SEND (SystemStringClass_InFile, 'FILEBUFFERS=' & ROUND(sz/512, 1))
    SELF.DisposeIt()
    SELF.s &= NEW STRING(sz)
    CurErr = 0
    start  = 1
    LOOP WHILE sz <> 0
      fetch = SIZE (SystemStringClass_InFile.buffer)
      IF fetch > sz
        fetch = sz
      END
      GET (SystemStringClass_InFile, start , fetch)
      CurErr = ERRORCODE()
      IF CurErr <> 0
        BREAK
      END
      SELF.s [start : start + fetch - 1] = SystemStringClass_InFile.buffer [1 : fetch]
      start += fetch
      sz    -= fetch
    END
  END

  CLOSE (SystemStringClass_InFile)
  RETURN CurErr

SystemStringClass.FromBlob PROCEDURE(*BLOB b)
sz      LONG,AUTO
  CODE
  sz = b{PROP:Size}
  SELF.DisposeIt()
  IF sz = 0
     SELF.FromString('')
  ELSE
    SELF.s &= new STRING(sz)
    SELF.s[1 : sz] = b [0 : sz - 1]
  END

SystemStringClass.ToBlob PROCEDURE(*BLOB b)
sz      LONG,AUTO
  CODE
  sz = SELF.Length()
  IF sz = 0
    b{PROP:Size} = sz
  ELSE
    b{PROP:Size} = sz
    b [0 : sz - 1] = SELF.s[1 : sz]
  END

SystemStringClass.Take24 PROCEDURE(byte h, byte m, byte l, *STRING Into)
B6 BYTE,AUTO
 CODE
    ! First 6 bits? What does the 'high bit is counted first' expression mean?
    ! I'm assuming top 6 bits of h
    B6 = BSHIFT(h,-2)
    Into[1] = SystemStringClass_Base64Encode[B6+1]
    ! Second 6 bits become bottom 2 of h (up 4) and top 4 of m (down 4)
    B6 = BOR(BAND(BSHIFT(h,4),030H),BSHIFT(m,-4))
    Into[2] = SystemStringClass_Base64Encode[B6+1]
    ! Third 6 bits are bottom 4 of m (up two) and top 2 of l (down 6)
    B6 = BOR(BAND(BSHIFT(m,2),03CH),BSHIFT(l,-6))
    Into[3] = SystemStringClass_Base64Encode[B6+1]
    ! Last 6 come from bottom 6 of l
    Into[4] = SystemStringClass_Base64Encode[BAND(l,03FH)+1]

SystemStringClass.Take32 PROCEDURE(*byte h, *byte m, *byte l, *STRING SFrom)
Buff BYTE,DIM(4),AUTO
idx  BYTE,AUTO
 CODE
    LOOP idx = 1 TO 4
      Buff[idx] = INSTRING(SFrom[idx],SystemStringClass_Base64Encode)
?     ASSERT(Buff[idx])
      Buff[idx] -= 1
    END
?   ASSERT(Buff[1]<>64)
?   ASSERT(Buff[2]<>64)
    ! Whole of first 6 bits up two and first two of second (down 4)
    h = BOR(BSHIFT(Buff[1],2),BSHIFT(Buff[2],-4))
    IF Buff[3] = 64 THEN RETURN 1 .
    ! Middle is bottom 4 bits of second (up 4) and top 4 bits of third (down 2)
    m = BOR(BSHIFT(Buff[2],4),BSHIFT(Buff[3],-2))
    IF Buff[4] = 64 THEN RETURN 2 .
    ! Bottom is bottom two bits of third (up 6) and whole of fourth
    l = BOR(BSHIFT(Buff[3],6),Buff[4])
    RETURN 3

SystemStringClass.ToBase64 PROCEDURE()
SOutv SystemStringClass
 CODE
    SOutv.Str(SELF)
    SOutv.EncodeBase64()
    RETURN SOutv.ToString()

SystemStringClass.FromBase64 PROCEDURE(STRING svalue)
SOutv SystemStringClass
 CODE
    SOutv.Str(svalue)
    SOutv.DecodeBase64()
    SELF.Str(SOutv)

SystemStringClass.EncodeBase64 PROCEDURE()
idx    SIGNED,AUTO
Blk    SIGNED,AUTO
Outv   &CSTRING
outBlk LONG
 CODE
    outBlk = (SELF.Length() * 4)
    IF outBlk % 3 > 0
       outBlk = outBlk/3 + 4
    ELSE
       outBlk = outBlk / 3
    END!if
    Outv &= new CSTRING(outBlk+1)
    Blk = SELF.Length()/3

    LOOP idx = 1 TO Blk
         SELF.Take24(VAL(SELF.s[idx*3-2]),VAL(SELF.s[idx*3-1]),VAL(SELF.s[idx*3]),Outv[idx*4-3:idx*4])
    END

    IF Blk * 3 < LEN(SELF.s)
      IF Blk *3 + 1 = LEN(SELF.s)
         SELF.Take24(VAL(SELF.s[LEN(SELF.s)]),0,0,Outv[Blk*4+1:Blk*4+4])
         Outv[Blk*4+3] = '='
         Outv[Blk*4+4] = '='
      ELSE
         SELF.Take24(VAL(SELF.s[LEN(SELF.s)-1]),VAL(SELF.s[LEN(SELF.s)]),0,Outv[Blk*4+1:Blk*4+4])
         Outv[Blk*4+4] = '='
      END
      outBlk = Blk*4+4
    ELSE
      outBlk = Blk * 4
    END

    SELF.FromString(Outv[1: (outBlk)])
    Outv = ''
    DISPOSE(Outv)

SystemStringClass.DecodeBase64 PROCEDURE()
F       SIGNED(1)
Store   STRING(4)
SH      BYTE(0)
OutF    SIGNED(1)
B       BYTE,DIM(3)
N       BYTE,AUTO
newSize LONG
newCS   &STRING
 CODE
    newSize = INT(LEN(SELF.s) * 3/4) !+ 1
    newCS &= new STRING(newSize)
    LOOP WHILE F <= LEN(SELF.s)
       IF INSTRING(SELF.s[F],SystemStringClass_Base64Encode)
          SH += 1
          Store[SH] = SELF.s[F]
          IF Sh = 4
             N = SELF.Take32(B[1],B[2],B[3],Store)
             newCS[OutF] = CHR(B[1])
             OutF += 1
             IF N = 1 THEN BREAK .
             newCS[OutF] = CHR(B[2])
             OutF += 1
             IF N = 2 THEN BREAK .
             newCS[OutF] = CHR(B[3])
             OutF += 1
            Sh = 0
          END
       END
       F += 1
    END
    SELF.DisposeIt()
    SELF.s &= newCS


SystemStringClass.HtmlEscape PROCEDURE()
idxChar          LONG,AUTO
lastIdx          LONG,AUTO
strLen           LONG,AUTO
curChar          STRING(1),AUTO
ReplacedBy       CSTRING(10),AUTO
tmpStr           SystemStringClass
 CODE
    idxChar = 0
    lastIdx = 1
    strLen = SELF.Length()
    LOOP
       idxChar+=1
       IF idxChar > strLen
          !Append till the end
          IF lastIdx > 1 AND lastIdx < strLen
             tmpStr.Append(SELF.s [lastIdx : strLen])
          END
          BREAK
       END
       curChar = SELF.s [idxChar]
       IF INSTRING(curChar,'&<>"''',1,1)
          CASE curChar
          OF '&'
                ReplacedBy   = '&amp;'
                !LenReplacedBy= 5
          OF '>'
                ReplacedBy   = '&gt;'
                !LenReplacedBy= 4
          OF '<'
                ReplacedBy   = '&lt;'
                !LenReplacedBy= 4
          OF ''''
                ReplacedBy   = '&apos;'
                !LenReplacedBy= 6
          OF '"'
                ReplacedBy   = '&quot;'
                !LenReplacedBy= 6
          END
          !Do the append t
          tmpStr.Append(SELF.s [lastIdx : (idxChar - 1)] & ReplacedBy)
          lastIdx = idxChar + 1
       END
    END
    IF tmpStr.Length()>0
       SELF.FromString(tmpStr.Str())
    END

SystemStringClass.UrlEncode               PROCEDURE()
 CODE
    SELF.Str(SELF.UrlEncode(SELF.Str()))

SystemStringClass.UrlDecode               PROCEDURE()
 CODE
    SELF.Str(SELF.UrlDecode(SELF.Str()))

SystemStringClass.UrlEncode PROCEDURE(STRING sValue)
sIdx    LONG,AUTO
newStr  SystemStringClass
sChar   STRING(1),AUTO
sAscii  BYTE,AUTO
 CODE
    IF LEN(sValue) > 0
       LOOP sIdx = 1 to LEN(sValue)
          sChar = sValue[sIdx]
          sAscii = VAL(sChar)
          IF sAscii <= 31 !skip
          ELSIF sAscii >= 48 AND sAscii < 58
            newStr.Append(sChar) !no need to encode
          ELSIF sAscii >= 65 AND sAscii < 127
            newStr.Append(sChar) !no need to encode
          ELSE
            newStr.Append('%' & SystemStringClass_ByteToHex(sAscii))
          END!If
       END!loop
       RETURN newStr.str()
    END
    RETURN ''

SystemStringClass.UrlDecode PROCEDURE(STRING sValue)
A       STRING(1),AUTO
B       STRING(1),AUTO
AVal    BYTE,AUTO
BVal    BYTE,AUTO
sIdx    LONG,AUTO
newStr  SystemStringClass
sChar   STRING(1),AUTO
L       LONG,AUTO
L2      LONG,AUTO
 CODE
    L = LEN(sValue)
    IF L > 2
       L2 = L - 2
       newStr.Clean()
       LOOP sIdx = 1 to L
            sChar = sValue[sIdx]
            IF sChar = '%' AND sIdx <= L2
               A = sValue[sIdx+1]
               B = sValue[sIdx+2]
               AVal = VAL(A)
               BVal = VAL(B)
               IF SystemStringClass_IsXDigit(AVal) AND SystemStringClass_IsXDigit(BVal)
                    !0=48
                    !9=57
                    !A=65
                    !Z=90
                    !a=97
                    !z=122
                  IF (AVal >= 97)! 'a')
                      AVal = AVal - 32!'a'-'A' = 97-65 = 32
                  ELSE
                     IF (AVal >= 65)! 'A')
                         AVal = AVal - 55!'A' - 10 = 65 - 10 = 55 
                     ELSE
                         AVal = AVal - 48!'0' = 48
                     END
                  END

                  IF (BVal >= 97)! 'a')
                      BVal = BVal - 32!'a'-'A' = 97-65 = 32
                  ELSE
                     IF (BVal >= 65)! 'A')
                         BVal = BVal - 55!'A' - 10 = 65 - 10 = 55 
                     ELSE
                         BVal = BVal - 48!'0' = 48
                     END
                  END
                  sChar = CHR(16*AVal + BVal)
                  sIdx+=2
               END
            ELSE
              IF sChar = '+'
                 sChar = ' '
              END
            END
            newStr.Append(sChar)
       END
       RETURN newStr.str()
    END
    RETURN sValue

SystemStringClass.Compress PROCEDURE()
compressedBuffer &STRING
result LONG
 CODE
    compressedBuffer &= COMPRESS(SELF.s,-1,result)
    IF result >0
       SELF.DisposeIt()
       SELF.s &= compressedBuffer
       RETURN TRUE
    END
    RETURN FALSE

SystemStringClass.Decompress PROCEDURE()
decompressedBuffer &STRING
result             LONG
lIdx               LONG
 CODE
    lIdx = 0
    LOOP
       lIdx+=1
       decompressedBuffer &= NEW STRING(1024 * lIdx)
       DECOMPRESS(decompressedBuffer,SELF.s,result)
       IF result > 0
          SELF.FromString(decompressedBuffer[1 : result])
          DISPOSE(decompressedBuffer)
          RETURN TRUE
       ELSE
          IF result = -5
            !Double the size of the buffer
            DISPOSE(decompressedBuffer)
            CYCLE
          ELSE
            DISPOSE(decompressedBuffer)
            RETURN FALSE
          END
       END
    END
    RETURN FALSE
!**********************
!Lines support
!**********************

!region Line Support
SystemStringClass.SplitToLines PROCEDURE(LONG lineLength)
strLen LONG,AUTO
start   LONG,AUTO
amount  LONG,AUTO
CurErr  SIGNED,AUTO
 CODE
    SELF.CleanSplitQueue(SELF.lines)
    strLen = SELF.Length()
    start  = 1
    LOOP WHILE strLen <> 0
       amount = lineLength
       IF amount > strLen
         amount = strLen
       END
       SELF.AddLine(SELF.s [start : start + amount - 1])
       start += amount
       strLen-= amount
    END

SystemStringClass.SplitToLines PROCEDURE()
 CODE
    SELF.Split(SELF.EOLMarker)

SystemStringClass.CountLines PROCEDURE()
 CODE
    RETURN RECORDS(SELF.lines)

SystemStringClass.GetLinesCount  PROCEDURE()
 CODE
    RETURN SELF.CountLines()

SystemStringClass.AddLine PROCEDURE(STRING svalue)
 CODE
    SELF.InsertLine(0, svalue)

SystemStringClass.InsertLine PROCEDURE(ULONG startIndex, STRING svalue)
splitStr    &SystemStringClass
 CODE
    splitStr &= new SystemStringClass()
    splitStr.Str(svalue)
    SELF.lines.Str &= splitStr
    ADD(SELF.lines, startIndex)

SystemStringClass.GetLineValue PROCEDURE(ULONG lineNumber)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       RETURN SELF.lines.Str.ToString()
    ELSE
       RETURN ''
    END

SystemStringClass.TryGetLineValue                 PROCEDURE(ULONG lineNumber,*SystemStringClass pValue)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       pValue.Str(SELF.lines.Str.Str())
       RETURN true
    ELSE
       RETURN false
    END

SystemStringClass.SetLineValue            PROCEDURE(ULONG lineNumber, STRING lineVal)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       SELF.lines.Str.Str(lineVal)
       RETURN true
    ELSE
       RETURN false
    END

SystemStringClass.GetLineTrimValue PROCEDURE(ULONG lineNumber)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       RETURN CLIP(LEFT(SELF.ReplaceSubString(SELF.lines.Str.ToString(),SELF.EOLMarker,'')))
    ELSE
       RETURN ''
    END

SystemStringClass.GetLine PROCEDURE(ULONG lineNumber)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       RETURN SELF.lines.Str
    ELSE
       RETURN 0
    END

SystemStringClass.GetLines                  PROCEDURE()
 CODE
    RETURN SELF.lines

SystemStringClass.DeleteLine                PROCEDURE(ULONG lineNumber)
 CODE
    IF lineNumber <= RECORDS(SELF.lines)
       GET(SELF.lines,lineNumber)
       IF NOT ERRORCODE()
          DISPOSE(SELF.lines.Str)
          DELETE(SELF.lines)
       END
    END

SystemStringClass.FromLines PROCEDURE()
 CODE
    SELF.FromLines('')

SystemStringClass.FromLines PROCEDURE(STRING delimiter)
 CODE
    SELF.FromLines('',delimiter)

SystemStringClass.FromLinesWithEOL PROCEDURE()
 CODE
    SELF.FromLines('',SELF.EOLMarker)

SystemStringClass.FromLines PROCEDURE(STRING leftDelimiter, STRING rigthDelimiter)
 CODE
    SELF.FromLines(leftDelimiter, rigthDelimiter, false, false)

SystemStringClass.FromLines PROCEDURE(STRING leftDelimiter, STRING rigthDelimiter, BYTE omitFirstSeparator, BYTE omitLastSeparator)
idx LONG
lastIdx LONG
 CODE
    lastIdx = RECORDS(SELF.lines)
    SELF.FromString('')
    LOOP idx = 1 TO lastIdx
       GET(SELF.lines,idx)
       IF omitFirstSeparator AND idx = 1
          SELF.Append(SELF.lines.Str.ToString()&rigthDelimiter)
       ELSE
          IF omitLastSeparator AND idx = lastIdx
             SELF.Append(leftDelimiter&SELF.lines.Str.ToString())
          ELSE
             SELF.Append(leftDelimiter&SELF.lines.Str.ToString()&rigthDelimiter)
          END
       END
    END

SystemStringClass.Merge PROCEDURE(STRING itemDelimiter)
 CODE
    SELF.FromLines('',itemDelimiter,true,true)

SystemStringClass.Merge PROCEDURE()
 CODE
    SELF.FromLines('',SELF.LastSplitDelimiter,true,true)

SystemStringClass.GetEOLMarker PROCEDURE()
 CODE
    RETURN SELF.EOLMarker

SystemStringClass.SetEOLMarker PROCEDURE(STRING EOLMarker)
 CODE
    SELF.EOLMarker = EOLMarker

SystemStringClass.GetValueSeparator       PROCEDURE()
 CODE
    RETURN SELF.valueSep

SystemStringClass.SetValueSeparator       PROCEDURE(STRING valueSeparator)
 CODE
    SELF.valueSep = valueSeparator

SystemStringClass.GetPairSeparator       PROCEDURE()
 CODE
    RETURN SELF.pairSep

SystemStringClass.SetPairSeparator       PROCEDURE(STRING pairSeparator)
 CODE
    SELF.pairSep = pairSeparator

SystemStringClass.SetPairValueSeparator  PROCEDURE(STRING pairSeparator, STRING valueSeparator)
 CODE
    SELF.pairSep = pairSeparator
    SELF.valueSep = valueSeparator

SystemStringClass.GetTokensDelimiters       PROCEDURE()
 CODE
    RETURN SELF.TokensDelimiters

SystemStringClass.SetTokensDelimiters       PROCEDURE(STRING delimiters)
 CODE
    SELF.TokensDelimiters = delimiters

SystemStringClass.SetUseLowerAsciiAsDelimiters PROCEDURE(BYTE value)
 CODE
    IF value>0
       SELF.LowerAsciiAsDelimiters = true
    ELSE
       SELF.LowerAsciiAsDelimiters = false
    END

SystemStringClass.GetUseLowerAsciiAsDelimiters PROCEDURE()
 CODE
    RETURN SELF.LowerAsciiAsDelimiters

SystemStringClass.ResetToken                PROCEDURE()
 CODE
    SELF.TokenSelStart = 0
    SELF.TokenSelEnd   = 0

SystemStringClass.IsPastEOL               PROCEDURE()
 CODE
    IF SELF.s &= NULL |
    OR SELF.TokenSelStart > SELF.TokenSelEnd |
    OR (SELF.TokenSelStart > SELF.Length() |
        AND NOT (SELF.TokenSelStart = SELF.TokenSelEnd AND SELF.TokenSelStart = (SELF.Length() + 1))  |
        )
       RETURN TRUE
    END
    RETURN FALSE

SystemStringClass.CountTokens             PROCEDURE()
lRetVal LONG,AUTO
 CODE
    lRetVal = 0
    SELF.ResetToken()
    LOOP
       SELF.NextToken()
       IF SELF.IsPastEOL()
          BREAK
       END
       IF NOT SELF.IsTokenEmpty() AND NOT SELF.IsTokenNull()
          lRetVal += 1
       END
    END
    RETURN lRetVal

SystemStringClass.CountWords               PROCEDURE()
lRetVal LONG,AUTO
lOldUseAscii BYTE,AUTO
 CODE
    lOldUseAscii = SELF.GetUseLowerAsciiAsDelimiters()
    SELF.SetUseLowerAsciiAsDelimiters(true)
    lRetVal = SELF.CountTokens()
    SELF.SetUseLowerAsciiAsDelimiters(lOldUseAscii)
    RETURN lRetVal

SystemStringClass.GetWord               PROCEDURE(ULONG wordIndex)
lIndex LONG,AUTO
 CODE
    lIndex = 0
    SELF.ResetToken()
    LOOP
       SELF.NextToken()
       IF SELF.IsPastEOL()
          BREAK
       END
       IF NOT SELF.IsTokenEmpty() AND NOT SELF.IsTokenNull()
          lIndex+=1
          IF lIndex = wordIndex
             RETURN SELF.GetCurrentToken()
          END
       END
    END
    RETURN ''

SystemStringClass.IsTokenEmpty              PROCEDURE()
 CODE
    IF SELF.s &= NULL OR (SELF.TokenSelStart = SELF.TokenSelEnd AND SELF.IsDelimiter(SELF.TokenSelStart))
       RETURN TRUE
    END
    RETURN FALSE

SystemStringClass.IsDelimiter             PROCEDURE(LONG checkIndex)
 CODE
    IF INSTRING(SELF.s[(checkIndex):(checkIndex)], SELF.TokensDelimiters, 1, 1)
       RETURN TRUE
    ELSE
       IF SELF.GetUseLowerAsciiAsDelimiters()
          IF (VAL(SELF.s[(checkIndex):(checkIndex)]) < 32)
             RETURN TRUE
          END
       END
    END
    RETURN FALSE

SystemStringClass.IsTokenNull               PROCEDURE()
 CODE
    IF SELF.s &= NULL OR |
       (SELF.TokenSelStart > SELF.TokenSelEnd) OR |
       (SELF.TokenSelEnd > SELF.Length()) OR |
       (SELF.TokenSelStart > SELF.Length()) OR |
       (SELF.TokenSelStart < 1) OR |
       (SELF.TokenSelEnd < 1)

       RETURN TRUE
    END
    RETURN FALSE

SystemStringClass.IsTokenInited             PROCEDURE()
 CODE
    IF SELF.TokenSelStart = 0 AND SELF.TokenSelEnd = 0
       RETURN FALSE
    ELSE
       RETURN TRUE
    END

SystemStringClass.GetCurrentToken           PROCEDURE()
 CODE
    IF SELF.IsTokenNull() OR (SELF.TokenSelStart = SELF.TokenSelEnd AND SELF.IsDelimiter(SELF.TokenSelEnd))
       RETURN ''
    ELSE
       !SELF.TokenSelEnd is always the separator when a next token exist
       IF INSTRING(SELF.s[(SELF.TokenSelEnd):(SELF.TokenSelEnd)], SELF.TokensDelimiters, 1, 1)
          RETURN SELF.s[(SELF.TokenSelStart):(SELF.TokenSelEnd - 1)]
       ELSE
          RETURN SELF.s[(SELF.TokenSelStart):(SELF.TokenSelEnd)]
       END
    END

SystemStringClass.FoundToken PROCEDURE(STRING svalue)
 CODE
    RETURN SELF.FoundToken(svalue,1)

SystemStringClass.FoundToken PROCEDURE(STRING svalue, ULONG startIndex)
idx          LONG,AUTO
startIdx     LONG,AUTO
endIdx       LONG,AUTO
startIdxOK   BYTE,AUTO
endIdxOK     BYTE,AUTO
 CODE
    idx = SELF.IndexOf(svalue, startIndex)
    IF idx>0
       startIdx = idx
       endIdx = startIdx + LEN(svalue) - 1
       !Check the what if was found is a token
       !to be a token it must be delimited by the delimiters
       startIdxOK = true
       IF startIdx > 1
          IF NOT SELF.IsDelimiter(startIdx-1)
             !The left limit NOT OK
             startIdxOK = false
          END
       END
       endIdxOK = false
       IF startIdxOK = true
          endIdxOK = true
          IF endIdx < SELF.Length()
             IF NOT SELF.IsDelimiter(startIdx+1)
                !The right limit NOT OK
                endIdxOK = false
             END
          END
       END
       IF startIdxOK AND endIdxOK
          SELF.TokenSelStart = startIdx
          SELF.TokenSelEnd   = endIdx
          RETURN startIdx
       END
    END
    SELF.ResetToken()
    RETURN 0

SystemStringClass.NextToken                 PROCEDURE()
idx1 LONG
countIdx LONG
subLength LONG,AUTO
 CODE
    IF SELF.s &= NULL
       SELF.ResetToken()
       RETURN ''
    END
    subLength = SELF.Length()

    SELF.TokenSelStart = SELF.TokenSelEnd + 1

    IF SELF.TokenSelEnd = subLength |
       AND NOT SELF.IsDelimiter(subLength)
       RETURN ''
    END

    countIdx = SELF.TokenSelEnd + 1

    LOOP idx1 = (SELF.TokenSelEnd + 1) TO subLength
        IF SELF.IsDelimiter(idx1)
           BREAK
        END
        countIdx += 1
    END
    IF countIdx>subLength AND SELF.TokenSelStart <=subLength
       countIdx=subLength
    END

    SELF.TokenSelEnd = countIdx
    RETURN SELF.GetCurrentToken()

SystemStringClass.PushToken                 PROCEDURE(ULONG startIndex, STRING svalue)
 CODE
    SELF.FromString(SELF.Insert(startIndex, svalue))
    SELF.TokenSelStart = startIndex
    SELF.TokenSelEnd   = startIndex + LEN(svalue)

SystemStringClass.PopToken                  PROCEDURE()
 CODE
    IF NOT SELF.IsTokenNull()
       SELF.FromString(SELF.SubstringLeft(SELF.TokenSelStart)&SELF.Substring(SELF.TokenSelEnd+1))
       SELF.TokenSelEnd = SELF.TokenSelStart
       RETURN TRUE
    ELSE
       RETURN FALSE
    END
!endregion

SystemStringClass.FormatString PROCEDURE(STRING objectsString, <STRING objectsString1>, <STRING objectsString2>, <STRING objectsString3>, <STRING objectsString4>, <STRING objectsString5>)
formatStringRef         SystemStringClass
indxPar LONG
 CODE
    formatStringRef.FromString(SELF.Replace('{{0}',objectsString))
    IF NOT OMITTED(3) AND LEN(objectsString1)>0
       formatStringRef.FromString(formatStringRef.Replace('{{1}',objectsString1))
    END
    IF NOT OMITTED(4) AND LEN(objectsString2)>0
       formatStringRef.FromString(formatStringRef.Replace('{{2}',objectsString2))
    END
    IF NOT OMITTED(5) AND LEN(objectsString3)>0
       formatStringRef.FromString(formatStringRef.Replace('{{3}',objectsString3))
    END
    IF NOT OMITTED(6) AND LEN(objectsString4)>0
       formatStringRef.FromString(formatStringRef.Replace('{{4}',objectsString4))
    END
    IF NOT OMITTED(7) AND LEN(objectsString5)>0
       formatStringRef.FromString(formatStringRef.Replace('{{5}',objectsString5))
    END
    RETURN formatStringRef.ToString()

SystemStringClass_ByteToHex PROCEDURE(BYTE inCharVal, BYTE LowerCase)
Out       STRING(2),AUTO
HEX       &STRING,AUTO
  CODE
  IF LowerCase
    HEX &= SystemStringClass_HexDigitsLow
  ELSE
    HEX &= SystemStringClass_HexDigitsUp
  END
  Out[1] = HEX [BSHIFT(inCharVal, -4) + 1]
  Out[2] = HEX [BAND(inCharVal, 0FH) + 1]
  RETURN Out

SystemStringClass_IsXDigit PROCEDURE(BYTE inCharVal)
 CODE
    !0=48
    !9=57
    !A=65
    !Z=90
    !a=97
    !z=122
    IF (inCharVal>47 AND inCharVal<58) OR (inCharVal>64 AND inCharVal<91) OR (inCharVal>96 AND inCharVal<123)
       RETURN TRUE
    ELSE
       RETURN FALSE
    END

