                    MEMBER()

  INCLUDE('ClaRunExt.INC'),ONCE

                    MAP
                      MODULE('Win32Api')
                        ClaRunExt_LoadLibrary(CONST *CSTRING pszModuleFileName), UNSIGNED, PASCAL, NAME('LoadLibraryA')
                        ClaRunExt_FreeLibrary(UNSIGNED hModule), BOOL, PASCAL, PROC, NAME('FreeLibrary')
                        ClaRunExt_GetModuleHandle(CONST *CSTRING pszModuleName), UNSIGNED, PASCAL, NAME('GetModuleHandleA')
                        ClaRunExt_GetProcAddress(UNSIGNED hModule, CONST *CSTRING pszProcName), LONG, PASCAL, NAME('GetProcAddress')
                        ClaRunExt_GetLastError(), ULONG, PASCAL, NAME('GetLastError')
                      END
                      MODULE('ClaRunExtDLL')
                        ImageToPNG1_ClaRunExt (CONST *STRING fileNameIn, LONG inLen),LONG,C,RAW,DLL(1)!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
                        ImageToPNG2_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen),LONG,C,RAW,DLL(1)!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
                        ImageRotateFlip_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG RotateFlipType),LONG,C,RAW,DLL(1)!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
                        ImageSaveThumbnail_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG percentage),LONG,C,RAW,DLL(1)!Save image reduced in size. Return 0 if no error and Error Number if there is an error
                        SendSMS_ClaRunExt (CONST *STRING SMTPServerHost, LONG hostLen, CONST *STRING SMTPLoginUserName, LONG nameLen, CONST *STRING SMTPLoginPassword, LONG pwdLen, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, | 
                          CONST *STRING  fromAddress, LONG fromLen, CONST *STRING  toPhoneNumber, LONG toLen, CONST *STRING  toCarrier, LONG carrierLen, CONST *STRING  subject, LONG subjectLen, CONST *STRING  textMessage, LONG messageLen),LONG,C,RAW,DLL(1)!Send a SMS message
                        SendMail_ClaRunExt (CONST *STRING SMTPServerHost, LONG hostLen, CONST *STRING SMTPLoginUserName, LONG nameLen, CONST *STRING SMTPLoginPassword, LONG pwdLen, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, | 
                          LONG receiveRequest, CONST *STRING messageBodyEncoding, LONG encodingLen, CONST *STRING fromAddress, LONG fromLen, CONST *STRING toAddress, LONG toLen, CONST *STRING replyToAddress, LONG replyLen, | 
                          CONST *STRING subject, LONG subjectLen, CONST *STRING htmlMessage, LONG htmlLen, CONST *STRING embeddedImageFileNames, LONG imagesLen, CONST *STRING textMessage, LONG textLen, CONST *STRING attachedFileNames, |
                          LONG attachmentsLen, CONST *STRING ccList, LONG ccLen, CONST *STRING bccList, LONG bccLen),LONG,C,RAW,DLL
                      END
                    END


!SendSMS and SendMail
!return error values:
!0  = No Error
!1  = SMTP Error
!2  = Parameter Format Error
!3  = No ClaRunExt.dll
!99 = Unknow Error


!Note:
!To add more functions supported in ClaRunExt.DLL:
!1) Add the new function to the MODULE('ClaRunExtDLL') in the MAP
!2) Add new LONG with the External Name with the exact same name as the function in the map
!3) Add a new CSTRING with the function name from Libmaker as PRIVATE
!4) Add a Method to the ClaRunExtLibClass for that new function
!5) Add a Method to the ClaRunExtClass for that new function
!6) Add the code to the ClaRunExtLibClass.DoInit method to assing the LONG variable created on step 2 using the value of the CSTRING created on step 3
!7) Add a new line to the verification in the ClaRunExtLibClass.DoInit using the LONG variable created on step 2
!8) Create a method on ClaRunExtLibClass with the name of the function that does the Init verification and the call to the Function declared in the MAP
!9) Create a method on ClaRunExtClass that calls the method to the ClaRunExtLibClass

