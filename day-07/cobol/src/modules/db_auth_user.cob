IDENTIFICATION DIVISION.
PROGRAM-ID. DBAUTH.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 WS-SQL        PIC X(240) VALUE SPACES.
01 WS-DB-OUTPUT  PIC X(300) VALUE SPACES.

LINKAGE SECTION.
01 L-EMAIL       PIC X(60).
01 L-PASSWORD    PIC X(6).
01 L-RESULT      PIC X.
01 L-MSG         PIC X(70).

PROCEDURE DIVISION USING L-EMAIL L-PASSWORD L-RESULT L-MSG.

    MOVE "N" TO L-RESULT
    MOVE SPACES TO L-MSG

    IF L-EMAIL = SPACES OR L-PASSWORD = SPACES
        MOVE "Email and Password are required." TO L-MSG
        GOBACK
    END-IF

    MOVE SPACES TO WS-SQL
    STRING
      "SELECT CASE WHEN EXISTS ("
      "SELECT 1 FROM users "
      "WHERE email='" FUNCTION TRIM(L-EMAIL) "' "
      "AND password_hash = crypt('" FUNCTION TRIM(L-PASSWORD) "', password_hash)"
      ") THEN 1 ELSE 0 END;"
      INTO WS-SQL
    END-STRING

    *> call DBEXEC from db_exec.cob using input and output parameters
    CALL "DBEXEC" USING WS-SQL WS-DB-OUTPUT

    IF FUNCTION TRIM(WS-DB-OUTPUT) = "1"
        MOVE "Y" TO L-RESULT
        MOVE "Authenticated." TO L-MSG
    ELSE
        MOVE "Invalid email or password." TO L-MSG
    END-IF

    GOBACK.
