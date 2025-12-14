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
    ImageToPNG1_ClaRunExt (CONST *CSTRING fileNameIn),LONG,C,DLL(1)!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
    ImageToPNG2_ClaRunExt (CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut),LONG,C,DLL(1)!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
    ImageRotateFlip_ClaRunExt (CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG RotateFlipType),LONG,C,DLL(1)!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
    ImageSaveThumbnail_ClaRunExt (CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG percentage),LONG,C,DLL(1)!Save image reduced in size. Return 0 if no error and Error Number if there is an error
   END
  END

!Note:
!To add more functions supported in ClaRunExt.DLL:
!1) Add the new function to the MODULE('ClaRunExtDLL') in the MAP
!2) Add new LONG with the External Name with the exactly same name as the function on the map
!3) Add a new CSTRING with the function name from Libmaker as PRIVATE
!4) Add a Method to the ClaRunExtLibClass for that new function
!5) Add a Method to the ClaRunExtClass for that new function
!6) Add the code to the ClaRunExtLibClass.DoInit method to assing the LONG variable created on step 2 using the value of the CSTRING created on step 3
!7) Add a new line to the verification in the ClaRunExtLibClass.DoInit using the LONG variable created on step 2
!8) Create a method on ClaRunExtLibClass with the name of the function that does the Init verification and the call to the Function declared in the MAP
!9) Create a method on ClaRunExtClass that calls the method to the ClaRunExtLibClass 

!Class Static Data

ImageToPNG1_ClaRunExt_fp        LONG,NAME('ImageToPNG1_ClaRunExt')
ImageToPNG2_ClaRunExt_fp        LONG,NAME('ImageToPNG2_ClaRunExt')
ImageRotateFlip_ClaRunExt_fp    LONG,NAME('ImageRotateFlip_ClaRunExt')
ImageSaveThumbnail_ClaRunExt_fp LONG,NAME('ImageSaveThumbnail_ClaRunExt')

ClaRunExtLibraryModuleName      CSTRING('ClaRunExt.DLL'),PRIVATE
ImageToPNG1_ClaRunExt_fn        CSTRING('?ImageToPNG1@@YAJPBD@Z'),PRIVATE
ImageToPNG2_ClaRunExt_fn        CSTRING('?ImageToPNG2@@YAJPBD0@Z'),PRIVATE
ImageRotateFlip_ClaRunExt_fn    CSTRING('?RotateFlip@@YAJPBD0J@Z'),PRIVATE
ImageSaveThumbnail_ClaRunExt_fn CSTRING('?SaveThumbnail@@YAJPBD0J@Z'),PRIVATE

!-------------------------------------------------------------
!This class is used to keep one instance of the ClaRunExt.DLL Library per application
!
ClaRunExtLibClass    CLASS,PRIVATE
hLib                    UNSIGNED,PROTECTED
Users                   UNSIGNED,PROTECTED
Inited                  BYTE,PROTECTED

Construct               PROCEDURE()
Destruct                PROCEDURE(),PROTECTED

Init                    PROCEDURE(),BYTE
DoInit                  PROCEDURE(),BYTE,PROTECTED
Kill                    PROCEDURE()
IsInited                PROCEDURE(),BYTE
ImageToPNG              PROCEDURE(CONST *CSTRING fileNameIn),LONG!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
ImageToPNG              PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut),LONG!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
ImageRotateFlip         PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG RotateFlipType),LONG!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
ImageSaveThumbnail      PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG porcentage),LONG!Save image reduced in size. Return 0 if no error and Error Number if there is an error
                     END
!-------------------------------------------------------------

!region ClaRunExtLibClass
ClaRunExtLibClass.Construct PROCEDURE()
  CODE
  SELF.hLib   = 0
  SELF.Users  = 0
  SELF.Inited = FALSE
  RETURN

ClaRunExtLibClass.Destruct PROCEDURE()
  CODE
  SELF.Kill()
  RETURN
        
ClaRunExtLibClass.Init PROCEDURE()
  CODE
  IF NOT SELF.IsInited()       
    IF NOT SELF.DoInit()
      RETURN FALSE
    END
    SELF.Inited = TRUE
  END
  RETURN TRUE
        