!Class Static Data

ImageToPNG1_ClaRunExt_fp    LONG,NAME('ImageToPNG1_ClaRunExt')
ImageToPNG2_ClaRunExt_fp    LONG,NAME('ImageToPNG2_ClaRunExt')
ImageRotateFlip_ClaRunExt_fp    LONG,NAME('ImageRotateFlip_ClaRunExt')
ImageSaveThumbnail_ClaRunExt_fp LONG,NAME('ImageSaveThumbnail_ClaRunExt')
SendSMS_ClaRunExt_fp    LONG,NAME('SendSMS_ClaRunExt')
SendMail_ClaRunExt_fp   LONG,NAME('SendMail_ClaRunExt')



ClaRunExtLibraryModuleName  CSTRING('ClaRunExt.DLL'),PRIVATE
ImageToPNG1_ClaRunExt_fn    CSTRING('?ImageToPNG1@@YAJPBDJ@Z'),PRIVATE
ImageToPNG2_ClaRunExt_fn    CSTRING('?ImageToPNG2@@YAJPBDJ0J@Z'),PRIVATE
ImageRotateFlip_ClaRunExt_fn    CSTRING('?RotateFlip@@YAJPBDJ0JJ@Z'),PRIVATE
ImageSaveThumbnail_ClaRunExt_fn CSTRING('?SaveThumbnail@@YAJPBDJ0JJ@Z'),PRIVATE
SendSMS_ClaRunExt_fn    CSTRING('?SendSMS@@YAJPBDJ0J0JJJJ0J0J0J0J0J@Z'),PRIVATE
SendMail_ClaRunExt_fn   CSTRING('?SendMail@@YAJPBDJ0J0JJJJJ0J0J0J0J0J0J0J0J0J0J0J@Z'),PRIVATE

!-------------------------------------------------------------
!This class is used to keep one instance of the ClaRunExt.DLL Library per application
!
ClaRunExtLibClass   CLASS,PRIVATE
hLib                  UNSIGNED,PROTECTED
Users                 UNSIGNED,PROTECTED
Inited                BYTE,PROTECTED

Construct             PROCEDURE()
Destruct              PROCEDURE(),PROTECTED

Init                  PROCEDURE(BOOL displayMessage),BYTE
DoInit                PROCEDURE(BOOL displayMessage),BYTE,PROTECTED
Kill                  PROCEDURE()
IsInited              PROCEDURE(),BYTE
ImageToPNG            PROCEDURE(STRING fileNameIn),LONG!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
ImageToPNG            PROCEDURE(STRING fileNameIn, STRING fileNameOut),LONG!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
ImageRotateFlip       PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType),LONG!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
ImageSaveThumbnail    PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG porcentage),LONG!Save image reduced in size. Return 0 if no error and Error Number if there is an error
SendSMS               PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage),LONG
SendMail              PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList),LONG
                    END
!-------------------------------------------------------------

!region ClaRunExtLibClass
ClaRunExtLibClass.Construct PROCEDURE()
  CODE
  SELF.hLib   = 0
  SELF.Users  = 0
  SELF.Inited = FALSE
  RETURN

ClaRunExtLibClass.Destruct  PROCEDURE()
  CODE
  SELF.Kill()
  RETURN

ClaRunExtLibClass.Init  PROCEDURE(BOOL displayMessage)
  CODE
  IF NOT SELF.IsInited()
    IF NOT SELF.DoInit(displayMessage)
      RETURN FALSE
    END
    SELF.Inited = TRUE
  END
  RETURN TRUE

ClaRunExtLibClass.DoInit    PROCEDURE(BOOL displayMessage)
  CODE
  IF SELF.hLib <> 0
    SELF.Users += 1
  ELSE
    SELF.hLib = ClaRunExt_LoadLibrary (ClaRunExtLibraryModuleName)
    IF SELF.hLib = 0
      IF displayMessage
        MESSAGE('ClaRunExt.DLL Could not be found')
      END
