                    MEMBER()

  INCLUDE('ClaRunExt.INC'),ONCE
  INCLUDE('CWSYNCHC.INC'),ONCE

COMPILE('***', _C100_)
  PRAGMA ('project(#file copy clarunext.dll)')
!***

  MAP
TestFnPtr   PROCEDURE(LONG fnPtr, STRING functionName, BOOL displayMessage, <*STRING errMessage>),BOOL
    MODULE('Core')
      MIMEEXT_PathSplit(CONST *CSTRING path, <*CSTRING drive>, <*CSTRING dir>, <*CSTRING file>, <*CSTRING ext>), SIGNED, PROC, RAW, NAME('_fnsplit')
    END
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
      ImageToPNG3_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG imageRes),LONG,C,RAW,DLL(1)!Save image to a PNG file with the name fileNameOut using the imageRes resolution. Return 0 if no error and Error Number if there is an error
      ImageRotateFlip_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG RotateFlipType),LONG,C,RAW,DLL(1)!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
      ImageSaveThumbnail_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG percentage),LONG,C,RAW,DLL(1)!Save image reduced in size. Return 0 if no error and Error Number if there is an error
      ImageSaveThumbnailPix_ClaRunExt (CONST *STRING fileNameIn, LONG inLen, CONST *STRING fileNameOut, LONG outLen, LONG pixelsWidth),LONG,C,RAW,DLL(1)!Save image reduced in size. Return 0 if no error and Error Number if there is an error
      SendSMS_ClaRunExt (CONST *STRING SMTPServerHost, LONG hostLen, CONST *STRING SMTPLoginUserName, LONG nameLen, CONST *STRING SMTPLoginPassword, LONG pwdLen, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, |
        CONST *STRING  fromAddress, LONG fromLen, CONST *STRING  toPhoneNumber, LONG toLen, CONST *STRING  toCarrier, LONG carrierLen, CONST *STRING  subject, LONG subjectLen, CONST *STRING  textMessage, LONG messageLen, |
        *STRING errMessage, LONG errMessageLen),LONG,C,RAW,DLL(1)!Send a SMS message
      SendMail_ClaRunExt (CONST *STRING SMTPServerHost, LONG hostLen, CONST *STRING SMTPLoginUserName, LONG nameLen, CONST *STRING SMTPLoginPassword, LONG pwdLen, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, |
        LONG receiveRequest, CONST *STRING messageBodyEncoding, LONG encodingLen, CONST *STRING fromAddress, LONG fromLen, CONST *STRING toAddress, LONG toLen, CONST *STRING replyToAddress, LONG replyLen, |
        CONST *STRING subject, LONG subjectLen, CONST *STRING htmlMessage, LONG htmlLen, CONST *STRING embeddedImageFileNames, LONG imagesLen, CONST *STRING textMessage, LONG textLen, CONST *STRING attachedFileNames, |
        LONG attachmentsLen, CONST *STRING ccList, LONG ccLen, CONST *STRING bccList, LONG bccLen, *STRING errMessage, LONG errMessageLen),LONG,C,RAW,DLL
      HttpUploadFile_ClaRunExt (CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters, CONST *CSTRING extraHeaders,*CSTRING responseOut),LONG,C,DLL(1)!HttpUploadFile
      HttpUploadFilePW_ClaRunExt (CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING extraHeaders,*CSTRING responseOut),LONG,C,DLL(1)!HttpUploadFile
      HttpWebRequest_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING responseOut),LONG,C,DLL(1)!HttpWebRequest
      HttpWebRequestExt_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING responseOut),LONG,C,DLL(1)!HttpWebRequest
      HttpWebRequestExtPW_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING responseOut),LONG,C,DLL(1)!HttpWebRequest
      HttpWebRequestToFile_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG,C,DLL(1)!HttpWebRequest
      HttpWebRequestToFileExt_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG,C,DLL(1)!HttpWebRequest
      HttpWebRequestToFileExtPW_ClaRunExt (CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG,C,DLL(1)!HttpWebRequest
      GetAWSRegion_ClaRunExt(*STRING displayName, LONG displayNameLen, *STRING systemName, LONG systemNameLen, *STRING errorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      ConnectToS3_ClaRunExt (*STRING AccessKey, LONG AccessKeyLen, *STRING SecretKey, LONG SecretKeyLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      DisconnectFromS3_ClaRunExt(LONG netPtr),C,RAW,DLL
      GetContainer_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING regionDisplayName, LONG regionDisplayNameLen, *STRING regionSystemName, LONG regionSystemNameLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      CreateContainer_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING region, LONG regionLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      DeleteContainer_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      CreateFolder_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING folder, LONG folderLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      DeleteFolder_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING folder, LONG folderLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      GetNextFile_ClaRunExt(LONG netPtr, *STRING container, LONG containerLen, *STRING parentFolder, LONG parentFolderLen, *STRING fileName, LONG fileNameLen, *BOOL isFile, *DATE lmDate, *TIME lmTime, *ULONG sizeLo, *LONG sizeHi, *STRING errorMessage, LONG errorMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      UploadFile_ClaRunExt (LONG netPtr, *STRING sourceFile, LONG sourceFileLen, *STRING container, LONG containerLen, *STRING destinationFile, LONG destinationFileLen, BOOL asynchronous, BOOL encrypted, IAWSTransfering callback, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      DownloadFile_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING sourceFile, LONG sourceFileLen, *STRING destinationFile, LONG destinationFileLen, BOOL asynchronous, IAWSTransfering callback, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      DeleteFile_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      FileExists_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      CancelTransfer_ClaRunExt(LONG netPtr, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      GetTemporaryURL_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, LONG days, LONG hours, LONG minutes, *STRING ret, LONG retLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),C,RAW,DLL
      GetPermanentURL_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, *STRING ret, LONG retLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),C,RAW,DLL
      AllowPublicAccess_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, LONG public, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      HasPublicAccess_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      GetNextMetaData_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, *STRING key, LONG keyLen, *STRING value, LONG valueLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      GetMetaData_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, STRING key, LONG keyLen, *STRING ret, LONG retLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),C,RAW,DLL
      SetAllMetaData_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, STRING metaData, LONG metaDataLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      SetMetaData_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, STRING key, LONG keyLen, STRING value, LONG valueLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
      RemoveMetaData_ClaRunExt (LONG netPtr, *STRING container, LONG containerLen, *STRING fileName, LONG fileNameLen, STRING key, LONG keyLen, *STRING ErrorMessage, LONG errMessageLen, *STRING errorCode, LONG errorCodeLen),LONG,C,RAW,DLL
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
!6) Add the code to the ClaRunExtLibClass.Init method to assign the LONG variable created on step 2 using the value of the CSTRING created on step 3
!7) Create a method on ClaRunExtLibClass with the name of the function that does the Init verification and the call to the Function declared in the MAP
!8) Create a method on ClaRunExtClass that calls the method to the ClaRunExtLibClass

!Class Static Data

ImageToPNG1_ClaRunExt_fp                LONG,NAME('ImageToPNG1_ClaRunExt')
ImageToPNG2_ClaRunExt_fp                LONG,NAME('ImageToPNG2_ClaRunExt')
ImageToPNG3_ClaRunExt_fp                LONG,NAME('ImageToPNG3_ClaRunExt')
ImageRotateFlip_ClaRunExt_fp            LONG,NAME('ImageRotateFlip_ClaRunExt')
ImageSaveThumbnail_ClaRunExt_fp         LONG,NAME('ImageSaveThumbnail_ClaRunExt')
ImageSaveThumbnailPix_ClaRunExt_fp      LONG,NAME('ImageSaveThumbnailPix_ClaRunExt')
SendSMS_ClaRunExt_fp                    LONG,NAME('SendSMS_ClaRunExt')
SendMail_ClaRunExt_fp                   LONG,NAME('SendMail_ClaRunExt')
HttpUploadFile_ClaRunExt_fp             LONG,NAME('HttpUploadFile_ClaRunExt')
HttpUploadFilePW_ClaRunExt_fp           LONG,NAME('HttpUploadFilePW_ClaRunExt')
HttpWebRequest_ClaRunExt_fp             LONG,NAME('HttpWebRequest_ClaRunExt')
HttpWebRequestExt_ClaRunExt_fp          LONG,NAME('HttpWebRequestExt_ClaRunExt')
HttpWebRequestExtPW_ClaRunExt_fp        LONG,NAME('HttpWebRequestExtPW_ClaRunExt')
HttpWebRequestToFile_ClaRunExt_fp       LONG,NAME('HttpWebRequestToFile_ClaRunExt')
HttpWebRequestToFileExt_ClaRunExt_fp    LONG,NAME('HttpWebRequestToFileExt_ClaRunExt')
HttpWebRequestToFileExtPW_ClaRunExt_fp  LONG,NAME('HttpWebRequestToFileExtPW_ClaRunExt')
GetAWSRegion_ClaRunExt_fp               LONG,NAME('GetAWSRegion_ClaRunExt')
ConnectToS3_ClaRunExt_fp                LONG,NAME('ConnectToS3_ClaRunExt')
DisconnectFromS3_ClaRunExt_fp           LONG,NAME('DisconnectFromS3_ClaRunExt')
GetContainer_ClaRunExt_fp               LONG,NAME('GetContainer_ClaRunExt')
CreateContainer_ClaRunExt_fp            LONG,NAME('CreateContainer_ClaRunExt')
DeleteContainer_ClaRunExt_fp            LONG,NAME('DeleteContainer_ClaRunExt')
GetNextFile_ClaRunExt_fp                LONG,NAME('GetNextFile_ClaRunExt')
CreateFolder_ClaRunExt_fp               LONG,NAME('CreateFolder_ClaRunExt')
DeleteFolder_ClaRunExt_fp               LONG,NAME('DeleteFolder_ClaRunExt')
UploadFile_ClaRunExt_fp                 LONG,NAME('UploadFile_ClaRunExt')
DownloadFile_ClaRunExt_fp               LONG,NAME('DownloadFile_ClaRunExt')
DeleteFile_ClaRunExt_fp                 LONG,NAME('DeleteFile_ClaRunExt')
FileExists_ClaRunExt_fp                 LONG,NAME('FileExists_ClaRunExt')
CancelTransfer_ClaRunExt_fp             LONG,NAME('CancelTransfer_ClaRunExt')
GetTemporaryURL_ClaRunExt_fp            LONG,NAME('GetTemporaryURL_ClaRunExt')
GetPermanentURL_ClaRunExt_fp            LONG,NAME('GetPermanentURL_ClaRunExt')
AllowPublicAccess_ClaRunExt_fp          LONG,NAME('AllowPublicAccess_ClaRunExt')
HasPublicAccess_ClaRunExt_fp            LONG,NAME('HasPublicAccess_ClaRunExt')
GetNextMetaData_ClaRunExt_fp            LONG,NAME('GetNextMetaData_ClaRunExt')
GetMetaData_ClaRunExt_fp                LONG,NAME('GetMetaData_ClaRunExt')
SetAllMetaData_ClaRunExt_fp             LONG,NAME('SetAllMetaData_ClaRunExt')
SetMetaData_ClaRunExt_fp                LONG,NAME('SetMetaData_ClaRunExt')
RemoveMetaData_ClaRunExt_fp             LONG,NAME('RemoveMetaData_ClaRunExt')

