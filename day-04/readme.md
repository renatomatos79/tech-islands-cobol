# Day 04 - Console UI Navigation (From Auth to Register)

## Goal
Demonstrate how to switch between two console "screens" (Auth and Register) and edit fields one by one. This is **UI flow only**. 
Neither database nor free-style editing YET.

---

# What this demo shows
- a simple console menu
- switching screens using a state flag
- editing individual fields with `ACCEPT`
- masking passwords
- keeping the program structure modular

The entry point is `main.cob`, which calls `UIAUTHREG`.

For this project the main.cob file is extremelly simple.
---

# Program Flow
1. `main.cob` calls `UIAUTHREG`.
2. `UIAUTHREG` loops until the user exits.
3. A screen flag (`WS-SCREEN`) decides whether to show Auth or Register.
4. Each screen offers menu actions to edit specific fields.
5. Option `[4]` on Auth moves to Register.
6. Option `[8]` on Register moves back to Auth.

---

# Screen State (Auth vs Register)
The current screen is controlled by `WS-SCREEN` (from `types.cpy`):

```cobol
01  WS-SCREEN          PIC X VALUE "A".
    88 SCREEN-AUTH     VALUE "A".
    88 SCREEN-REG      VALUE "R".
```

Remember we shoud use `01` level to define a group item (a record or structure).
For this demo, we are combining `01` with `88` (condional label)
We can think of it like this in modern terms:

```cobol
WS-SCREEN = "A"

SCREEN-AUTH = (WS-SCREEN == "A")
SCREEN-REG  = (WS-SCREEN == "R")
```


In `UIAUTHREG`, the main loop checks this flag:

```cobol
*> remember this variable was init with "N"
PERFORM UNTIL WS-DONE = "Y"
    *> using the conditional label (WS-SCREEN == "A")
    IF SCREEN-AUTH
        *> it goes to AUTH-SCREEN subroutine
        PERFORM AUTH-SCREEN
    ELSE
        PERFORM REG-SCREEN
    END-IF
END-PERFORM
```

---

# Auth Screen (`AUTH-SCREEN`)
- Displays email and password (masked).
- Lets you edit Email or Password.
- Option `[4] Register` switches to the Register screen.
- Option `[9] Exit` ends the program.

Switching to Register:
```cobol
WHEN 4
    MOVE SPACE TO WS-REG-EMAIL
    MOVE SPACE TO WS-REG-PASS
    MOVE "R"   TO WS-SCREEN
```

---

# Register Screen (`REG-SCREEN`)
- Displays username, email, and password (masked).
- Lets you edit each field individually.
- Option `[8] Back` returns to Auth.
- Option `[9] Exit` ends the program.

Switching back to Auth:
```cobol
WHEN 8
    MOVE SPACE TO WS-EMAIL
    MOVE SPACE TO WS-PASSWORD
    MOVE "A"   TO WS-SCREEN
```

---

# Field-by-Field Editing
This demo intentionally edits one field at a time. For example:

```cobol
DISPLAY "Email: " WITH NO ADVANCING
ACCEPT WS-EMAIL
```

The same pattern is used for username and password.

---

# Compile and Run (from macOS)
```bash
docker compose run --rm cobol make crun
```

# Sample Screens

Auth screens:
```bash
----------------------------------------
AUTH
----------------------------------------
Email    : renato.matos79@gmail.com
Password : ******
----------------------------------------
[1] Edit Email
[2] Edit Password (6 chars)
[3] Auth (not implemented)
[4] Register
[9] Exit
Choose:
```

Register screens:
```bash
----------------------------------------
REGISTER
----------------------------------------
Username : renato.matos
Email    : renato.matos79@gmail.com
Password : ******
----------------------------------------
[1] Edit Username
[2] Edit Email
[3] Edit Password (6 chars)
[4] Save (not implemented)
[8] Back
[9] Exit
Choose:
```

