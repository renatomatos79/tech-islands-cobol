# Day 03 - Input Validation and Modular COBOL

## Goal
Build a small interactive program that:
- greets the user
- reads two numbers
- validates input (digits only + range check)
- adds the numbers using a reusable module

This day introduces **input validation** and **composition across 3 modules**
and of course we are learning how to reuse our functions.

---

# Folder Focus
The logic lives in `main.cob` and three modules in `cobol/src/modules/`:
- `read_number.cob` (`READNUMBER`) - prompts and validates numeric input
- `is_number.cob` (`ISNUMBER`) - checks if input text is digits only
- `math_utils.cob` (`MATHUTILS`) - performs the sum

Copybooks provide shared data:
- `constants.cpy` - app name and separator line
- `types.cpy` - working variables (numbers, prompt, min/max)

---

# Program Flow (main.cob)
1. Display app header (`WS-APP-NAME`, `WS-SEP`).
2. Ask for the user's name and greet them.
3. Ask for Num1 (0-9999), using `READNUMBER`.
4. If Num1 is 0, exit.
5. Ask for Num2 (0-9999), using `READNUMBER`.
6. If Num2 is 0, exit.
7. Call `MATHUTILS` to compute the sum.
8. Display the result.

Key calls in `main.cob`:
```cobol
MOVE "Enter Num1 (0-9999, 0=Exit): " TO WS-PROMPT
CALL "READNUMBER" USING WS-PROMPT WS-MIN WS-MAX WS-NUM1

CALL "MATHUTILS" USING WS-NUM1 WS-NUM2 WS-RESULT
```

---

# Module 1 - `READNUMBER` (Input + Validation)
`READNUMBER` is a loop that keeps asking until input is valid:

1. Displays the prompt from the caller.
2. Reads raw text into `WS-IN-TEXT`.
3. Calls `ISNUMBER` to check digits-only.
4. Converts text to a number with `NUMVAL`.
5. Validates range `L-MIN .. L-MAX`.

If any rule fails, it prints an error and asks again.

Core logic:
```cobol
CALL "ISNUMBER" USING WS-IN-TEXT WS-IS-NUM

IF WS-IS-NUM = "Y"
    MOVE FUNCTION NUMVAL(WS-IN-TEXT) TO WS-TMP
    IF WS-TMP >= L-MIN AND WS-TMP <= L-MAX
        MOVE WS-TMP TO L-OUT-NUM
        MOVE "Y" TO WS-OK
    ELSE
        DISPLAY "Invalid range. Use " L-MIN " .. " L-MAX "."
    END-IF
ELSE
    DISPLAY "Invalid input. Digits only."
END-IF
```

---

# Module 2 - `ISNUMBER` (Digits Only)
`ISNUMBER` trims spaces and validates that every character is between `"0"` and `"9"`.

- Returns `"Y"` if the trimmed input is digits only.
- Returns `"N"` for empty input or any non-digit character.

This isolates **string validation** so the rest of the program stays clean.

---

# Module 3 - `MATHUTILS` (Business Logic)
`MATHUTILS` is a small reusable program that adds two numbers.

```cobol
PROCEDURE DIVISION USING L-A L-B L-SUM.
    COMPUTE L-SUM = L-A + L-B
    GOBACK.
```

The main program doesn't care how the sum is computed - it just calls the module.

---

# Why this structure?
- **Validation is isolated** in `READNUMBER` and `ISNUMBER`.
- **Business logic is isolated** in `MATHUTILS`.
- **Main stays readable**, focused on the app flow.

Once we have three modules, we must not forget to udpate the Makefile in order to compile them together

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
		$(SRC)/modules/math_utils.cob \
		$(SRC)/modules/is_number.cob \
		$(SRC)/modules/read_number.cob
```

---

# Compile and Run (from macOS)
```bash
docker compose run --rm cobol make crun
```

Your output should be something like this  (dealing with invalid input content=

```bash
----------------------------------------
COBOL Playground
----------------------------------------
Your name: Renato Matos
Hello, Renato Matos                  
----------------------------------------
Enter Num1 (0-9999, 0=Exit):            bla
Invalid input. Digits only.
Enter Num1 (0-9999, 0=Exit):            bla bla
Invalid input. Digits only.
Enter Num1 (0-9999, 0=Exit):            20
Enter Num2 (0-9999, 0=Exit):            15
----------------------------------------
Sum = 000035
----------------------------------------
```
