       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILE-MENU.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TXT-FILE ASSIGN TO DYNAMIC WS-FILENAME
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TXT-STATUS.

           SELECT LIST-FILE ASSIGN TO WS-LIST-TMP
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TXT-FILE.
       01  TXT-LINE                PIC X(250).

       FD  LIST-FILE.
       01  LIST-REC                PIC X(200).

       WORKING-STORAGE SECTION.
       77  WS-OPTION               PIC 9 VALUE 0.
       77  WS-TXT-STATUS           PIC XX VALUE "00".

       77  WS-FILENAME             PIC X(260) VALUE SPACES.
       77  WS-RAWNAME              PIC X(200) VALUE SPACES.
       77  WS-PATH                 PIC X(260) VALUE SPACES.

       77  WS-EOF                  PIC X VALUE "N".
           88 EOF                  VALUE "Y".
           88 NOT-EOF              VALUE "N".

       77  WS-DONE                 PIC X VALUE "N".
           88 DONE                 VALUE "Y".
           88 NOT-DONE             VALUE "N".

       77  WS-CMD                  PIC X(500) VALUE SPACES.
       77  WS-ANSWER               PIC X VALUE SPACE.

       77  WS-MORE                 PIC X VALUE "N".
           88 MORE                 VALUE "Y" "y".
           88 NO-MORE              VALUE "N" "n" SPACE.

       77  WS-I                    PIC 9(2) VALUE 0.
       77  WS-FOUND-DOT            PIC X VALUE "N".
           88 FOUND-DOT            VALUE "Y".
           88 NOT-FOUND-DOT        VALUE "N".

       77  WS-L1                   PIC X(250) VALUE SPACES.
       77  WS-L2                   PIC X(250) VALUE SPACES.
       77  WS-L3                   PIC X(250) VALUE SPACES.
       77  WS-L4                   PIC X(250) VALUE SPACES.
       77  WS-L5                   PIC X(250) VALUE SPACES.
       77  WS-L6                   PIC X(250) VALUE SPACES.
       77  WS-L7                   PIC X(250) VALUE SPACES.
       77  WS-L8                   PIC X(250) VALUE SPACES.
       77  WS-L9                   PIC X(250) VALUE SPACES.
       77  WS-L10                  PIC X(250) VALUE SPACES.

       *> Listing support
       77  WS-LIST-TMP             PIC X(260) VALUE "/tmp/cob_list.txt".
       77  WS-LIST-EOF             PIC X VALUE "N".
           88 LIST-EOF             VALUE "Y".
           88 LIST-NOT-EOF         VALUE "N".

       77  WS-L1F                  PIC X(80) VALUE SPACES.
       77  WS-L2F                  PIC X(80) VALUE SPACES.
       77  WS-L3F                  PIC X(80) VALUE SPACES.
       77  WS-L4F                  PIC X(80) VALUE SPACES.
       77  WS-L5F                  PIC X(80) VALUE SPACES.
       77  WS-L6F                  PIC X(80) VALUE SPACES.
       77  WS-L7F                  PIC X(80) VALUE SPACES.
       77  WS-L8F                  PIC X(80) VALUE SPACES.
       77  WS-L9F                  PIC X(80) VALUE SPACES.
       77  WS-L10F                 PIC X(80) VALUE SPACES.
       77  WS-L11F                 PIC X(80) VALUE SPACES.
       77  WS-L12F                 PIC X(80) VALUE SPACES.
       77  WS-L13F                 PIC X(80) VALUE SPACES.
       77  WS-L14F                 PIC X(80) VALUE SPACES.
       77  WS-L15F                 PIC X(80) VALUE SPACES.

       *> View support (15 lines page)
       77  WS-VIEW-ACT             PIC X VALUE SPACE.
       77  WS-V1                   PIC X(80) VALUE SPACES.
       77  WS-V2                   PIC X(80) VALUE SPACES.
       77  WS-V3                   PIC X(80) VALUE SPACES.
       77  WS-V4                   PIC X(80) VALUE SPACES.
       77  WS-V5                   PIC X(80) VALUE SPACES.
       77  WS-V6                   PIC X(80) VALUE SPACES.
       77  WS-V7                   PIC X(80) VALUE SPACES.
       77  WS-V8                   PIC X(80) VALUE SPACES.
       77  WS-V9                   PIC X(80) VALUE SPACES.
       77  WS-V10                  PIC X(80) VALUE SPACES.
       77  WS-V11                  PIC X(80) VALUE SPACES.
       77  WS-V12                  PIC X(80) VALUE SPACES.
       77  WS-V13                  PIC X(80) VALUE SPACES.
       77  WS-V14                  PIC X(80) VALUE SPACES.
       77  WS-V15                  PIC X(80) VALUE SPACES.

       *> Generic message support
       77  WS-MSG                  PIC X(60) VALUE SPACES.
       77  WS-DUMMY                PIC X VALUE SPACE.

       SCREEN SECTION.

       01 MENU-SCR.
           05 BLANK SCREEN.
           05 LINE 2  COLUMN 10 VALUE "------------------------------".
           05 LINE 3  COLUMN 10 VALUE " COBOL Text File Manager".
           05 LINE 4  COLUMN 10 VALUE "------------------------------".
           05 LINE 6  COLUMN 10 VALUE "1) Create new file".
           05 LINE 7  COLUMN 10 VALUE "2) List files (data folder)".
           05 LINE 8  COLUMN 10 VALUE "3) View file".
           05 LINE 9  COLUMN 10 VALUE "4) Delete file".
           05 LINE 10 COLUMN 10 VALUE "9) Exit".
           05 LINE 13 COLUMN 10 VALUE "Choose: ".
           05 LINE 13 COLUMN 18 PIC 9 TO WS-OPTION.

       01 FILENAME-SCR.
           05 BLANK SCREEN.
           05 LINE 2  COLUMN 10 VALUE "File name (without extension):".
           05 LINE 4  COLUMN 10 PIC X(40) TO WS-RAWNAME.
           05 LINE 6  COLUMN 10 VALUE "Press ENTER to confirm.".

       01 CONFIRM-SCR.
           05 LINE 20 COLUMN 10 VALUE "Continue? (Y/N): ".
           05 LINE 20 COLUMN 28 PIC X TO WS-ANSWER.

       01 MSG-SCR.
           05 LINE 20 COLUMN 10 PIC X(60) FROM WS-MSG.
           05 LINE 21 COLUMN 10 VALUE "Press ENTER to continue...".
           05 LINE 21 COLUMN 38 PIC X TO WS-DUMMY.

       01 MORE-SCR.
           05 LINE 20 COLUMN 10 VALUE "Add 10 more lines? (Y/N): ".
           05 LINE 20 COLUMN 36 PIC X TO WS-MORE.

       01 CONTENT-SCR.
           05 BLANK SCREEN.
           05 LINE 2  COLUMN 10 VALUE
              "Type up to 10 lines. Put a single dot (.) in any line to finish.".
           05 LINE 4  COLUMN 5  VALUE "01:".
           05 LINE 4  COLUMN 10 PIC X(70) TO WS-L1.
           05 LINE 5  COLUMN 5  VALUE "02:".
           05 LINE 5  COLUMN 10 PIC X(70) TO WS-L2.
           05 LINE 6  COLUMN 5  VALUE "03:".
           05 LINE 6  COLUMN 10 PIC X(70) TO WS-L3.
           05 LINE 7  COLUMN 5  VALUE "04:".
           05 LINE 7  COLUMN 10 PIC X(70) TO WS-L4.
           05 LINE 8  COLUMN 5  VALUE "05:".
           05 LINE 8  COLUMN 10 PIC X(70) TO WS-L5.
           05 LINE 9  COLUMN 5  VALUE "06:".
           05 LINE 9  COLUMN 10 PIC X(70) TO WS-L6.
           05 LINE 10 COLUMN 5  VALUE "07:".
           05 LINE 10 COLUMN 10 PIC X(70) TO WS-L7.
           05 LINE 11 COLUMN 5  VALUE "08:".
           05 LINE 11 COLUMN 10 PIC X(70) TO WS-L8.
           05 LINE 12 COLUMN 5  VALUE "09:".
           05 LINE 12 COLUMN 10 PIC X(70) TO WS-L9.
           05 LINE 13 COLUMN 5  VALUE "10:".
           05 LINE 13 COLUMN 10 PIC X(70) TO WS-L10.
           05 LINE 15 COLUMN 10 VALUE "Press ENTER to save these lines.".

       01 LIST-SCR.
           05 BLANK SCREEN.
           05 LINE 2  COLUMN 10 VALUE "Files in data folder:".
           05 LINE 4  COLUMN 10 PIC X(80) FROM WS-L1F.
           05 LINE 5  COLUMN 10 PIC X(80) FROM WS-L2F.
           05 LINE 6  COLUMN 10 PIC X(80) FROM WS-L3F.
           05 LINE 7  COLUMN 10 PIC X(80) FROM WS-L4F.
           05 LINE 8  COLUMN 10 PIC X(80) FROM WS-L5F.
           05 LINE 9  COLUMN 10 PIC X(80) FROM WS-L6F.
           05 LINE 10 COLUMN 10 PIC X(80) FROM WS-L7F.
           05 LINE 11 COLUMN 10 PIC X(80) FROM WS-L8F.
           05 LINE 12 COLUMN 10 PIC X(80) FROM WS-L9F.
           05 LINE 13 COLUMN 10 PIC X(80) FROM WS-L10F.
           05 LINE 14 COLUMN 10 PIC X(80) FROM WS-L11F.
           05 LINE 15 COLUMN 10 PIC X(80) FROM WS-L12F.
           05 LINE 16 COLUMN 10 PIC X(80) FROM WS-L13F.
           05 LINE 17 COLUMN 10 PIC X(80) FROM WS-L14F.
           05 LINE 18 COLUMN 10 PIC X(80) FROM WS-L15F.
           05 LINE 20 COLUMN 10 VALUE "Press ENTER to return...".
           05 LINE 20 COLUMN 36 PIC X TO WS-DUMMY.

       01 VIEW-SCR.
           05 BLANK SCREEN.
           05 LINE 2  COLUMN 10 VALUE "File content:".
           05 LINE 3  COLUMN 10 PIC X(80) FROM WS-FILENAME.
           05 LINE 5  COLUMN 10 PIC X(80) FROM WS-V1.
           05 LINE 6  COLUMN 10 PIC X(80) FROM WS-V2.
           05 LINE 7  COLUMN 10 PIC X(80) FROM WS-V3.
           05 LINE 8  COLUMN 10 PIC X(80) FROM WS-V4.
           05 LINE 9  COLUMN 10 PIC X(80) FROM WS-V5.
           05 LINE 10 COLUMN 10 PIC X(80) FROM WS-V6.
           05 LINE 11 COLUMN 10 PIC X(80) FROM WS-V7.
           05 LINE 12 COLUMN 10 PIC X(80) FROM WS-V8.
           05 LINE 13 COLUMN 10 PIC X(80) FROM WS-V9.
           05 LINE 14 COLUMN 10 PIC X(80) FROM WS-V10.
           05 LINE 15 COLUMN 10 PIC X(80) FROM WS-V11.
           05 LINE 16 COLUMN 10 PIC X(80) FROM WS-V12.
           05 LINE 17 COLUMN 10 PIC X(80) FROM WS-V13.
           05 LINE 18 COLUMN 10 PIC X(80) FROM WS-V14.
           05 LINE 19 COLUMN 10 PIC X(80) FROM WS-V15.
           05 LINE 21 COLUMN 10 VALUE "[N] Next page   [Q] Quit: ".
           05 LINE 21 COLUMN 39 PIC X TO WS-VIEW-ACT.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM UNTIL WS-OPTION = 9
               ACCEPT MENU-SCR
               EVALUATE WS-OPTION
                   WHEN 1 PERFORM CREATE-FILE
                   WHEN 2 PERFORM LIST-FILES
                   WHEN 3 PERFORM VIEW-FILE
                   WHEN 4 PERFORM DELETE-FILE
                   WHEN 9 CONTINUE
                   WHEN OTHER
                       MOVE "Invalid option." TO WS-MSG
                       PERFORM SHOW-MSG
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       SHOW-MSG.
           MOVE SPACE TO WS-DUMMY
           ACCEPT MSG-SCR
           EXIT PARAGRAPH.

       BUILD-PATH.
           MOVE SPACES TO WS-RAWNAME
           ACCEPT FILENAME-SCR

           IF FUNCTION TRIM(WS-RAWNAME) = ""
               MOVE "Name cannot be empty." TO WS-MSG
               PERFORM SHOW-MSG
               MOVE SPACES TO WS-FILENAME
               EXIT PARAGRAPH
           END-IF

           MOVE SPACES TO WS-PATH
           STRING "data/" DELIMITED BY SIZE
                  FUNCTION TRIM(WS-RAWNAME) DELIMITED BY SIZE
                  ".txt" DELIMITED BY SIZE
                  INTO WS-PATH
           END-STRING
           MOVE WS-PATH TO WS-FILENAME.

       CLEAR-CONTENT-FIELDS.
           MOVE SPACES TO WS-L1
           MOVE SPACES TO WS-L2
           MOVE SPACES TO WS-L3
           MOVE SPACES TO WS-L4
           MOVE SPACES TO WS-L5
           MOVE SPACES TO WS-L6
           MOVE SPACES TO WS-L7
           MOVE SPACES TO WS-L8
           MOVE SPACES TO WS-L9
           MOVE SPACES TO WS-L10.

       WRITE-CONTENT-PAGE.
           SET NOT-FOUND-DOT TO TRUE

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10 OR FOUND-DOT
               EVALUATE WS-I
                   WHEN 1  MOVE WS-L1  TO TXT-LINE
                   WHEN 2  MOVE WS-L2  TO TXT-LINE
                   WHEN 3  MOVE WS-L3  TO TXT-LINE
                   WHEN 4  MOVE WS-L4  TO TXT-LINE
                   WHEN 5  MOVE WS-L5  TO TXT-LINE
                   WHEN 6  MOVE WS-L6  TO TXT-LINE
                   WHEN 7  MOVE WS-L7  TO TXT-LINE
                   WHEN 8  MOVE WS-L8  TO TXT-LINE
                   WHEN 9  MOVE WS-L9  TO TXT-LINE
                   WHEN 10 MOVE WS-L10 TO TXT-LINE
               END-EVALUATE

               IF FUNCTION TRIM(TXT-LINE) = "."
                   SET FOUND-DOT TO TRUE
               ELSE
                   IF FUNCTION TRIM(TXT-LINE) NOT = ""
                       WRITE TXT-LINE
                   END-IF
               END-IF
           END-PERFORM.

       CLEAR-LIST-FIELDS.
           MOVE SPACES TO WS-L1F
           MOVE SPACES TO WS-L2F
           MOVE SPACES TO WS-L3F
           MOVE SPACES TO WS-L4F
           MOVE SPACES TO WS-L5F
           MOVE SPACES TO WS-L6F
           MOVE SPACES TO WS-L7F
           MOVE SPACES TO WS-L8F
           MOVE SPACES TO WS-L9F
           MOVE SPACES TO WS-L10F
           MOVE SPACES TO WS-L11F
           MOVE SPACES TO WS-L12F
           MOVE SPACES TO WS-L13F
           MOVE SPACES TO WS-L14F
           MOVE SPACES TO WS-L15F.

       CLEAR-VIEW-LINES.
           MOVE SPACES TO WS-V1
           MOVE SPACES TO WS-V2
           MOVE SPACES TO WS-V3
           MOVE SPACES TO WS-V4
           MOVE SPACES TO WS-V5
           MOVE SPACES TO WS-V6
           MOVE SPACES TO WS-V7
           MOVE SPACES TO WS-V8
           MOVE SPACES TO WS-V9
           MOVE SPACES TO WS-V10
           MOVE SPACES TO WS-V11
           MOVE SPACES TO WS-V12
           MOVE SPACES TO WS-V13
           MOVE SPACES TO WS-V14
           MOVE SPACES TO WS-V15.

       CREATE-FILE.
           PERFORM BUILD-PATH
           IF WS-FILENAME = SPACES
               EXIT PARAGRAPH
           END-IF

           OPEN OUTPUT TXT-FILE

           SET NOT-DONE TO TRUE
           PERFORM UNTIL DONE
               PERFORM CLEAR-CONTENT-FIELDS
               ACCEPT CONTENT-SCR
               PERFORM WRITE-CONTENT-PAGE

               IF FOUND-DOT
                   SET DONE TO TRUE
               ELSE
                   MOVE "N" TO WS-MORE
                   ACCEPT MORE-SCR
                   IF NO-MORE
                       SET DONE TO TRUE
                   END-IF
               END-IF
           END-PERFORM

           CLOSE TXT-FILE
           MOVE "Created successfully." TO WS-MSG
           PERFORM SHOW-MSG
           EXIT PARAGRAPH.

       LIST-FILES.
           MOVE SPACES TO WS-CMD
           STRING "ls -1 data/*.txt 2>/dev/null > " DELIMITED BY SIZE
                  FUNCTION TRIM(WS-LIST-TMP) DELIMITED BY SIZE
                  INTO WS-CMD
           END-STRING
           CALL "SYSTEM" USING WS-CMD

           PERFORM CLEAR-LIST-FIELDS

           SET LIST-NOT-EOF TO TRUE
           OPEN INPUT LIST-FILE

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 15 OR LIST-EOF
               READ LIST-FILE
                   AT END
                       SET LIST-EOF TO TRUE
                   NOT AT END
                       EVALUATE WS-I
                           WHEN 1  MOVE LIST-REC TO WS-L1F
                           WHEN 2  MOVE LIST-REC TO WS-L2F
                           WHEN 3  MOVE LIST-REC TO WS-L3F
                           WHEN 4  MOVE LIST-REC TO WS-L4F
                           WHEN 5  MOVE LIST-REC TO WS-L5F
                           WHEN 6  MOVE LIST-REC TO WS-L6F
                           WHEN 7  MOVE LIST-REC TO WS-L7F
                           WHEN 8  MOVE LIST-REC TO WS-L8F
                           WHEN 9  MOVE LIST-REC TO WS-L9F
                           WHEN 10 MOVE LIST-REC TO WS-L10F
                           WHEN 11 MOVE LIST-REC TO WS-L11F
                           WHEN 12 MOVE LIST-REC TO WS-L12F
                           WHEN 13 MOVE LIST-REC TO WS-L13F
                           WHEN 14 MOVE LIST-REC TO WS-L14F
                           WHEN 15 MOVE LIST-REC TO WS-L15F
                       END-EVALUATE
               END-READ
           END-PERFORM

           CLOSE LIST-FILE

           IF WS-L1F = SPACES
               MOVE "No .txt files found in data/." TO WS-MSG
               PERFORM SHOW-MSG
               EXIT PARAGRAPH
           END-IF

           MOVE SPACE TO WS-DUMMY
           ACCEPT LIST-SCR
           EXIT PARAGRAPH.

       VIEW-FILE.
           PERFORM BUILD-PATH
           IF WS-FILENAME = SPACES
               EXIT PARAGRAPH
           END-IF

           MOVE "00" TO WS-TXT-STATUS
           OPEN INPUT TXT-FILE

           IF WS-TXT-STATUS NOT = "00"
               MOVE "File not found or empty." TO WS-MSG
               PERFORM SHOW-MSG
               EXIT PARAGRAPH
           END-IF

           SET NOT-EOF TO TRUE

           PERFORM UNTIL WS-VIEW-ACT = "Q" OR WS-VIEW-ACT = "q"
               PERFORM CLEAR-VIEW-LINES

               PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 15 OR EOF
                   READ TXT-FILE
                       AT END
                           SET EOF TO TRUE
                       NOT AT END
                           EVALUATE WS-I
                               WHEN 1  MOVE TXT-LINE(1:80) TO WS-V1
                               WHEN 2  MOVE TXT-LINE(1:80) TO WS-V2
                               WHEN 3  MOVE TXT-LINE(1:80) TO WS-V3
                               WHEN 4  MOVE TXT-LINE(1:80) TO WS-V4
                               WHEN 5  MOVE TXT-LINE(1:80) TO WS-V5
                               WHEN 6  MOVE TXT-LINE(1:80) TO WS-V6
                               WHEN 7  MOVE TXT-LINE(1:80) TO WS-V7
                               WHEN 8  MOVE TXT-LINE(1:80) TO WS-V8
                               WHEN 9  MOVE TXT-LINE(1:80) TO WS-V9
                               WHEN 10 MOVE TXT-LINE(1:80) TO WS-V10
                               WHEN 11 MOVE TXT-LINE(1:80) TO WS-V11
                               WHEN 12 MOVE TXT-LINE(1:80) TO WS-V12
                               WHEN 13 MOVE TXT-LINE(1:80) TO WS-V13
                               WHEN 14 MOVE TXT-LINE(1:80) TO WS-V14
                               WHEN 15 MOVE TXT-LINE(1:80) TO WS-V15
                           END-EVALUATE
                   END-READ
               END-PERFORM

               IF WS-V1 = SPACES AND EOF
                   MOVE "End of file." TO WS-MSG
                   PERFORM SHOW-MSG
                   EXIT PERFORM
               END-IF

               MOVE "N" TO WS-VIEW-ACT
               ACCEPT VIEW-SCR

               IF EOF
                   IF WS-VIEW-ACT = "N" OR WS-VIEW-ACT = "n"
                       MOVE "End of file." TO WS-MSG
                       PERFORM SHOW-MSG
                       EXIT PERFORM
                   END-IF
               END-IF
           END-PERFORM

           CLOSE TXT-FILE
           EXIT PARAGRAPH.

       DELETE-FILE.
           PERFORM BUILD-PATH
           IF WS-FILENAME = SPACES
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-ANSWER
           ACCEPT CONFIRM-SCR
           IF WS-ANSWER NOT = "Y" AND WS-ANSWER NOT = "y"
               MOVE "Cancelled." TO WS-MSG
               PERFORM SHOW-MSG
               EXIT PARAGRAPH
           END-IF

           MOVE "00" TO WS-TXT-STATUS
           OPEN INPUT TXT-FILE

           IF WS-TXT-STATUS NOT = "00"
               MOVE "File not found." TO WS-MSG
               PERFORM SHOW-MSG
               EXIT PARAGRAPH
           END-IF

           CLOSE TXT-FILE

           MOVE SPACES TO WS-CMD
           STRING "rm -f " DELIMITED BY SIZE
                  FUNCTION TRIM(WS-FILENAME) DELIMITED BY SIZE
                  INTO WS-CMD
           END-STRING

           CALL "SYSTEM" USING WS-CMD

           MOVE "File deleted." TO WS-MSG
           PERFORM SHOW-MSG
           EXIT PARAGRAPH.

       END PROGRAM FILE-MENU.
