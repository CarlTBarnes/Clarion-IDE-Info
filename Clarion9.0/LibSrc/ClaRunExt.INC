!ABCIncludeFile(ABC)

OMIT('_EndOfInclude_',_ClaRunExtPresent_)
_ClaRunExtPresent_ EQUATE(1)

RotateFlipType:RotateNoneFlipNone  EQUATE(0)!Specifies no clockwise rotation and no flipping.
RotateFlipType:Rotate90FlipNone	   EQUATE(1)!Specifies a 90-degree clockwise rotation without flipping.
RotateFlipType:Rotate180FlipNone   EQUATE(2)!Specifies a 180-degree clockwise rotation without flipping.
RotateFlipType:Rotate270FlipNone   EQUATE(3)!Specifies a 270-degree clockwise rotation without flipping.
RotateFlipType:RotateNoneFlipX	   EQUATE(4)!Specifies no clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate90FlipX	   EQUATE(5)!Specifies a 90-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate180FlipX	   EQUATE(6)!Specifies a 180-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:Rotate270FlipX	   EQUATE(7)!Specifies a 270-degree clockwise rotation followed by a horizontal flip.
RotateFlipType:RotateNoneFlipY	   EQUATE(8)!Specifies no clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate90FlipY	   EQUATE(9)!Specifies a 90-degree clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate180FlipY	   EQUATE(10)!Specifies a 180-degree clockwise rotation followed by a vertical flip.
RotateFlipType:Rotate270FlipY	   EQUATE(11)!Specifies a 270-degree clockwise rotation followed by a vertical flip.
RotateFlipType:RotateNoneFlipXY	   EQUATE(12)!Specifies no clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate90FlipXY	   EQUATE(13)!Specifies a 90-degree clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate180FlipXY	   EQUATE(14)!Specifies a 180-degree clockwise rotation followed by a horizontal and vertical flip.
RotateFlipType:Rotate270FlipXY	   EQUATE(15)!Specifies a 270-degree clockwise rotation followed by a horizontal and vertical flip.


ClaRunExtClass      CLASS,TYPE,MODULE('ClaRunExt.clw'),LINK('ClaRunExt.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Inited                  BYTE,PROTECTED
Construct               PROCEDURE()
Destruct                PROCEDURE(),PROTECTED
Init                    PROCEDURE(),BYTE,PROTECTED
ImageToPNG              PROCEDURE(CONST *CSTRING fileNameIn),LONG!Save image to a PNG file, changing the fileName extension to PNG. Return 0 if no error and Error Number if there is an error
ImageToPNG              PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut),LONG!Save image to a PNG file with the name fileNameOut. Return 0 if no error and Error Number if there is an error
ImageRotateFlip         PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG RotateFlipType),LONG!Save image rotated or fliped. Return 0 if no error and Error Number if there is an error
ImageSaveThumbnail      PROCEDURE(CONST *CSTRING fileNameIn, CONST *CSTRING fileNameOut, LONG porcentage),LONG!Save image reduced in size. Return 0 if no error and Error Number if there is an error
                    END

!_EndOfInclude_
