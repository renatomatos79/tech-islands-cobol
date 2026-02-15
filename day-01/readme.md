# Day 01 - COBOL Intro and Tooling

## Required Tools
- VS Code
- Docker
- Make

### Install Make (Homebrew)
```bash
brew install make
```

### VS Code Extension
- COBOL language support: https://marketplace.visualstudio.com/items?itemName=bitlang.cobol

## Create the Project Folders
```bash
mkdir day-01 && cd day-01
mkdir -p cobol/src cobol/bin
```

**Target folder structure**
```text
day-01
  cobol
    bin
    src
    Dockerfile
  docker-compose.yml
  readme.md
```

## Add a Dockerfile in `day-01/cobol`
```dockerfile
# -------------------------------------------------------------
# Use a small, stable Debian Linux image as the base.
# This is the "operating system" inside our container.
# bookworm-slim = lightweight version (smaller image).
# -------------------------------------------------------------
FROM debian:bookworm-slim

# -------------------------------------------------------------
# Install the tools we need inside the container:
# - gnucobol : the COBOL compiler
# - make     : build automation tool used by our Makefile
#
# The commands mean:
# 1) apt-get update  -> refresh the list of available packages
# 2) apt-get install -> actually install the software
# 3) rm -rf ...      -> clean up cache to keep the image small
# -------------------------------------------------------------
RUN apt-get update && apt-get install -y \
  gnucobol \
  make \
  && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------------
# Set the default working directory inside the container.
# When we run the container, /work will be the current folder.
# Our local "cobol" folder will be mounted here via Docker.
# -------------------------------------------------------------
WORKDIR /work
```

## Add `docker-compose.yml` in `day-01`
```yaml
services:
  cobol:
    build: ./cobol
    working_dir: /work
    volumes:
      - ./cobol:/work
    tty: true
```

### Why both Dockerfile and docker-compose?
It might be overkill for a simple build, but we plan to reuse this pattern in later projects, where it helps compose multiple services (for example, COBOL + PostgreSQL).

This `docker-compose.yml` points its `build` field to `./cobol`, where the `Dockerfile` lives.

## Run the COBOL Service
```bash
# Start a temporary one-off container from the service named cobol
# --rm = remove the container automatically after it finishes
docker compose run --rm cobol

# inside the container, verify the compiler
cobc -V

# exit the container
exit
```

Expected output from `cobc -V`:
```text
cobc (GnuCOBOL) 3.1.2.0
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Keisuke Nishida, Roger While, Ron Norman, Simon Sobisch, Edward Hart
Built     Sep 19 2022 00:26:12
Packaged  Dec 23 2020 12:04:58 UTC
C version "12.2.0"
```

### Why `docker compose run` instead of `docker compose up`?
```bash
# Runs services as long-running apps
docker compose up

# Runs a temporary, interactive container for a task
docker compose run
```

Use `run` when you want to execute a command and finish, for example:
```bash
docker compose run cobol make run
docker compose run cobol bash
```

---

# COBOL Basics Overview
Before building our first program, here is a quick overview of:
- constants
- variables
- if..else..switch
- functions
- loops

## 1) Constants in COBOL
COBOL calls constants **literals**, for example string and numeric literals.

```cobol
78 MAX-AGE      VALUE 99.
78 COMPANY-NAME VALUE "MY COMPANY".
78 TRUE-FLAG    VALUE "Y".
78 FALSE-FLAG   VALUE "N".
```

Modern-language equivalent:
```typescript
const MAX_AGE      = 99
const COMPANY_NAME = "MY COMPANY"
const TRUE_FLAG    = "Y"
const FALSE_FLAG   = "N"
```

> Do you need to memorize that 78 is for constants?
> I am afraid of reading the answer! :)
> Yes, but not as a random number. We should understand what it means.

In COBOL, 78 is not a “type” this is a special level number whose only purpose is to define named constants. So we don’t memorize it like a magic number; we remember the rule:

> Level 78 = named constant

Useful levels:

| Level | Meaning |
| --- | --- |
| 01 | A record / structure |
| 02-49 | Subfields |
| 66 | Renames (alternative view data) |
| 77 | A variable |
| 78 | A constant |
| 88 | A condition (Boolean flag tied to data) |

## 2) Variables in COBOL (Data Items)
Variables are defined in the `WORKING-STORAGE SECTION`.