?     ASSERT(ImageToPNG1_ClaRunExt_fp <> 0, 'ClaRunExt.DLL Not found')
      RETURN FALSE
    END

    SELF.Users += 1

    ! LONG Function pointer = GetProcAddress(ModuleHandle, CSTRING Function Name)
    ImageToPNG1_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG1_ClaRunExt_fn)
    IF displayMessage AND ImageToPNG1_ClaRunExt_fp = 0
      MESSAGE('ImageToPNG1 was not found in ClaRunExt.DLL')
    END
?   ASSERT(ImageToPNG1_ClaRunExt_fp <> 0, 'ImageToPNG1 not found in ClaRunExt.DLL')
    ImageToPNG2_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG2_ClaRunExt_fn)
    IF displayMessage AND ImageToPNG2_ClaRunExt_fp = 0
      MESSAGE('ImageToPNG2 was not found in ClaRunExt.DLL')
    END
?   ASSERT(ImageToPNG2_ClaRunExt_fp <> 0, 'ImageToPNG2 not found in ClaRunExt.DLL')
    ImageRotateFlip_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageRotateFlip_ClaRunExt_fn)
    IF displayMessage AND ImageRotateFlip_ClaRunExt_fp = 0
      MESSAGE('ImageRotateFlip was not found in ClaRunExt.DLL')
    END
?   ASSERT(ImageRotateFlip_ClaRunExt_fp <> 0,'ImageRotateFlip not found in ClaRunExt.DLL')
    ImageSaveThumbnail_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageSaveThumbnail_ClaRunExt_fn)
    IF displayMessage AND ImageSaveThumbnail_ClaRunExt_fp = 0
      MESSAGE('ImageSaveThumbnail was not found in ClaRunExt.DLL')
    END
?   ASSERT(ImageSaveThumbnail_ClaRunExt_fp <>0 ,'ImageSaveThumbnail not found in ClaRunExt.DLL')

    SendSMS_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SendSMS_ClaRunExt_fn)
    IF displayMessage AND SendSMS_ClaRunExt_fp = 0
      MESSAGE('SendSMS was not found in ClaRunExt.DLL')
    END
?   ASSERT(SendSMS_ClaRunExt_fp <>0 ,'SendSMS not found in ClaRunExt.DLL')
    SendMail_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SendMail_ClaRunExt_fn)
    IF displayMessage AND SendMail_ClaRunExt_fp = 0
      MESSAGE('SendMail was not found in ClaRunExt.DLL')
    END
?   ASSERT(SendMail_ClaRunExt_fp <>0 ,'SendMail not found in ClaRunExt.DLL')

    !Verification that all the function pointer were found, and if not just Kill the class
    IF ImageToPNG1_ClaRunExt_fp = 0 OR |
      ImageToPNG2_ClaRunExt_fp = 0 OR |
      ImageRotateFlip_ClaRunExt_fp = 0 OR |
      ImageSaveThumbnail_ClaRunExt_fp = 0 OR |
      SendSMS_ClaRunExt_fp = 0 OR |
      SendMail_ClaRunExt_fp = 0
      SELF.Kill()
      RETURN FALSE
    END
  END
  RETURN TRUE

ClaRunExtLibClass.IsInited  PROCEDURE()
  CODE
  RETURN CHOOSE (SELF.Inited <> FALSE)

ClaRunExtLibClass.Kill  PROCEDURE()
  CODE
  !Note make a lock to the ClaRunExtLibraryModule so no two threads can unload the library at the same time.
  !Any way it will be safe

  IF SELF.Inited
    SELF.Users -= 1

    IF SELF.Users = 0
      ClaRunExt_FreeLibrary (SELF.hLib)
      SELF.hLib = 0
    END
  END
  RETURN

!region ClaRunExtLibClass function pointer calling methods
ClaRunExtLibClass.ImageToPNG    PROCEDURE(STRING fileNameIn)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageToPNG1_ClaRunExt (fileNameIn, LEN(fileNameIn))

ClaRunExtLibClass.ImageToPNG    PROCEDURE(STRING fileNameIn, STRING fileNameOut)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageToPNG2_ClaRunExt (fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut))

