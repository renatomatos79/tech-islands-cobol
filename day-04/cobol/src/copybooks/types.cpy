       01  WS-AUTH-UI.
           05 WS-EMAIL        PIC X(60) VALUE SPACES.
           05 WS-PASSWORD     PIC X(6)  VALUE SPACES.

       01  WS-REG-UI.
           05 WS-USERNAME     PIC X(30) VALUE SPACES.
           05 WS-REG-EMAIL    PIC X(60) VALUE SPACES.
           05 WS-REG-PASS     PIC X(6)  VALUE SPACES.

       01  WS-CHOICE          PIC 9 VALUE 0.

       01  WS-SCREEN          PIC X VALUE "A".
           88 SCREEN-AUTH     VALUE "A".
           88 SCREEN-REG      VALUE "R".

       01  WS-MASK            PIC X(6) VALUE "******".
       01  WS-DONE            PIC X VALUE "N".