```cobol
WORKING-STORAGE SECTION.
01  WS-EMPLOYEE-NAME   PIC X(30).
01  WS-AGE             PIC 9(3).
01  WS-SALARY          PIC 9(7)V99.
```

What this means:
- `01` -> level number (main variable)
- `PIC` -> picture clause (data format)
- `X` -> alphanumeric
- `9` -> numeric
- `V` -> implied decimal point

**COBOL Data Types (PIC Clauses)**

| PIC | Meaning | Example |
| --- | --- | --- |
| X | Alphanumeric | `PIC X(10)` |
| 9 | Numeric | `PIC 9(5)` |
| S9 | Signed number | `PIC S9(5)` |
| V | Implied decimal | `PIC 9(5)V99` |
| Z | Zero suppression | `PIC Z(5)` |
| A | Alphabetic only | `PIC A(20)` |

```cobol
WORKING-STORAGE SECTION.
01 WS-AMOUNT PIC 9(5)V99.  *> like 12345.67
```

## 3) IF..ELSE..SWITCH
This is how COBOL handles decision flow using IF .. ELSE

```cobol
IF WS-CHOICE = 1
    DISPLAY "You chose option 1"
ELSE
    DISPLAY "You did not choose 1"
END-IF
```

But if we need multiple conditions?

```cobol
IF WS-EMAIL = SPACES OR WS-PASSWORD = SPACES
    DISPLAY "Email and Password are required"
ELSE
    DISPLAY "Proceeding with login"
END-IF
```

Nested IF (IF inside IF)

```cobol
IF WS-CHOICE = 1
    IF WS-EMAIL NOT = SPACES
        DISPLAY "Valid input"
    ELSE
        DISPLAY "Missing email"
    END-IF
END-IF
```

ELSE IF in COBOL

```cobol
IF WS-CHOICE = 1
    DISPLAY "Auth"
ELSE IF WS-CHOICE = 2
    DISPLAY "Register"
ELSE IF WS-CHOICE = 9
    DISPLAY "Exit"
ELSE
    DISPLAY "Invalid option"
END-IF
```

COBOL’s SWITCH = EVALUATE

```cobol
EVALUATE WS-CHOICE
    WHEN 1
        DISPLAY "Auth selected"
    WHEN 2
        DISPLAY "Register selected"
    WHEN 9
        DISPLAY "Exit selected"
    WHEN OTHER
        DISPLAY "Invalid option"
END-EVALUATE
```

Blending EVALUATE with conditions 

```cobol
EVALUATE TRUE
    WHEN WS-EMAIL = SPACES
        DISPLAY "Email missing"
    WHEN WS-PASSWORD = SPACES
        DISPLAY "Password missing"
    WHEN WS-CHOICE = 9
        DISPLAY "User exited"
    WHEN OTHER
        DISPLAY "All good"
END-EVALUATE
```

Let´s put everything together

```cobol
ACCEPT WS-CHOICE

EVALUATE WS-CHOICE
    WHEN 1
        IF WS-EMAIL = SPACES OR WS-PASSWORD = SPACES
            DISPLAY "Required fields missing"
        ELSE
            CALL "HOME"
        END-IF

    WHEN 2
        MOVE "R" TO WS-SCREEN

    WHEN 9
        MOVE "Y" TO WS-DONE

    WHEN OTHER
        DISPLAY "Invalid option"
END-EVALUATE
```

## 4) Loops in COBOL
COBOL uses `PERFORM` for loops.

### Fixed loop (like `for`)
```cobol
PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
   DISPLAY "VALUE: " WS-I
END-PERFORM.
```

Output:
```text
VALUE: 01
VALUE: 02
VALUE: 03
VALUE: 04
VALUE: 05
VALUE: 06
VALUE: 07
VALUE: 08
VALUE: 09
VALUE: 10
```

Similar to:
```csharp
for (int i = 1; i <= 10; i++)
```

Full code:
```cobol
IDENTIFICATION DIVISION.
  PROGRAM-ID. hello.

DATA DIVISION.
WORKING-STORAGE SECTION.
  77  WS-I PIC 9(2) VALUE 0.

PROCEDURE DIVISION.

  PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
    DISPLAY "VALUE: " WS-I
  END-PERFORM.

  STOP RUN.
```

