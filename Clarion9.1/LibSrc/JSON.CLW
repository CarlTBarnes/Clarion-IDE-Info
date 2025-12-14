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

JSONDataClass.EscapeString              PROCEDURE(STRING value)!,STRING
CharToReplace   STRING(1),AUTO
ReplacedBy      STRING(10),AUTO
LenReplacedBy   SHORT,AUTO
lIndex          ULONG,AUTO
lLastIndex      ULONG,AUTO
lIndex1         ULONG,AUTO
lIndex2         ULONG,AUTO
lSubLen         ULONG,AUTO

lSLen           ULONG,AUTO
lOriginalSLen   ULONG,AUTO
lReplaced       BYTE,AUTO
SAux1           &STRING
SAux2           &STRING
indexQ          QUEUE
i                ULONG
                END
lI              ULONG,AUTO  
tFound          ULONG,AUTO
 CODE

    SAux1 &= SELF._EscapedString

    IF NOT SAux1 &= NULL
       DISPOSE(SAux1)
    END

    lSLen = LEN(Value)
    lOriginalSLen = lSLen
    SAux1 &= NEW(STRING(lSLen))
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
    FREE(indexQ)
    LOOP
       lIndex = INSTRING(CharToReplace,SAux1,1,lLastIndex)
       IF lIndex THEN
          indexQ.i = lIndex
          ADD(indexQ)
          lLastIndex = lIndex + 1
       ELSE
          BREAK
       END
    END
    tFound = RECORDS(indexQ)
    IF tFound>0
       SAux2 &= NEW(STRING(lSLen - tFound + (tFound * LenReplacedBy)))
       lIndex1 = 1
       lLastIndex = 0
       LOOP lI = 1 TO RECORDS(indexQ)
            GET(indexQ,lI)
            IF NOT ERRORCODE()
               lSubLen = indexQ.i - lLastIndex - 1
               lIndex2 = lIndex1 + lSubLen + LenReplacedBy - 1
               SAux2[lIndex1 : lIndex2] = SUB(SAux1, lLastIndex + 1 ,lSubLen) & ReplacedBy[1:LenReplacedBy]
               lLastIndex = indexQ.i
               lIndex1 = lIndex2+LenReplacedBy - 1
            END
       END
       !from last to end
       IF lLastIndex < lSLen
          SAux2[lIndex1 : LEN(SAux2)] = SAux1[(lLastIndex+1) : lSLen]
       END
       lSLen = lSLen - tFound + (tFound * LenReplacedBy)
       DISPOSE(SAux1)
       SAux1 &= SAux2
    END
    
    
JSONDataClass.StringToJSON              PROCEDURE(STRING name, STRING value)
 CODE
    IF SELF.clipValues
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": "'& CLIP(SELF.EscapeString(CLIP(value)))&'"'
    ELSE
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": "'& SELF.EscapeString(value)&'"'
    END
    
JSONDataClass.BoolToJSON                PROCEDURE(STRING name, BYTE value)
 CODE
    IF value
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": true'
    ELSE
       RETURN '"'&SELF.EscapeString(CLIP(name)) &'": false'
    END
    
JSONDataClass.DecimalToJSON             PROCEDURE(STRING name, *DECIMAL value)
 CODE
    RETURN '"'&SELF.EscapeString(CLIP(name)) &'": '& value
 
JSONDataClass.NumberToJSON              PROCEDURE(STRING name, LONG value)
JQPicture           STRING(50)
 CODE
    IF SELF.TryGetFormaterPicture(name, JQPicture)
       RETURN SELF.NumberToJSON(name, value, JQPicture)
    END 
    RETURN '"'&SELF.EscapeString(CLIP(name)) &'": '& value

JSONDataClass.NumberToJSON      PROCEDURE(STRING name, LONG value, STRING picture)
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

JSONDataClass.ToJSON                    PROCEDURE(*BYTE[] values)
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


JSONDataClass.ToJSON                    PROCEDURE(*LONG[] values)
 CODE
    RETURN SELF.LongArrToJSON(values)
    
JSONDataClass.ToJSON                    PROCEDURE(*STRING[] values)
 CODE
    RETURN SELF.StringArrToJSON(values)
    
JSONDataClass.LongArrToJSON             PROCEDURE(*LONG[] values)
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

