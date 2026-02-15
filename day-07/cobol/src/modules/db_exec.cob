IDENTIFICATION DIVISION.
PROGRAM-ID. DBEXEC.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT SQLFILE ASSIGN TO WS-SQLFILE
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT OUTFILE ASSIGN TO WS-OUTFILE
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.

FD SQLFILE.
01 SQLLINE PIC X(300).

FD OUTFILE.
01 OUTLINE PIC X(300).

WORKING-STORAGE SECTION.
01 WS-CMD        PIC X(400) VALUE SPACES.
01 WS-SQLFILE    PIC X(40)  VALUE "/tmp/query.sql".
01 WS-OUTFILE    PIC X(80)  VALUE "/tmp/db_out.txt".
01 WS-ERRFILE    PIC X(80)  VALUE "/tmp/psql_err.txt".
01 WS-ONE-LINE   PIC X(300) VALUE SPACES.

LINKAGE SECTION.
01 L-SQL         PIC X(240).

*> returned output line (trim it in caller like a reference variable)
01 L-FIRST-LINE  PIC X(300).  

PROCEDURE DIVISION USING L-SQL L-FIRST-LINE.

    MOVE SPACES TO L-FIRST-LINE

    *> 1) Write SQL content that comes from "L-SQL" into /tmp/query.sql
    OPEN OUTPUT SQLFILE
    WRITE SQLLINE FROM L-SQL
    CLOSE SQLFILE

    *> 2) Execute psql using -f (no quoting problems)
    *> This produces something like:
    *> psql "postgresql://cobol:cobolpass@postgres:5432/coboldb" -tA -f /tmp/query.sql > /tmp/db_out.txt 2> /tmp/psql_err.txt
    *> -f /tmp/query.sql: run SQL from that file.
    *> -t: remove headers/footers (tuples-only).
    *> -A: no pretty table formatting; cleaner one-value-per-line output (no-align).
    *> > /tmp/db_out.txt → stdout goes to output file.
    *> 2> /tmp/psql_err.txt → stderr goes to error file.
    *> full documentation: https://www.postgresql.org/docs/current/app-psql.html

    MOVE SPACES TO WS-CMD
    STRING
      "psql ""postgresql://cobol:cobolpass@postgres:5432/coboldb"""
      " -tA -f " WS-SQLFILE
      " > " WS-OUTFILE
      " 2> " WS-ERRFILE
      INTO WS-CMD
    END-STRING

    CALL "SYSTEM" USING WS-CMD

    *> 3) Read first line of output (if any)
    OPEN INPUT OUTFILE
    READ OUTFILE INTO WS-ONE-LINE
        AT END MOVE SPACES TO WS-ONE-LINE
    END-READ
    CLOSE OUTFILE

    MOVE WS-ONE-LINE TO L-FIRST-LINE
    GOBACK.
