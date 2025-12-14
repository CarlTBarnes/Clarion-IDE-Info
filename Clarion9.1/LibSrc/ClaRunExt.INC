!ABCIncludeFile(ABC)

  OMIT('_EndOfInclude_',_ClaRunExtPresent_)
_ClaRunExtPresent_  EQUATE(1)

RotateFlipType:RotateNoneFlipNone   EQUATE(0)!Specifies no clockwise rotation and no flipping.
RotateFlipType:Rotate90FlipNone EQUATE(1)!Specifies a 90-degree clockwise rotation without flipping.
RotateFlipType:Rotate180FlipNone    EQUATE(2)!Specifies a 180-degree clockwise rotation without flipping.
RotateFlipType:Rotate270FlipNone    EQUATE(3)!Specifies a 270-degree clockwise rotation without flipping.
RotateFlipType:RotateNoneFlipX  EQUATE(4)!Specifies no clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate90FlipX    EQUATE(5)!Specifies a 90-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate180FlipX   EQUATE(6)!Specifies a 180-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate270FlipX   EQUATE(7)!Specifies a 270-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:RotateNoneFlipY  EQUATE(8)!Specifies no clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate90FlipY    EQUATE(9)!Specifies a 90-degree clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate180FlipY   EQUATE(10)!Specifies a 180-degree clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate270FlipY   EQUATE(11)!Specifies a 270-degree clockwise rotation followed by a vertical flip.
RotateFlipType:RotateNoneFlipXY EQUATE(12)!Specifies no clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate90FlipXY   EQUATE(13)!Specifies a 90-degree clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate180FlipXY  EQUATE(14)!Specifies a 180-degree clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate270FlipXY  EQUATE(15)!Specifies a 270-degree clockwise rotation followed by a horizontal and vertical flip.