ClaRunExtLibraryModuleName              CSTRING('ClaRunExt.DLL'),PRIVATE
ImageToPNG1_ClaRunExt_fn                CSTRING('?ImageToPNG1@@YAJPBDJ@Z'),PRIVATE
ImageToPNG2_ClaRunExt_fn                CSTRING('?ImageToPNG2@@YAJPBDJ0J@Z'),PRIVATE
ImageToPNG3_ClaRunExt_fn                CSTRING('?ImageToPNG3@@YAJPBDJ0JJ@Z'),PRIVATE
ImageRotateFlip_ClaRunExt_fn            CSTRING('?RotateFlip@@YAJPBDJ0JJ@Z'),PRIVATE
ImageSaveThumbnail_ClaRunExt_fn         CSTRING('?SaveThumbnail@@YAJPBDJ0JJ@Z'),PRIVATE
ImageSaveThumbnailPix_ClaRunExt_fn      CSTRING('?SaveThumbnailPix@@YAJPBDJ0JJ@Z'),PRIVATE
SendSMS_ClaRunExt_fn                    CSTRING('?SendSMS@@YAJPBDJ0J0JJJJJ0J0J0J0J0JPADJ@Z'),PRIVATE
SendMail_ClaRunExt_fn                   CSTRING('?SendMail@@YAJPBDJ0J0JJJJJJ0J0J0J0J0J0J0J0J0J0J0JPADJ@Z'),PRIVATE
HttpUploadFile_ClaRunExt_fn             CSTRING('?HttpUploadFile@@YAHPBD00000IPAD@Z'),PRIVATE
HttpUploadFilePW_ClaRunExt_fn           CSTRING('?HttpUploadFilePW@@YAHPBD0000000IPAD@Z'),PRIVATE
HttpWebRequest_ClaRunExt_fn             CSTRING('?MakeHttpWebRequest@@YAHPBDH00IPAD@Z'),PRIVATE
HttpWebRequestExt_ClaRunExt_fn          CSTRING('?MakeHttpWebRequestExt@@YAHPBDH0000IPAD@Z'),PRIVATE
HttpWebRequestExtPW_ClaRunExt_fn        CSTRING('?MakeHttpWebRequestExtPW@@YAHPBDH000000IPAD@Z'),PRIVATE
HttpWebRequestToFile_ClaRunExt_fn       CSTRING('?MakeHttpWebRequestToFile@@YAHPBDH00IPAD0@Z'),PRIVATE
HttpWebRequestToFileExt_ClaRunExt_fn    CSTRING('?MakeHttpWebRequestToFileExt@@YAHPBDH0000IPAD0@Z'),PRIVATE
HttpWebRequestToFileExtPW_ClaRunExt_fn  CSTRING('?MakeHttpWebRequestToFileExtPW@@YAHPBDH000000IPAD0@Z'),PRIVATE
GetAWSRegion_ClaRunExt_fn               CSTRING('?GetAWSRegion@@YAJPADJ0J0J@Z'),PRIVATE
ConnectToS3_ClaRunExt_fn                CSTRING('?ConnectToS3@@YAJPBDJ0JPADJ1J@Z'),PRIVATE
DisconnectFromS3_ClaRunExt_fn           CSTRING('?DisconnectFromS3@@YAXJ@Z'),PRIVATE
GetContainer_ClaRunExt_fn               CSTRING('?GetContainer@@YAJJPADJ0J0J0J0J@Z'),PRIVATE
CreateContainer_ClaRunExt_fn            CSTRING('?CreateContainer@@YAJJPBDJ0JPADJ1J@Z'),PRIVATE
DeleteContainer_ClaRunExt_fn            CSTRING('?DeleteContainer@@YAJJPBDJPADJ1J@Z'),PRIVATE
CreateFolder_ClaRunExt_fn               CSTRING('?CreateFolder@@YAJJPBDJ0JPADJ1J@Z'),PRIVATE
DeleteFolder_ClaRunExt_fn               CSTRING('?DeleteFolder@@YAJJPBDJ0JPADJ1J@Z'),PRIVATE
GetNextFile_ClaRunExt_fn                CSTRING('?GetNextFile@@YAJJPADJ0J0JPAJ11PAK10J0J@Z'),PRIVATE
UploadFile_ClaRunExt_fn                 CSTRING('?UploadFile@@YAJJPADJ0J0JJJPAVIAWSTransfer@@0J0J@Z'),PRIVATE
DownloadFile_ClaRunExt_fn               CSTRING('?DownloadFile@@YAJJPADJ0J0JJPAVIAWSTransfer@@0J0J@Z'),PRIVATE
DeleteFile_ClaRunExt_fn                 CSTRING('?DeleteFile@@YAJJPADJ0J0J0J@Z'),PRIVATE
FileExists_ClaRunExt_fn                 CSTRING('?FileExists@@YAJJPADJ0J0J0J@Z'),PRIVATE
CancelTransfer_ClaRunExt_fn             CSTRING('?CancelTransfer@@YAJJPADJ0J@Z'),PRIVATE
GetTemporaryURL_ClaRunExt_fn            CSTRING('?GetTemporaryURL@@YAXJPADJ0JJJJ0J0J0J@Z'),PRIVATE
GetPermanentURL_ClaRunExt_fn            CSTRING('?GetPermanentURL@@YAXJPADJ0J0J0J0J@Z'),PRIVATE
AllowPublicAccess_ClaRunExt_fn          CSTRING('?AllowPublicAccess@@YAJJPADJ0JJ0J0J@Z'),PRIVATE
HasPublicAccess_ClaRunExt_fn            CSTRING('?HasPublicAccess@@YAJJPADJ0J0J0J@Z'),PRIVATE
GetNextMetaData_ClaRunExt_fn            CSTRING('?GetNextMetaData@@YAJJPADJ0J0J0J0J0J@Z'),PRIVATE
GetMetaData_ClaRunExt_fn                CSTRING('?GetMetaData@@YAJJPADJ0JPBDJ0J0J0J@Z'),PRIVATE
SetAllMetaData_ClaRunExt_fn             CSTRING('?SetAllMetaData@@YAJJPADJ0JPBDJ0J0J@Z'),PRIVATE
SetMetaData_ClaRunExt_fn                CSTRING('?SetMetaData@@YAJJPADJ0JPBDJ1J0J0J@Z'),PRIVATE
RemoveMetaData_ClaRunExt_fn             CSTRING('?RemoveMetaData@@YAJJPADJ0JPBDJ0J0J@Z'),PRIVATE

!-------------------------------------------------------------
!This class is used to keep one instance of the ClaRunExt.DLL Library per application
!
ClaRunExtLibClass   CLASS,PRIVATE
hLib                  UNSIGNED,PRIVATE
Users                 UNSIGNED,PRIVATE
Inited                BYTE,PRIVATE
cs                    &CriticalSection

Construct             PROCEDURE()
Destruct              PROCEDURE()

Init                  PROCEDURE(BOOL displayMessage, <*STRING errMessage>),BYTE,PRIVATE
Use                   PROCEDURE()
Kill                  PROCEDURE()
Disconnect            PROCEDURE()

ImageToPNG            PROCEDURE(STRING fileNameIn),LONG!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
ImageToPNG            PROCEDURE(STRING fileNameIn, STRING fileNameOut),LONG!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
ImageToPNG            PROCEDURE(STRING fileNameIn, STRING fileNameOut, USHORT imageRes),LONG!Save image to a PNG file with the name fileNameOut using the imageRes resolution. Return 0 if no error and Error Number if there is an error
ImageRotateFlip       PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType),LONG!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
ImageSaveThumbnail    PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG porcentage),LONG!Save image reduced in size. Return 0 if no error and Error Number if there is an error
ImageSaveThumbnailPix PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG pixelsWidth),LONG!Save image reduced in size. Return 0 if no error and Error Number if there is an error
SendSMS               PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage, <*STRING errMessage>),LONG
SendMail              PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList, <*STRING errMessage>),LONG
HttpUploadFile        PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters,CONST *CSTRING extraHeaders,*CSTRING responseOut),LONG
HttpUploadFile        PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword,CONST *CSTRING extraHeaders,*CSTRING responseOut),LONG
HttpWebRequest        PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING responseOut),LONG
HttpWebRequest        PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING responseOut),LONG
HttpWebRequest        PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING responseOut),LONG
HttpWebRequestToFile  PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG
HttpWebRequestToFile  PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG
HttpWebRequestToFile  PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename),LONG
GetAWSRegion          PROCEDURE(*STRING displayName, *STRING systemName, <*STRING errorMessage>, <*STRING errorCode>),LONG
ConnectToS3           PROCEDURE(STRING AccessKey, STRING SecretKey, <*STRING ErrorMessage>, <*STRING errorCode>),LONG
DisconnectFromS3      PROCEDURE(LONG service)
GetContainer          PROCEDURE(LONG ptr, *STRING containerName, *STRING regionDisplayName, *STRING regionSystemName, *STRING errorMessage, *STRING errorCode),LONG
CreateContainer       PROCEDURE(LONG ptr, STRING containerName, STRING region, *STRING errorMessage, *STRING errorCode),LONG
DeleteContainer       PROCEDURE(LONG ptr, STRING containerName, *STRING errorMessage, *STRING errorCode),LONG
CreateFolder          PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode),LONG
DeleteFolder          PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode),LONG
GetNextFile           PROCEDURE(LONG ptr, STRING containerName, STRING parentFolder, *STRING fileName, *BOOL isFile, *DATE lmDate, *TIME lmTime, *INT64 size, *STRING errorMessage, *STRING errorCode),LONG
UploadFile            PROCEDURE(LONG ptr, STRING sourceFile, STRING containerName, STRING destinationFile, BOOL asynchronous, BOOL encrypted, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode),LONG
DownloadFile          PROCEDURE(LONG ptr, STRING containerName, STRING sourceFile, STRING destinationFile, BOOL asynchronous, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode),LONG
DeleteFile            PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode),LONG
FileExists            PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode),LONG
CancelTransfer        PROCEDURE(LONG ptr, *STRING errorMessage, *STRING errorCode),LONG
GetTemporaryURL       PROCEDURE(LONG ptr, STRING containerName, STRING fileName, LONG days, LONG hours, LONG minutes, *STRING errorMessage, *STRING errorCode),STRING
GetPermanentURL       PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode),STRING
AllowPublicAccess     PROCEDURE(LONG ptr, STRING containerName, STRING fileName, BOOL public, *STRING errorMessage, *STRING errorCode),LONG
HasPublicAccess       PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode),BOOL
GetNextMetaData       PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING key, *STRING value, *STRING errorMessage, *STRING errorCode),BOOL
GetMetaData           PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode),STRING
SetMetaData           PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING metaData, *STRING errorMessage, *STRING errorCode),BOOL
SetMetaData           PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, STRING value, *STRING errorMessage, *STRING errorCode),LONG
RemoveMetaData        PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode),LONG
                    END
