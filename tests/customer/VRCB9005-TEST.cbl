       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB9005-TEST.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-MESSAGE-CODE          PIC X(12).

       COPY VRCP9003.

       PROCEDURE DIVISION.

       1000-MAIN.

           MOVE "VR-CUST-001"
             TO WS-MESSAGE-CODE

           DISPLAY "========================================"
           DISPLAY " VRCB9005 MESSAGE LOOKUP TEST"
           DISPLAY "========================================"
           DISPLAY "Message Code : "
                   WS-MESSAGE-CODE

           CALL "VRCB9005"
                USING WS-MESSAGE-CODE
                      OPERATION-RESULT

           DISPLAY "Return Code  : "
                   OPERATION-RETURN-CODE

           DISPLAY "Severity     : "
                   OPERATION-SEVERITY

           DISPLAY "Error Code   : "
                   OPERATION-ERROR-CODE

           DISPLAY "Message      : "
                   OPERATION-RETURN-MESSAGE

           IF OPERATION-RETURN-CODE = 00
               AND OPERATION-ERROR-CODE = "VR-CUST-001"
               AND OPERATION-RETURN-MESSAGE = "Customer already exists"
               DISPLAY "MESSAGE LOOKUP SUCCESS PATH : PASS"
           ELSE
               DISPLAY "MESSAGE LOOKUP SUCCESS PATH : FAIL"
           END-IF

           DISPLAY "========================================"

           GOBACK.
