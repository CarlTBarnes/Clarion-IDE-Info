# Call from BAT file and pass Folder Name
# This will UPPER all of the file names because Git sort is Case Sensitive
# Keep most common .EXTEN as .UPPER 9.CLW .INC .TPW) others set .UpLow .Int .Equ .Trn .Tpl 

param ( [string]$Path2Fix )

echo "Rename files to UPPER in $Path2Fix"
#Read-Host -Prompt "Press Enter to Start Rename to UPPER ..."

Get-ChildItem -Path $Path2Fix -Exclude "*.PDF" -Recurse -File | ForEach-Object {
    $newName = $_.Name.ToUpper()          # .ToLower or .ToUpper
#     $newName = $_.Name.ToLower()          # Reverse as .ToLower for testing

# Rename extension so less common standot a bit. Easier to see on my phone.
#    $newName = $newName.Replace('.INC','.Inc')   #Keep .CLW .INC Caps
    $newName = $newName.Replace('.INT','.Int')   # make .INT .Int UpLow
    $newName = $newName.Replace('.EQU','.Equ')   # others make UpLow
    $newName = $newName.Replace('.TRN','.Trn')   # make .INT .Int UpLow
    $newName = $newName.Replace('.TPL','.Tpl')   # make .INT .Int UpLow

#Prefer these file names Mixed Case as I will look at them most
    $newName = $newName.Replace('PROPERTY'    ,'Property'    )
    $newName = $newName.Replace('BUILTINS'    ,'BuiltIns'    )
    $newName = $newName.Replace('DEFAULTS'    ,'Defaults'    )
    $newName = $newName.Replace('EQUATES'     ,'Equates'     )
    $newName = $newName.Replace('ERRORS'      ,'Errors'      )
    $newName = $newName.Replace('KEYCODES'    ,'KeyCodes'    )
    $newName = $newName.Replace('PRNPROP'     ,'PRNProp'     )

    $newName = $newName.Replace('ANYSCREEN'   ,'AnyScreen'   )
    $newName = $newName.Replace('CLARUNEXT'   ,'ClaRunExt'   )
    $newName = $newName.Replace('CWSYNCH'     ,'CWSynch'     )  #CWSynchC and CWSynchM
    $newName = $newName.Replace('CWSYNCLP'    ,'CWSyncLp'    )  #
    $newName = $newName.Replace('CWSYNCWT'    ,'CWSyncWT'    )  #Working Thread
    $newName = $newName.Replace('CSIDLFOLDER' ,'CSIDLFolder' )
    $newName = $newName.Replace('ABBREAK'     ,'ABBreak'     )
    $newName = $newName.Replace('ABBROWSE'    ,'ABBrowse'    )
    $newName = $newName.Replace('ABPOPUP'     ,'ABPopup'     )
    $newName = $newName.Replace('ABREPORT'    ,'ABReport'    )
    $newName = $newName.Replace('ABWINDOW'    ,'ABWindow'    )
    $newName = $newName.Replace('MENUSTYLE'   ,'MenuStyle'   )
    $newName = $newName.Replace('SYSTEMSTRING' ,'SystemString')
#skip    $newName = $newName.Replace('ABFILE'      ,'ABFile'      )   #all CAPS
#skip    $newName = $newName.Replace('ABUTIL'      ,'ABUtil'      )

    if ($_.Name -cne $newName) {          # -cne  Case Senbsitive Not Equal
        ECHO "Upper Name $newName  -- For File: $_.Name"
        Rename-Item -LiteralPath $_.FullName -NewName $newName   # -Force
    }
}
Read-Host -Prompt "Rename Upper done in $Path2Fix"
EXIT