!-------------------------------------------------------------
TestFnPtr           PROCEDURE(LONG fnPtr, STRING functionName, BOOL displayMessage, <*STRING errMessage>)
errorDetails          STRING(50)
  CODE
  IF fnPtr = 0
    errorDetails = functionName & ' was not found in ClaRunExt.DLL'
    IF NOT OMITTED(errMessage)
      errMessage = errorDetails
    END
    IF displayMessage
      MESSAGE(errorDetails)
    END
    RETURN FALSE
  END
  RETURN TRUE

!region ClaRunExtLibClass
!region Initialisation/Destruction
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

ClaRunExtLibClass.Init  PROCEDURE(BOOL displayMessage, <*STRING errMessage>)
errorText                     STRING('ClaRunExt.DLL Could not be found')
functionsExist                BOOL
  CODE
  IF NOT SELF.Inited
    SELF.hLib = ClaRunExt_LoadLibrary (ClaRunExtLibraryModuleName)
    IF SELF.hLib = 0
      IF NOT OMITTED(errMessage)
        errMessage = errorText
      END
      IF displayMessage
        MESSAGE(errorText)
      END
      RETURN FALSE
    END

    ! LONG Function pointer = GetProcAddress(ModuleHandle, CSTRING Function Name)
    ImageToPNG1_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG1_ClaRunExt_fn)
    functionsExist = TestFnPtr(ImageToPNG1_ClaRunExt_fp, 'ImageToPNG1', displayMessage, errMessage)
    ImageToPNG2_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG2_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ImageToPNG2_ClaRunExt_fp, 'ImageToPNG2', displayMessage, errMessage))
    ImageToPNG3_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG3_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ImageToPNG3_ClaRunExt_fp, 'ImageToPNG3', displayMessage, errMessage))
    ImageRotateFlip_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageRotateFlip_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ImageRotateFlip_ClaRunExt_fp, 'ImageRotateFlip', displayMessage, errMessage))
    ImageSaveThumbnail_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageSaveThumbnail_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ImageSaveThumbnail_ClaRunExt_fp, 'ImageSaveThumbnail', displayMessage, errMessage))
    ImageSaveThumbnailPix_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageSaveThumbnailPix_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ImageSaveThumbnailPix_ClaRunExt_fp, 'ImageSaveThumbnailPix', displayMessage, errMessage))
    SendSMS_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SendSMS_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(SendSMS_ClaRunExt_fp, 'SendSMS', displayMessage, errMessage))
    SendMail_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SendMail_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(SendMail_ClaRunExt_fp, 'SendMail', displayMessage, errMessage))
    HttpUploadFile_ClaRunExt_fp    = ClaRunExt_GetProcAddress (SELF.hLib, HttpUploadFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpUploadFile_ClaRunExt_fp, 'HttpUploadFile', displayMessage, errMessage))
    HttpUploadFilePW_ClaRunExt_fp    = ClaRunExt_GetProcAddress (SELF.hLib, HttpUploadFilePW_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpUploadFilePW_ClaRunExt_fp, 'HttpUploadFilePW', displayMessage, errMessage))
    HttpWebRequest_ClaRunExt_fp    = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequest_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequest_ClaRunExt_fp, 'HttpWebRequest', displayMessage, errMessage))
    HttpWebRequestExt_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequestExt_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequestExt_ClaRunExt_fp, 'HttpWebRequestExt', displayMessage, errMessage))
    HttpWebRequestExtPW_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequestExtPW_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequestExtPW_ClaRunExt_fp, 'HttpWebRequestExtPW', displayMessage, errMessage))
    HttpWebRequestToFile_ClaRunExt_fp    = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequestToFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequestToFile_ClaRunExt_fp, 'HttpWebRequestToFile', displayMessage, errMessage))
    HttpWebRequestToFileExt_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequestToFileExt_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequestToFileExt_ClaRunExt_fp, 'HttpWebRequestToFileExt', displayMessage, errMessage))
    HttpWebRequestToFileExtPW_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, HttpWebRequestToFileExtPW_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HttpWebRequestToFileExtPW_ClaRunExt_fp, 'HttpWebRequestToFileExtPW', displayMessage, errMessage))
    GetAWSRegion_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetAWSRegion_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetAWSRegion_ClaRunExt_fp, 'GetAWSRegion', displayMessage, errMessage))
    ConnectToS3_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ConnectToS3_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(ConnectToS3_ClaRunExt_fp, 'ConnectToS3', displayMessage, errMessage))
    DisconnectFromS3_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, DisconnectFromS3_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(DisconnectFromS3_ClaRunExt_fp, 'DisconnectFromS3', displayMessage, errMessage))
    GetContainer_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetContainer_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetContainer_ClaRunExt_fp, 'GetContainer', displayMessage, errMessage))
    CreateContainer_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, CreateContainer_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(CreateContainer_ClaRunExt_fp, 'CreateContainer', displayMessage, errMessage))
    DeleteContainer_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, DeleteContainer_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(DeleteContainer_ClaRunExt_fp, 'DeleteContainer', displayMessage, errMessage))
    GetNextFile_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetNextFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetNextFile_ClaRunExt_fp, 'GetNextFile', displayMessage, errMessage))
    CreateFolder_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, CreateFolder_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(CreateFolder_ClaRunExt_fp, 'CreateFolder', displayMessage, errMessage))
    DeleteFolder_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, DeleteFolder_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(DeleteFolder_ClaRunExt_fp, 'DeleteFolder', displayMessage, errMessage))
    UploadFile_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, UploadFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(UploadFile_ClaRunExt_fp, 'UploadFile', displayMessage, errMessage))
    DownloadFile_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, DownloadFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(DownloadFile_ClaRunExt_fp, 'DownloadFile', displayMessage, errMessage))
    DeleteFile_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, DeleteFile_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(DeleteFile_ClaRunExt_fp, 'DeleteFile', displayMessage, errMessage))
    FileExists_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, FileExists_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(FileExists_ClaRunExt_fp, 'FileExists', displayMessage, errMessage))
    CancelTransfer_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, CancelTransfer_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(CancelTransfer_ClaRunExt_fp, 'CancelTransfer', displayMessage, errMessage))
    GetTemporaryURL_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetTemporaryURL_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetTemporaryURL_ClaRunExt_fp, 'GetTemporaryURL', displayMessage, errMessage))
    GetPermanentURL_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetPermanentURL_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetPermanentURL_ClaRunExt_fp, 'GetPermanentURL', displayMessage, errMessage))
    AllowPublicAccess_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, AllowPublicAccess_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(AllowPublicAccess_ClaRunExt_fp, 'AllowPublicAccess', displayMessage, errMessage))
    HasPublicAccess_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, HasPublicAccess_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(HasPublicAccess_ClaRunExt_fp, 'HasPublicAccess', displayMessage, errMessage))
    GetNextMetaData_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetNextMetaData_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetNextMetaData_ClaRunExt_fp, 'GetNextMetaData', displayMessage, errMessage))
    GetMetaData_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, GetMetaData_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(GetMetaData_ClaRunExt_fp, 'GetMetaData', displayMessage, errMessage))
    SetAllMetaData_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SetAllMetaData_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(SetAllMetaData_ClaRunExt_fp, 'SetAllMetaData', displayMessage, errMessage))
    SetMetaData_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, SetMetaData_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(SetMetaData_ClaRunExt_fp, 'SetMetaData', displayMessage, errMessage))
    RemoveMetaData_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, RemoveMetaData_ClaRunExt_fn)
    functionsExist = CHOOSE(functionsExist AND TestFnPtr(RemoveMetaData_ClaRunExt_fp, 'RemoveMetaData', displayMessage, errMessage))

    IF NOT functionsExist
      SELF.Disconnect()
      RETURN FALSE
    END
    SELF.Inited = TRUE
  END
  RETURN TRUE

ClaRunExtLibClass.Use   PROCEDURE()
  CODE
  IF SELF.cs &= NULL
    SELF.cs &= NEW CriticalSection()
  END
  SELF.Users += 1

ClaRunExtLibClass.Kill  PROCEDURE()
disposeCs BOOL
  CODE
  IF SELF.Users
    SELF.cs.Wait()
    SELF.Users -= 1
    IF SELF.Users = 0
      SELF.Disconnect()
      disposeCs = TRUE
    END
    SELF.cs.Release()
    IF disposeCs
      DISPOSE(SELF.cs)
      SELF.cs &= NULL
    END
  END

ClaRunExtLibClass.Disconnect    PROCEDURE()
  CODE
  IF SELF.hLib <> 0
    ClaRunExt_FreeLibrary (SELF.hLib)
    SELF.hLib = 0
  END
!endregion
!region ClaRunExtLibClass function pointer calling methods
ClaRunExtLibClass.ImageToPNG    PROCEDURE(STRING fileNameIn)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageToPNG1_ClaRunExt (fileNameIn, LEN(fileNameIn))

ClaRunExtLibClass.ImageToPNG    PROCEDURE(STRING fileNameIn, STRING fileNameOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageToPNG2_ClaRunExt (fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut))

ClaRunExtLibClass.ImageToPNG    PROCEDURE(STRING fileNameIn, STRING fileNameOut, USHORT imageRes)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageToPNG3_ClaRunExt (fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), imageRes)

ClaRunExtLibClass.ImageRotateFlip   PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageRotateFlip_ClaRunExt (fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), RotateFlipType)

ClaRunExtLibClass.ImageSaveThumbnail    PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG percentage)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageSaveThumbnail_ClaRunExt(fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), percentage)

ClaRunExtLibClass.ImageSaveThumbnailPix  PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG pixelsWidth)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN ImageSaveThumbnailPix_ClaRunExt(fileNameIn, LEN(fileNameIn), fileNameOut, LEN(fileNameOut), pixelsWidth)

ClaRunExtLibClass.SendSMS   PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage, <*STRING errMessage>)
errMsgLen LONG
  CODE
  IF NOT SELF.Init(showErrorMessage, errMessage)
    RETURN 3
	END
	IF NOT OMITTED(errMessage)
		errMsgLen = LEN(errMessage)
	END
  RETURN SendSMS_ClaRunExt (SMTPServerHost, LEN(SMTPServerHost), SMTPLoginUserName, LEN(SMTPLoginUserName), SMTPLoginPassword, LEN(SMTPLoginPassword), |
    SMTPPort, SMTPEnableSsl, SMTPForceCertCheck, showErrorMessage, fromAddress, LEN(fromAddress), toPhoneNumber, LEN(toPhoneNumber), toCarrier, LEN(toCarrier), subject, |
    LEN(subject), textMessage, LEN(textMessage), errMessage, errMsgLen)

ClaRunExtLibClass.SendMail  PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList, <*STRING errMessage>)
errMsgLen LONG
  CODE
  IF NOT SELF.Init(showErrorMessage, errMessage)
    RETURN 3
  END
  IF NOT OMITTED(errMessage)
    errMsgLen = LEN(errMessage)
  END
  RETURN SendMail_ClaRunExt (SMTPServerHost, LEN(SMTPServerHost), SMTPLoginUserName, LEN(SMTPLoginUserName), SMTPLoginPassword, LEN(SMTPLoginPassword), |
    SMTPPort, SMTPEnableSsl, SMTPForceCertCheck, showErrorMessage, receiveRequest, messageBodyEncoding, LEN(messageBodyEncoding), fromAddress, LEN(fromAddress), toAddress, |
    LEN(toAddress), replyToAddress, LEN(replyToAddress), subject, LEN(subject), htmlMessage, LEN(htmlMessage), embeddedImageFileNames, LEN(embeddedImageFileNames), |
    textMessage, LEN(textMessage), attachedFileNames, LEN(attachedFileNames), ccList, LEN(ccList), bccList, LEN(bccList), errMessage, errMsgLen)

