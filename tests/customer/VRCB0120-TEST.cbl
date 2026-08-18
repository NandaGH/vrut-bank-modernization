       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB0120-TEST.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  WS-SEQUENCE-TYPE       PIC X(10).
       01  WS-GENERATED-NUMBER    PIC 9(10).

       01  WS-CUSTOMER-FIRST      PIC 9(10).
       01  WS-CUSTOMER-SECOND     PIC 9(10).
       01  WS-CUSTOMER-THIRD      PIC 9(10).
       01  WS-ACCOUNT-FIRST       PIC 9(10).
       01  WS-ACCOUNT-SECOND      PIC 9(10).

       PROCEDURE DIVISION.

       1000-MAIN.

           DISPLAY "========================================"
           DISPLAY " VRCB0120 SEQUENCE SERVICE TEST"
           DISPLAY "========================================"

           MOVE "CUSTOMER"
             TO WS-SEQUENCE-TYPE

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO WS-CUSTOMER-FIRST

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO WS-CUSTOMER-SECOND

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO WS-CUSTOMER-THIRD

           DISPLAY "CUSTOMER #1 : " WS-CUSTOMER-FIRST
           DISPLAY "CUSTOMER #2 : " WS-CUSTOMER-SECOND
           DISPLAY "CUSTOMER #3 : " WS-CUSTOMER-THIRD

           IF WS-CUSTOMER-SECOND = WS-CUSTOMER-FIRST + 1
              AND WS-CUSTOMER-THIRD = WS-CUSTOMER-SECOND + 1
               DISPLAY "CUSTOMER SEQUENCE : PASS"
           ELSE
               DISPLAY "CUSTOMER SEQUENCE : FAIL"
           END-IF

           MOVE "ACCOUNT"
             TO WS-SEQUENCE-TYPE

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO WS-ACCOUNT-FIRST

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO WS-ACCOUNT-SECOND

           DISPLAY "ACCOUNT  #1 : " WS-ACCOUNT-FIRST
           DISPLAY "ACCOUNT  #2 : " WS-ACCOUNT-SECOND

           IF WS-ACCOUNT-FIRST = 1
              AND WS-ACCOUNT-SECOND = 2
               DISPLAY "ACCOUNT SEQUENCE  : PASS"
           ELSE
               DISPLAY "ACCOUNT SEQUENCE  : FAIL"
           END-IF

           MOVE "CUSTOMER"
             TO WS-SEQUENCE-TYPE

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           DISPLAY "CUSTOMER #4 : " WS-GENERATED-NUMBER

           IF WS-GENERATED-NUMBER = WS-CUSTOMER-THIRD + 1
               DISPLAY "CUSTOMER REENTRY  : PASS"
           ELSE
               DISPLAY "CUSTOMER REENTRY  : FAIL"
           END-IF.

           DISPLAY "========================================".

           GOBACK.
