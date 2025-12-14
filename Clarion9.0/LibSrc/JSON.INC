!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_JSONStringClassPresente_)
_SystemStringPresente_ EQUATE(1)

!http://www.w3resource.com/JSON/structures.php
!A collection of name/value pairs. 
!
!An ordered list of values

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
JSONObject                &JSONDataValueQueue,PROTECTED
formater                  &JSONDataPicturesQueue,PROTECTED
_EscapedString            &STRING,PROTECTED
JSONObjectSize            LONG,PROTECTED
retValTmp                 &STRING,PROTECTED
clipValues                BYTE,PROTECTED
Construct                 PROCEDURE()
Destruct                  PROCEDURE()
DisposeIt                 PROCEDURE(),PROTECTED
CreateNewString           PROCEDURE(LONG strSize),PROTECTED
TryGetFormaterPicture     PROCEDURE(STRING fieldName, *STRING picture), BYTE, PROTECTED
GroupToJSON               PROCEDURE(*GROUP JSONObject),STRING,PROTECTED
LongArrToJSON             PROCEDURE(*LONG[] values),STRING,PROTECTED
StringArrToJSON           PROCEDURE(*STRING[] values),STRING,PROTECTED
!endregion
SetClipValues             PROCEDURE(BYTE value)
GetClipValues             PROCEDURE(),BYTE
EscapeString              PROCEDURE(STRING value),STRING
SetNumberFormater         PROCEDURE(STRING fieldName, STRING picture)
StringToJSON              PROCEDURE(STRING name, STRING value),STRING
BoolToJSON                PROCEDURE(STRING name, BYTE value),STRING
NumberToJSON              PROCEDURE(STRING name, LONG value),STRING
NumberToJSON              PROCEDURE(STRING name, LONG value, STRING picture),STRING
DecimalToJSON             PROCEDURE(STRING name, *DECIMAL value),STRING
ToJSON                    PROCEDURE(*GROUP JSONObject),STRING
ToJSON                    PROCEDURE(*QUEUE JSONArray),STRING
ToJSON                    PROCEDURE(STRING JSONArrayName, *QUEUE JSONArray),STRING
ToJSON                    PROCEDURE(*BYTE[] values),STRING
ToJSON                    PROCEDURE(*LONG[] values),STRING
ToJSON                    PROCEDURE(*STRING[] values),STRING
!region JSON Object
ClearObject               PROCEDURE()
ClearObject               PROCEDURE(*JSONDataValueQueue jsonQueue),PROTECTED
GetGroupSize              PROCEDURE(*GROUP jsonGroup), LONG, PROTECTED
GetJSONObjectSize         PROCEDURE(), LONG, PROTECTED
ToJSON                    PROCEDURE(),STRING
AddString                 PROCEDURE(STRING name, STRING value)
AddBool                   PROCEDURE(STRING name, BYTE value)
AddNumber                 PROCEDURE(STRING name, LONG value)
AddNumber                 PROCEDURE(STRING name, LONG value, STRING picture)
AddGroup                  PROCEDURE(STRING name, *GROUP value)
AddQueue                  PROCEDURE(STRING name, *QUEUE value)
!endregion
                    END

_EndOfInclude_                    