!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_JSONStringClassPresente_)
_SystemStringPresente_ EQUATE(1)

!http://www.w3resource.com/JSON/structures.php
!A collection of name/value pairs. 
!
!An ordered list of values

  ITEMIZE(0),PRE(JSONDataType)
None    EQUATE
String  EQUATE
Number  EQUATE
Bool    EQUATE
Decimal EQUATE
Array   EQUATE
Object  EQUATE
  END

JSONDataValueQueue  QUEUE,TYPE
Name                  CSTRING(256)
Value                 &STRING
                    END
JSONDataPicturesQueue  QUEUE,TYPE
Name                  CSTRING(256)
Picture               STRING(50)
                    END
                    
JSONDataClass     CLASS, MODULE('JSON.CLW'),LINK('JSON.CLW', _ABCLinkMode_), DLL(_ABCDllMode_), TYPE
!region PROTECTED
JSONObject                   &JSONDataValueQueue,PROTECTED
formater                     &JSONDataPicturesQueue,PROTECTED
_EscapedString               &STRING,PROTECTED
JSONObjectSize               LONG,PROTECTED
retValTmp                    &STRING,PROTECTED
clipValues                   BYTE,PROTECTED
Construct                    PROCEDURE()
Destruct                     PROCEDURE()
DisposeIt                    PROCEDURE(),PROTECTED
CreateNewString              PROCEDURE(LONG strSize),PROTECTED
TryGetFormaterPicture        PROCEDURE(STRING fieldName, *STRING picture), BYTE, PROTECTED
GroupToJSON                  PROCEDURE(*GROUP JSONObject),STRING,PROTECTED
LongArrToJSON                PROCEDURE(*LONG[] values),STRING,PROTECTED
StringArrToJSON              PROCEDURE(*STRING[] values),STRING,PROTECTED
!endregion
SetClipValues                PROCEDURE(BYTE value)
GetClipValues                PROCEDURE(),BYTE
EscapeString                 PROCEDURE(STRING value),STRING
SetNumberFormater            PROCEDURE(STRING fieldName, STRING picture)
GetNumberFormater            PROCEDURE(STRING fieldName),STRING
DeleteNumberFormater         PROCEDURE(STRING fieldName)
StringToJSON                 PROCEDURE(STRING name, STRING value),STRING
BoolToJSON                   PROCEDURE(STRING name, BYTE value),STRING
NumberToJSON                 PROCEDURE(STRING name, LONG value),STRING
NumberToJSON                 PROCEDURE(STRING name, LONG value, STRING picture),STRING
DecimalToJSON                PROCEDURE(STRING name, *DECIMAL value),STRING
ToJSON                       PROCEDURE(*GROUP pJSONObject),STRING
ToJSON                       PROCEDURE(*QUEUE pJSONArray),STRING
ToJSON                       PROCEDURE(STRING pJSONArrayName, *QUEUE pJSONArray),STRING
ToJSON                       PROCEDURE(*BYTE[] values),STRING
ToJSON                       PROCEDURE(*LONG[] values),STRING
ToJSON                       PROCEDURE(*STRING[] values),STRING
FromJSON                     PROCEDURE(*STRING pJSONString,*GROUP pJSONObject)
FromJSON                     PROCEDURE(*STRING pJSONString,*QUEUE pJSONArray)
!region JSON Object
ClearObject                  PROCEDURE()
ClearObject                  PROCEDURE(*JSONDataValueQueue jsonQueue),PROTECTED
GetGroupSize                 PROCEDURE(*GROUP jsonGroup), LONG, PROTECTED
GetJSONObjectSize            PROCEDURE(), LONG, PROTECTED
ToJSON                       PROCEDURE(),STRING
AddString                    PROCEDURE(STRING name, STRING value)
AddBool                      PROCEDURE(STRING name, BYTE value)
AddNumber                    PROCEDURE(STRING name, LONG value)
AddNumber                    PROCEDURE(STRING name, LONG value, STRING picture)
AddGroup                     PROCEDURE(STRING name, *GROUP value)
AddQueue                     PROCEDURE(STRING name, *QUEUE value)
!endregion
!region JSON String Parsing
TryGetName                   PROCEDURE(STRING pJSONString, *STRING name),BYTE,PROC
TryGetValue                  PROCEDURE(STRING pJSONString, *STRING value),BYTE,PROC
TryGetNameValue              PROCEDURE(STRING pJSONString,*STRING name, *STRING value),BYTE,PROC
TryGetNameValuePositions     PROCEDURE(*STRING pJSONString,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd),BYTE
TryGetNextPairPositions      PROCEDURE(*STRING pJSONString,*LONG pairStart,*LONG pairEnd,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd),BYTE
TryGetNextPairPositions      PROCEDURE(*STRING pJSONString, LONG itemEnd,*LONG pairStart,*LONG pairEnd,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd),BYTE
TryGetNextArrayItemPositions PROCEDURE(*STRING pJSONString,*LONG arrayStart,*LONG arrayEnd,*LONG itemStart,*LONG itemEnd),BYTE
GetValueType                 PROCEDURE(*STRING pJSONString, *LONG valueStart,*LONG valueEnd),UNSIGNED
AssignGroupField             PROCEDURE(*STRING pJSONString,*GROUP pJSONObject,*LONG nameStart,*LONG nameEnd,*LONG valueStart,*LONG valueEnd),PROTECTED
!endregion
                    END

_EndOfInclude_                    