JSONDataClass.StringArrToJSON           PROCEDURE(*STRING[] values)
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
JSONDataClass.GetGroupSize              PROCEDURE(*GROUP jsonGroup)
idx LONG,AUTO
totalSize LONG,AUTO
JQName              CSTRING(256)
 CODE
    !Note missing recursion in the GROUP using WHAT 
    !and taking references to strings and or nested groups into account
    totalSize = 0!SIZE(jsonGroup)
    idx = 1
    LOOP
       JQName = WHO(jsonGroup, idx)          
       IF JQName=''
          BREAK
       END
       totalSize += LEN(CLIP(JQName)) + 2 + 2      
       IF ISGROUP(jsonGroup, idx)
          !totalSize += SELF.GetGroupSize(WHAT(jsonGroup, idx))
       ELSE
          IF ISSTRING(WHAT(jsonGroup, idx))
             totalSize += LEN(WHAT(jsonGroup, idx))
          ELSE 
             totalSize += 10
          END
       END
       idx+=1
    END
    RETURN totalSize

!TODO: ToJSON(GROUP)  does not work with arrays of STRINGs or LONGs or GROUPs as part of the GROUP
!TODO: support DECIMALs
JSONDataClass.ToJSON                    PROCEDURE(*GROUP JSONObject)
 CODE
    RETURN SELF.GroupToJSON(JSONObject)
    
JSONDataClass.GroupToJSON               PROCEDURE(*GROUP JSONObject)
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
        
JSONDataClass.ToJSON                    PROCEDURE(*QUEUE JSONArray)
 CODE
    RETURN SELF.ToJSON('', JSONArray)
    
JSONDataClass.ToJSON                    PROCEDURE(STRING JSONArrayName, *QUEUE JSONArray)
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
       retVal &= new STRING(((retJsonValueSize+1) * recs))
       LOOP idx = 1 TO recs
            GET(JSONArray,idx)
            IF ERRORCODE()
               BREAK
            END
            IF idx = 1
               retVal = SELF.GroupToJSON(JSONArray)
            ELSE
               retVal = CLIP(retVal) & ',' & SELF.GroupToJSON(JSONArray)
            END
            
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
    
JSONDataClass.ToJSON                    PROCEDURE()
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
         IF idx = 1
            retVal = '"' & SELF.JSONObject.Name& '": ' & CLIP(SELF.JSONObject.Value)
         ELSE               
            retVal = CLIP(retVal) & ', "' & SELF.JSONObject.Name& '": ' & CLIP(SELF.JSONObject.Value)
         END                  
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
          IF NOT ERRORCODE()
             DELETE(SELF.formater)
          END
       ELSE
          SELF.formater.Name = UPPER(CLIP(fieldName))
          SELF.formater.Picture = picture
          ADD(SELF.formater)
       END
    END

JSONDataClass.GetNumberFormater            PROCEDURE(STRING fieldName)
 CODE
    IF NOT SELF.formater &= NULL
       SELF.formater.Name = UPPER(CLIP(fieldName))
       GET(SELF.formater,SELF.formater.Name)
       IF NOT ERRORCODE()
          RETURN SELF.formater.Name
       END
    END
    RETURN ''
    
JSONDataClass.DeleteNumberFormater         PROCEDURE(STRING fieldName)
 CODE
    SELF.SetNumberFormater(fieldName,'')

JSONDataClass.TryGetFormaterPicture     PROCEDURE(STRING fieldName, *STRING picture)
retVal BYTE
 CODE
    retVal = FALSE
    IF NOT SELF.formater &= NULL
       SELF.formater.Name = UPPER(CLIP(fieldName))
       GET(SELF.formater,SELF.formater.Name)
       IF NOT ERRORCODE()
          picture = SELF.formater.Picture
          retVal = true
       END
    END   
    RETURN retVal

JSONDataClass.TryGetName                   PROCEDURE(STRING pJSONString, *STRING name)
nameStart LONG
nameEnd LONG 
valueStart LONG 
valueEnd LONG
 CODE
    IF SELF.TryGetNameValuePositions(pJSONString,nameStart,nameEnd,valueStart,valueEnd)
       name = pJSONString[nameStart : nameEnd]
       RETURN true
    ELSE 
       RETURN false
    END
    
JSONDataClass.TryGetValue                  PROCEDURE(STRING pJSONString, *STRING value)
nameStart LONG
nameEnd LONG 
valueStart LONG 
valueEnd LONG
 CODE
    IF SELF.TryGetNameValuePositions(pJSONString,nameStart,nameEnd,valueStart,valueEnd)
       value = pJSONString[valueStart : valueEnd]
       RETURN true
    ELSE 
       RETURN false
    END
    
