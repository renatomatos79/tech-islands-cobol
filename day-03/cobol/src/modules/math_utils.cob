       IDENTIFICATION DIVISION.
       PROGRAM-ID. MATHUTILS.             

       DATA DIVISION.
       LINKAGE SECTION.                 
       01 L-A        PIC 9(4).           
       01 L-B        PIC 9(4).         
       01 L-SUM      PIC 9(6).          

       PROCEDURE DIVISION USING L-A L-B L-SUM.
           COMPUTE L-SUM = L-A + L-B    
           GOBACK.

       END PROGRAM MATHUTILS. 
