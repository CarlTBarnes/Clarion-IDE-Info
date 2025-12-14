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

StringRefFactoryClass CLASS, MODULE('SystemString.CLW'),LINK('SystemString.CLW', _ABCLinkMode_), DLL(_ABCDllMode_), TYPE
garbageStrs             &StringRefQueue,PROTECTED
Construct               PROCEDURE()
Destruct                PROCEDURE()
DisposeIt               PROCEDURE()
!!! <summary>
!!! create a new string disposing the existing content, return the new created string reference
!!! </summary>
!!! <param name="sizeValue">The value to be used to create the new empty string</param>
NewStringRef            PROCEDURE(ULONG sizeValue),*STRING
 END

SystemStringClass   CLASS, MODULE('SystemString.CLW'),LINK('SystemString.CLW', _ABCLinkMode_), DLL(_ABCDllMode_), TYPE
_AppendOnCursor         BYTE,PROTECTED
_ClipOnCursor           BYTE,PROTECTED
appendCursor            LONG,PROTECTED
s                       &STRING,PROTECTED
cs                      &CSTRING,PROTECTED
garbageStr              &STRING,PROTECTED
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
EOLAsDelimiters         BYTE,PROTECTED
TokenSelStart           LONG,PROTECTED
TokenSelEnd             LONG,PROTECTED
alreadyDisposed         BYTE,PROTECTED
UrlEncodeDataChar       BYTE,PROTECTED
caseSensitive           BYTE,PROTECTED
wasExternalized         BYTE,PROTECTED

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
!!! Exernalize the internal string pointer. After calling this the dispose will do nothing, the receiving code will have to dispose the ref string
!!! </summary>
Externalize             PROCEDURE(),*STRING
IsExternalized          PROCEDURE(),BYTE
!!! <summary>
!!! create a new string disposing the existing content
!!! </summary>
!!! <param name="sizeValue">The value to be used to create the new empty string</param>
NewString               PROCEDURE(ULONG sizeValue=0)
!!! <summary>
!!! create a new string disposing the existing content, return the new created string reference
!!! </summary>
!!! <param name="sizeValue">The value to be used to create the new empty string</param>
NewStringRef            PROCEDURE(ULONG sizeValue),*STRING
AutoDispose             PROCEDURE(*STRING newString),PROTECTED
Internalize             PROCEDURE(*STRING svalue),PROTECTED
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
!!! A way to access the internal string when it need to pass the content to other code as a string ref that still disposed internally
!!! </summary>
!!! <returns>
!!! The reference to the internal string. Altering the internal string size o content could affect the internal SysString functions
!!! </returns>
GetStringRef            PROCEDURE(),*STRING
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