Online playground:
- https://www.jdoodle.com/execute-cobol-online

### Conditional loop (like `while`)
```cobol
PERFORM UNTIL WS-FLAG = "Y"
   DISPLAY "PROCESSING..."
END-PERFORM.
```

### Infinite loop with `EXIT`
```cobol
PERFORM UNTIL 1 = 2
   IF WS-EOF = "Y"
      EXIT PERFORM
   END-IF
END-PERFORM.
```

## 5) Functions in COBOL
COBOL has many built-in (intrinsic) functions.

```cobol
MOVE FUNCTION CURRENT-DATE TO WS-DATE.
MOVE FUNCTION LENGTH(WS-NAME) TO WS-LEN.
MOVE FUNCTION UPPER-CASE(WS-NAME) TO WS-NAME.
```

Common functions:

| Function | What it does |
| --- | --- |
| `CURRENT-DATE` | Returns system date/time as `YYYYMMDDHHMMSSssssss+hhmm` (21 chars) |
| `LENGTH()` | Length of a string |
| `UPPER-CASE()` | Converts to uppercase |
| `LOWER-CASE()` | Converts to lowercase |
| `TRIM()` | Removes spaces |

### Example: formatted date-time
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO-WORLD.
DATA DIVISION.
    WORKING-STORAGE SECTION.
       01 WS-FORMATTED-DATE PIC X(19).
       01 WS-DATE.
           05 WS-YEAR   PIC 9(4).
           05 WS-MONTH  PIC 9(2).
           05 WS-DAY    PIC 9(2).
           05 WS-HOUR   PIC 9(2).
           05 WS-MINUTE PIC 9(2).
           05 WS-SECOND PIC 9(2).
           05 WS-REST   PIC X(7).

PROCEDURE DIVISION.
    MOVE FUNCTION CURRENT-DATE TO WS-DATE.

     STRING
       WS-DAY    DELIMITED BY SIZE
       "/"
       WS-MONTH  DELIMITED BY SIZE
       "/"
       WS-YEAR   DELIMITED BY SIZE
       " "
       WS-HOUR   DELIMITED BY SIZE
       ":"
       WS-MINUTE DELIMITED BY SIZE
       ":"
       WS-SECOND DELIMITED BY SIZE
    INTO WS-FORMATTED-DATE

    DISPLAY "CURRENT DATE: " WS-FORMATTED-DATE.
    DISPLAY "LEN CURRENT DATE: " FUNCTION LENGTH(WS-FORMATTED-DATE).

    STOP RUN.
```

Sample output:
```text
CURRENT DATE: 08/02/2026 18:44:13
LEN CURRENT DATE: 19
```

### String functions in COBOL

**Concatenate strings**
```cobol
STRING WS-FIRST-NAME  DELIMITED BY SPACE
       " "            DELIMITED BY SIZE
       WS-LAST-NAME   DELIMITED BY SPACE
       INTO WS-FULL-NAME
END-STRING
```

Attention: the COBOL `STRING` statement does not automatically know where each piece of text “ends.”
- `DELIMITED BY SPACE` stops at the first space.
- `DELIMITED BY SIZE` uses the whole field.

**Extract substring**
```cobol
MOVE WS-NAME(1:5) TO WS-SHORT-NAME.
```

**Inspect (search in string)**
```cobol
INSPECT WS-TEXT TALLYING WS-COUNT FOR ALL "A".
```

**Replace characters**
```cobol
INSPECT WS-TEXT REPLACING ALL "A" BY "X".
```

**Full example**
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. SAMPLE1.

DATA DIVISION.
WORKING-STORAGE SECTION.
    78  WS-FIRST-NAME VALUE "RENATO".
    78  WS-LAST-NAME  VALUE "MATOS".
    77  WS-FULL-NAME  PIC X(20) VALUE SPACES.
    77  WS-LEN        PIC 9(2)  VALUE 0.
    77  WS-COUNT-A    PIC 9(2)  VALUE 0.

PROCEDURE DIVISION.
    STRING WS-FIRST-NAME  DELIMITED BY SPACE
           " "            DELIMITED BY SIZE
           WS-LAST-NAME   DELIMITED BY SPACE
      INTO WS-FULL-NAME
    END-STRING

    MOVE FUNCTION LENGTH(WS-FULL-NAME) TO WS-LEN

    DISPLAY "NAME (ORIGINAL): " WS-FULL-NAME
    DISPLAY "SUBSTR: " WS-FULL-NAME(1:5)
    DISPLAY "LENGTH (FIELD): " WS-LEN

    *> --- SEARCH / COUNT EXAMPLE ---
    INSPECT WS-FULL-NAME TALLYING WS-COUNT-A FOR ALL "A"
    DISPLAY "COUNT OF 'A': " WS-COUNT-A

    *> --- REPLACE EXAMPLE ---
    *> Replace all 'A' by 'X'
    INSPECT WS-FULL-NAME REPLACING ALL "A" BY "X"
    DISPLAY "NAME (REPLACED): " WS-FULL-NAME

    STOP RUN.
```