JSONDataClass.TryGetNameValue              PROCEDURE(STRING pJSONString,*STRING name, *STRING value)
nameStart LONG
nameEnd LONG 
valueStart LONG 
valueEnd LONG
 CODE
    IF SELF.TryGetNameValuePositions(pJSONString,nameStart,nameEnd,valueStart,valueEnd)
       name = pJSONString[nameStart : nameEnd]
       value = pJSONString[valueStart : valueEnd]
       RETURN True
    ELSE 
       RETURN False
    END
    
JSONDataClass.TryGetNameValuePositions     PROCEDURE(*STRING pJSONString,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd)
pairStart LONG
pairEnd   LONG
 CODE
    pairStart = 1
    pairEnd   = LEN(pJSONString)
    RETURN SELF.TryGetNextPairPositions(pJSONString,pairStart,pairEnd,nameStart,nameEnd,valueStart,valueEnd)
    
JSONDataClass.TryGetNextPairPositions      PROCEDURE(*STRING pJSONString,*LONG pairStart,*LONG pairEnd,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd)
 CODE    
    RETURN SELF.TryGetNextPairPositions(pJSONString, LEN(pJSONString),pairStart,pairEnd,nameStart,nameEnd,valueStart,valueEnd)

JSONDataClass.TryGetNextPairPositions      PROCEDURE(*STRING pJSONString, LONG itemEnd,*LONG pairStart,*LONG pairEnd,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd)
idxFound          LONG
openCurlyBrakets  LONG,AUTO
startCurlyBrakets BYTE,AUTO
openBrakets       LONG,AUTO
idx               LONG,AUTO
openQuotes        BYTE,AUTO
 CODE
    nameStart  = 0
    nameEnd    = 0
    valueStart = 0
    valueEnd   = 0
    pairEnd    = -1
    
    IF CLIP(pJSONString) = ''
       RETURN FALSE
    END

    IF itemEnd = 0
       itemEnd = LEN(pJSONString)
    END
    IF pairStart>=itemEnd
       RETURN FALSE
    END
!    IF itemStart = 0
!       itemStart = 1
!    END
    IF pairStart = 0 
       pairStart = 1
    END
    idxFound = INSTRING(':', pJSONString, 1, pairStart)
    IF idxFound = 0
       RETURN FALSE
    END
    openCurlyBrakets = 0
    valueEnd   = itemEnd
    pairEnd    = itemEnd
    openQuotes = FALSE
    startCurlyBrakets= FALSE
    openBrakets=0
    LOOP idx = pairStart to itemEnd
         IF openQuotes = FALSE AND pJSONString[idx] = '{{'
            openCurlyBrakets += 1            
            CYCLE
         END
         IF nameStart = 0 
            IF pJSONString[idx] = ' ' !Omit any empty spaces
               CYCLE 
            END
            IF openCurlyBrakets>0
               startCurlyBrakets = true
            END
            nameStart = idx
            pairStart = nameStart
            IF pJSONString[idx] = '"'
               nameStart += 1
            END
         END
         IF openQuotes = FALSE AND nameEnd > 0 AND valueStart = 0 AND pJSONString[idx] <> ' '
            valueStart = idx
         END
         IF pJSONString[idx] = '"'
            IF openQuotes = FALSE
               openQuotes = TRUE
            ELSE
               openQuotes = FALSE
            END            
         END
         IF openQuotes = FALSE
            IF pJSONString[idx] = '['
               openBrakets+=1
            END
            IF pJSONString[idx] = ']'
               openBrakets-=1
            END
            IF openBrakets = 0
               IF nameEnd = 0 AND pJSONString[idx] = ':'
                  nameEnd = idx - 1
                  LOOP
                     IF nameEnd <= nameStart
                        BREAK
                     END
                     IF pJSONString[nameEnd] = '"'
                        nameEnd -= 1
                        BREAK   
                     END
                     nameEnd -= 1
                  END
                  CYCLE
               END
               IF openCurlyBrakets <=1 AND pJSONString[idx] = ','
                  pairEnd = idx
                  BREAK
               END
               IF pJSONString[idx] = '}'
                  openCurlyBrakets -= 1
                  IF openCurlyBrakets <=0
                     pairEnd = idx
                     BREAK
                  END
               END
            END
         END
    END
    
    LOOP idx = pairEnd - 1 TO 1 BY -1
         IF pJSONString[idx] = ' '
            CYCLE
         END
         IF startCurlyBrakets = true AND pJSONString[idx] = '}'
            startCurlyBrakets = false
            CYCLE
         END
         valueEnd = idx
         BREAK
    END
    
    RETURN TRUE

