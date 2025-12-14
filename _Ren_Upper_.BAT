@ECHO OFF
Echo ===============================================================
Echo Many of the file names in LibSrc are Lower case. This is bad for
Echo putting on GitHub because the sort is case sensitive.
Echo This does an UPPER on all file names, then adjusts a few to UpLow.
Echo This works out best for me looking at this on my Phone.
Echo+
echo "Rename files to UPPER for the below folders: (Powershell _Ren_Upper_Worker.ps1)"
FOR /D %%G in ("Clarion*","CW*") DO ( 
       ECHO    Folder: "%%G"
       )
pause

Echo ===============================================================
FOR /D %%G in ("Clarion*","CW*") DO (
       ECHO ---------------------------------------------------- 
       ECHO Call Powershell _Ren_Upper_Worker.PS1 for "%%G"
       call powershell -NoProfile -ExecutionPolicy Bypass -File _Ren_Upper_Worker.PS1   "%%G"
       )
Echo ===============================================================

Echo All done in Rename Upper BAT
pause
goto :EOF
