 MEMBER

 INCLUDE ('ERRORS.CLW')
 INCLUDE ('JSON.INC'),ONCE
  MAP
  END




JSONDataClass.Construct PROCEDURE()
  CODE
     SELF.JSONObject &= new JSONDataValueQueue
     SELF.formater   &= new JSONDataPicturesQueue
 
JSONDataClass.Destruct PROCEDURE()
  CODE
  	SELF.DisposeIt()

JSONDataClass.DisposeIt PROCEDURE()
idx LONG
 CODE
    IF NOT SELF.JSONObject &= NULL
       SELF.ClearObject(SELF.JSONObject)
       DISPOSE(SELF.JSONObject)
    END
    IF NOT SELF.formater &= NULL
       FREE(SELF.formater)
       DISPOSE(SELF.formater)
    END
    IF NOT SELF.retValTmp &=  NULL
       DISPOSE(SELF.retValTmp)
    END
    IF NOT SELF._EscapedString &=  NULL
       DISPOSE(SELF._EscapedString)
    END

JSONDataClass.CreateNewString           PROCEDURE(LONG strSize)
 CODE
    IF NOT SELF.retValTmp &=  NULL
       DISPOSE(SELF.retValTmp)
    END
    SELF.retValTmp &= new STRING(strSize)    
    
JSONDataClass.ClearObject                     PROCEDURE()
 CODE
    SELF.ClearObject(SELF.JSONObject)
    FREE(SELF.formater)
    
JSONDataClass.ClearObject                     PROCEDURE(*JSONDataValueQueue jsonQueue)
idx LONG
 CODE
    IF NOT jsonQueue &= NULL
       LOOP idx = 1 TO RECORDS(jsonQueue)
            GET(jsonQueue, idx)
            IF ERRORCODE()
               BREAK
            END
            DISPOSE(jsonQueue.Value)
       END
       FREE(jsonQueue)
    END
    SELF.JSONObjectSize = 0

JSONDataClass.SetClipValues             PROCEDURE(BYTE value)
 CODE
    IF value
       SELF.clipValues = true
    ELSE
       SELF.clipValues = false
    END
JSONDataClass.GetClipValues             PROCEDURE()!,BYTE
 CODE
    RETURN SELF.clipValues

!TODO: The escape function does nothing check http://www.w3resource.com/JSON/structures.php to see what need to be escaped
JSONDataClass.EscapeString              PROCEDURE(STRING value)!,STRING
CharToReplace   STRING(1)
ReplacedBy      STRING(10)
LenReplacedBy   SHORT
lIndex          SHORT
lLastIndex      SHORT

lSLen           SHORT
lOriginalSLen   SHORT
lReplaced       BYTE
SAux1           &STRING
SAux2           &STRING
 CODE

    SAux1 &= SELF._EscapedString

    IF NOT SAux1 &= NULL
       DISPOSE(SAux1)
    END

    lSLen = LEN(Value)
    lOriginalSLen = lSLen
    SAux1 &= NEW(STRING(lSLen+20))
    SAux1 = Value

    CharToReplace= '"'
    ReplacedBy   = '\"'
    LenReplacedBy= 2
    Do ReplaceOneChar

    CharToReplace= '\'
    ReplacedBy   = '\\'
    LenReplacedBy= 2
    Do ReplaceOneChar

    CharToReplace= CHR(13)
    ReplacedBy   = '\r'
    LenReplacedBy= 2
    Do ReplaceOneChar

    CharToReplace= CHR(10)
    ReplacedBy   = '\n'
    LenReplacedBy= 2
    Do ReplaceOneChar

    SELF._EscapedString &= SAux1
    RETURN SAux1[1:lSLen]

ReplaceOneChar   ROUTINE
    lLastIndex = 1
    LOOP
       lIndex = INSTRING(CharToReplace,SAux1,1,lLastIndex)
       IF lIndex THEN
