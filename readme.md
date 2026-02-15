<p align="center">
  <img src="https://raw.githubusercontent.com/renatomatos79/tech-islands-cobol/main/logo.png" alt="adventure">
</p>

---

## Summary Session
This repository documents a progressive COBOL learning path across 7 days, moving from setup and language basics to console interfaces, and database integration.

So far, the journey includes:
- Environment setup with Docker and Make
- Core COBOL syntax and program structure
- Modular design with copybooks and reusable routines
- Input validation and user flow control
- Transition to free-format COBOL and `SCREEN SECTION`
- File management features in console applications
- PostgreSQL authentication/registration workflows
- Evolution from shell-based SQL calls to JDBC integration (coming soon)

Together, these steps form a practical foundation for building real COBOL applications, from simple terminal programs to database-connected systems.

## Day 01
Intro to COBOL tooling and setup with Docker + Make. Creates the base folder structure and walks through COBOL fundamentals: constants, variables, loops, and functions.

## Day 02
Builds the first COBOL project with modules and copybooks. Explains `.cob` vs `.cpy`, sets up a Makefile, and compiles a small program that uses shared definitions.

## Day 03
Adds input validation and modular flow. Introduces three modules (`READNUMBER`, `ISNUMBER`, `MATHUTILS`) to validate numeric input and reuse logic.

## Day 04
Shows console UI navigation between Auth and Register screens without a database. Demonstrates field-by-field editing and simple screen switching logic.

## Day 05
Moves to free-form COBOL (`-free`) and introduces `SCREEN SECTION` for structured console UIs. Adds basic validation and a simple Home/Menu flow.

## Day 06
In this project we have a simple GnuCOBOL “free format” console app designed to:
- Create a new .txt file and write content
- List text files in a folder
- View a file content
- Delete a file

## Day 07
Extends the UI with PostgreSQL integration. Auth and Register now validate against a real database using COBOL DB modules and `psql` execution.

## Day 08
Let´s improve the previous code from Day-07 by adding a JDBC driver rather than using `psql` command line. This allows us to execute SQL queries directly from COBOL without shelling out.

Under construction... stay tuned for more updates!

:)

