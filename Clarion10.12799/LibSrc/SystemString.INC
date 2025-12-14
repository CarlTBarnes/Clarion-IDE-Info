!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_SystemStringClassPresente_)
_SystemStringClassPresente_ EQUATE(1)

SystemStringQueue   QUEUE,TYPE
Str                     &SystemStringClass
                    END

SystemStringSegmentsQueue   QUEUE,TYPE
startSeg                ULONG
endSeg                  ULONG
Str                     &STRING
                    END

SystemStringClass   CLASS, MODULE('SystemString.CLW'),LINK('SystemString.CLW', _ABCLinkMode_), DLL(_ABCDllMode_), TYPE
_AppendOnCursor         BYTE,PROTECTED
_ClipOnCursor           BYTE,PROTECTED
appendCursor            LONG,PROTECTED
s                       &STRING,PROTECTED
cs                      &CSTRING,PROTECTED
lines                   &SystemStringQueue,PROTECTED
segmentsToReplace       &SystemStringSegmentsQueue,PROTECTED
EOLMarker               CSTRING(8),PROTECTED
LastSplitDelimiter      CSTRING(8),PROTECTED
valueSep                CSTRING(11),PROTECTED
pairSep                 CSTRING(11),PROTECTED
strMark                 CSTRING(8),PROTECTED
containsStr             BYTE,PROTECTED
TokensDelimiters        CSTRING (101),PROTECTED
LowerAsciiAsDelimiters  BYTE,PROTECTED
TokenSelStart           LONG,PROTECTED
TokenSelEnd             LONG,PROTECTED

Construct               PROCEDURE()
Destruct                PROCEDURE()
!!! <summary>
!!! Dispose the internal String representation
!!! </summary>
DisposeIt               PROCEDURE()
!!! <summary>
!!! Dispose the internal CString representation
!!! </summary>
DisposeItCString        PROCEDURE()
!!! <summary>
!!! Alias for FromString
!!! </summary>
!!! <param name="svalue">The value to be assigned to the SystemString</param>
Str                     PROCEDURE(STRING svalue)
!!! <summary>
!!! Assign the passed SystemString value to the SystemString
!!! </summary>
Str                     PROCEDURE(SystemStringClass s)
!!! <summary>
!!! Alias for ToString and GetString
!!! </summary>
!!! <returns>
!!! The value of the SystemString
!!! </returns>
Str                     PROCEDURE(),STRING
!!! <summary>
!!! Alias for ToString and Str
!!! </summary>
!!! <returns>
!!! The value of the SystemString
!!! </returns>
GetString               PROCEDURE(),STRING
!!! <summary>
!!! Initializes the SystemStringClass to an empty string
!!! </summary>
Clean                   PROCEDURE()
!!! <summary>
!!! Free the memory allocated when the String was split into lines
!!! </summary>
CleanLines              PROCEDURE()
!!! <summary>
!!! Assign the passed STRING value to the SystemString
!!! </summary>
FromString              PROCEDURE(STRING svalue)
!!! <summary>
!!! Assign the passed STRING value to the SystemString
!!! </summary>
SetString               PROCEDURE(STRING svalue)
!!! <summary>
!!! Assign the passed CSTRING value to the SystemString
!!! </summary>
SetString              PROCEDURE(*CSTRING svalue)
!!! <summary>
!!! Assign the passed CSTRING value to the SystemString
!!! </summary>
FromString              PROCEDURE(*CSTRING svalue)
!!! <summary>
!!! Return the value of the SystemString
!!! </summary>
!!! <returns>
!!! The value of the SystemString
!!! </returns>
ToString                PROCEDURE(),STRING
!!! <summary>
!!! Return the value of the SystemString as a CSTRING
!!! </summary>
!!! <returns>
!!! The value of the SystemString
!!! </returns>
ToCString               PROCEDURE(),*CSTRING
FromCString             PROCEDURE(),PROTECTED

