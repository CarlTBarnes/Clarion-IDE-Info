=================================================
Clarion 5.5.07 'G' Release Changes and fixes 
=================================================

This release of the patch for 5.507 is primarily being released
to resolve a problem introduced with the release of MS XP operating system

Microsoft Europe has confirmed unexpected behavior under XP of programs
running correctly under previous Window versions. The most likely cause for the 
loss of backward compatibility are changes in the XP system loader.   
C55F had been assumed as our last C55 build, but to provide a workaround for 
the XP problem SoftVelocity has prepared a C55G build.  

We have also addressed the problem for 5.0 users by providing a new
linker for 5.0 users.  Email support@softvelocity.com for a copy of this
update for Clarion 5.0.


Fixes and enhancements
======================

1. RTL

FIX: If entry control uses @P picture with more than 15 < or # tokens,
changing of the last digits can remain undetected and the USE variable does
not
receive the new value.

2. RTL

FIX: Animated GIFs displaying incorrectly if they are not transparent

3. ABC Library

FIX: CWinSock20.ProcessNetworkEvent method (ABAPI.CLW) uses 0-based indexes
for getting array elements.

4. 32 bit Debugger

FIX: Adding a variable from the Stack Trace window to Watch window can cause
GPF, going into infinite loop or displaying wrong name for that variable

5. IDE

FIX: Under certain conditions the IDE can't redirect file names returned
from
the File Dialog correctly under NT/W2000.

6. Browser

FIX: If file is declared in the dictionary with a variable password,
in-place
conversion can fail.

7. CLW Compiler

FIX: Using GROUPs as a parameter of the FROM() attribute of listboxes
populated to reports is declared but was not supported by the compiler.

8. RW, TopScan

REGRESSION: Files with GROUP as a first field were importing incorrectly

9. CLW Compiler

FIX: The compiler can go into infinite loop if a label is duplicated in the
same
scope.

10. RTL

FIX: Setting PROP:Mark dynamically does not highlight rows which have a
non-0 value in
the new mark field.

11. CLW Compiler

FIX: The compiler reports error for getting SIZE for elements of arrays.

12. RTL

FIX: If font color for the PROMPT control is set to system one, e.g.
COLOR:GRAYTEXT, it is displaying in black.

13. RTL (16 bits)

FIX: Incorrect handling of unloading DLLs referenced in DLLs loaded
dynamically.

14. RTL (32 bits)

WORK AROUND: To resolve the compatibility issue introduced in the XP system
loader the .bss section of every CW made executable is initialized to 0s at load
time.

15. Linker (32 bits)

WORK AROUND for the problem with the XP system loader.

16. RTL

FEATURE: Semantic of result of getting PROPLIST:Exists is extended. Now it
returns
- TRUE or FALSE if called with the column number > 0
- total number of listbox columns if called with the column number 0
- total number of columns in the specified group if called for the group
  (?List {PROPLIST:Exists + PROPLIST:Group, GroupNumber})

17. CLW Compiler

BUG: Dot syntax is not supported for projected and linking fields in VIEWs

18. RTL

BUG: If PROP:Skip is set to FALSE for a combo box, this control can't be
left using TAB key.

19. RTL 
BUG: Fix the problem in the 32 bit RTL in the queue compression routine that
could cause a GPF.

20. Database Browser
Fix 516 error during browsing tables from the Pick list
or from menu.

21. RTL

Fix for a bug with using Ctrl-Right in multi-column listboxes.

22. CLW Compiler

FEATURE: Changed way how parameters of named GROUP types are passed by value
to procedures with the RAW attribute. Now if the RAW attribute is used the value 
of the parameter is passed on the stack in a way compatible with C/C++ compilers. 

Example:

POINT   GROUP,TYPE
X         LONG
Y         LONG
        END

        MAP
          MODULE('')
            ByAddress (*POINT),RAW   !pass the address of the group
            ByValue (POINT),RAW      !pass value of the group
          END
        END

Explanation:
The GROUP of the POINT type is passed to the ByAddress procedure by its
address as it was before this change. But the value of the GROUP is passed 
to the ByValue procedure and is copied to the stack in accordance with parameters order.

Nothing has been changed in passing parameters of named GROUP types to
functions prototyped without the RAW attribute.


23. CLW, C++, Modula-2 Compilers

Fix: Under certain conditions an error could occur when optimizing fixed point constants.

24.  Data Modeller

Fix for GPF when exiting using the Window system X.

24.  Data Modeller

Fix: GPF could occur when generating test data.

----------------------------------------------------------------------------
----------------------------------------------------------------------------
As a temporary resolution to reports on using the QBE with the Form option, we'll
recommend use of two versions of the QBE support (found in ABQUERY.CLW)
-- 
You already have both versions if you have 5.506.  The one best for use with the Form option 
is contained in (build 5.505), and the best for use with the List option is (build 5.506).