!          lReplaced = True
!          IF CharToReplace='&'
!             IF lSLen-lIndex>=4
!                IF SAux1[(lIndex):(lIndex+3)]='&gt;' OR SAux1[(lIndex):(lIndex+3)]='&lt;'
!                   lReplaced = False
!                   lLastIndex=lIndex+4
!                END
!             END
!             IF lSLen-lIndex>=5
!                IF SAux1[(lIndex):(lIndex+4)]='&amp;'
!                   lReplaced = False
!                   lLastIndex=lIndex+5
!                END
!             END
!             IF lSLen-lIndex>=6
!                IF SAux1[(lIndex):(lIndex+5)]='&apos;' OR SAux1[(lIndex):(lIndex+5)]='&quot;'
!                   lReplaced = False
!                   lLastIndex=lIndex+6
!                END
!             END
!          END
          !IF lReplaced
             IF (lSLen+LenReplacedBy)>(lOriginalSLen+20) THEN
                SAux2 &= NEW(STRING(lSLen+500))
                SAux2 = ''
                SAux2 = SAux1[1:lSLen]
                DISPOSE(SAux1)
                SAux1 &= SAux2[1:lSLen]
             END
             SAux1 = SAux1[1:(lIndex-1)] & ReplacedBy[1:LenReplacedBy] & SAux1[(lIndex+1):(lSLen)]
             lSLen += LenReplacedBy
             lLastIndex=lIndex+LenReplacedBy
          !END
       ELSE
          BREAK
       END
    END
    
    
JSONDataClass.StringToJSON              PROCEDURE(STRING name, STRING value)!,STRING
 CODE
    IF SELF.clipValues
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": "'& CLIP(SELF.EscapeString(CLIP(value)))&'"'
    ELSE
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": "'& SELF.EscapeString(value)&'"'
    END
    
JSONDataClass.BoolToJSON                PROCEDURE(STRING name, BYTE value)!,STRING
 CODE
    IF value
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": true'
    ELSE
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": false'
    END
    
JSONDataClass.DecimalToJSON             PROCEDURE(STRING name, *DECIMAL value)!,STRING    
 CODE
    RETURN '"'&SELF.EscapeString(CLIP(name)) &'": '& value
 
JSONDataClass.NumberToJSON              PROCEDURE(STRING name, LONG value)!,STRING
JQPicture           STRING(50)
 CODE
    IF SELF.TryGetFormaterPicture(name, JQPicture)
       RETURN SELF.NumberToJSON(name, value, JQPicture)
    END 
    RETURN '"'&SELF.EscapeString(CLIP(name)) &'": '& value

JSONDataClass.NumberToJSON      PROCEDURE(STRING name, LONG value, STRING picture)!,STRING
 CODE
    IF picture = '@BOOL'
       IF value
          RETURN '"'&SELF.EscapeString(CLIP(name)) &'": true'
       ELSE
          RETURN '"'&SELF.EscapeString(CLIP(name)) &'": false'
       END
    ELSE
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": "'& FORMAT(value, picture) &'"'
    END

JSONDataClass.ToJSON                    PROCEDURE(*BYTE[] values)!,STRING
retLen LONG,AUTO
retVal CSTRING(8192)
idx    LONG,AUTO
 CODE
    retLen = MAXIMUM(values,1)
    idx = 1
    LOOP idx = 1 to retLen
         IF values[idx]>0
            retVal = CLIP(retVal) & ', true'
         ELSE
            retVal = CLIP(retVal) & ', false'
         END
    END
    return '[' &CLIP(retVal)& ']'


JSONDataClass.ToJSON                    PROCEDURE(*LONG[] values)!,STRING
 CODE
    RETURN SELF.LongArrToJSON(values)
    
JSONDataClass.ToJSON                    PROCEDURE(*STRING[] values)!,STRING
 CODE
    RETURN SELF.StringArrToJSON(values)
    
JSONDataClass.LongArrToJSON             PROCEDURE(*LONG[] values)!,STRING,PROTECTED
retLen LONG,AUTO
retVal CSTRING(8192)
idx    LONG,AUTO
 CODE
    retLen = MAXIMUM(values,1)
    idx = 1
    LOOP idx = 1 to retLen
         retVal = CLIP(retVal) & ', ' & values[idx]
    END
    return '[' &CLIP(retVal)& ']'

JSONDataClass.StringArrToJSON           PROCEDURE(*STRING[] values)!,STRING,PROTECTED
retLen LONG,AUTO
retVal CSTRING(64000)
idx    LONG,AUTO
 CODE
    retLen = MAXIMUM(values,1)
    idx = 1
    LOOP idx = 1 to retLen
         retVal = CLIP(retVal) & ', ' & '"'& SELF.EscapeString(values[idx])&'"'
    END
    return '[' &CLIP(retVal)& ']'