GetAppendOnCursor       PROCEDURE(),BYTE
SetAppendOnCursor       PROCEDURE(BYTE value=true)
GetCursor               PROCEDURE(),LONG
SetCursor               PROCEDURE(LONG value)
SetClipOnCursor         PROCEDURE(BYTE value=true)
GetClipOnCursor         PROCEDURE(),BYTE
SetCaseSensitive        PROCEDURE(BYTE value)
GetCaseSensitive        PROCEDURE(),BYTE

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
!!! Split the SystemString string value into lines of the same length
!!! If length is 0 the the lines will be separated using the EOLMarker as the separator
!!! Any previous lines will be discarded
!!! The length of each line is lineLength
!!! If the length of the total SystemString value is less than the lineLength then the only line length is the SystemString length
!!! The last line length could be less than the lineLength
!!! </summary>
SplitToLines            PROCEDURE(LONG lineLength=0)
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
!!! the method does not validate the index or the internal string. It expect all to be valid
!!! </summary>
IsDelimiter             PROCEDURE(LONG checkIndex),BYTE,PROTECTED
!!! <summary>
!!! Check that the value of the internal string for that index is or not the EOL Marker
!!! the method does not validate the index or the internal string or end. It expect all to be valid
!!! </summary>
IsEOLMarker             PROCEDURE(LONG checkIndex),BYTE,PROTECTED
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
!!! <summary>
!!! Return the number of sub-string separated by Delimiters that match the svalue contained in the SystemString
!!! The empty valueas are not count.
!!! </summary>
CountToken              PROCEDURE(STRING svalue),LONG
!!! <summary>
!!! Return the number of sub-string separated by Delimiters and EOL contained in the SystemString
!!! The empty valueas are not count.
!!! </summary>
CountWords              PROCEDURE(),LONG
!!! <summary>
!!! Return the number of sub-string separated by Delimiters and EOL that match the svalue contained in the SystemString
!!! The empty valueas are not count.
!!! </summary>
CountWord               PROCEDURE(STRING svalue),LONG
!!! <summary>
!!! Return the sub-string separated by Delimiters contained in the SystemString found on the index passed wordIndex
!!! </summary>
GetToken                PROCEDURE(ULONG tokenIndex),STRING
!!! <summary>
!!! Return the sub-string separated by Delimiters and EOL contained in the SystemString found on the index passed wordIndex
!!! </summary>
GetWord                 PROCEDURE(ULONG wordIndex),STRING
!!! <summary>
!!! Return TRUE if the internal string start with the passed svalue, otherwise return FALSE
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
StartsWith              PROCEDURE(SystemStringClass svalue),BYTE
!!! <summary>
!!! Return TRUE if the internal string start with the passed svalue, otherwise return FALSE
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
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
!!! <summary>
!!! Return the index on the internal string of the passed svalue substring starting the search from left to right on the first character of the string
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
IndexOf                 PROCEDURE(STRING svalue),LONG
!!! <summary>
!!! Return the index on the internal string of the passed svalue substring starting the search from left to right on the startIndex character of the string
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
IndexOf                 PROCEDURE(STRING svalue, ULONG startIndex),LONG
IndexOfReg              PROCEDURE(STRING regExpValue),LONG
IndexOfReg              PROCEDURE(STRING regExpValue, ULONG startIndex),LONG
IndexOfReg              PROCEDURE(STRING regExpValue, ULONG startIndex,BYTE IgnoreCase),LONG
!!! <summary>
!!! Return the last index on the internal string of the passed svalue substring starting the search from left to right on the first character of the string
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
LastIndexOf             PROCEDURE(STRING svalue),LONG
!!! <summary>
!!! Return the last index on the internal string of the passed svalue substring starting the search from left to right on the startIndex character of the string
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
LastIndexOf             PROCEDURE(STRING svalue, ULONG startIndex),LONG
!!! <summary>
!!! Return the substring to the left of the firt occurrence of the svalue in the internal string
!!! </summary>
GetLeftOf               PROCEDURE(STRING svalue),STRING
!!! <summary>
!!! Return the substring to the right of the firt occurrence of the svalue in the internal string
!!! </summary>
GetRightOf              PROCEDURE(STRING svalue),STRING
!!! <summary>
!!! Resize the internal string to the passed value, and fill up with Spaces. Any content will be lost.
!!! (Alias for SetLen)
!!! </summary>
SetLength               PROCEDURE(LONG pValLen)
!!! <summary>
!!! Resize the internal string to the passed value, and fill up with Spaces. Any content will be lost.
!!! (Alias for SetLength)
!!! </summary>
SetLen                  PROCEDURE(LONG pValLen)
!!! <summary>
!!! Resize the internal string to the passed value, truncating the content if need. If the new size is bigger than the old size the cotent will be filled up with Spaces.
!!! </summary>
Resize                  PROCEDURE(LONG pValLen)
!!! <summary>
!!! Return the Lenght of the internal string.
!!! </summary>
Length                  PROCEDURE(),LONG
Split                   PROCEDURE()
Split                   PROCEDURE(STRING lineSeparator,BYTE includeEmptyResults = false)
CleanSplitQueue         PROCEDURE(*SystemStringQueue collection)
!!! <summary>
!!! Return the modified string with the passed value string inserted in the startIndex character.
!!! If startIndex  is greter than the Lenght the value will be appended at the end.
!!! </summary>
Insert                  PROCEDURE(ULONG startIndex, STRING value),STRING
!!! <summary>
!!! Add new segments to be inserted by InsertInContentSegment, the svalue will beinserted in s[startSeg : startSeg]
!!! </summary>
AddInsertInContentSegment PROCEDURE(LONG insertIndex, STRING svalue)
!!! <summary>
!!! Will process all the segments added by AddInsertInContentSegment and adjust the string size if needed
!!! </summary>
InsertInContentSegment  PROCEDURE()
!!! <summary>
!!! Return true if the internal string contains the substring svalue.
!!! If the startIndex is other than 1 it will start the search on the index
!!! If the startIndex is greater than the lenght the return value is false
!!! SetCaseSensitive can be call to allow caseless check
!!! </summary>
Contains                PROCEDURE(STRING svalue,ULONG startIndex=1),BYTE
PadLeft                 PROCEDURE(ULONG totalWidth),STRING
PadLeft                 PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING
PadRight                PROCEDURE(ULONG totalWidth),STRING
PadRight                PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING
PadCenter               PROCEDURE(ULONG totalWidth),STRING
PadCenter               PROCEDURE(ULONG totalWidth, STRING paddingChar),STRING

