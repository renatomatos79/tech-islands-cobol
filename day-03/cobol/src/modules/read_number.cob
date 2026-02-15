       IDENTIFICATION DIVISION.
       PROGRAM-ID. READNUMBER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-IN-TEXT       PIC X(20) VALUE SPACES.
       01  WS-IS-NUM        PIC X     VALUE "N".
       01  WS-OK            PIC X     VALUE "N".
       01  WS-TMP           PIC 9(9)  VALUE 0.

       LINKAGE SECTION.
       01  L-PROMPT         PIC X(40).
       01  L-MIN            PIC 9(4).
       01  L-MAX            PIC 9(4).
       01  L-OUT-NUM        PIC 9(4).

       PROCEDURE DIVISION USING L-PROMPT L-MIN L-MAX L-OUT-NUM.

           MOVE "N" TO WS-OK

           PERFORM UNTIL WS-OK = "Y"
               DISPLAY L-PROMPT WITH NO ADVANCING
               ACCEPT WS-IN-TEXT

               CALL "ISNUMBER" USING WS-IN-TEXT WS-IS-NUM

               IF WS-IS-NUM = "Y"
                   MOVE FUNCTION NUMVAL(WS-IN-TEXT) TO WS-TMP

                   IF WS-TMP >= L-MIN AND WS-TMP <= L-MAX
                       MOVE WS-TMP TO L-OUT-NUM
                       MOVE "Y" TO WS-OK
                   ELSE
                       DISPLAY "Invalid range. Use " L-MIN " .. " L-MAX "."
                   END-IF
               ELSE
                   DISPLAY "Invalid input. Digits only."
               END-IF
           END-PERFORM

           GOBACK.

       END PROGRAM READNUMBER.