!TODO: GetGroupSize missing recursion in the GROUP using WHAT 
JSONDataClass.GetGroupSize              PROCEDURE(*GROUP jsonGroup)!, LONG, PROTECTED 
idx LONG,AUTO
totoalSize LONG,AUTO
JQName              CSTRING(256)
 CODE
    !Note missing recursion in the GROUP using WHAT 
    !andtaking references to stings and or groups into account
    totoalSize = 0!SIZE(jsonGroup)
    idx = 1
    LOOP
       JQName = WHO(jsonGroup, idx)          
       IF JQName=''
          BREAK
       END
       totoalSize += LEN(CLIP(JQName)) + 2 + 2      
       IF ISGROUP(jsonGroup, idx)
          !totoalSize += SELF.GetGroupSize(WHAT(jsonGroup, idx))
       ELSE
          IF ISSTRING(WHAT(jsonGroup, idx))
             totoalSize += LEN(WHAT(jsonGroup, idx))
          ELSE 
             totoalSize += 10
          END
       END
       idx+=1
    END
    RETURN totoalSize

!TODO: ToJSON(GROUP)  does not work with arrays of STRINGs or LONGs or GROUPs as part of the GROUP
!TODO: support DECIMALs
JSONDataClass.ToJSON                    PROCEDURE(*GROUP JSONObject)!,STRING,PROTECTED
 CODE
    RETURN SELF.GroupToJSON(JSONObject)
    
JSONDataClass.GroupToJSON               PROCEDURE(*GROUP JSONObject)!,STRING,PROTECTED
idx                 LONG,AUTO
JQName              CSTRING(256)
retIdx              LONG,AUTO
retJsonValueSize    LONG,AUTO
fieldSize           LONG,AUTO
innerGroup &GROUP
innerIdx   LONG,AUTO
 CODE
    IF ADDRESS(JSONObject) = 0
       RETURN ''
    ELSE
       idx = 1
       retIdx = 1
       retJsonValueSize = SELF.GetGroupSize(JSONObject)
       
       SELF.CreateNewString(retJsonValueSize)
       LOOP
          JQName = WHO(JSONObject, idx)
          IF JQName=''
             BREAK
          ELSE
             IF ISGROUP(JSONObject, idx)
                innerGroup &= GETGROUP(JSONObject, idx)
                IF HOWMANY(JSONObject, idx) > 1
                ELSE
                   IF idx = 1
                      SELF.retValTmp = '"'&CLIP(JQName)&'": '&SELF.GroupToJSON(innerGroup)
                   ELSE
                      SELF.retValTmp = CLIP(SELF.retValTmp)&', '&'"'&CLIP(JQName)&'": '&SELF.GroupToJSON(innerGroup)
                   END
                END
                innerIdx = 1
                LOOP
                   IF WHO(innerGroup, innerIdx) = ''
                      BREAK
                   END
                   innerIdx+=1
                END
                idx += innerIdx
                !SELF.retValTmp = CLIP(SELF.retValTmp)&', '&SELF.GroupToJSON(aG, applyFormat)
             ELSE
                IF ISSTRING(WHAT(JSONObject, idx))
                   IF HOWMANY(JSONObject, idx) > 1
                      !SELF.retValTmp = CLIP(SELF.retValTmp)&', '&SELF.StringToJSON(JQName, SELF.StringArrToJSON(WHAT(JSONObject, idx)))
                   ELSE
                      IF idx = 1
                         SELF.retValTmp = SELF.StringToJSON(JQName, WHAT(JSONObject, idx))
                      ELSE
                         SELF.retValTmp = CLIP(SELF.retValTmp)&', '&SELF.StringToJSON(JQName, WHAT(JSONObject, idx))
                      END
                   END
                ELSE
                   !This should be  number
                   IF HOWMANY(JSONObject, idx) > 1
                      !SELF.retValTmp = CLIP(SELF.retValTmp)&', '&SELF.NumberToJSON(JQName, SELF.LongArrToJSON(WHAT(JSONObject, idx)))
                   ELSE
                      IF idx = 1
                         SELF.retValTmp = SELF.NumberToJSON(JQName, WHAT(JSONObject, idx))
                      ELSE
                         SELF.retValTmp = CLIP(SELF.retValTmp)&', '&SELF.NumberToJSON(JQName, WHAT(JSONObject, idx))
                      END                      
                   END
                END
             END
          END
          idx+=1
       END
       RETURN '{{'&CLIP(SELF.retValTmp)&'}'
    END
        