!!! <summary>
!!! Remove any not used segment to be used in the ReplaceInContentSegment and added by AddReplaceInContentSegment
!!! </summary>
CleanSegments           PROCEDURE()
!!! <summary>
!!! Add new segments to be replaced in ReplaceInContentSegment, the [startSeg : endSeg] segment will ber eplaced by the svalue string adjusting the string size if needed
!!! </summary>
AddReplaceInContentSegment PROCEDURE(LONG startSeg, LONG endSeg, STRING svalue)
!!! <summary>
!!! Will process all the segments added AddReplaceInContentSegment and adjust the string size if needed
!!! The segments should not overlap for the process to work correctly
!!! </summary>
ReplaceInContentSegment PROCEDURE()
!!! <summary>
!!! This method replace the value of the oldString in the the internal string by the newString and return the number of times that the replacement was done
!!! After processing all the segment CleanSegments will be call to remove the used segments 
!!! </summary>
ReplaceInContent        PROCEDURE(STRING oldString,STRING newString),LONG,PROC
!!! <summary>
!!! This method replace the content of the internal string starting from idxReplaceStart and the lenght strReplaceLen by the value of the new string
!!! If the values of the indexes are correct the method return TRUE otherwise return FALSE
!!! </summary>
ReplaceInContent        PROCEDURE(LONG idxReplaceStart, LONG strReplaceLen,STRING newString),BYTE,PROC
!!! <summary>
!!! Set the value for the substring starting in the startIndex and replace the LEN(newString) with value for newString
!!! If the values of the indexes are correct the method return TRUE otherwise return FALSE
!!! </summary>
SetSubstring            PROCEDURE(ULONG startIndex, STRING newString),BYTE,PROC
!!! <summary>
!!! Overwrite the content of the internal string starting from idxReplaceStart with the content of the svalue
!!! if resizeIfneeded=FALSE the extra characters will be discarded, if resizeIfneeded=TRUE the resulting string will be resized to grow as needed
!!! </summary>
Overwrite               PROCEDURE(LONG idxReplaceStart, STRING svalue, BYTE resizeIfneeded=FALSE),BYTE,PROC
!!! <summary>
!!! Replace the oldString by the newString on a copy of the internal string and return the resulting string.
!!! It will not change the internal string, SetCaseSensitive can be call to allow caseless replacements
!!! </summary>
Replace                 PROCEDURE(STRING oldString,STRING newString),STRING
!!! <summary>
!!! Replace the oldString by the newString on the passed originalString and return the resulting string.
!!! It will not change the internal string, SetCaseSensitive can be call to allow caseless replacements
!!! </summary>
ReplaceSubString        PROCEDURE(STRING originalString, STRING oldString,STRING newString),STRING
!!! <summary>
!!! Replace the oldString by the Empty string on the passed originalString and return the resulting string.
!!! It will not change the internal string, SetCaseSensitive can be call to allow caseless replacements
!!! </summary>
RemoveSubString         PROCEDURE(STRING originalString, STRING subString),STRING
!!! <summary>
!!! Replace the oldString by the Empty string on the internal String and return the resulting string.
!!! It will not change the internal string, SetCaseSensitive can be call to allow caseless replacements
!!! </summary>
RemoveSubString         PROCEDURE(STRING subString),STRING
!!! <summary>
!!! Replace the oldString by the Empty string on the internal String and return the number of times replaced.
!!! It will change the internal string, SetCaseSensitive can be call to allow caseless replacements
!!! </summary>
RemoveSubStringInContent PROCEDURE(STRING subString),LONG,PROC
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
!!! It use the default Value Separator and Pair Separators
!!! default values for the separators pValueSep: =  and pPairSep: &
!!! </summary>
!!! <returns>
!!! If the Key exist, it will return True
!!! Otherwise it will return false
!!! </returns>
ExtractKeyValue         PROCEDURE(STRING pKey, *SystemStringClass pValue),BYTE
!!! <summary>
!!! This method replace the value from a KeyValuePair string: Key1=Value1&Key2=Value2 for the passed Key value
!!! </summary>
!!! <returns>
!!! If the Key exist, it will return True
!!! Otherwise it will return false
!!! </returns>
ReplaceKeyValue         PROCEDURE(STRING pKey, STRING pValueSep, STRING pPairSep, STRING pNewValue),BYTE,PROC
!!! <summary>
!!! This method replace the value from a KeyValuePair string: Key1=Value1&Key2=Value2 for the passed Key value
!!! It use the default Value Separator and Pair Separators
!!! default values for the separators pValueSep: =  and pPairSep: &
!!! </summary>
!!! <returns>
!!! If the Key exist, it will return True
!!! Otherwise it will return false
!!! </returns>
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
!!! <summary>
!!! return the substring to the left of the startIndex removing the caracters from the startIndex to the end of the string
!!! </summary>
Remove                  PROCEDURE(ULONG startIndex),STRING
!!! <summary>
!!! return the substring removing the subLength caracters from the startIndex
!!! </summary>
Remove                  PROCEDURE(ULONG startIndex, ULONG subLength),STRING
!!! <summary>
!!! return the substring to the right of startIndex to the end of the string
!!! </summary>
Substring               PROCEDURE(ULONG startIndex),STRING
!!! <summary>
!!! return the substring to the right of startIndex up to subLength characters
!!! </summary>
Substring               PROCEDURE(ULONG startIndex, ULONG subLength),STRING
!!! <summary>
!!! return the internal string value surrounded by leftValue and rightValue, if startIndex and endIndex are used onl the substring will be used to search for the surrounded value
!!! </summary>
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
ToLower                 PROCEDURE(STRING pStr),STRING
ToUpper                 PROCEDURE(STRING pStr),STRING
ToCapitalize            PROCEDURE(STRING pStr),STRING
ToLowerInContext        PROCEDURE()
ToUpperInContext        PROCEDURE()
ToCapitalizeInContext   PROCEDURE()
TrimInContext           PROCEDURE()!Remove spaces in front and leading
!!! <summary>
!!! remove the characters from the internal string base on the trimType
!!! trimType can be 0=All, 1=Left, 2=Right
!!! </summary>
TrimInContext           PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
!!! <summary>
!!! remove the characters from the internal string from the left and right
!!! </summary>
TrimInContext           PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>)
!!! <summary>
!!! Return the resulting string after removing the spaces from the internal string from the left and right
!!! </summary>
Trim                    PROCEDURE(),STRING !Remove spaces in front and leading
!!! <summary>
!!! Return the resulting string after removing the characters from the internal string from the left and right
!!! The caracters must be in Surrounding the string C1 C2 C3 C4 ABC C4 C3 C2 C1 the processing of C1 search will stop once other character is found
!!! The search are done from right to left and from left to right and repeated using the C1 C2 C3 and C4 characters
!!! </summary>
Trim                    PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING
!!! <summary>
!!! Return the resulting string after removing the characters from the internal string base on the trimType
!!! trimType can be 0=All, 1=Left, 2=Right
!!! </summary>
Trim                    PROCEDURE(BYTE trimType,STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING
!!! <summary>
!!! Return the resulting string after removing the characters from the internal string from the left
!!! </summary>
TrimStart               PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING
!!! <summary>
!!! Return the resulting string after removing the characters from the internal string from the right
!!! </summary>
TrimEnd                 PROCEDURE(STRING char1,<STRING char2>,<STRING char3>,<STRING char4>),STRING

GetTrimmingLimits       PROCEDURE(*LONG idxToTrimStart, *LONG idxToTrimEnd, BYTE trimType, STRING char1, <STRING char2>, <STRING char3>, <STRING char4>),BYTE,PROC,PROTECTED

SetUrlEncodeDataChar    PROCEDURE(BYTE val)
GetUrlEncodeDataChar    PROCEDURE(),BYTE

Escape                  PROCEDURE(STRING sValue,BYTE clipValue = 0),STRING
Escape                  PROCEDURE()
UnEscape                PROCEDURE(STRING sValue,BYTE clipValue = 0),STRING
UnEscape                PROCEDURE()
UrlEncode               PROCEDURE()
UrlDecode               PROCEDURE()
UrlEncode               PROCEDURE(STRING sValue),STRING
UrlDecode               PROCEDURE(STRING sValue),STRING
HtmlEscape              PROCEDURE()
ToBase64                PROCEDURE(),STRING
FromBase64              PROCEDURE(STRING svalue)
EncodeBase64            PROCEDURE(BYTE quote=0)
DecodeBase64            PROCEDURE(BYTE isQuoted=0)
EncodeBase64            PROCEDURE(STRING svalue, BYTE quote=0),STRING
DecodeBase64            PROCEDURE(STRING b64sValue, BYTE isQuoted=0),STRING
Compress                PROCEDURE(),BYTE,PROC
Decompress              PROCEDURE(),BYTE,PROC
ToFile                  PROCEDURE(STRING fileName),BYTE,PROC
FromFile                PROCEDURE(STRING fileName),BYTE,PROC
FromBlob                PROCEDURE(*BLOB b)
ToBlob                  PROCEDURE(*BLOB b)

!region Private Methods
Take24                  PROCEDURE(byte h, byte m, byte l, *STRING Into),PRIVATE
Take32                  PROCEDURE(*byte h, *byte m, *byte l, *STRING SFrom),BYTE,PRIVATE
!endregion
                    END
_EndOfInclude_