IDENTIFICATION DIVISION.
PROGRAM-ID. AUTHREG.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "src/copybooks/constants.cpy".
COPY "src/copybooks/types.cpy".

01  WS-DONE        PIC X VALUE "N".
01  WS-DUMMY       PIC X VALUE SPACE.
01  WS-BLANK-LINE  PIC X(70) VALUE SPACES.
01 WS-DB-OK        PIC X VALUE "N".

SCREEN SECTION.

01  AUTH-SCREEN.
    05 BLANK SCREEN.
    05 LINE 3  COLUMN 30 VALUE "AUTH".
    05 LINE 5  COLUMN 2  VALUE "Email    :".
    05 LINE 5  COLUMN 14 PIC X(60) USING WS-EMAIL.

    05 LINE 7  COLUMN 2  VALUE "Password :".
    05 LINE 7  COLUMN 14 PIC X(6)  USING WS-PASSWORD.

    05 LINE 9  COLUMN 2  VALUE "[1] Auth   [2] Register   [9] Exit".
    05 LINE 10 COLUMN 2  VALUE "Choose ==> ".
    05 LINE 10 COLUMN 12 PIC 9 USING WS-CHOICE.

01  REG-SCREEN.
    05 BLANK SCREEN.
    *> 05 LINE 1  COLUMN 2  VALUE "Menu  Utilities  Compilers  Options  Status  Help".
    05 LINE 3  COLUMN 28 VALUE "REGISTER".
    05 LINE 5  COLUMN 2  VALUE "Username :".
    05 LINE 5  COLUMN 14 PIC X(30) USING WS-REG-USERNAME.

    05 LINE 7  COLUMN 2  VALUE "Email    :".
    05 LINE 7  COLUMN 14 PIC X(60) USING WS-REG-EMAIL.

    05 LINE 9  COLUMN 2  VALUE "Password :".
    05 LINE 9  COLUMN 14 PIC X(6)  USING WS-REG-PASS.

    05 LINE 11 COLUMN 2  VALUE "[1] Back   [2] Save   [9] Exit".
    05 LINE 12 COLUMN 2  VALUE "Choose ==> ".
    05 LINE 12 COLUMN 12 PIC 9 USING WS-CHOICE.

PROCEDURE DIVISION.

    PERFORM UNTIL WS-DONE = "Y"
        PERFORM CLEAR-SCREEN
        
        IF APP-EXIT
            MOVE "Y" TO WS-DONE
        END-IF

        IF SCREEN-AUTH
            PERFORM AUTH-LOOP
        ELSE
            PERFORM REG-LOOP
        END-IF

    END-PERFORM

    GOBACK.


CLEAR-SCREEN.
     CALL "SYSTEM" USING "clear".
     .

AUTH-LOOP.

    MOVE 0 TO WS-CHOICE
    ACCEPT AUTH-SCREEN

    *> If invalid, show message and wait
    EVALUATE WS-CHOICE
        WHEN 1
           CALL "DBAUTH" USING WS-EMAIL WS-PASSWORD WS-DB-OK WS-MSG
           IF WS-DB-OK = "Y"
               CALL "HOME"
               MOVE "Y" TO WS-DONE
           ELSE
               PERFORM SHOW-AUTH-MSG
           END-IF
           

        WHEN 2
            MOVE SPACES TO WS-MSG
            MOVE SPACES TO WS-REG-EMAIL
            MOVE SPACES TO WS-REG-PASS
            MOVE SPACES TO WS-REG-USERNAME
            MOVE "R" TO WS-SCREEN

        WHEN 9
            MOVE "Y" TO WS-DONE

        WHEN OTHER
            MOVE "Invalid option. Use 1, 2 or 9." TO WS-MSG
            PERFORM SHOW-AUTH-MSG
    END-EVALUATE
    .


REG-LOOP.
    ACCEPT REG-SCREEN

    IF WS-REG-PASS NOT = SPACES
        MOVE "Password stored (masked as ****** on display)." TO WS-MSG
    END-IF

    EVALUATE WS-CHOICE
        WHEN 1
            *> Back to auth and reset variables
            MOVE SPACES TO WS-EMAIL
            MOVE SPACES TO WS-PASSWORD
            MOVE "A" TO WS-SCREEN

        WHEN 2
           CALL "DBREGISTER" USING WS-REG-USERNAME WS-REG-EMAIL WS-REG-PASS WS-DB-OK WS-MSG
           IF WS-DB-OK = "Y"
               CALL "HOME"
               MOVE "Y" TO WS-DONE

           ELSE
               PERFORM SHOW-REG-MSG
           END-IF

        WHEN 9
            MOVE "Y" TO WS-DONE

        WHEN OTHER
            MOVE "Invalid option. Use 1, 2 or 9." TO WS-MSG
            PERFORM SHOW-REG-MSG
    END-EVALUATE
    .

SHOW-AUTH-MSG.
    DISPLAY AUTH-SCREEN
    PERFORM SHOW-MSG
    DISPLAY "Press ENTER to continue..." AT LINE 23 COLUMN 2
    ACCEPT WS-DUMMY
    MOVE SPACES TO WS-MSG
    .

SHOW-REG-MSG.
    DISPLAY REG-SCREEN
    PERFORM SHOW-MSG
    DISPLAY "Press ENTER to continue..." AT LINE 23 COLUMN 2
    ACCEPT WS-DUMMY
    MOVE SPACES TO WS-MSG
    .

SHOW-MSG.
    DISPLAY WS-BLANK-LINE AT LINE 22 COLUMN 2
    DISPLAY WS-MSG        AT LINE 22 COLUMN 2
    .