GetAppendOnCursor       PROCEDURE(),BYTE
SetAppendOnCursor       PROCEDURE(BYTE value=true)
GetCursor               PROCEDURE(),LONG
SetCursor               PROCEDURE(LONG value)
SetClipOnCursor         PROCEDURE(BYTE value=true)
GetClipOnCursor         PROCEDURE(),BYTE
!!! <summary>
!!! Return the value of the EOL marker used for the line splitting
!!! </summary>
!!! <returns>
!!! The value of the EOL marker
!!! </returns>
GetEOLMarker            PROCEDURE(),STRING
!!! <summary>
!!! Set the value of the EOL marker used for the line splitting
!!! </summary>
SetEOLMarker            PROCEDURE(STRING EOLMarker)
!!! <summary>
!!! Get the value of the default Value Separator to be used in (Key,Value) processing
!!! </summary>
GetValueSeparator       PROCEDURE(),STRING
!!! <summary>
!!! Set the value of the default Value Separator to be used in (Key,Value) processing
!!! </summary>
SetValueSeparator       PROCEDURE(STRING valueSeparator)
!!! <summary>
!!! Get the value of the default Pair Separator to be used in (Key,Value) processing
!!! </summary>
GetPairSeparator       PROCEDURE(),STRING
!!! <summary>
!!! Set the value of the default Pair Separator to be used in (Key,Value) processing
!!! </summary>
SetPairSeparator       PROCEDURE(STRING pairSeparator)
!!! <summary>
!!! Set the value of the default Pair Separator and the Value Separator to be used in (Key,Value) processing
!!! </summary>
SetPairValueSeparator  PROCEDURE(STRING pairSeparator,STRING valueSeparator)
!!! <summary>
!!! Prepend the string passed svalue to the value of the SystemString
!!! </summary>
Prepend                 PROCEDURE(STRING svalue, BYTE pAddEOLMarker=0)
!!! <summary>
!!! Append the string passed svalue to the value of the SystemString
!!! </summary>
Append                  PROCEDURE(STRING svalue, BYTE pAddEOLMarker=0)
Append                  PROCEDURE(SystemStringClass svalue)
Append                  PROCEDURE(STRING leftValue, SystemStringClass svalue, STRING rightValue)
Surround                PROCEDURE(STRING leftValue, STRING rightValue)
!!! <summary>
!!! Append the passed string svalue to the value of the SystemString adding the EOLMarker at the end of the svalue
!!! </summary>
AppendLine              PROCEDURE(STRING svalue)
!!! <summary>
!!! Add a new line to the existing lines in the SystemString.
!!! The new line will be added after the last line position
!!! The new line will NOT affect the SystemString value till the FromLines function is called
!!! </summary>
AddLine                 PROCEDURE(STRING svalue)
!!! <summary>
!!! Insert a new line to the existing lines in the SystemString.
!!! The new line will be added at the startIndex position, moving any exising lines
!!! The new line will NOT affect the SystemString value till the FromLines function is called
!!! </summary>
InsertLine              PROCEDURE(ULONG startIndex, STRING svalue)
!!! <summary>
!!! Return the number of lines in the SystemString after the SplitToLines was called
!!! Same as GetLinesCount
!!! </summary>
!!! <returns>
!!! Return the number of lines in the SystemString
!!! </returns>
CountLines              PROCEDURE(),ULONG
!!! <summary>
!!! Return the number of lines in the SystemString after the SplitToLines was called
!!! Same as CountLines
!!! </summary>
!!! <returns>
!!! Return the number of lines in the SystemString
!!! </returns>
GetLinesCount           PROCEDURE(),ULONG
!!! <summary>
!!! Gets the lineNumber'th line in the SystemString after SplitToLines was called
!!! </summary>
!!! <returns>
!!! Return the string value of the line
!!! </returns>
GetLineValue            PROCEDURE(ULONG lineNumber),STRING
!!! <summary>
!!! Sets the lineNumber'th line value using the lineVal
!!! </summary>
!!! <returns>
!!! If th eline exist it return true otherwise it return false
!!! </returns>
SetLineValue            PROCEDURE(ULONG lineNumber, STRING lineVal),BYTE,PROC
!!! <summary>
!!! Gets the lineNumber'th line in the SystemString with leading and trailing spaces removed after SplitToLines was called
!!! </summary>
!!! <returns>
!!! Return the string value of the line
!!! </returns>
GetLineTrimValue        PROCEDURE(ULONG lineNumber),STRING
!!! <summary>
!!! Gets the lineNumber'th line in the SystemString as a SystemStringClass after SplitToLines was called
!!! </summary>
!!! <returns>
!!! Return the SystemStringClass value of the line
!!! </returns>
GetLine                 PROCEDURE(ULONG lineNumber),*SystemStringClass
!!! <summary>
!!! If the line number exist then assign a copy of its value to the passed pValue and return true
!!! </summary>
!!! <returns>
!!! Return true if the line exist and false if not
!!! </returns>
TryGetLineValue         PROCEDURE(ULONG lineNumber,*SystemStringClass pValue),BYTE
!!! <summary>
!!! Get the SystemString queue of lines as a SystemStringQueue
!!! Any modification to this queue will affect the current SystemStringClass
!!! </summary>
!!! <returns>
!!! Return the SystemStringQueue of the current SystemStringClass
!!! </returns>
GetLines                PROCEDURE(),*SystemStringQueue
!!! <summary>
!!! Delete the lineNumber line in the SystemString
!!! </summary>
DeleteLine              PROCEDURE(ULONG lineNumber)
!!! <summary>
!!! Split the SystemString string value into lines using the EOLMarker as the separator
!!! Any previous lines will be discarded
!!! The length of each line is variable
!!! </summary>
SplitToLines            PROCEDURE()
!!! <summary>
!!! Split the SystemString string value into lines of the same length
!!! Any previous lines will be discarded
!!! The length of each line is lineLength
!!! If the length of the total SystemString value is less than the lineLength then the only line length is the SystemString length
!!! The last line length could be less than the lineLength
!!! </summary>
SplitToLines            PROCEDURE(LONG lineLength)
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! </summary>
FromLines               PROCEDURE()
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the delimiter string will be appended to the content of each line before merging it to the SystemString value
!!! </summary>
FromLines               PROCEDURE(STRING delimiter)
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the leftDelimiter and rigthDelimiter string will be added to the content of each line before merging it to the SystemString value
!!! </summary>
FromLines               PROCEDURE(STRING leftDelimiter, STRING rigthDelimiter)
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the leftDelimiter and rigthDelimiter string will be added to the content of each line before merging it to the SystemString value
!!! The first and last lines will be treated according the parameters omitFirstSeparator and omitLastSeparator
!!! </summary>
FromLines               PROCEDURE(STRING leftDelimiter, STRING rigthDelimiter, BYTE omitFirstSeparator, BYTE omitLastSeparator)
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the current EOLMarker will be appended to the content of each line before merging it to the SystemString value
!!! </summary>
FromLinesWithEOL        PROCEDURE()
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the delimiter string will be added only between each line
!!! </summary>
Merge                   PROCEDURE(STRING itemDelimiter)
!!! <summary>
!!! Merge the SystemString lines into one string and assign it to the SystemString value
!!! The value of the delimiter is the last used in the Split
!!! </summary>
Merge                   PROCEDURE()
!!! <summary>
!!! Get the value of the Tokens Delimiters that will be used in the Tokenizing process of the SystemString
!!! </summary>
!!! <returns>
!!! Return the Tokens Delimiters of the current SystemStringClass
!!! </returns>
GetTokensDelimiters     PROCEDURE(),STRING
!!! <summary>
!!! Set the value of the Tokens Delimiters that will be used in the Tokenizing process of the SystemString
!!! </summary>
SetTokensDelimiters     PROCEDURE(STRING delimiters)
!!! <summary>
!!! Set the value of the Tokens Delimiters to also use the 0-31 ASCII values
!!! </summary>
SetUseLowerAsciiAsDelimiters PROCEDURE(BYTE value=true)
!!! <summary>
!!! Return the true if the 0-31 ASCII values are used as Delimiters
!!! </summary>
GetUseLowerAsciiAsDelimiters PROCEDURE(),BYTE
!!! <summary>
!!! Check that the value of the internal string for that index is or not in the group of delimiters
!!! the method does not vlidate the index or the internal string. It expect all to be valid
!!! </summary>
IsDelimiter             PROCEDURE(LONG checkIndex),BYTE,PROTECTED
!!! <summary>
!!! Reset the current token of the SystemString
!!! The NextToken will start from the begining of the string
!!! </summary>
ResetToken              PROCEDURE()
!!! <summary>
!!! Return True if the Token process was never started and NextToken/PrevToken was never called
!!! </summary>
!!! <returns>
!!! Return True if the Token process was never started
!!! </returns>
IsTokenInited           PROCEDURE(),BYTE
!!! <summary>
!!! Return True SystemString is NULL of after the call to NextToken
!!! the Current Token contain an invalid (out of range) value
!!! </summary>
!!! <returns>
!!! Return True if the Current Token is out of range
!!! </returns>
IsTokenNull             PROCEDURE(),BYTE
!!! <summary>
!!! Return True if the current token after the call to NextToken has no content
!!! </summary>
!!! <returns>
!!! Return True if the current token has no content
!!! </returns>
IsTokenEmpty            PROCEDURE(),BYTE
!!! <summary>
!!! Return True if after the call to NextToken there is no more tokens to read and the call set the status to past the end of string content.
!!! The value returned by NextToken was empty but was not a value from the string.
!!! </summary>
!!! <returns>
!!! Return True if the Current Token is out of range
!!! </returns>
IsPastEOL               PROCEDURE(),BYTE
!!! <summary>
!!! Return string token for the result after the call to NextToken/PrevToken
!!! </summary>
!!! <returns>
!!! Return the Current Token
!!! </returns>
GetCurrentToken         PROCEDURE(),STRING
!!! <summary>
!!! Move the pointer to the current token to the Next available Token in the SystemString value
!!! The processing is done from left to right stating from the last token found or if it is the first time that is called form the first charater of the string
!!! The Tokens will be separated using the values of the TokensDelimiters
!!! The SystemString value or it's lines will not be affected by the Tokenizing process
!!! If no more tokens exist, the status will be set so the IsTokenNull will return true
!!! </summary>
!!! <returns>
!!! If successful and the Next token exists it will return the value of the Current Found Token.
!!! Other wise it will return empty
!!! </returns>
NextToken               PROCEDURE(),STRING,PROC
!!! <summary>
!!! If a current token exist in the SystemString it will be removed from the SystemString value.
!!! The SystemString value will be affected by this call
!!! </summary>
!!! <returns>
!!! If succesful it will return True
!!! Other wise it will return false
!!! </returns>
PopToken                PROCEDURE(),BYTE,PROC
!!! <summary>
!!! The svalue will be inserted in the startIndex of the SystemString value.
!!! The SystemString value will be affected by this call
!!! </summary>
PushToken               PROCEDURE(ULONG startIndex, STRING svalue)
!!! <summary>
!!! The svalue will be search in the SystemString value and the found index will be returned if it is found
!!! And zero if it is not
!!! The search starts from the beginning of the string
!!! The search will use the the Token Delimiters to search for a token and not just a substring
!!! If you just need a substring use IndexOf
!!! </summary>
FoundToken              PROCEDURE(STRING svalue),LONG
!!! <summary>
!!! The svalue will be searched in the SystemString value and the index will be returned if it is found
!!! And zero if it is not
!!! The search starts from the startIndex
!!! The search will use the the Tokens Delimiters to search for a token and not just a substring
!!! If you just need a substring use IndexOf
!!! </summary>
FoundToken              PROCEDURE(STRING svalue, ULONG startIndex),LONG
!!! <summary>
!!! Return the number of sub-string separated by Delimiters are contained in the SystemString
!!! The empty valueas are not count.
!!! </summary>
CountTokens             PROCEDURE(),LONG
CountWords              PROCEDURE(),LONG
GetWord                 PROCEDURE(ULONG wordIndex),STRING