JSONDataClass.ToJSON                    PROCEDURE(*QUEUE JSONArray)!,STRING
 CODE
    RETURN SELF.ToJSON('', JSONArray)
    
JSONDataClass.ToJSON                    PROCEDURE(STRING JSONArrayName, *QUEUE JSONArray)!,STRING
idx  LONG,AUTO
recs LONG,AUTO
retJsonValueSize        LONG,AUTO
retVal &STRING
 CODE
    IF ADDRESS(JSONArray) = 0
       RETURN ''
    ELSE
       recs = RECORDS(JSONArray)
       IF recs = 0
          RETURN '[]'
       END
       retJsonValueSize = SELF.GetGroupSize(JSONArray)
       retVal &= new STRING((retJsonValueSize * recs))
       LOOP idx = 1 TO recs
            GET(JSONArray,idx)
            IF ERRORCODE()
               BREAK
            END
            retVal = CLIP(retVal) & SELF.GroupToJSON(JSONArray)
       END
       IF NOT SELF.retValTmp &= null
          DISPOSE(SELF.retValTmp)
       END
       SELF.retValTmp &= retVal
       IF CLIP(JSONArrayName)<>''
          RETURN '{{"'&CLIP(JSONArrayName)&'": ['&CLIP(SELF.retValTmp)&']}'
       ELSE
          RETURN '['&CLIP(SELF.retValTmp)&']'
       END
    END

JSONDataClass.AddString                 PROCEDURE(STRING name, STRING value)
 CODE
    SELF.JSONObject.Name = CLIP(name)
    SELF.JSONObject.Value &= new STRING(SIZE(value)+100)
    IF SELF.clipValues
       SELF.JSONObject.Value = '"'&CLIP(SELF.EscapeString(CLIP(value)))&'"'
    ELSE
       SELF.JSONObject.Value = '"'&SELF.EscapeString(value)&'"'
    END
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)
    
JSONDataClass.AddBool                   PROCEDURE(STRING name, BYTE value)
 CODE
    SELF.JSONObject.Name = CLIP(name)
    IF value > 0
       SELF.JSONObject.Value &= new STRING(4)
       SELF.JSONObject.Value = 'true'
    ELSE
       SELF.JSONObject.Value &= new STRING(5)
       SELF.JSONObject.Value = 'false'
    END
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)

JSONDataClass.AddNumber                 PROCEDURE(STRING name, LONG value)
snum CSTRING(14)
 CODE
    SELF.JSONObject.Name = CLIP(name)
    snum = value   
    SELF.JSONObject.Value &= new STRING(LEN(CLIP(snum)))
    SELF.JSONObject.Value = CLIP(snum)
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)
    
JSONDataClass.AddNumber         PROCEDURE(STRING name, LONG value, STRING picture)
snum CSTRING(100)
 CODE
    SELF.JSONObject.Name = CLIP(name)
    snum = FORMAT(value, picture)
    SELF.JSONObject.Value &= new STRING(LEN(CLIP(snum)))
    SELF.JSONObject.Value = '"'&CLIP(snum)&'"'
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)

JSONDataClass.AddGroup                  PROCEDURE(STRING name, *GROUP value)
grpLen LONG,AUTO
 CODE
    SELF.JSONObject.Name = CLIP(name)
    grpLen = SELF.GetGroupSize(value)
    SELF.JSONObject.Value &= new STRING(grpLen)
    SELF.JSONObject.Value = SELF.ToJSON(value)
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)
 
JSONDataClass.AddQueue                  PROCEDURE(STRING name, *QUEUE value)
grpLen LONG,AUTO
recs   LONG,AUTO
totalSize LONG,AUTO
 CODE
    recs = RECORDS(value)
    SELF.JSONObject.Name = CLIP(name)
    IF recs = 0
       SELF.JSONObject.Value &= new STRING(2)
       SELF.JSONObject.Value = '[]'
    ELSE
       grpLen = SELF.GetGroupSize(value) + 2 !the group size + {}
       totalSize = (grpLen * recs) + recs - 1 + 2 !
       SELF.JSONObject.Value &= new STRING(totalSize)
       SELF.JSONObject.Value = SELF.ToJSON(value)
    END
    SELF.JSONObjectSize += LEN(SELF.JSONObject.Name) + LEN(SELF.JSONObject.Value)
    ADD(SELF.JSONObject)