JSONDataClass.TryGetNextArrayItemPositions PROCEDURE(*STRING pJSONString,*LONG arrayStart,*LONG arrayEnd,*LONG itemStart,*LONG itemEnd)
idx               LONG,AUTO
openCurlyBrakets  LONG,AUTO
itemIsObject      BYTE,AUTO
itemRead          BYTE,AUTO
startCurlyBrakets BYTE,AUTO
openBrakets       LONG,AUTO
openQuotes        BYTE,AUTO
strLen            LONG,AUTO
 CODE
    IF CLIP(pJSONString) = ''
       RETURN FALSE
    END
    IF arrayStart>arrayEnd
       RETURN FALSE
    END
    strLen = LEN(pJSONString)
    IF arrayStart = 0
       arrayStart = 1
       !After this loop the arrayStart will be where the [ is
       !this is here just to trim
       LOOP
          IF pJSONString[arrayStart] = '['
             BREAK
          END
          IF pJSONString[arrayStart] <> ' '
             RETURN false
          END
          arrayStart += 1
          IF arrayStart>=strLen
             RETURN false
          END
       END
    END
    IF arrayEnd = 0 
       arrayEnd = strLen
       !After this loop the arrayEnd will be where the ] is
       !this is here just to trim
       LOOP
          IF pJSONString[arrayEnd] = ']'
             BREAK
          END
          IF pJSONString[arrayEnd] <> ' '
             RETURN false
          END
          arrayEnd -= 1
          IF arrayEnd<=arrayStart
             RETURN false
          END
       END
    END
    IF itemStart>=arrayEnd
       RETURN FALSE
    END
    IF itemStart = 0
       itemStart = arrayStart + 1
    ELSE
       !If item start in a , or blank space
       itemStart -= 1
       LOOP          
          itemStart += 1
          IF pJSONString[itemStart] = ','
             CYCLE
          END
          IF pJSONString[itemStart] <> ' '
             BREAK
          END
          IF itemStart>=arrayEnd
             RETURN false
          END
       END
    END
    
    !Initialization of local variables
    
    !Array items can be simple items or objects that start and end with {}
    idx = itemStart - 1
    itemIsObject = false
    itemRead     = false
    itemEnd      = 0
    openQuotes   = false
    openCurlyBrakets = 0
    LOOP
       idx += 1
       IF idx >= arrayEnd
          BREAK
       END
       !
       IF pJSONString[idx] = '"'
          IF openQuotes = FALSE
             openQuotes = TRUE
          ELSE
             openQuotes = FALSE
          END            
       END
       !
       IF openQuotes = FALSE
          CASE pJSONString[idx]
          OF '{{'
             IF itemRead = FALSE
                itemIsObject = true
             END
             openCurlyBrakets += 1            
          OF '}'
             IF openCurlyBrakets > 0
                openCurlyBrakets -= 1
             END
          OF ','
             IF itemIsObject = FALSE OR openCurlyBrakets = 0
                itemEnd = idx - 1
                BREAK
             END          
          END
       END
       IF itemRead = FALSE AND pJSONString[idx] <> ' '
          itemRead = TRUE
       END
    END !End LOOP
    IF itemEnd = 0
       itemEnd = arrayEnd - 1
    END
    RETURN TRUE

JSONDataClass.FromJSON      PROCEDURE(*STRING pJSONString,*GROUP JSONObject)
lpairStart  LONG,AUTO
lpairEnd    LONG,AUTO
lnameStart  LONG,AUTO 
lnameEnd    LONG,AUTO 
lvalueStart LONG,AUTO 
lvalueEnd   LONG,AUTO
 CODE
    lpairStart  =0
    lpairEnd    =0
    LOOP
       IF NOT SELF.TryGetNextPairPositions(pJSONString,lpairStart,lpairEnd,lnameStart,lnameEnd,lvalueStart,lvalueEnd)     
          BREAK
       END
       SELF.AssignGroupField(pJSONString,JSONObject,lnameStart, lnameEnd, lvalueStart,lvalueEnd)
       lpairStart = lpairEnd+1
    END        