ClaRunExtLibClass.HttpUploadFile    PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters, CONST *CSTRING extraHeaders, *CSTRING responseOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpUploadFile_ClaRunExt (httpWebAddress,uploadFileName,fileNameParameterName,contentType,otherParameters,extraHeaders,responseOut)

ClaRunExtLibClass.HttpUploadFile    PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters, CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING extraHeaders, *CSTRING responseOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpUploadFilePW_ClaRunExt (httpWebAddress,uploadFileName,fileNameParameterName,contentType,otherParameters,basicUserName,basicPassword,extraHeaders,responseOut)

ClaRunExtLibClass.HttpWebRequest    PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING responseOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequest_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,responseOut)

ClaRunExtLibClass.HttpWebRequest    PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING responseOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequestExt_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,contentType, headers,responseOut)

ClaRunExtLibClass.HttpWebRequest    PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName, CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING responseOut)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequestExtPW_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,contentType,basicUserName,basicPassword,headers,responseOut)

ClaRunExtLibClass.HttpWebRequestToFile      PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING errorOut, CONST *CSTRING outputFilename)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequestToFile_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,errorOut, outputFilename)

ClaRunExtLibClass.HttpWebRequestToFile      PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequestToFileExt_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,contentType, headers,errorOut, outputFilename)

ClaRunExtLibClass.HttpWebRequestToFile      PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING basicUserName, CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN FALSE
  END
  RETURN HttpWebRequestToFileExtPW_ClaRunExt (requestEndpoint,httpVerbMethod,postData,requestParameters,contentType,basicUserName,basicPassword,headers,errorOut, outputFilename)

ClaRunExtLibClass.GetAWSRegion      PROCEDURE(*STRING displayName, *STRING systemName, <*STRING errorMessage>, <*STRING errorCode>)
errMsgLen                         LONG
errCodeLen                        LONG
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN FALSE
  END
  IF NOT OMITTED(errorMessage)
    errMsgLen = LEN(errorMessage)
  END
  IF NOT OMITTED(errorCode)
    errCodeLen = LEN(errorCode)
  END
  RETURN GetAWSRegion_ClaRunExt (displayName, LEN(displayName), systemName, LEN(systemName), errorMessage, errMsgLen, errorCode, errCodeLen)

ClaRunExtLibClass.ConnectToS3  PROCEDURE(STRING AccessKey, STRING SecretKey, <*STRING ErrorMessage>, <*STRING errorCode>)
errMsgLen                         LONG
errCodeLen                        LONG
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 0
  END
  IF NOT OMITTED(errorMessage)
    errMsgLen = LEN(errorMessage)
  END
  IF NOT OMITTED(errorCode)
    errCodeLen = LEN(errorCode)
  END
  RETURN ConnectToS3_ClaRunExt (AccessKey, LEN(AccessKey), SecretKey, LEN(SecretKey), errorMessage, errMsgLen, errorCode, errCodeLen)
ClaRunExtLibClass.DisconnectFromS3    PROCEDURE(LONG service)
  CODE
  IF NOT SELF.Init(TRUE)
    RETURN
  END
  DisconnectFromS3_ClaRunExt (service)
