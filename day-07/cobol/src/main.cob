       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "src/copybooks/constants.cpy".
       COPY "src/copybooks/types.cpy".

       PROCEDURE DIVISION.
           CALL "AUTHREG"
           STOP RUN.