JSONDataClass.GetValueType PROCEDURE(*STRING pJSONString, *LONG lvalueStart,*LONG lvalueEnd)
 CODE
    IF pJSONString[lvalueStart] = '['
       RETURN JSONDataType:Array
    END
    IF pJSONString[lvalueStart] = '{{'
       RETURN JSONDataType:Object
    END
    IF pJSONString[lvalueStart] = '"'
       RETURN JSONDataType:String
    END
    IF UPPER(pJSONString[(lvalueStart):(lvalueEnd)]) = 'TRUE' OR UPPER(pJSONString[(lvalueStart):(lvalueEnd)]) = 'FALSE'
       RETURN JSONDataType:Bool
    END
    IF NUMERIC(pJSONString[(lvalueStart):(lvalueEnd)])
       RETURN JSONDataType:Number
    END
    RETURN JSONDataType:None
    
JSONDataClass.AssignGroupField PROCEDURE(*STRING pJSONString,*GROUP pJSONObject,*LONG lnameStart,*LONG lnameEnd,*LONG lvalueStart,*LONG lvalueEnd)
idx         LONG,AUTO
lJQObjName  CSTRING(256)
lJQName     CSTRING(256)
lJQValue    CSTRING(256)
lCurrentField ANY
lJQPicture    STRING(50)
 CODE
       idx = 1
       LOOP
          lJQObjName = WHO(pJSONObject, idx)
          IF lJQObjName=''
             BREAK
          END
          IF UPPER(lJQObjName) = UPPER(pJSONString[(lnameStart):(lnameEnd)])
             lCurrentField &= WHAT(pJSONObject,idx)
             IF SELF.GetValueType(pJSONString, lvalueStart, lvalueEnd) = JSONDataType:String
                IF SELF.TryGetFormaterPicture(lJQObjName, lJQPicture)
                   IF lJQPicture = '@BOOL'
                      IF LOWER(pJSONString[(lvalueStart+1):(lvalueEnd-1)]) = 'true'
                         lCurrentField = 1
                      ELSE
                         lCurrentField = 0
                      END
                   ELSE
                      lCurrentField = DEFORMAT(pJSONString[(lvalueStart+1):(lvalueEnd-1)],lJQPicture)
                   END
                ELSE
                   lCurrentField = pJSONString[(lvalueStart+1):(lvalueEnd-1)]
                END
             ELSE
                IF SELF.TryGetFormaterPicture(lJQObjName, lJQPicture)
                   IF lJQPicture = '@BOOL'
                      IF LOWER(pJSONString[(lvalueStart):(lvalueEnd)]) = 'true'
                         lCurrentField = 1
                      ELSE
                         lCurrentField = 0
                      END
                   ELSE
                      lCurrentField = DEFORMAT(pJSONString[(lvalueStart):(lvalueEnd)],lJQPicture)
                   END
                ELSE
                   lCurrentField = pJSONString[(lvalueStart):(lvalueEnd)]
                END 
             END
             BREAK
          END
          idx +=1
       END
 
JSONDataClass.FromJSON PROCEDURE(*STRING pJSONString,*QUEUE pJSONArray)
larrayStart LONG,AUTO
larrayEnd   LONG,AUTO
litemStart  LONG,AUTO 
litemEnd    LONG,AUTO

lpairStart  LONG,AUTO
lpairEnd    LONG,AUTO
lnameStart  LONG,AUTO 
lnameEnd    LONG,AUTO 
lvalueStart LONG,AUTO 
lvalueEnd   LONG,AUTO
 CODE
    larrayStart =0
    larrayEnd   =0
    litemStart  =0
    litemEnd    =0

    FREE(pJSONArray)
    LOOP
        IF NOT SELF.TryGetNextArrayItemPositions(pJSONString,larrayStart,larrayEnd,litemStart,litemEnd)
           BREAK
        END
        !Process the Item
        lpairStart  =litemStart
        lpairEnd    =0
        
        lnameStart  = 0
        lnameEnd    = 0
        lvalueStart = 0
        lvalueEnd   = 0
        CLEAR(pJSONArray)
        LOOP
           IF NOT SELF.TryGetNextPairPositions(pJSONString, litemEnd,lpairStart,lpairEnd,lnameStart,lnameEnd,lvalueStart,lvalueEnd)
              BREAK
           END
           SELF.AssignGroupField(pJSONString,pJSONArray,lnameStart, lnameEnd, lvalueStart,lvalueEnd)
           lpairStart = lpairEnd+1
        END        
        ADD(pJSONArray)

        litemStart = litemEnd + 1
    END