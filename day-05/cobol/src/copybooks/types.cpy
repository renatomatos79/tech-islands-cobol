       77  WS-EMAIL        PIC X(60) VALUE SPACES.
       77  WS-PASSWORD     PIC X(6)  VALUE SPACES.

       77  WS-USERNAME     PIC X(30) VALUE SPACES.
       77  WS-REG-EMAIL    PIC X(60) VALUE SPACES.
       77  WS-REG-PASS     PIC X(6)  VALUE SPACES.

       77  WS-CHOICE       PIC 9     VALUE 0.
       
       01 WS-SCREEN       PIC X     VALUE "A".
          88 SCREEN-AUTH  VALUE "A".
          88 SCREEN-REG   VALUE "R".

       77  WS-MSG          PIC X(70) VALUE SPACES.
       77  WS-MASK         PIC X(6)  VALUE "******".

       01  WS-APP-EXIT     PIC X     VALUE "N".
           88 APP-EXIT     VALUE "Y".
           88 APP-RUN      VALUE "N".

       77  WS-DONE        PIC X VALUE "N".
       77  WS-DUMMY       PIC X VALUE SPACE.
       77  WS-BLANK-LINE  PIC X(70) VALUE SPACES.
       77  WS-HOME-OPT    PIC X VALUE SPACE.
       77  WS-IN-MENU     PIC X VALUE "N".
