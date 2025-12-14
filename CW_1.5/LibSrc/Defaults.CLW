!  Default Window and Report Structures
!  ====================================
!
!  Used by Format New Structure (Ctrl-F) in CW editor
!
!  You may modify these, or add new window or report types
!  (NB remember to add preceeding '!!> title' line)
!  It *is* safe to use the CW Editor and Screen or Report
!  formatter to edit these structures


!!> Window
window WINDOW('Caption'),AT(,,260,100),GRAY
       END

!!> Window with OK & Cancel
window WINDOW('Caption'),AT(,,185,92),GRAY
         BUTTON('OK'),AT(144,10,35,14),DEFAULT,USE(?OkButton)
         BUTTON('Cancel'),AT(144,28,36,14),USE(?CancelButton)
       END

!!> System Modal Window
window WINDOW('Caption'),AT(,,100,100),MODAL,DOUBLE,CENTER,GRAY
       END

!!> MDI Child Window
window WINDOW('Caption'),AT(,,185,92),MDI,SYSTEM,RESIZE,GRAY
       END

!!> MDI Parent Frame
AppFrame APPLICATION('Caption'),AT(,,280,100),SYSTEM,RESIZE
       END

!!> Report (portrait)
report  REPORT,AT(1000,2000,6000,7000),THOUS,PRE(RPT),FONT('Arial',10)
         HEADER,AT(1000,1000,6000,1000)
         END
detail   DETAIL
         END
         FOOTER,AT(1000,9000,6000,1000)
         END
         FORM,AT(1000,1000,6000,9000)
         END
       END

!!> Report (landscape)
report  REPORT,AT(1000,1500,9000,5000),THOUS,PRE(RPT),LANDSCAPE,FONT('Arial',10)
         HEADER,AT(1000,1000,9000,500)
         END
detail   DETAIL
         END
         FOOTER,AT(1000,6500,9000,500)
         END
         FORM,AT(1000,1000,9000,6000)
         END
       END


