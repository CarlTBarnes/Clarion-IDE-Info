=================================================
Clarion 5.5.08 'H' Release Changes and fixes 
=================================================
This release provides an enhancement aimed at improving
ClarioNet applications handling of tab ordering on complex
windows, as well as several new bug fixes.


Fixes and enhancements
======================


RTL
===

Enhancement - A newly created control determines its correct Z-order
              in relation to parent container(s)

Fix - Size properties return unexpected results for TAB controls

Fix - DISPLAY for the TEXT control can move focus to this control

IDE
===

Fix - Choosing to create a backup option in the Browser could cause deleting of the file

Fix - If #PREPARE section of the auto-populated #EXTENSION template is evaluated
  as #REJECT, this can cause GPF

Fix - WRAP attribute in #CONTROL templates does not work for STRINGs

Fix - The declaration of check boxes populated to REPORT is parsed incorrectly
  if VALUE attribute is present

Templates/Classes
=================

Fix - Resizer class for Legacy templates produces memory leaks when the window is
      closed.


ReportWriter
=============
Fix - possible problem with the SQL generated for reports that contain
a user-defined relation at the top of a three table join.  For example:

grandfather - parent - child