ClaRunExtLibClass.DoInit PROCEDURE()
  CODE
  IF SELF.hLib <> 0
    SELF.Users += 1
  ELSE
    SELF.hLib = ClaRunExt_LoadLibrary (ClaRunExtLibraryModuleName)
    IF SELF.hLib = 0
      RETURN FALSE
    END
    
    SELF.Users += 1

    ! LONG Function pointer = GetProcAddress(ModuleHandle, CSTRING Function Name)
    ImageToPNG1_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG1_ClaRunExt_fn)
?   ASSERT(ImageToPNG1_ClaRunExt_fp <> 0, 'ImageToPNG1 not found in ClaRunExt.DLL')
    ImageToPNG2_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageToPNG2_ClaRunExt_fn)
?   ASSERT(ImageToPNG2_ClaRunExt_fp <> 0, 'ImageToPNG2 not found in ClaRunExt.DLL')
    ImageRotateFlip_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageRotateFlip_ClaRunExt_fn)
?   ASSERT(ImageRotateFlip_ClaRunExt_fp <> 0,'ImageRotateFlip not found in ClaRunExt.DLL')
    ImageSaveThumbnail_ClaRunExt_fp = ClaRunExt_GetProcAddress (SELF.hLib, ImageSaveThumbnail_ClaRunExt_fn)
?   ASSERT(ImageSaveThumbnail_ClaRunExt_fp <>0 ,'ImageSaveThumbnail not found in ClaRunExt.DLL')

    !Verification that all the function pointer were found, and if not just Kill the class
    IF ImageToPNG1_ClaRunExt_fp = 0 OR |
       ImageToPNG2_ClaRunExt_fp = 0 OR |
       ImageRotateFlip_ClaRunExt_fp = 0 OR |
       ImageSaveThumbnail_ClaRunExt_fp = 0
      SELF.Kill()
      RETURN FALSE
    END
  END
  RETURN TRUE
        
ClaRunExtLibClass.IsInited PROCEDURE()
  CODE
  RETURN CHOOSE (SELF.Inited <> FALSE)
        
ClaRunExtLibClass.Kill PROCEDURE()
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
ClaRunExtLibClass.ImageToPNG PROCEDURE(CONST *CSTRING fileNameIn)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageToPNG1_ClaRunExt (fileNameIn)
        
ClaRunExtLibClass.ImageToPNG PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageToPNG2_ClaRunExt (fileNameIn,fileNameOut)
        
ClaRunExtLibClass.ImageRotateFlip PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG RotateFlipType)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageRotateFlip_ClaRunExt (fileNameIn, fileNameOut, RotateFlipType)
        
ClaRunExtLibClass.ImageSaveThumbnail PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG percentage)
  CODE
  IF NOT SELF.IsInited()
    RETURN FALSE
  END
  RETURN ImageSaveThumbnail_ClaRunExt(fileNameIn, fileNameOut, percentage)
!endregion
!endregion

!region ClaRunExtClass
ClaRunExtClass.Construct               PROCEDURE()
 CODE
    SELF.Inited = FALSE
    
ClaRunExtClass.Destruct                PROCEDURE()
 CODE
    IF SELF.Inited
       ClaRunExtLibClass.Kill()
    END
    
ClaRunExtClass.Init                    PROCEDURE()
 CODE
    IF NOT SELF.Inited
       SELF.Inited = ClaRunExtLibClass.Init()
    END
    RETURN SELF.Inited

ClaRunExtClass.ImageToPNG PROCEDURE(CONST *CSTRING fileNameIn)
 CODE
    IF SELF.Init()
       RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn)              
    END
    RETURN FALSE
ClaRunExtClass.ImageToPNG PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut)
 CODE
    IF SELF.Init()
       RETURN ClaRunExtLibClass.ImageToPNG(fileNameIn, fileNameOut)
    END
    RETURN FALSE
ClaRunExtClass.ImageRotateFlip PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG RotateFlipType)
 CODE
    IF SELF.Init()
       RETURN ClaRunExtLibClass.ImageRotateFlip(fileNameIn, fileNameOut, RotateFlipType)
    END
    RETURN FALSE
ClaRunExtClass.ImageSaveThumbnail PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG porcentage)
 CODE
    IF SELF.Init()
       RETURN ClaRunExtLibClass.ImageSaveThumbnail(fileNameIn, fileNameOut, porcentage)
    END
    RETURN FALSE
!endregion