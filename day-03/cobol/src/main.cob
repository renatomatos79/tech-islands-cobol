       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "src/copybooks/constants.cpy".
       COPY "src/copybooks/types.cpy".

       PROCEDURE DIVISION.

           DISPLAY WS-SEP
           DISPLAY WS-APP-NAME
           DISPLAY WS-SEP

           DISPLAY "Your name: " WITH NO ADVANCING
           ACCEPT WS-NAME
           DISPLAY "Hello, " WS-NAME

           DISPLAY WS-SEP

           MOVE "Enter Num1 (0-9999, 0=Exit): " TO WS-PROMPT
           CALL "READNUMBER" USING WS-PROMPT WS-MIN WS-MAX WS-NUM1
           IF WS-NUM1 = 0
               DISPLAY "Bye!"
               STOP RUN
           END-IF

           MOVE "Enter Num2 (0-9999, 0=Exit): " TO WS-PROMPT
           CALL "READNUMBER" USING WS-PROMPT WS-MIN WS-MAX WS-NUM2
           IF WS-NUM2 = 0
               DISPLAY "Bye!"
               STOP RUN
           END-IF

           CALL "MATHUTILS" USING WS-NUM1 WS-NUM2 WS-RESULT

           DISPLAY WS-SEP
           DISPLAY "Sum = " WS-RESULT
           DISPLAY WS-SEP

           STOP RUN.

       END PROGRAM MAIN.