ClaRunExtLibClass.GetContainer  PROCEDURE(LONG ptr, *STRING containerName, *STRING regionDisplayName, *STRING regionSystemName, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN FALSE
  END
  RETURN GetContainer_ClaRunExt (ptr, containerName, LEN(containerName), regionDisplayName, LEN(regionDisplayName), regionSystemName, LEN(regionSystemName), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.CreateContainer  PROCEDURE(LONG ptr, STRING containerName, STRING region, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN CreateContainer_ClaRunExt (ptr, containerName, LEN(containerName), region, LEN(region), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.DeleteContainer  PROCEDURE(LONG ptr, STRING containerName, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN DeleteContainer_ClaRunExt (ptr, containerName, LEN(containerName), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.GetNextFile   PROCEDURE(LONG ptr, STRING containerName, STRING parentFolder, *STRING fileName, *BOOL isFile, *DATE lmDate, *TIME lmTime, *INT64 size, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN FALSE
  END
  RETURN GetNextFile_ClaRunExt (ptr, containerName, LEN(containerName), parentFolder, LEN(parentFolder), fileName, LEN(fileName), isFile, lmDate, lmTime, size.lo, size.hi, errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.CreateFolder   PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN CreateFolder_ClaRunExt (ptr, containerName, LEN(containerName), folder, LEN(folder), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.DeleteFolder   PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN DeleteFolder_ClaRunExt (ptr, containerName, LEN(containerName), folder, LEN(folder), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.UploadFile   PROCEDURE(LONG ptr, STRING sourceFile, STRING containerName, STRING destinationFile, BOOL asynchronous, BOOL encrypted, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN UploadFile_ClaRunExt (ptr, sourceFile, LEN(sourceFile), containerName, LEN(containerName), destinationFile, LEN(destinationFile), asynchronous, encrypted, callback, errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.DownloadFile  PROCEDURE(LONG ptr, STRING containerName, STRING sourceFile, STRING destinationFile, BOOL asynchronous, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN DownloadFile_ClaRunExt (ptr, containerName, LEN(containerName), sourceFile, LEN(sourceFile), destinationFile, LEN(destinationFile), asynchronous, callback, errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.DeleteFile    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN DeleteFile_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.FileExists    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN FALSE
  END
  RETURN FileExists_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.CancelTransfer    PROCEDURE(LONG ptr, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN CancelTransfer_ClaRunExt(ptr, errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.GetTemporaryURL   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, LONG days, LONG hours, LONG minutes, *STRING errorMessage, *STRING errorCode)
ret                                   STRING(1000)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN ''
  END
  GetTemporaryURL_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), days, hours, minutes, ret, LEN(ret), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
  RETURN ret
ClaRunExtLibClass.GetPermanentURL   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
ret                                   STRING(1000)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN ''
  END
  GetPermanentURL_ClaRunExt(ptr, containerName, LEN(containerName), fileName, LEN(fileName), ret, LEN(ret), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
  RETURN ret
ClaRunExtLibClass.AllowPublicAccess PROCEDURE(LONG ptr, STRING containerName, STRING fileName, BOOL public, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN AllowPublicAccess_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), public, errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.HasPublicAccess PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN FALSE
  END
  RETURN HasPublicAccess_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.GetNextMetaData    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING key, *STRING value, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN GetNextMetaData_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), key, LEN(key), value, LEN(value), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.GetMetaData   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode)
ret                               STRING(1000)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN ''
  END
  GetMetaData_ClaRunExt(ptr, containerName, LEN(containerName), fileName, LEN(fileName), key, LEN(key), ret, LEN(ret), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
  RETURN ret
ClaRunExtLibClass.SetMetaData   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING metaData, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN SetAllMetaData_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), metaData, LEN(metaData), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.SetMetaData   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, STRING value, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN SetMetaData_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), key, LEN(key), value, LEN(value), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
ClaRunExtLibClass.RemoveMetaData    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode)
  CODE
  IF NOT SELF.Init(FALSE, errorMessage)
    RETURN 3
  END
  RETURN RemoveMetaData_ClaRunExt (ptr, containerName, LEN(containerName), fileName, LEN(fileName), key, LEN(key), errorMessage, LEN(errorMessage), errorCode, LEN(errorCode))
!endregion
!endregion
!region ClaRunExtClass
ClaRunExtClass.Construct    PROCEDURE()
  CODE
  ClaRunExtLibClass.Use()

ClaRunExtClass.Destruct PROCEDURE()
  CODE
  ClaRunExtLibClass.Kill()
!region Image Manipulation
ClaRunExtClass.ImageToPNG   PROCEDURE(STRING fileNameIn)
  CODE
  RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn)
ClaRunExtClass.ImageToPNG   PROCEDURE(STRING fileNameIn, STRING fileNameOut)
  CODE
  RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn, fileNameOut)
ClaRunExtClass.ImageToPNG   PROCEDURE(STRING fileNameIn, STRING fileNameOut, USHORT imageRes)
  CODE
  RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn, fileNameOut, imageRes)
ClaRunExtClass.ImageRotateFlip  PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG RotateFlipType)
  CODE
  RETURN ClaRunExtLibClass.ImageRotateFlip(fileNameIn, fileNameOut, RotateFlipType)
ClaRunExtClass.ImageSaveThumbnail   PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG percentage)
  CODE
  RETURN ClaRunExtLibClass.ImageSaveThumbnail(fileNameIn, fileNameOut, percentage)
ClaRunExtClass.ImageSaveThumbnailPix   PROCEDURE(STRING fileNameIn, STRING fileNameOut, LONG pixelsWidth)
  CODE
  RETURN ClaRunExtLibClass.ImageSaveThumbnailPix(fileNameIn, fileNameOut, pixelsWidth)
!endregion
!region Email/SMS
ClaRunExtClass.SendSMS  PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage, <*STRING errMessage>)
_lSMTPForceCertChek LONG(1)
  CODE
  RETURN SELF.SendSMS(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, _lSMTPForceCertChek, showErrorMessage, fromAddress, toPhoneNumber, toCarrier, subject, textMessage, errMessage)
ClaRunExtClass.SendSMS  PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, STRING  fromAddress, STRING  toPhoneNumber, STRING  toCarrier, STRING  subject, STRING  textMessage, <*STRING errMessage>)
  CODE
  RETURN ClaRunExtLibClass.SendSMS(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, SMTPForceCertCheck, showErrorMessage, fromAddress, toPhoneNumber, toCarrier, subject, textMessage, errMessage)
ClaRunExtClass.SendMail PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList, <*STRING errMessage>)
_lSMTPForceCertChek LONG(1)
  CODE
  RETURN ClaRunExtLibClass.SendMail(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, _lSMTPForceCertChek, showErrorMessage, receiveRequest, messageBodyEncoding, fromAddress, toAddress, replyToAddress, subject, htmlMessage, embeddedImageFileNames, textMessage, attachedFileNames, ccList, bccList, errMessage)
ClaRunExtClass.SendMail PROCEDURE(STRING SMTPServerHost, STRING SMTPLoginUserName, STRING SMTPLoginPassword, LONG SMTPPort, LONG SMTPEnableSsl, LONG SMTPForceCertCheck, LONG showErrorMessage, LONG receiveRequest, STRING messageBodyEncoding, STRING fromAddress, STRING toAddress, STRING replyToAddress, STRING subject, STRING htmlMessage, STRING embeddedImageFileNames, STRING textMessage, STRING attachedFileNames, STRING ccList, STRING bccList, <*STRING errMessage>)
  CODE
  RETURN ClaRunExtLibClass.SendMail(SMTPServerHost, SMTPLoginUserName, SMTPLoginPassword, SMTPPort, SMTPEnableSsl, SMTPForceCertCheck, showErrorMessage, receiveRequest, messageBodyEncoding, fromAddress, toAddress, replyToAddress, subject, htmlMessage, embeddedImageFileNames, textMessage, attachedFileNames, ccList, bccList, errMessage)
!endregion
!region WebRequest
ClaRunExtClass.GetMimeTypeFromFile    PROCEDURE(STRING fileName)
retVal    SIGNED
LFileName CSTRING(FILE:MaxFilePath+1),AUTO
LExt      CSTRING(128),AUTO
 CODE
    LFileName = fileName
    LExt = ''
    retVal  = MIMEEXT_PathSplit(LFileName,,,, LExt)
    IF retVal
       RETURN SELF.GetMimeType(LExt)
    ELSE
       RETURN ''
    END
!!!base on information from:
!!!https://github.com/samuelneff/MimeTypeMap
ClaRunExtClass.GetMimeType            PROCEDURE(STRING fileExtension)
 CODE
     IF CLIP(fileExtension) =''
        RETURN ''
     END
     IF fileExtension[1]<>'.'
        fileExtension = '.'&fileExtension
     END
     CASE fileExtension
     OF '.323'; RETURN 'text/h323'
     OF '.3g2'; RETURN 'video/3gpp2'
     OF '.3gp'; RETURN 'video/3gpp'
     OF '.3gp2'; RETURN 'video/3gpp2'
     OF '.3gpp'; RETURN 'video/3gpp'
     OF '.7z'; RETURN 'application/x-7z-compressed'
     OF '.aa'; RETURN 'audio/audible'
     OF '.AAC'; RETURN 'audio/aac'
     OF '.aaf'; RETURN 'application/octet-stream'
     OF '.aax'; RETURN 'audio/vnd.audible.aax'
     OF '.ac3'; RETURN 'audio/ac3'
     OF '.aca'; RETURN 'application/octet-stream'
     OF '.accda'; RETURN 'application/msaccess.addin'
     OF '.accdb'; RETURN 'application/msaccess'
     OF '.accdc'; RETURN 'application/msaccess.cab'
     OF '.accde'; RETURN 'application/msaccess'
     OF '.accdr'; RETURN 'application/msaccess.runtime'
     OF '.accdt'; RETURN 'application/msaccess'
     OF '.accdw'; RETURN 'application/msaccess.webapplication'
     OF '.accft'; RETURN 'application/msaccess.ftemplate'
     OF '.acx'; RETURN 'application/internet-property-stream'
     OF '.AddIn'; RETURN 'text/xml'
     OF '.ade'; RETURN 'application/msaccess'
     OF '.adobebridge'; RETURN 'application/x-bridge-url'
     OF '.adp'; RETURN 'application/msaccess'
     OF '.ADT'; RETURN 'audio/vnd.dlna.adts'
     OF '.ADTS'; RETURN 'audio/aac'
     OF '.afm'; RETURN 'application/octet-stream'
     OF '.ai'; RETURN 'application/postscript'
     OF '.aif'; RETURN 'audio/x-aiff'
     OF '.aifc'; RETURN 'audio/aiff'
     OF '.aiff'; RETURN 'audio/aiff'
     OF '.air'; RETURN 'application/vnd.adobe.air-application-installer-package+zip'
     OF '.amc'; RETURN 'application/x-mpeg'
     OF '.application'; RETURN 'application/x-ms-application'
     OF '.art'; RETURN 'image/x-jg'
     OF '.asa'; RETURN 'application/xml'
     OF '.asax'; RETURN 'application/xml'
     OF '.ascx'; RETURN 'application/xml'
     OF '.asd'; RETURN 'application/octet-stream'
     OF '.asf'; RETURN 'video/x-ms-asf'
     OF '.ashx'; RETURN 'application/xml'
     OF '.asi'; RETURN 'application/octet-stream'
     OF '.asm'; RETURN 'text/plain'
     OF '.asmx'; RETURN 'application/xml'
     OF '.aspx'; RETURN 'application/xml'
     OF '.asr'; RETURN 'video/x-ms-asf'
     OF '.asx'; RETURN 'video/x-ms-asf'
     OF '.atom'; RETURN 'application/atom+xml'
     OF '.au'; RETURN 'audio/basic'
     OF '.avi'; RETURN 'video/x-msvideo'
     OF '.axs'; RETURN 'application/olescript'
     OF '.bas'; RETURN 'text/plain'
     OF '.bcpio'; RETURN 'application/x-bcpio'
     OF '.bin'; RETURN 'application/octet-stream'
     OF '.bmp'; RETURN 'image/bmp'
     OF '.c'; RETURN 'text/plain'
     OF '.cab'; RETURN 'application/octet-stream'
     OF '.caf'; RETURN 'audio/x-caf'
     OF '.calx'; RETURN 'application/vnd.ms-office.calx'
     OF '.cat'; RETURN 'application/vnd.ms-pki.seccat'
     OF '.cc'; RETURN 'text/plain'
     OF '.cd'; RETURN 'text/plain'
     OF '.cdda'; RETURN 'audio/aiff'
     OF '.cdf'; RETURN 'application/x-cdf'
     OF '.cer'; RETURN 'application/x-x509-ca-cert'
     OF '.chm'; RETURN 'application/octet-stream'
     OF '.class'; RETURN 'application/x-java-applet'
     OF '.clp'; RETURN 'application/x-msclip'
     OF '.cmx'; RETURN 'image/x-cmx'
     OF '.cnf'; RETURN 'text/plain'
     OF '.cod'; RETURN 'image/cis-cod'
     OF '.config'; RETURN 'application/xml'
     OF '.contact'; RETURN 'text/x-ms-contact'
     OF '.coverage'; RETURN 'application/xml'
     OF '.cpio'; RETURN 'application/x-cpio'
     OF '.cpp'; RETURN 'text/plain'
     OF '.crd'; RETURN 'application/x-mscardfile'
     OF '.crl'; RETURN 'application/pkix-crl'
     OF '.crt'; RETURN 'application/x-x509-ca-cert'
     OF '.cs'; RETURN 'text/plain'
     OF '.csdproj'; RETURN 'text/plain'
     OF '.csh'; RETURN 'application/x-csh'
     OF '.csproj'; RETURN 'text/plain'
     OF '.css'; RETURN 'text/css'
     OF '.csv'; RETURN 'text/csv'
     OF '.cur'; RETURN 'application/octet-stream'
     OF '.cxx'; RETURN 'text/plain'
     OF '.dat'; RETURN 'application/octet-stream'
     OF '.datasource'; RETURN 'application/xml'
     OF '.dbproj'; RETURN 'text/plain'
     OF '.dcr'; RETURN 'application/x-director'
     OF '.def'; RETURN 'text/plain'
     OF '.deploy'; RETURN 'application/octet-stream'
     OF '.der'; RETURN 'application/x-x509-ca-cert'
     OF '.dgml'; RETURN 'application/xml'
     OF '.dib'; RETURN 'image/bmp'
     OF '.dif'; RETURN 'video/x-dv'
     OF '.dir'; RETURN 'application/x-director'
     OF '.disco'; RETURN 'text/xml'
     OF '.divx'; RETURN 'video/divx'
     OF '.dll'; RETURN 'application/x-msdownload'
     OF '.dll.config'; RETURN 'text/xml'
     OF '.dlm'; RETURN 'text/dlm'
     OF '.doc'; RETURN 'application/msword'
     OF '.docm'; RETURN 'application/vnd.ms-word.document.macroEnabled.12'
     OF '.docx'; RETURN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
     OF '.dot'; RETURN 'application/msword'
     OF '.dotm'; RETURN 'application/vnd.ms-word.template.macroEnabled.12'
     OF '.dotx'; RETURN 'application/vnd.openxmlformats-officedocument.wordprocessingml.template'
     OF '.dsp'; RETURN 'application/octet-stream'
     OF '.dsw'; RETURN 'text/plain'
     OF '.dtd'; RETURN 'text/xml'
     OF '.dtsConfig'; RETURN 'text/xml'
     OF '.dv'; RETURN 'video/x-dv'
     OF '.dvi'; RETURN 'application/x-dvi'
     OF '.dwf'; RETURN 'drawing/x-dwf'
     OF '.dwp'; RETURN 'application/octet-stream'
     OF '.dxr'; RETURN 'application/x-director'
     OF '.eml'; RETURN 'message/rfc822'
     OF '.emz'; RETURN 'application/octet-stream'
     OF '.eot'; RETURN 'application/octet-stream'
     OF '.eps'; RETURN 'application/postscript'
     OF '.etl'; RETURN 'application/etl'
     OF '.etx'; RETURN 'text/x-setext'
     OF '.evy'; RETURN 'application/envoy'
     OF '.exe'; RETURN 'application/octet-stream'
     OF '.exe.config'; RETURN 'text/xml'
     OF '.fdf'; RETURN 'application/vnd.fdf'
     OF '.fif'; RETURN 'application/fractals'
     OF '.filters'; RETURN 'Application/xml'
     OF '.fla'; RETURN 'application/octet-stream'
     OF '.flr'; RETURN 'x-world/x-vrml'
     OF '.flv'; RETURN 'video/x-flv'
     OF '.fsscript'; RETURN 'application/fsharp-script'
     OF '.fsx'; RETURN 'application/fsharp-script'
     OF '.generictest'; RETURN 'application/xml'
     OF '.gif'; RETURN 'image/gif'
     OF '.group'; RETURN 'text/x-ms-group'
     OF '.gsm'; RETURN 'audio/x-gsm'
     OF '.gtar'; RETURN 'application/x-gtar'
     OF '.gz'; RETURN 'application/x-gzip'
     OF '.h'; RETURN 'text/plain'
     OF '.hdf'; RETURN 'application/x-hdf'
     OF '.hdml'; RETURN 'text/x-hdml'
     OF '.hhc'; RETURN 'application/x-oleobject'
     OF '.hhk'; RETURN 'application/octet-stream'
     OF '.hhp'; RETURN 'application/octet-stream'
     OF '.hlp'; RETURN 'application/winhlp'
     OF '.hpp'; RETURN 'text/plain'
     OF '.hqx'; RETURN 'application/mac-binhex40'
     OF '.hta'; RETURN 'application/hta'
     OF '.htc'; RETURN 'text/x-component'
     OF '.htm'; RETURN 'text/html'
     OF '.html'; RETURN 'text/html'
     OF '.htt'; RETURN 'text/webviewhtml'
     OF '.hxa'; RETURN 'application/xml'
     OF '.hxc'; RETURN 'application/xml'
     OF '.hxd'; RETURN 'application/octet-stream'
     OF '.hxe'; RETURN 'application/xml'
     OF '.hxf'; RETURN 'application/xml'
     OF '.hxh'; RETURN 'application/octet-stream'
     OF '.hxi'; RETURN 'application/octet-stream'
     OF '.hxk'; RETURN 'application/xml'
     OF '.hxq'; RETURN 'application/octet-stream'
     OF '.hxr'; RETURN 'application/octet-stream'
     OF '.hxs'; RETURN 'application/octet-stream'
     OF '.hxt'; RETURN 'text/html'
     OF '.hxv'; RETURN 'application/xml'
     OF '.hxw'; RETURN 'application/octet-stream'
     OF '.hxx'; RETURN 'text/plain'
     OF '.i'; RETURN 'text/plain'
     OF '.ico'; RETURN 'image/x-icon'
     OF '.ics'; RETURN 'application/octet-stream'
     OF '.idl'; RETURN 'text/plain'
     OF '.ief'; RETURN 'image/ief'
     OF '.iii'; RETURN 'application/x-iphone'
     OF '.inc'; RETURN 'text/plain'
     OF '.inf'; RETURN 'application/octet-stream'
     OF '.inl'; RETURN 'text/plain'
     OF '.ins'; RETURN 'application/x-internet-signup'
     OF '.ipa'; RETURN 'application/x-itunes-ipa'
     OF '.ipg'; RETURN 'application/x-itunes-ipg'
     OF '.ipproj'; RETURN 'text/plain'
     OF '.ipsw'; RETURN 'application/x-itunes-ipsw'
     OF '.iqy'; RETURN 'text/x-ms-iqy'
     OF '.isp'; RETURN 'application/x-internet-signup'
     OF '.ite'; RETURN 'application/x-itunes-ite'
     OF '.itlp'; RETURN 'application/x-itunes-itlp'
     OF '.itms'; RETURN 'application/x-itunes-itms'
     OF '.itpc'; RETURN 'application/x-itunes-itpc'
     OF '.IVF'; RETURN 'video/x-ivf'
     OF '.jar'; RETURN 'application/java-archive'
     OF '.java'; RETURN 'application/octet-stream'
     OF '.jck'; RETURN 'application/liquidmotion'
     OF '.jcz'; RETURN 'application/liquidmotion'
     OF '.jfif'; RETURN 'image/pjpeg'
     OF '.jnlp'; RETURN 'application/x-java-jnlp-file'
     OF '.jpb'; RETURN 'application/octet-stream'
     OF '.jpe'; RETURN 'image/jpeg'
     OF '.jpeg'; RETURN 'image/jpeg'
     OF '.jpg'; RETURN 'image/jpeg'
     OF '.js'; RETURN 'application/x-javascript'
     OF '.json'; RETURN 'application/json'
     OF '.jsx'; RETURN 'text/jscript'
     OF '.jsxbin'; RETURN 'text/plain'
     OF '.latex'; RETURN 'application/x-latex'
     OF '.library-ms'; RETURN 'application/windows-library+xml'
     OF '.lit'; RETURN 'application/x-ms-reader'
     OF '.loadtest'; RETURN 'application/xml'
     OF '.lpk'; RETURN 'application/octet-stream'
     OF '.lsf'; RETURN 'video/x-la-asf'
     OF '.lst'; RETURN 'text/plain'
     OF '.lsx'; RETURN 'video/x-la-asf'
     OF '.lzh'; RETURN 'application/octet-stream'
     OF '.m13'; RETURN 'application/x-msmediaview'
     OF '.m14'; RETURN 'application/x-msmediaview'
     OF '.m1v'; RETURN 'video/mpeg'
     OF '.m2t'; RETURN 'video/vnd.dlna.mpeg-tts'
     OF '.m2ts'; RETURN 'video/vnd.dlna.mpeg-tts'
     OF '.m2v'; RETURN 'video/mpeg'
     OF '.m3u'; RETURN 'audio/x-mpegurl'
     OF '.m3u8'; RETURN 'audio/x-mpegurl'
     OF '.m4a'; RETURN 'audio/m4a'
     OF '.m4b'; RETURN 'audio/m4b'
     OF '.m4p'; RETURN 'audio/m4p'
     OF '.m4r'; RETURN 'audio/x-m4r'
     OF '.m4v'; RETURN 'video/x-m4v'
     OF '.mac'; RETURN 'image/x-macpaint'
     OF '.mak'; RETURN 'text/plain'
     OF '.man'; RETURN 'application/x-troff-man'
     OF '.manifest'; RETURN 'application/x-ms-manifest'
     OF '.map'; RETURN 'text/plain'
     OF '.master'; RETURN 'application/xml'
     OF '.mda'; RETURN 'application/msaccess'
     OF '.mdb'; RETURN 'application/x-msaccess'
     OF '.mde'; RETURN 'application/msaccess'
     OF '.mdp'; RETURN 'application/octet-stream'
     OF '.me'; RETURN 'application/x-troff-me'
     OF '.mfp'; RETURN 'application/x-shockwave-flash'
     OF '.mht'; RETURN 'message/rfc822'
     OF '.mhtml'; RETURN 'message/rfc822'
     OF '.mid'; RETURN 'audio/mid'
     OF '.midi'; RETURN 'audio/mid'
     OF '.mix'; RETURN 'application/octet-stream'
     OF '.mk'; RETURN 'text/plain'
     OF '.mmf'; RETURN 'application/x-smaf'
     OF '.mno'; RETURN 'text/xml'
     OF '.mny'; RETURN 'application/x-msmoney'
     OF '.mod'; RETURN 'video/mpeg'
     OF '.mov'; RETURN 'video/quicktime'
     OF '.movie'; RETURN 'video/x-sgi-movie'
     OF '.mp2'; RETURN 'video/mpeg'
     OF '.mp2v'; RETURN 'video/mpeg'
     OF '.mp3'; RETURN 'audio/mpeg'
     OF '.mp4'; RETURN 'video/mp4'
     OF '.mp4v'; RETURN 'video/mp4'
     OF '.mpa'; RETURN 'video/mpeg'
     OF '.mpe'; RETURN 'video/mpeg'
     OF '.mpeg'; RETURN 'video/mpeg'
     OF '.mpf'; RETURN 'application/vnd.ms-mediapackage'
     OF '.mpg'; RETURN 'video/mpeg'
     OF '.mpp'; RETURN 'application/vnd.ms-project'
     OF '.mpv2'; RETURN 'video/mpeg'
     OF '.mqv'; RETURN 'video/quicktime'
     OF '.ms'; RETURN 'application/x-troff-ms'
     OF '.msi'; RETURN 'application/octet-stream'
     OF '.mso'; RETURN 'application/octet-stream'
     OF '.mts'; RETURN 'video/vnd.dlna.mpeg-tts'
     OF '.mtx'; RETURN 'application/xml'
     OF '.mvb'; RETURN 'application/x-msmediaview'
     OF '.mvc'; RETURN 'application/x-miva-compiled'
     OF '.mxp'; RETURN 'application/x-mmxp'
     OF '.nc'; RETURN 'application/x-netcdf'
     OF '.nsc'; RETURN 'video/x-ms-asf'
     OF '.nws'; RETURN 'message/rfc822'
     OF '.ocx'; RETURN 'application/octet-stream'
     OF '.oda'; RETURN 'application/oda'
     OF '.odb'; RETURN 'application/vnd.oasis.opendocument.database'
     OF '.odc'; RETURN 'application/vnd.oasis.opendocument.chart'
     OF '.odf'; RETURN 'application/vnd.oasis.opendocument.formula'
     OF '.odg'; RETURN 'application/vnd.oasis.opendocument.graphics'
     OF '.odh'; RETURN 'text/plain'
     OF '.odi'; RETURN 'application/vnd.oasis.opendocument.image'
     OF '.odl'; RETURN 'text/plain'
     OF '.odm'; RETURN 'application/vnd.oasis.opendocument.text-master'
     OF '.odp'; RETURN 'application/vnd.oasis.opendocument.presentation'
     OF '.ods'; RETURN 'application/vnd.oasis.opendocument.spreadsheet'
     OF '.odt'; RETURN 'application/vnd.oasis.opendocument.text'
     OF '.ogv'; RETURN 'video/ogg'
     OF '.one'; RETURN 'application/onenote'
     OF '.onea'; RETURN 'application/onenote'
     OF '.onepkg'; RETURN 'application/onenote'
     OF '.onetmp'; RETURN 'application/onenote'
     OF '.onetoc'; RETURN 'application/onenote'
     OF '.onetoc2'; RETURN 'application/onenote'
     OF '.orderedtest'; RETURN 'application/xml'
     OF '.osdx'; RETURN 'application/opensearchdescription+xml'
     OF '.otg'; RETURN 'application/vnd.oasis.opendocument.graphics-template'
     OF '.oth'; RETURN 'application/vnd.oasis.opendocument.text-web'
     OF '.otp'; RETURN 'application/vnd.oasis.opendocument.presentation-template'
     OF '.ots'; RETURN 'application/vnd.oasis.opendocument.spreadsheet-template'
     OF '.ott'; RETURN 'application/vnd.oasis.opendocument.text-template'
     OF '.oxt'; RETURN 'application/vnd.openofficeorg.extension'
     OF '.p10'; RETURN 'application/pkcs10'
     OF '.p12'; RETURN 'application/x-pkcs12'
     OF '.p7b'; RETURN 'application/x-pkcs7-certificates'
     OF '.p7c'; RETURN 'application/pkcs7-mime'
     OF '.p7m'; RETURN 'application/pkcs7-mime'
     OF '.p7r'; RETURN 'application/x-pkcs7-certreqresp'
     OF '.p7s'; RETURN 'application/pkcs7-signature'
     OF '.pbm'; RETURN 'image/x-portable-bitmap'
     OF '.pcast'; RETURN 'application/x-podcast'
     OF '.pct'; RETURN 'image/pict'
     OF '.pcx'; RETURN 'application/octet-stream'
     OF '.pcz'; RETURN 'application/octet-stream'
     OF '.pdf'; RETURN 'application/pdf'
     OF '.pfb'; RETURN 'application/octet-stream'
     OF '.pfm'; RETURN 'application/octet-stream'
     OF '.pfx'; RETURN 'application/x-pkcs12'
     OF '.pgm'; RETURN 'image/x-portable-graymap'
     OF '.pic'; RETURN 'image/pict'
     OF '.pict'; RETURN 'image/pict'
     OF '.pkgdef'; RETURN 'text/plain'
     OF '.pkgundef'; RETURN 'text/plain'
     OF '.pko'; RETURN 'application/vnd.ms-pki.pko'
     OF '.pls'; RETURN 'audio/scpls'
     OF '.pma'; RETURN 'application/x-perfmon'
     OF '.pmc'; RETURN 'application/x-perfmon'
     OF '.pml'; RETURN 'application/x-perfmon'
     OF '.pmr'; RETURN 'application/x-perfmon'
     OF '.pmw'; RETURN 'application/x-perfmon'
     OF '.png'; RETURN 'image/png'
     OF '.pnm'; RETURN 'image/x-portable-anymap'
     OF '.pnt'; RETURN 'image/x-macpaint'
     OF '.pntg'; RETURN 'image/x-macpaint'
     OF '.pnz'; RETURN 'image/png'
     OF '.pot'; RETURN 'application/vnd.ms-powerpoint'
     OF '.potm'; RETURN 'application/vnd.ms-powerpoint.template.macroEnabled.12'
     OF '.potx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.template'
     OF '.ppa'; RETURN 'application/vnd.ms-powerpoint'
     OF '.ppam'; RETURN 'application/vnd.ms-powerpoint.addin.macroEnabled.12'
     OF '.ppm'; RETURN 'image/x-portable-pixmap'
     OF '.pps'; RETURN 'application/vnd.ms-powerpoint'
     OF '.ppsm'; RETURN 'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
     OF '.ppsx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'
     OF '.ppt'; RETURN 'application/vnd.ms-powerpoint'
     OF '.pptm'; RETURN 'application/vnd.ms-powerpoint.presentation.macroEnabled.12'
     OF '.pptx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
     OF '.prf'; RETURN 'application/pics-rules'
     OF '.prm'; RETURN 'application/octet-stream'
     OF '.prx'; RETURN 'application/octet-stream'
     OF '.ps'; RETURN 'application/postscript'
     OF '.psc1'; RETURN 'application/PowerShell'
     OF '.psd'; RETURN 'application/octet-stream'
     OF '.psess'; RETURN 'application/xml'
     OF '.psm'; RETURN 'application/octet-stream'
     OF '.psp'; RETURN 'application/octet-stream'
     OF '.pub'; RETURN 'application/x-mspublisher'
     OF '.pwz'; RETURN 'application/vnd.ms-powerpoint'
     OF '.qht'; RETURN 'text/x-html-insertion'
     OF '.qhtm'; RETURN 'text/x-html-insertion'
     OF '.qt'; RETURN 'video/quicktime'
     OF '.qti'; RETURN 'image/x-quicktime'
     OF '.qtif'; RETURN 'image/x-quicktime'
     OF '.qtl'; RETURN 'application/x-quicktimeplayer'
     OF '.qxd'; RETURN 'application/octet-stream'
     OF '.ra'; RETURN 'audio/x-pn-realaudio'
     OF '.ram'; RETURN 'audio/x-pn-realaudio'
     OF '.rar'; RETURN 'application/octet-stream'
     OF '.ras'; RETURN 'image/x-cmu-raster'
     OF '.rat'; RETURN 'application/rat-file'
     OF '.rc'; RETURN 'text/plain'
     OF '.rc2'; RETURN 'text/plain'
     OF '.rct'; RETURN 'text/plain'
     OF '.rdlc'; RETURN 'application/xml'
     OF '.resx'; RETURN 'application/xml'
     OF '.rf'; RETURN 'image/vnd.rn-realflash'
     OF '.rgb'; RETURN 'image/x-rgb'
     OF '.rgs'; RETURN 'text/plain'
     OF '.rm'; RETURN 'application/vnd.rn-realmedia'
     OF '.rmi'; RETURN 'audio/mid'
     OF '.rmp'; RETURN 'application/vnd.rn-rn_music_package'
     OF '.roff'; RETURN 'application/x-troff'
     OF '.rpm'; RETURN 'audio/x-pn-realaudio-plugin'
     OF '.rqy'; RETURN 'text/x-ms-rqy'
     OF '.rtf'; RETURN 'application/rtf'
     OF '.rtx'; RETURN 'text/richtext'
     OF '.ruleset'; RETURN 'application/xml'
     OF '.s'; RETURN 'text/plain'
     OF '.safariextz'; RETURN 'application/x-safari-safariextz'
     OF '.scd'; RETURN 'application/x-msschedule'
     OF '.sct'; RETURN 'text/scriptlet'
     OF '.sd2'; RETURN 'audio/x-sd2'
     OF '.sdp'; RETURN 'application/sdp'
     OF '.sea'; RETURN 'application/octet-stream'
     OF '.searchConnector-ms'; RETURN 'application/windows-search-connector+xml'
     OF '.setpay'; RETURN 'application/set-payment-initiation'
     OF '.setreg'; RETURN 'application/set-registration-initiation'
     OF '.settings'; RETURN 'application/xml'
     OF '.sgimb'; RETURN 'application/x-sgimb'
     OF '.sgml'; RETURN 'text/sgml'
     OF '.sh'; RETURN 'application/x-sh'
     OF '.shar'; RETURN 'application/x-shar'
     OF '.shtml'; RETURN 'text/html'
     OF '.sit'; RETURN 'application/x-stuffit'
     OF '.sitemap'; RETURN 'application/xml'
     OF '.skin'; RETURN 'application/xml'
     OF '.sldm'; RETURN 'application/vnd.ms-powerpoint.slide.macroEnabled.12'
     OF '.sldx'; RETURN 'application/vnd.openxmlformats-officedocument.presentationml.slide'
     OF '.slk'; RETURN 'application/vnd.ms-excel'
     OF '.sln'; RETURN 'text/plain'
     OF '.slupkg-ms'; RETURN 'application/x-ms-license'
     OF '.smd'; RETURN 'audio/x-smd'
     OF '.smi'; RETURN 'application/octet-stream'
     OF '.smx'; RETURN 'audio/x-smd'
     OF '.smz'; RETURN 'audio/x-smd'
     OF '.snd'; RETURN 'audio/basic'
     OF '.snippet'; RETURN 'application/xml'
     OF '.snp'; RETURN 'application/octet-stream'
     OF '.sol'; RETURN 'text/plain'
     OF '.sor'; RETURN 'text/plain'
     OF '.spc'; RETURN 'application/x-pkcs7-certificates'
     OF '.spl'; RETURN 'application/futuresplash'
     OF '.src'; RETURN 'application/x-wais-source'
     OF '.srf'; RETURN 'text/plain'
     OF '.SSISDeploymentManifest'; RETURN 'text/xml'
     OF '.ssm'; RETURN 'application/streamingmedia'
     OF '.sst'; RETURN 'application/vnd.ms-pki.certstore'
     OF '.stl'; RETURN 'application/vnd.ms-pki.stl'
     OF '.sv4cpio'; RETURN 'application/x-sv4cpio'
     OF '.sv4crc'; RETURN 'application/x-sv4crc'
     OF '.svc'; RETURN 'application/xml'
     OF '.svg'; RETURN 'image/svg+xml'
     OF '.swf'; RETURN 'application/x-shockwave-flash'
     OF '.t'; RETURN 'application/x-troff'
     OF '.tar'; RETURN 'application/x-tar'
     OF '.tcl'; RETURN 'application/x-tcl'
     OF '.testrunconfig'; RETURN 'application/xml'
     OF '.testsettings'; RETURN 'application/xml'
     OF '.tex'; RETURN 'application/x-tex'
     OF '.texi'; RETURN 'application/x-texinfo'
     OF '.texinfo'; RETURN 'application/x-texinfo'
     OF '.tgz'; RETURN 'application/x-compressed'
     OF '.thmx'; RETURN 'application/vnd.ms-officetheme'
     OF '.thn'; RETURN 'application/octet-stream'
     OF '.tif'; RETURN 'image/tiff'
     OF '.tiff'; RETURN 'image/tiff'
     OF '.tlh'; RETURN 'text/plain'
     OF '.tli'; RETURN 'text/plain'
     OF '.toc'; RETURN 'application/octet-stream'
     OF '.tr'; RETURN 'application/x-troff'
     OF '.trm'; RETURN 'application/x-msterminal'
     OF '.trx'; RETURN 'application/xml'
     OF '.ts'; RETURN 'video/vnd.dlna.mpeg-tts'
     OF '.tsv'; RETURN 'text/tab-separated-values'
     OF '.ttf'; RETURN 'application/octet-stream'
     OF '.tts'; RETURN 'video/vnd.dlna.mpeg-tts'
     OF '.txt'; RETURN 'text/plain'
     OF '.u32'; RETURN 'application/octet-stream'
     OF '.uls'; RETURN 'text/iuls'
     OF '.user'; RETURN 'text/plain'
     OF '.ustar'; RETURN 'application/x-ustar'
     OF '.vb'; RETURN 'text/plain'
     OF '.vbdproj'; RETURN 'text/plain'
     OF '.vbk'; RETURN 'video/mpeg'
     OF '.vbproj'; RETURN 'text/plain'
     OF '.vbs'; RETURN 'text/vbscript'
     OF '.vcf'; RETURN 'text/x-vcard'
     OF '.vcproj'; RETURN 'Application/xml'
     OF '.vcs'; RETURN 'text/plain'
     OF '.vcxproj'; RETURN 'Application/xml'
     OF '.vddproj'; RETURN 'text/plain'
     OF '.vdp'; RETURN 'text/plain'
     OF '.vdproj'; RETURN 'text/plain'
     OF '.vdx'; RETURN 'application/vnd.ms-visio.viewer'
     OF '.vml'; RETURN 'text/xml'
     OF '.vscontent'; RETURN 'application/xml'
     OF '.vsct'; RETURN 'text/xml'
     OF '.vsd'; RETURN 'application/vnd.visio'
     OF '.vsi'; RETURN 'application/ms-vsi'
     OF '.vsix'; RETURN 'application/vsix'
     OF '.vsixlangpack'; RETURN 'text/xml'
     OF '.vsixmanifest'; RETURN 'text/xml'
     OF '.vsmdi'; RETURN 'application/xml'
     OF '.vspscc'; RETURN 'text/plain'
     OF '.vss'; RETURN 'application/vnd.visio'
     OF '.vsscc'; RETURN 'text/plain'
     OF '.vssettings'; RETURN 'text/xml'
     OF '.vssscc'; RETURN 'text/plain'
     OF '.vst'; RETURN 'application/vnd.visio'
     OF '.vstemplate'; RETURN 'text/xml'
     OF '.vsto'; RETURN 'application/x-ms-vsto'
     OF '.vsw'; RETURN 'application/vnd.visio'
     OF '.vsx'; RETURN 'application/vnd.visio'
     OF '.vtx'; RETURN 'application/vnd.visio'
     OF '.wav'; RETURN 'audio/wav'
     OF '.wave'; RETURN 'audio/wav'
     OF '.wax'; RETURN 'audio/x-ms-wax'
     OF '.wbk'; RETURN 'application/msword'
     OF '.wbmp'; RETURN 'image/vnd.wap.wbmp'
     OF '.wcm'; RETURN 'application/vnd.ms-works'
     OF '.wdb'; RETURN 'application/vnd.ms-works'
     OF '.wdp'; RETURN 'image/vnd.ms-photo'
     OF '.webarchive'; RETURN 'application/x-safari-webarchive'
     OF '.webm'; RETURN 'video/webm'
     OF '.webtest'; RETURN 'application/xml'
     OF '.wiq'; RETURN 'application/xml'
     OF '.wiz'; RETURN 'application/msword'
     OF '.wks'; RETURN 'application/vnd.ms-works'
     OF '.WLMP'; RETURN 'application/wlmoviemaker'
     OF '.wlpginstall'; RETURN 'application/x-wlpg-detect'
     OF '.wlpginstall3'; RETURN 'application/x-wlpg3-detect'
     OF '.wm'; RETURN 'video/x-ms-wm'
     OF '.wma'; RETURN 'audio/x-ms-wma'
     OF '.wmd'; RETURN 'application/x-ms-wmd'
     OF '.wmf'; RETURN 'application/x-msmetafile'
     OF '.wml'; RETURN 'text/vnd.wap.wml'
     OF '.wmlc'; RETURN 'application/vnd.wap.wmlc'
     OF '.wmls'; RETURN 'text/vnd.wap.wmlscript'
     OF '.wmlsc'; RETURN 'application/vnd.wap.wmlscriptc'
     OF '.wmp'; RETURN 'video/x-ms-wmp'
     OF '.wmv'; RETURN 'video/x-ms-wmv'
     OF '.wmx'; RETURN 'video/x-ms-wmx'
     OF '.wmz'; RETURN 'application/x-ms-wmz'
     OF '.wpl'; RETURN 'application/vnd.ms-wpl'
     OF '.wps'; RETURN 'application/vnd.ms-works'
     OF '.wri'; RETURN 'application/x-mswrite'
     OF '.wrl'; RETURN 'x-world/x-vrml'
     OF '.wrz'; RETURN 'x-world/x-vrml'
     OF '.wsc'; RETURN 'text/scriptlet'
     OF '.wsdl'; RETURN 'text/xml'
     OF '.wvx'; RETURN 'video/x-ms-wvx'
     OF '.x'; RETURN 'application/directx'
     OF '.xaf'; RETURN 'x-world/x-vrml'
     OF '.xaml'; RETURN 'application/xaml+xml'
     OF '.xap'; RETURN 'application/x-silverlight-app'
     OF '.xbap'; RETURN 'application/x-ms-xbap'
     OF '.xbm'; RETURN 'image/x-xbitmap'
     OF '.xdr'; RETURN 'text/plain'
     OF '.xht'; RETURN 'application/xhtml+xml'
     OF '.xhtml'; RETURN 'application/xhtml+xml'
     OF '.xla'; RETURN 'application/vnd.ms-excel'
     OF '.xlam'; RETURN 'application/vnd.ms-excel.addin.macroEnabled.12'
     OF '.xlc'; RETURN 'application/vnd.ms-excel'
     OF '.xld'; RETURN 'application/vnd.ms-excel'
     OF '.xlk'; RETURN 'application/vnd.ms-excel'
     OF '.xll'; RETURN 'application/vnd.ms-excel'
     OF '.xlm'; RETURN 'application/vnd.ms-excel'
     OF '.xls'; RETURN 'application/vnd.ms-excel'
     OF '.xlsb'; RETURN 'application/vnd.ms-excel.sheet.binary.macroEnabled.12'
     OF '.xlsm'; RETURN 'application/vnd.ms-excel.sheet.macroEnabled.12'
     OF '.xlsx'; RETURN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
     OF '.xlt'; RETURN 'application/vnd.ms-excel'
     OF '.xltm'; RETURN 'application/vnd.ms-excel.template.macroEnabled.12'
     OF '.xltx'; RETURN 'application/vnd.openxmlformats-officedocument.spreadsheetml.template'
     OF '.xlw'; RETURN 'application/vnd.ms-excel'
     OF '.xml'; RETURN 'text/xml'
     OF '.xmta'; RETURN 'application/xml'
     OF '.xof'; RETURN 'x-world/x-vrml'
     OF '.XOML'; RETURN 'text/plain'
     OF '.xpm'; RETURN 'image/x-xpixmap'
     OF '.xps'; RETURN 'application/vnd.ms-xpsdocument'
     OF '.xrm-ms'; RETURN 'text/xml'
     OF '.xsc'; RETURN 'application/xml'
     OF '.xsd'; RETURN 'text/xml'
     OF '.xsf'; RETURN 'text/xml'
     OF '.xsl'; RETURN 'text/xml'
     OF '.xslt'; RETURN 'text/xml'
     OF '.xsn'; RETURN 'application/octet-stream'
     OF '.xss'; RETURN 'application/xml'
     OF '.xtp'; RETURN 'application/octet-stream'
     OF '.xwd'; RETURN 'image/x-xwindowdump'
     OF '.z'; RETURN 'application/x-compress'
     OF '.zip'; RETURN 'application/x-zip-compressed'
     ELSE
         RETURN 'application/octet-stream'
     END

ClaRunExtClass.HttpUploadFile          PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters, CONST *CSTRING extraHeaders,*CSTRING responseOut)
lContentType CSTRING(256)
 CODE
 lContentType = contentType
 IF CLIP(lContentType) = ''
    lContentType = SELF.GetMimeType(uploadFileName)
 END
 RETURN ClaRunExtLibClass.HttpUploadFile(httpWebAddress,uploadFileName,fileNameParameterName,lContentType,otherParameters,extraHeaders,responseOut)

ClaRunExtClass.HttpUploadFile          PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType,CONST *CSTRING otherParameters,*CSTRING responseOut)
lExtraHeaders CSTRING(256)
 CODE
    lExtraHeaders = ''
    RETURN SELF.HttpUploadFile(httpWebAddress, uploadFileName, fileNameParameterName, contentType, otherParameters, lExtraHeaders, responseOut)

ClaRunExtClass.HttpUploadFile          PROCEDURE(CONST *CSTRING httpWebAddress,CONST *CSTRING uploadFileName,CONST *CSTRING fileNameParameterName,CONST *CSTRING contentType, CONST *CSTRING otherParameters,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING extraHeaders,*CSTRING responseOut)
lContentType CSTRING(256)
 CODE
 lContentType = contentType
 IF CLIP(lContentType) = ''
    lContentType = SELF.GetMimeType(uploadFileName)
 END
 RETURN ClaRunExtLibClass.HttpUploadFile(httpWebAddress,uploadFileName,fileNameParameterName,lContentType,otherParameters, basicUserName, basicPassword, extraHeaders,responseOut)

ClaRunExtClass.HttpWebRequest PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING responseOut)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequest(requestEndpoint, httpVerbMethod, postData, requestParameters, responseOut)