Output:
```text
NAME (ORIGINAL): RENATO MATOS
SUBSTR: RENAT
LENGTH (FIELD): 20
COUNT OF 'A': 02
NAME (REPLACED): RENXTO MXTOS
```

---

# Using `PERFORM` to Invoke Subroutines
For these subroutines, we are using `COMPUTE`.
- `COMPUTE` is COBOL’s general arithmetic statement.
- It’s used when you have an expression, not just a simple `MOVE` or `ADD`.

```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. CALC.

DATA DIVISION.
WORKING-STORAGE SECTION.

    78 A VALUE 10.
    78 B VALUE 3.

    77 WS-ADD  PIC S9(5)V99 VALUE 0.
    77 WS-SUB  PIC S9(5)V99 VALUE 0.
    77 WS-MULT PIC S9(5)V99 VALUE 0.
    77 WS-DIV  PIC S9(5)V99 VALUE 0.

PROCEDURE DIVISION.

    PERFORM ADD-A-B
    PERFORM SUB-A-B
    PERFORM MULT-A-B
    PERFORM DIV-A-B

    DISPLAY "A = " A "  B = " B
    DISPLAY "A + B = " WS-ADD
    DISPLAY "A - B = " WS-SUB
    DISPLAY "A * B = " WS-MULT
    DISPLAY "A / B = " WS-DIV

    STOP RUN.

ADD-A-B.
    COMPUTE WS-ADD = A + B
    *> Stop this paragraph and return to whoever called me.
    EXIT.

SUB-A-B.
    COMPUTE WS-SUB = A - B
    *> Stop this paragraph and return to whoever called me.
    EXIT.

MULT-A-B.
    COMPUTE WS-MULT = A * B
    *> Stop this paragraph and return to whoever called me.
    EXIT.

DIV-A-B.
    IF B = 0
      MOVE 0 TO WS-DIV
    ELSE
      COMPUTE WS-DIV = A / B
    END-IF
    *> Stop this paragraph and return to whoever called me.
    EXIT.
```

More options for math operations:
```cobol
ADD A TO WS-ADD
SUBTRACT B FROM WS-SUB
MULTIPLY A BY WS-MULT
DIVIDE A INTO WS-DIV
```

## Using Parameters for Subroutines
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. CALC.

DATA DIVISION.
WORKING-STORAGE SECTION.
*> 78-level items are constants (they never change)
  78 VAL1 VALUE 10.
  78 VAL2 VALUE 3.

*> 77-level items are normal working variables
  77 WS-ADD  PIC S9(7)V99 VALUE 0.

PROCEDURE DIVISION.
*> Call to another COBOL program (subroutine)
  CALL "ADD-A-B" USING VAL1 VAL2 WS-ADD

  DISPLAY "A = " VAL1 "  B = " VAL2
  DISPLAY "A + B = " WS-ADD

  STOP RUN.
*> We should end the CALC program if we use the same file for demos
END PROGRAM CALC.

IDENTIFICATION DIVISION.
PROGRAM-ID. ADD-A-B.

DATA DIVISION.
*> LINKAGE SECTION is used for parameters received
*> allowing our subroutine to deal with external calls and parameters
LINKAGE SECTION.
  77 L-A      PIC S9(7)V99.
  77 L-B      PIC S9(7)V99.
  77 L-RESULT PIC S9(7)V99.

PROCEDURE DIVISION USING L-A L-B L-RESULT.
  COMPUTE L-RESULT = L-A + L-B
  GOBACK.
END PROGRAM ADD-A-B.
```
