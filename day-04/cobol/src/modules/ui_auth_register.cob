       IDENTIFICATION DIVISION.
       PROGRAM-ID. UIAUTHREG.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "src/copybooks/constants.cpy".
       COPY "src/copybooks/types.cpy".


       PROCEDURE DIVISION.

           PERFORM UNTIL WS-DONE = "Y"
               IF SCREEN-AUTH
                   PERFORM AUTH-SCREEN
               ELSE
                   PERFORM REG-SCREEN
               END-IF
           END-PERFORM

           GOBACK.


       CLEAR-SCREEN.
           CALL "SYSTEM" USING "clear".
           .

       AUTH-SCREEN.
           PERFORM CLEAR-SCREEN

           DISPLAY WS-SEP
           DISPLAY "AUTH"
           DISPLAY WS-SEP

           DISPLAY "Email    : " WS-EMAIL

           IF WS-PASSWORD = SPACES
               DISPLAY "Password : "
           ELSE
               DISPLAY "Password : " WS-MASK
           END-IF

           DISPLAY WS-SEP
           DISPLAY "[1] Edit Email"
           DISPLAY "[2] Edit Password (6 chars)"
           DISPLAY "[3] Auth (not implemented)"
           DISPLAY "[4] Register"
           DISPLAY "[9] Exit"
           DISPLAY "Choose: " WITH NO ADVANCING
           ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN 1
                   DISPLAY "Email: " WITH NO ADVANCING
                   ACCEPT WS-EMAIL

               WHEN 2
                   DISPLAY "Password (6 chars): " WITH NO ADVANCING
                   ACCEPT WS-PASSWORD

               WHEN 3
                   DISPLAY "Auth not implemented. Press ENTER..."
                   ACCEPT WS-CHOICE

               WHEN 4
                   MOVE SPACE TO WS-REG-EMAIL
                   MOVE SPACE TO WS-REG-PASS
                   MOVE "R" TO WS-SCREEN

               WHEN 9
                   MOVE "Y" TO WS-DONE

               WHEN OTHER
                   DISPLAY "Invalid option. Press ENTER..."
                   ACCEPT WS-CHOICE
           END-EVALUATE
           .


       REG-SCREEN.
           PERFORM CLEAR-SCREEN

           DISPLAY WS-SEP
           DISPLAY "REGISTER"
           DISPLAY WS-SEP

           DISPLAY "Username : " WS-USERNAME
           DISPLAY "Email    : " WS-REG-EMAIL

           IF WS-REG-PASS = SPACES
               DISPLAY "Password : "
           ELSE
               DISPLAY "Password : " WS-MASK
           END-IF

           DISPLAY WS-SEP
           DISPLAY "[1] Edit Username"
           DISPLAY "[2] Edit Email"
           DISPLAY "[3] Edit Password (6 chars)"
           DISPLAY "[4] Save (not implemented)"
           DISPLAY "[8] Back"
           DISPLAY "[9] Exit"
           DISPLAY "Choose: " WITH NO ADVANCING
           ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN 1
                   DISPLAY "Username: " WITH NO ADVANCING
                   ACCEPT WS-USERNAME

               WHEN 2
                   DISPLAY "Email: " WITH NO ADVANCING
                   ACCEPT WS-REG-EMAIL

               WHEN 3
                   DISPLAY "Password (6 chars): " WITH NO ADVANCING
                   ACCEPT WS-REG-PASS

               WHEN 4
                   DISPLAY "Save not implemented. Press ENTER..."
                   ACCEPT WS-CHOICE

               WHEN 8
                   MOVE "" TO WS-EMAIL
                   MOVE ""  TO WS-PASSWORD
                   MOVE "A" TO WS-SCREEN

               WHEN 9
                   MOVE "Y" TO WS-DONE

               WHEN OTHER
                   DISPLAY "Invalid option. Press ENTER..."
                   ACCEPT WS-CHOICE
           END-EVALUATE
           .