ClaRunExtClass.HttpWebRequest          PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING responseOut)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequest(requestEndpoint, httpVerbMethod, postData, requestParameters, contentType, headers, responseOut)

ClaRunExtClass.HttpWebRequest          PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING responseOut)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequest(requestEndpoint, httpVerbMethod, postData, requestParameters, contentType, basicUserName, basicPassword, headers, responseOut)

ClaRunExtClass.HttpWebRequestToFile    PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,*CSTRING errorOut, CONST *CSTRING outputFilename)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequestToFile(requestEndpoint, httpVerbMethod, postData, requestParameters, errorOut, outputFilename)

ClaRunExtClass.HttpWebRequestToFile PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType,CONST *CSTRING basicUserName,CONST *CSTRING basicPassword, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequestToFile(requestEndpoint, httpVerbMethod, postData, requestParameters, contentType, basicUserName, basicPassword, headers, errorOut, outputFilename)

ClaRunExtClass.HttpWebRequestToFile PROCEDURE(CONST *CSTRING requestEndpoint,LONG httpVerbMethod,CONST *CSTRING postData,CONST *CSTRING requestParameters,CONST *CSTRING contentType, CONST *CSTRING headers,*CSTRING errorOut, CONST *CSTRING outputFilename)
 CODE
 RETURN ClaRunExtLibClass.HttpWebRequestToFile(requestEndpoint, httpVerbMethod, postData, requestParameters, contentType, headers, errorOut, outputFilename)
