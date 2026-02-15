       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.                     *> Name of this program

       DATA DIVISION.
       WORKING-STORAGE SECTION.             *> Where variables live
       COPY "src/copybooks/constants.cpy".  *> Import shared constants
       COPY "src/copybooks/types.cpy".      *> Import shared data structures

       PROCEDURE DIVISION.                  *> Here the logic starts

           DISPLAY WS-SEP                   *> Print a separator line
           DISPLAY WS-APP-NAME              *> Show application title
           DISPLAY WS-SEP

           *> Print this text, but DO NOT move the cursor to the next line
           DISPLAY "Your name: " WITH NO ADVANCING
           ACCEPT WS-NAME                   *> Read user input into WS-NAME
           DISPLAY "Hello, " WS-NAME        *> Greet the user

           DISPLAY WS-SEP
           DISPLAY "Enter Num1 (0-9999): " WITH NO ADVANCING
           ACCEPT WS-NUM1                   *> Read first number

           DISPLAY "Enter Num2 (0-9999): " WITH NO ADVANCING
           ACCEPT WS-NUM2                   *> Read second number

           CALL "MATHUTILS" USING
             WS-NUM1 WS-NUM2 WS-RESULT      *> Call another program to add numbers

           DISPLAY "Sum = " WS-RESULT       *> Show result
           DISPLAY WS-SEP

           STOP RUN.

       END PROGRAM MAIN.  