StartsWith              PROCEDURE(SystemStringClass svalue),BYTE
StartsWith              PROCEDURE(SystemStringClass svalue, BYTE IgnoreCase),BYTE
StartsWith              PROCEDURE(STRING svalue),BYTE
StartsWith              PROCEDURE(STRING svalue,BYTE IgnoreCase),BYTE
EndsWith                PROCEDURE(SystemStringClass svalue),BYTE
EndsWith                PROCEDURE(SystemStringClass svalue, BYTE IgnoreCase),BYTE
EndsWith                PROCEDURE(STRING svalue),BYTE
EndsWith                PROCEDURE(STRING svalue,BYTE IgnoreCase),BYTE
Equals                  PROCEDURE(SystemStringClass svalue),BYTE
Equals                  PROCEDURE(STRING svalue),BYTE
Equals                  PROCEDURE(STRING svalue, BYTE IgnoreCase),BYTE
IndexOf                 PROCEDURE(STRING svalue),LONG
IndexOf                 PROCEDURE(STRING svalue, ULONG startIndex),LONG
IndexOfReg              PROCEDURE(STRING regExpValue),LONG
IndexOfReg              PROCEDURE(STRING regExpValue, ULONG startIndex, BYTE IgnoreCase = true),LONG
LastIndexOf             PROCEDURE(STRING svalue),LONG
LastIndexOf             PROCEDURE(STRING svalue, ULONG startIndex),LONG
GetLeftOf               PROCEDURE(STRING svalue),STRING
GetRightOf              PROCEDURE(STRING svalue),STRING
SetLength               PROCEDURE(LONG pValLen)
SetLen                  PROCEDURE(LONG pValLen)
Resize                  PROCEDURE(LONG pValLen)
Length                  PROCEDURE(),LONG
Split                   PROCEDURE(STRING lineSeparator,BYTE includeEmptyResults = false)
CleanSplitQueue         PROCEDURE(*SystemStringQueue collection)
Insert                  PROCEDURE(ULONG startIndex, STRING value),STRING
Contains                PROCEDURE(STRING svalue),BYTE
PadLeft                 PROCEDURE(ULONG totalWidth),STRING
PadLeft                 PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING
PadRight                PROCEDURE(ULONG totalWidth),STRING
PadRight                PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING
PadCenter               PROCEDURE(ULONG totalWidth),STRING
PadCenter               PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING

CleanSegments           PROCEDURE(),PROTECTED
AddReplaceInContentSegment PROCEDURE(LONG startSeg, LONG endSeg, STRING svalue)
ReplaceInContentSegment PROCEDURE()!replace all the segments added using AddReplaceInContentSegment
ReplaceInContent        PROCEDURE(STRING oldString,STRING newString),LONG,PROC!return the number of time the newstring was replaced
ReplaceInContent        PROCEDURE(LONG idxReplaceStart, LONG strReplaceLen,STRING newString),BYTE,PROC!return true if the replace was done
SetSubstring            PROCEDURE(LONG idxReplaceStart, STRING svalue, BYTE resizeIfneeded=FALSE),BYTE,PROC!return true if the replace was done
Replace                 PROCEDURE(STRING oldString,STRING newString),STRING!return the new string with the oldstring replaced
ReplaceSubString        PROCEDURE(STRING originalString, STRING oldString,STRING newString),STRING!execute a replace in the internal string, return the altered string
RemoveSubString         PROCEDURE(STRING originalString, STRING subString),STRING!execute a replace by empty in the originalString variable, return the altered string
RemoveSubString         PROCEDURE(STRING subString),STRING!execute a replace by empty in the internal string, return the number of time the subString was replaced
RemoveSubStringInContent PROCEDURE(STRING subString),LONG,PROC!return the number of time the newstring was replaced