!endregion
!region AWS Methods
ClaRunExtClass.GetAWSRegion PROCEDURE(*STRING displayName, *STRING systemName, <*STRING errorMessage>, <*STRING errorCode>)
  CODE
  RETURN ClaRunExtLibClass.GetAWSRegion(displayName, systemName, errorMessage, errorCode)
ClaRunExtClass.ConnectToS3 PROCEDURE(STRING AccessKey, STRING SecretKey, <*STRING ErrorMessage>, <*STRING errorCode>)
  CODE
  RETURN ClaRunExtLibClass.ConnectToS3(AccessKey, SecretKey, ErrorMessage, errorCode)
ClaRunExtClass.DisconnectFromS3    PROCEDURE(LONG service)
  CODE
  ClaRunExtLibClass.DisconnectFromS3(service)
ClaRunExtClass.GetContainer  PROCEDURE(LONG ptr, *STRING containerName, *STRING regionDisplayName, *STRING regionSystemName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetContainer (ptr, containerName, regionDisplayName, regionSystemName, errorMessage, errorCode)
ClaRunExtClass.CreateContainer PROCEDURE(LONG ptr, STRING containerName, STRING region, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.CreateContainer (ptr, containerName, region, errorMessage, errorCode)
ClaRunExtClass.DeleteContainer PROCEDURE(LONG ptr, STRING containerName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.DeleteContainer (ptr, containerName, errorMessage, errorCode)
ClaRunExtClass.CreateFolder PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.CreateFolder (ptr, containerName, folder, errorMessage, errorCode)
ClaRunExtClass.DeleteFolder  PROCEDURE(LONG ptr, STRING containerName, STRING folder, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.DeleteFolder (ptr, containerName, folder, errorMessage, errorCode)
ClaRunExtClass.GetNextFile  PROCEDURE(LONG ptr, STRING containerName, STRING parentFolder, *STRING fileName, *BOOL isFile, *DATE lmDate, *TIME lmTime, *INT64 size, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetNextFile(ptr, containerName, parentFolder, fileName, isFile, lmDate, lmTime, size, errorMessage, errorCode)
ClaRunExtClass.UploadFile   PROCEDURE(LONG ptr, STRING sourceFile, STRING containerName, STRING destinationFile, BOOL asynchronous, BOOL encrypted, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.UploadFile(ptr, sourceFile, containerName, destinationFile, asynchronous, encrypted, callback, errorMessage, errorCode)
ClaRunExtClass.DownloadFile PROCEDURE(LONG ptr, STRING containerName, STRING sourceFile, STRING destinationFile, BOOL asynchronous, IAWSTransfering callback, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.DownloadFile(ptr, containerName, sourceFile, destinationFile, asynchronous, callback, errorMessage, errorCode)
ClaRunExtClass.DeleteFile   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.DeleteFile(ptr, containerName, fileName, errorMessage, errorCode)
ClaRunExtClass.FileExists   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.FileExists(ptr, containerName, fileName, errorMessage, errorCode)
ClaRunExtClass.CancelTransfer   PROCEDURE(LONG ptr, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.CancelTransfer(ptr, errorMessage, errorCode)
ClaRunExtClass.GetTemporaryURL  PROCEDURE(LONG ptr, STRING containerName, STRING fileName, LONG days, LONG hours, LONG minutes, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetTemporaryURL(ptr, containerName, fileName, days, hours, minutes, errorMessage, errorCode)
ClaRunExtClass.GetPermanentURL  PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetPermanentURL(ptr, containerName, fileName, errorMessage, errorCode)
ClaRunExtClass.AllowPublicAccess    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, BOOL public, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.AllowPublicAccess(ptr, containerName, fileName, public, errorMessage, errorCode)
ClaRunExtClass.HasPublicAccess    PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.HasPublicAccess(ptr, containerName, fileName, errorMessage, errorCode)
ClaRunExtClass.GetNextMetaData   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, *STRING key, *STRING value, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetNextMetaData(ptr, containerName, fileName, key, value, errorMessage, errorCode)
ClaRunExtClass.GetMetaData  PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.GetMetaData(ptr, containerName, fileName, key, errorMessage, errorCode)
ClaRunExtClass.SetMetaData  PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING metaData, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.SetMetaData(ptr, containerName, fileName, metaData, errorMessage, errorCode)
ClaRunExtClass.SetMetaData  PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, STRING value, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.SetMetaData(ptr, containerName, fileName, key, value, errorMessage, errorCode)
ClaRunExtClass.RemoveMetaData   PROCEDURE(LONG ptr, STRING containerName, STRING fileName, STRING key, *STRING errorMessage, *STRING errorCode)
  CODE
  RETURN ClaRunExtLibClass.RemoveMetaData(ptr, containerName, fileName, key, errorMessage, errorCode)
!endregion
!endregion