ClaRunExtClass      CLASS,TYPE,MODULE('ClaRunExt.clw'),LINK('ClaRunExt.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
!region Protected Methods
Inited                BYTE,PROTECTED
Construct             PROCEDURE()
Destruct              PROCEDURE(),PROTECTED
Init                  PROCEDURE(BOOL displayMessage=TRUE),BYTE,PROTECTED
!endregion

!region Public Methods
!region Image Methods
!!! <summary>
!!! Convert any Clarion supported format file to a PNG file, changing the fileName extension to PNG.
!!! </summary>
!!! <param name="fileNameIn">the name of the file to convert</param>
!!! <returns>Return Zero if no error and Error Number if there is an error.</returns>
ImageToPNG            PROCEDURE(STRING fileNameIn),LONG
!!! <summary>
!!! Convert any Clarion supported format file to a PNG with the name fileNameOut.
!!! </summary>
!!! <param name="fileNameIn">the name of the file to convert</param>
!!! <param name="fileNameOut">the name of the PNG output file</param>
!!! <returns>Return Zero if no error and Error Number if there is an error.</returns>
ImageToPNG            PROCEDURE(STRING fileNameIn, STRING fileNameOut),LONG
!!! <summary>
!!! Modify a file applying rotation or flip and storing hte result in a new file
!!! </summary>
!!! <param name="fileNameIn">the name of the file to rotate</param>
!!! <param name="fileNameOut">the name of the modified file</param>
!!! <param name="RotateFlipType">Type of rotation to by applyed to the image. equate of type RotateFlipType:</param>
!!! <returns>Return Zero if no error and Error Number if there is an error.</returns>
ImageRotateFlip       PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType),LONG
!!! <summary>
!!! Create a new image reduced in size base on the parcentage passed
!!! </summary>
!!! <param name="fileNameIn">the name of the original file to reduce</param>
!!! <param name="fileNameOut">the name of the modified file</param>
!!! <param name="percentage">porcentage to reduce the file</param>
!!! <returns>Return Zero if no error and Error Number if there is an error.</returns>
ImageSaveThumbnail    PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG percentage),LONG
!endregion
!region SMTP Methods
!!! <summary>
!!! Send an SMS to the toPhoneNumber via the toCarrier using the SMTP server information
!!! </summary>
!!! <param name="SMTPServerHost">the server name to use to send the SMS</param>
!!! <param name="SMTPLoginUserName">user name to login to the server</param>
!!! <param name="SMTPLoginPassword">password to login to the server</param>
!!! <param name="SMTPPort">port number, if needed, for the server</param>
!!! <param name="SMTPEnableSsl">(true/false) if the server uses SSL</param>
!!! <param name="showErrorMessage">(true/false) if the function will show the full error in a message or just return the error value</param>
!!! <param name="fromAddress">
!!! address of the sender of the message.  The address must be in one of these formats:
!!! "display name" <address@host>,
!!! display name <address@host>,
!!! <address@host>, or
!!! address@host
!!! If the display name is not in quotes, then there cannot be a comma in the display
!!! name.  It is recommended therefore to use either "display name" or no display name
!!! </param>
!!! <param name="toPhoneNumber">
!!! The telephone number to send the SMS to
!!! </param>
!!! <param name="toCarrier">
!!! The name of the carrier who the toPhoneNumber is with.  The format of toCarrier defines how the
!!! address of the receiver is constructed:
!!! Format                 Address
!!! ======                 =======
!!! name                   <toPhoneNumber>@name
!!! @name                  <toPhoneNumber>@name
!!! text{number}more       text<toPhoneNumber>more
!!! The last format gives you complete control over the name.  An example of this is
!!! toPhoneNumber = 123456
!!! toCarrier = 'sms.{number}@carrier.com
!!! The SMS would be sent to sms.123456@carrier.com
!!! </param>
!!! <param name="subject">subject of the SMS</param>
!!! <param name="textMessage">content of the SMS</param>
!!! <returns>0 if the SMS was successfully sent, 2 if there was a format exception, 1 if there was an SMPT exception, 99 for other types of exceptions.</returns>
SendSMS               PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, STRING fromAddress, STRING toPhoneNumber, STRING toCarrier, STRING subject, STRING textMessage),LONG
!!! <summary>
!!! Send an email to the toAddress using the SMTP server information
!!! </summary>
!!! <param name="SMTPServerHost">the server name to use to send the email</param>
!!! <param name="SMTPLoginUserName">user name to login to the server</param>
!!! <param name="SMTPLoginPassword">password to login to the server</param>
!!! <param name="SMTPPort">port number, if needed, for the server</param>
!!! <param name="SMTPEnableSsl">(true/false) if the server uses SSL</param>
!!! <param name="showErrorMessage">(true/false) if the function will show the full error in a message or just return the error value</param>
!!! <param name="receiveRequest">(true/false) if a confirmation of received is requested (not all clients will answer)</param>
!!! <param name="messageBodyEncoding">the encoding for the message empty or defualt will be ASCII</param>
!!! <param name="fromAddress">
!!! address of the sender of the message.  The address must be in one of these formats:
!!! "display name" <address@host>,
!!! display name <address@host>,
!!! <address@host>, or
!!! address@host
!!! If the display name is not in quotes, then there cannot be a comma in the display
!!! name.  It is recommended therefore to use either "display name" or no display name
!!! </param>
!!! <param name="toAddress">
!!! address to send the message to.  The address must be in one of these formats:
!!! "display name" <address@host>,
!!! display name <address@host>,
!!! <address@host>, or
!!! address@host
!!! If the display name is not in quotes, then there cannot be a comma in the display
!!! name.  It is recommended therefore to use either "display name" or no display name
!!! </param>
!!! <param name="replyToAddress">the address to get the reply from the message</param>
!!! <param name="subject">subject of the message</param>
!!! <param name="htmlMessage">content of the message if it is html formated</param>
!!! <param name="embeddedImageFileNames">
!!! Image file names separated by a semi-colon (;)
!!! To reference the images in your html message you use '<img src="cid:imageId' & n & '">'
!!! where n indicates the image's position in your list of names starting at 1.  For example
!!! if you set embeddedImageFileNames to 'C:\Images\Flowers.png;C:\Images\Cats.png', then in your
!!! htmlMessage you reference Flowers.png with the code '<img src="cid:imageId1">' and Cats.png
!!! with the code '<img src="cid:imageId2">'
!!! </param>
!!! <param name="textMessage">content of the message if it is plain text</param>
!!! <param name="attachedFileNames">attachement files separated by a semi-colon (;)</param>
!!! <param name="ccList">
!!! A coma (,) seperated list of email addresses that should be in the CC list in the email
!!! The addresses must be in one of these formats:
!!! "display name" <address@host>,
!!! display name <address@host>,
!!! <address@host>, or
!!! address@host
!!! If the display name is not in quotes, then there cannot be a comma in the display
!!! name.  It is recommended therefore to use either "display name" or no display name
!!! </param>
!!! <param name="bccList">
!!! A coma (,) seperated list of email addresses that should be in the BCC list in the email
!!! The addresses must be in one of these formats:
!!! "display name" <address@host>,
!!! display name <address@host>,
!!! <address@host>, or
!!! address@host
!!! If the display name is not in quotes, then there cannot be a comma in the display
!!! name.  It is recommended therefore to use either "display name" or no display name
!!! </param>
!!! <returns>0 if the email was successfully sent, 2 if there was a format exception, 1 if there was an SMPT exception, 99 for other types of exceptions.</returns>
SendMail              PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList),LONG
!endregion
!endregion
                    END
!_EndOfInclude_
