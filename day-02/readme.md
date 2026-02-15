# Day 02 - First COBOL Project, Modules, and Makefile

## Context
In the previous folder we introduced the COBOL compiler. Today we will build our first project, work with modules, and run simple task automation using a Makefile.

**Attention**
Don't forget to install the extension and required tools mentioned in Day 01.

## Create the Project Folders
```bash
mkdir day-02 && cd day-02
mkdir -p cobol/src/copybooks cobol/src/modules cobol/bin
```

**Target folder structure**
```text
day-02
  cobol
    bin
    src
      copybooks
        constants.cpy
        types.cpy
      modules
        math_utils.cob
      main.cob
    Dockerfile
  docker-compose.yml
  readme.md
```

---

# File Extensions: `.cob` vs `.cpy`
These extensions exist for organization, reuse, and maintenance, not for the compiler itself.

| Extension | Meaning | Role in a COBOL project |
| --- | --- | --- |
| `.cob` | COBOL program source | A runnable program or module compiled by the compiler |
| `.cpy` | Copybook | A shared include file copied into `.cob` files (not compiled alone) |

## What `.cob` is
A complete COBOL program (or a callable module), for example:
- `main.cob`
- `unit.cob`
- `auth.cob`

Typical structure inside a `.cob` file:
```cobol
IDENTIFICATION DIVISION.
    PROGRAM-ID. hello.
    *> IDENTIFICATION DIVISION:
    *>   - Tells the compiler what this program is called.

    DATA DIVISION.
    WORKING-STORAGE SECTION.
    *> DATA DIVISION:
    *>   - This is where all variables and data used by the program are defined.
    *>
    *> WORKING-STORAGE SECTION:
    *>   - Contains variables that belong only to THIS program.
    *>   - They exist while the program is running.

    PROCEDURE DIVISION.
    *> PROCEDURE DIVISION:
    *>   - This is the "logic" of the program.

       DISPLAY "Hello".
       *> DISPLAY prints text to the console (screen/output).

       STOP RUN.
    END PROGRAM hello.
```

The `.cob` file can be compiled directly using `cobc`:
```bash
# -x is used to specify we intend to create an executable program, not just compiled objects
# -o is used to mention the output file name (program) "app"
# Compile this file: main.cob
cobc -x -o app main.cob
```

So you can think of `.cob` as:
- `.cs` in C#
- `.java` in Java
- `.py` in Python

## What `.cpy` is (Copybook)
A COPYBOOK is a shared include file. Historically, mainframes stored these definitions in libraries like `SYS1.COBOL.COPYBOOK`, and developers started calling them “copybooks.”

A `.cpy` file is not a program. It is a reusable snippet of COBOL code that gets inserted into many programs at compile time.

Example `constants.cpy`:
```cobol
78  WS-SEP VALUE "--------------------------------".
78  WS-APP-NAME VALUE "COBOL System".
```

Import it inside a `.cob` file:
```cobol
COPY "src/copybooks/constants.cpy".
```

The compiler behaves as if those lines were typed directly inside `main.cob`.

So `.cpy` is like:
- `#include` in C
- an import of a shared file
- a shared “header” / “definitions” file

If you still have questions, check the notes in `day-01`.

---

# Add a Dockerfile in `day-02/cobol`
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

# Add `docker-compose.yml` in `day-02`
```yaml
services:
  cobol:
    build: ./cobol
    working_dir: /work
    volumes:
      - ./cobol:/work
    tty: true
```

## Run the COBOL Service
```bash
# Start a temporary one-off container from the service named cobol
# --rm = remove the container automatically after it finishes
docker compose run --rm cobol

# inside the container, verify the compiler version
cobc -V

# exit the container
exit
```

Expected output from `cobc -V`:
```bash
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

# Add a Makefile in `day-02/cobol`
```makefile
# ---------------------------------------------------------
# VARIABLES (so we don't repeat ourselves later)
# ---------------------------------------------------------

# Name of the COBOL compiler command
COBC = cobc

# Folder where our app source files live
SRC = src

# Folder where compiled binaries will be placed
BIN = bin


# ---------------------------------------------------------
# DEFAULT TARGET
# ---------------------------------------------------------
# When we just type:  make
# this is the target that will run automatically
# It says: "build the file bin/app"
# ---------------------------------------------------------
all: $(BIN)/app


# ---------------------------------------------------------
# HOW TO BUILD bin/app
# ---------------------------------------------------------
# This is the actual compilation rule.
# It says:
#   To create bin/app, do the following steps:
# ---------------------------------------------------------
$(BIN)/app:
	# Ensure the output folder exists
	mkdir -p $(BIN)

	# Compile the COBOL programs into one executable:
	# -x          = create an executable program
	# -o bin/app  = name of the output file
	# Then we list all COBOL source files to compile together
	$(COBC) -x -o $(BIN)/app \
		$(SRC)/main.cob \
		$(SRC)/modules/math_utils.cob


# ---------------------------------------------------------
# RUN THE PROGRAM
# ---------------------------------------------------------
# When we type:  make run
# it will:
# 1) First run "make all" (compile if needed)
# 2) Then execute the program
# ---------------------------------------------------------
run: all
	./$(BIN)/app


