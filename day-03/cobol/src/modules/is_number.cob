       IDENTIFICATION DIVISION.
       PROGRAM-ID. ISNUMBER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I            PIC 9(4) COMP VALUE 0.
       01  LEN          PIC 9(4) COMP VALUE 0.
       01  START-IDX    PIC 9(4) COMP VALUE 0.
       01  END-IDX      PIC 9(4) COMP VALUE 0.
       01  ONE-CHAR     PIC X         VALUE SPACE.

       LINKAGE SECTION.
       01  L-TEXT       PIC X(20).
       01  L-OK         PIC X.

       PROCEDURE DIVISION USING L-TEXT L-OK.
           *> L-OK = "Y" if trimmed text contains only digits 0-9
           *> L-OK = "N" otherwise (including empty or spaces only)

           MOVE "N" TO L-OK

           MOVE FUNCTION LENGTH(L-TEXT) TO LEN

           *> Find first non-space from the left
           MOVE 0 TO START-IDX
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LEN
               IF L-TEXT(I:1) NOT = SPACE
                   MOVE I TO START-IDX
                   EXIT PERFORM
               END-IF
           END-PERFORM

           *> If we never found a non-space, it's empty => not a number
           IF START-IDX = 0
               GOBACK
           END-IF

           *> Find first non-space from the right
           MOVE 0 TO END-IDX
           PERFORM VARYING I FROM LEN BY -1 UNTIL I < 1
               IF L-TEXT(I:1) NOT = SPACE
                   MOVE I TO END-IDX
                   EXIT PERFORM
               END-IF
           END-PERFORM

           *> Validate each character between START-IDX and END-IDX
           PERFORM VARYING I FROM START-IDX BY 1 UNTIL I > END-IDX
               MOVE L-TEXT(I:1) TO ONE-CHAR

               IF ONE-CHAR < "0" OR ONE-CHAR > "9"
                   MOVE "N" TO L-OK
                   GOBACK
               END-IF
           END-PERFORM

           MOVE "Y" TO L-OK
           GOBACK.

       END PROGRAM ISNUMBER. 