!!! <summary>
!!! This method can extract values from a KeyValuePair string: Key1=Value1&Key2=Value2
!!! stored in the SystemString, and will assign the Key value to the SystemString passed.
!!! </summary>
!!! <returns>
!!! If the Key exist, it will return True
!!! Other wise it will return false
!!! </returns>
ExtractKeyValue         PROCEDURE(STRING pKey, STRING pValueSep, STRING pPairSep, *SystemStringClass pValue),BYTE
!!! <summary>
!!! This method can extract values from a KeyValuePair string: Key1=Value1&Key2=Value2
!!! stored in the SystemString, and will assign the Key value to the SystemString passed.
!!! defauylt values for the separators pValueSep: =  and pPairSep: &
!!! </summary>
!!! <returns>
!!! If the Key exist, it will return True
!!! Other wise it will return false
!!! </returns>
ExtractKeyValue         PROCEDURE(STRING pKey, *SystemStringClass pValue),BYTE
ReplaceKeyValue         PROCEDURE(STRING pKey, STRING pValueSep, STRING pPairSep, STRING pNewValue),BYTE,PROC
ReplaceKeyValue         PROCEDURE(STRING pKey, STRING pNewValue),BYTE,PROC
!!! <summary>
!!! Replace in the string the place holders {0},{1},{2},{3},{4},{5}
!!! with the values passed as parameter on the internal string that will be returned.
!!! The internal string will not be modified
!!! IE: 'Hello my name is {0} and my phone is {1}' 
!!! then call the method with the name and phone as parameters.
!!! </summary>
!!! <returns>
!!! The string with the values modified in the place holders
!!! </returns>
FormatString            PROCEDURE(STRING objectsString, <STRING objectsString1>, <STRING objectsString2>, <STRING objectsString3>, <STRING objectsString4>, <STRING objectsString5>),STRING
Remove                  PROCEDURE(ULONG startIndex),STRING
Remove                  PROCEDURE(ULONG startIndex, ULONG subLength),STRING
Substring               PROCEDURE(ULONG startIndex),STRING
Substring               PROCEDURE(ULONG startIndex, ULONG subLength),STRING
GetSurrounded           PROCEDURE(STRING leftValue, STRING rightValue,ULONG startIndex=1,ULONG endIndex=0),STRING
!!! <summary>
!!! return the substring to the left of startIndex to the begining of the string
!!! </summary>
!!! <returns>
!!! Other wise it will return substring form the begining of the string up to the startIndex-1
!!! </returns>
SubstringLeft           PROCEDURE(ULONG startIndex),STRING
!!! <summary>
!!! return the substring to the left of startIndex up to subLength characters
!!! </summary>
!!! <returns>
!!! if startIndex it will return empty
!!! Other wise it will return substring form the begining of the string up to the startIndex-1
!!! </returns>
SubstringLeft           PROCEDURE(ULONG startIndex, ULONG subLength),STRING
ToLower                 PROCEDURE(),STRING
ToUpper                 PROCEDURE(),STRING
ToCapitalize            PROCEDURE(),STRING
TrimInContext           PROCEDURE()!Remove spaces in front and leading
TrimInContext           PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
Trim                    PROCEDURE(),STRING !Remove spaces in front and leading
Trim                    PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING
Trim                    PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING,PROTECTED
TrimStart               PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING
TrimEnd                 PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING

UrlEncode               PROCEDURE()
UrlDecode               PROCEDURE()
UrlEncode               PROCEDURE(STRING sValue),STRING
UrlDecode               PROCEDURE(STRING sValue),STRING
HtmlEscape              PROCEDURE()
ToBase64                PROCEDURE(),STRING
FromBase64              PROCEDURE(STRING svalue)
EncodeBase64            PROCEDURE()
DecodeBase64            PROCEDURE()
Compress                PROCEDURE(),BYTE,PROC
Decompress              PROCEDURE(),BYTE,PROC
ToFile                  PROCEDURE(STRING fileName),BYTE,PROC
FromFile                PROCEDURE(STRING fileName),BYTE,PROC
FromBlob                PROCEDURE(*BLOB b)
ToBlob                  PROCEDURE(*BLOB b)

!region Private Methods
Take24                  PROCEDURE(byte h, byte m, byte l, *STRING Into),PRIVATE
Take32                  PROCEDURE(*byte h, *byte m, *byte l, *STRING SFrom),BYTE,PRIVATE
Capitalize              PROCEDURE(STRING cs),STRING,PRIVATE
!endregion
                    END
_EndOfInclude_