# ---------------------------------------------------------
# CLEAN TARGET
# ---------------------------------------------------------
# When we type:  make clean
# it deletes all compiled files in bin/
# Useful when we want a fresh rebuild
# ---------------------------------------------------------
clean:
	rm -rf $(BIN)/*


# ---------------------------------------------------------
# CLEAN + RUN IN ONE COMMAND
# ---------------------------------------------------------
# When you type:  make crun
# it will:
# 1) run "make clean"
# 2) then run "make run"
# ---------------------------------------------------------
crun: clean run
```

---

# Create Copybooks (constants + shared data)
Create `constants.cpy` in `cobol/src/copybooks/`:

```cobol
       78  WS-SEP      VALUE "----------------------------------------".
       78  WS-APP-NAME VALUE "COBOL Playground".
```

**Do we need these blank spaces?**
Short answer: yes. COBOL historically uses fixed-format columns.

Historically, every COBOL line had this structure:

| Columns | Name | What goes here |
| --- | --- | --- |
| 1–6 | Sequence area | Line numbers (usually blank today) |
| 7 | Indicator area | `*` for comment, `/` for page break, etc. |
| 8–11 | Area A | Level numbers (01, 05, 10, 78, etc.) |
| 12–72 | Area B | The actual COBOL statements |
| 73–80 | Ignored | Usually blank |

If you open this file using the extension mentioned in the beginning, you will see vertical column guides.

```cobol
       78  WS-SEP      VALUE "----------------------------------------".
       78  WS-APP-NAME VALUE "COBOL Playground".
```

**Therefore:** these spaces are not cosmetic, they are structural.

## Create `types.cpy` in `cobol/src/copybooks/`
```cobol
       77  WS-NUM1        PIC 9(4) VALUE 0.
       77  WS-NUM2        PIC 9(4) VALUE 0.
       77  WS-RESULT      PIC 9(6) VALUE 0.
       77  WS-NAME        PIC X(30) VALUE SPACES.
```

---

# Create a Module (Reusable Program)
Create `math_utils.cob` in `cobol/src/modules/`:

```cobol
       IDENTIFICATION DIVISION.
       *> this is our module name that is going to be referenced using makefile
       PROGRAM-ID. MATHUTILS.

       DATA DIVISION.

       *> Data received from the calling program
       *> (like parameters in a function)
       LINKAGE SECTION.
       01 L-A        PIC 9(4).             *> First number passed in (0–9999)
       01 L-B        PIC 9(4).             *> Second number passed in (0–9999)
       01 L-SUM      PIC 9(6).             *> Result to be returned (up to 999999)

       PROCEDURE DIVISION USING L-A L-B L-SUM.
           *> The USING clause means:
           *> "These three values will come from another program"

           COMPUTE L-SUM = L-A + L-B

           *> Return control to the caller
           GOBACK.

      END PROGRAM MATHUTILS.
```

---

# Main Program (variables + constants + copybooks + `CALL`)
`cobol/src/main.cob`

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.                     *> program name

       DATA DIVISION.
       WORKING-STORAGE SECTION.             *> Where variables live
       COPY "src/copybooks/constants.cpy".  *> Import shared constants
       COPY "src/copybooks/types.cpy".      *> Import shared data structures

       PROCEDURE DIVISION.                  *> Here the logic starts

           DISPLAY WS-SEP                   *> Print a separator line
           DISPLAY WS-APP-NAME              *> Show application title
           DISPLAY WS-SEP

           *> Print this text, but DO NOT move the cursor to the next line
           DISPLAY "Your name: " WITH NO ADVANCING
           ACCEPT WS-NAME                   *> Read user input into WS-NAME
           DISPLAY "Hello, " WS-NAME        *> Greet the user

           DISPLAY WS-SEP
           DISPLAY "Enter Num1 (0-9999): " WITH NO ADVANCING
           ACCEPT WS-NUM1                   *> Read first number

           DISPLAY "Enter Num2 (0-9999): " WITH NO ADVANCING
           ACCEPT WS-NUM2                   *> Read second number

           *> Call another program to add numbers
           CALL "MATHUTILS" USING WS-NUM1 WS-NUM2 WS-RESULT

           *> Show result
           DISPLAY "Sum = " WS-RESULT
           DISPLAY WS-SEP

           STOP RUN.

      END PROGRAM MAIN.
```

But, in the `main.cob` file, we are not importing this module `MATHUTILS`? 
How compiler knows `MATHUTILS`resides into the `math_utils.cob` file?
Remember in the `Makefile` we have these lines in order to compile them together. 

```bash
$(BIN)/app:
	# Ensure the output folder exists
	mkdir -p $(BIN)

	# Compile the COBOL programs into one executable:
	# -x          = create an executable program
	# -o bin/app  = name of the output file
	# Then we list all COBOL source files to compile together
	$(COBC) -x -o $(BIN)/app \
		$(SRC)/main.cob \
		$(SRC)/modules/math_utils.cob
```

---

# Compile and Run
So, finally, let´s compile and run

```bash
docker compose run --rm cobol make crun
```

Your output should be something like this

```bash
----------------------------------------
COBOL Playground
----------------------------------------
Your name: renato matos
Hello, renato matos                  
----------------------------------------
Enter Num1 (0-9999): 10 
Enter Num2 (0-9999): 20
Sum = 000030
----------------------------------------
```