JSONDataClass.GetJSONObjectSize         PROCEDURE()
recs LONG,AUTO
totalSize LONG,AUTO
 CODE
    totalSize = 0
    recs = RECORDS(SELF.JSONObject)
    totalSize = SELF.JSONObjectSize
    totalSize += (recs * 2) ! the quoates arround the name
    totalSize += ((recs-1) * 2) ! the comman and space between the name and the value    
    RETURN totalSize
    
JSONDataClass.ToJSON                    PROCEDURE()!,STRING
idx  LONG,AUTO
recs LONG,AUTO
retVal &STRING
 CODE
    retVal &= new STRING(SELF.GetJSONObjectSize())
    recs = RECORDS(SELF.JSONObject)
    LOOP idx = 1 TO recs
         GET(SELF.JSONObject,idx)
         IF ERRORCODE()
            BREAK
         END
         retVal = CLIP(retVal) & '"' & SELF.JSONObject.Name& '", ' & CLIP(SELF.JSONObject.Value)
    END
    IF NOT SELF.retValTmp &= NULL
       DISPOSE(SELF.retValTmp)
    END
    SELF.retValTmp &= retVal
    RETURN '{{'&CLIP(retVal)&'}'
    
JSONDataClass.SetNumberFormater         PROCEDURE(STRING fieldName, STRING picture)
 CODE
    IF NOT SELF.formater &= NULL
       IF CLIP(picture) = ''
          SELF.formater.Name = UPPER(CLIP(fieldName))
          GET(SELF.formater,SELF.formater.Name)
          IF NOT ERRORCODE() AND SELF.formater.Name = UPPER(CLIP(fieldName))
             DELETE(SELF.formater)
          END
       ELSE
          SELF.formater.Name = UPPER(CLIP(fieldName))
          SELF.formater.Picture = picture
          ADD(SELF.formater)
       END
    END

JSONDataClass.TryGetFormaterPicture     PROCEDURE(STRING fieldName, *STRING picture)
retVal BYTE
 CODE
    retVal = FALSE
    IF NOT SELF.formater &= NULL
       SELF.formater.Name = UPPER(CLIP(fieldName))
       GET(SELF.formater,SELF.formater.Name)
       IF NOT ERRORCODE() AND SELF.formater.Name = UPPER(CLIP(fieldName))
          picture = SELF.formater.Picture
          retVal = true
       END
    END   
    RETURN retVal

!JSONDataClass.GetName                   PROCEDURE(STRING JSONString)!,STRING
!nameStart LONG
!nameEnd LONG 
!valueStart LONG 
!valueEnd LONG
! CODE
!    IF SELF.GetNameValuePositions(JSONString,nameStart,nameEnd,valueStart,valueEnd)
!       RETURN JSONString[nameStart : nameEnd]
!    ELSE 
!       RETURN ''
!    END
!    
!JSONDataClass.GetValue                  PROCEDURE(STRING JSONString)!,STRING
!nameStart LONG
!nameEnd LONG 
!valueStart LONG 
!valueEnd LONG
! CODE
!    IF SELF.GetNameValuePositions(JSONString,nameStart,nameEnd,valueStart,valueEnd)
!       RETURN JSONString[valueStart : valueEnd]
!    ELSE 
!       RETURN ''
!    END
!
!JSONDataClass.GetNameValue              PROCEDURE(STRING JSONString,*STRING name, *STRING value)!,BYTE,PROC
!nameStart LONG
!nameEnd LONG 
!valueStart LONG 
!valueEnd LONG
! CODE
!    IF SELF.GetNameValuePositions(JSONString,nameStart,nameEnd,valueStart,valueEnd)
!       name = JSONString[nameStart : nameEnd]
!       value = JSONString[valueStart : valueEnd]
!       RETURN True
!    ELSE 
!       RETURN False
!    END
!    
!!TODO: GetNameValuePositions does not return valid values. The functions is not finish
!JSONDataClass.GetNameValuePositions     PROCEDURE(STRING JSONString,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd)
!idxFound       LONG
!tokenStringLen LONG
!prevIdxFound   LONG
! CODE
!    tokenStringLen = LEN(JSONString)
!    idxFound = INSTRING(':', JSONString, 1, 1)
!    IF idxFound = 0
!       nameStart  = 0
!       nameEnd    = 0
!       valueStart = 0
!       valueEnd   = 0
!       RETURN false
!    END   
!    RETURN false