ClaRunExtLibClass.ImageRotateFlip   PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageRotateFlip_ClaRunExt (fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), RotateFlipType)

ClaRunExtLibClass.ImageSaveThumbnail    PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG percentage)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageSaveThumbnail_ClaRunExt(fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), percentage)


ClaRunExtLibClass.SendSMS   PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN SendSMS_ClaRunExt (SMTPServerHost, LEN(SMTPServerHost), SMTPLoginUserName, LEN(SMTPLoginUserName), SMTPLoginPassword, LEN(SMTPLoginPassword), | 
    SMTPPort, SMTPEnableSsl, showErrorMessage, fromAddress, LEN(fromAddress), toPhoneNumber, LEN(toPhoneNumber), toCarrier, LEN(toCarrier), subject, | 
    LEN(subject), textMessage, LEN(textMessage))

ClaRunExtLibClass.SendMail  PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN SendMail_ClaRunExt (SMTPServerHost, LEN(SMTPServerHost), SMTPLoginUserName, LEN(SMTPLoginUserName), SMTPLoginPassword, LEN(SMTPLoginPassword), | 
    SMTPPort, SMTPEnableSsl, showErrorMessage, receiveRequest, messageBodyEncoding, LEN(messageBodyEncoding), fromAddress, LEN(fromAddress), toAddress, |
    LEN(toAddress), replyToAddress, LEN(replyToAddress), subject, LEN(subject), htmlMessage, LEN(htmlMessage), embeddedImageFileNames, LEN(embeddedImageFileNames), |
    textMessage, LEN(textMessage), attachedFileNames, LEN(attachedFileNames), ccList, LEN(ccList), bccList, LEN(bccList))

!endregion
!endregion
!region ClaRunExtClass
ClaRunExtClass.Construct    PROCEDURE()
  CODE
  SELF.Inited = FALSE

ClaRunExtClass.Destruct PROCEDURE()
  CODE
  IF SELF.Inited
    ClaRunExtLibClass.Kill()
  END

ClaRunExtClass.Init PROCEDURE(BOOL displayMessage)
  CODE
  IF NOT SELF.Inited
    SELF.Inited = ClaRunExtLibClass.Init(displayMessage)
  END
  RETURN SELF.Inited

ClaRunExtClass.ImageToPNG   PROCEDURE(STRING fileNameIn)
  CODE
  IF SELF.Init(TRUE)
    RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn)
  END
  RETURN FALSE
ClaRunExtClass.ImageToPNG   PROCEDURE(STRING fileNameIn, STRING fileNameOut)
  CODE
  IF SELF.Init(TRUE)
    RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn, fileNameOut)
  END
  RETURN FALSE
ClaRunExtClass.ImageRotateFlip  PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType)
  CODE
  IF SELF.Init(TRUE)
    RETURN ClaRunExtLibClass.ImageRotateFlip(fileNameIn, fileNameOut, RotateFlipType)
  END
  RETURN FALSE
ClaRunExtClass.ImageSaveThumbnail   PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG percentage)
  CODE
  IF SELF.Init(TRUE)
    RETURN ClaRunExtLibClass.ImageSaveThumbnail(fileNameIn, fileNameOut, percentage)
  END
  RETURN FALSE
ClaRunExtClass.SendSMS  PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage)
  CODE
  IF SELF.Init(showErrorMessage)
    RETURN ClaRunExtLibClass.SendSMS(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, showErrorMessage, fromAddress, toPhoneNumber, toCarrier, subject, textMessage)
  END
  RETURN 3
ClaRunExtClass.SendMail PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList)
  CODE
  IF SELF.Init(showErrorMessage)
    RETURN ClaRunExtLibClass.SendMail(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, showErrorMessage, receiveRequest, messageBodyEncoding, fromAddress, toAddress, replyToAddress, subject, htmlMessage, embeddedImageFileNames, textMessage, attachedFileNames, ccList, bccList)
  END
  RETURN 3
!endregion
