       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCUSTM-READBACK-TEST.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT CUSTOMER-FILE
               ASSIGN TO "test-data/VRCUSTM.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CUSTOMER-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD CUSTOMER-FILE.

       COPY VRCP0101.

       WORKING-STORAGE SECTION.

       01 WS-FILE-STATUS              PIC XX.

       01 WS-EXPECTED-ID              PIC X(10)
                                      VALUE "0000000011".

       PROCEDURE DIVISION.

       1000-MAIN.

           DISPLAY "========================================"
           DISPLAY " VRCUSTM PERSISTENCE TEST"
           DISPLAY "========================================"

           OPEN INPUT CUSTOMER-FILE

           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "CUSTOMER FILE OPEN : FAIL"
               GOBACK
           END-IF

           MOVE WS-EXPECTED-ID
             TO CUSTOMER-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   DISPLAY "CUSTOMER PERSISTENCE : FAIL"

               NOT INVALID KEY

                   DISPLAY "Customer ID   : "
                           CUSTOMER-ID

                   DISPLAY "First Name    : "
                           CUSTOMER-FIRST-NAME

                   DISPLAY "Last Name     : "
                           CUSTOMER-LAST-NAME

                   IF CUSTOMER-FIRST-NAME = "ARUN"
                       AND CUSTOMER-LAST-NAME = "KUMAR"

                       DISPLAY "CUSTOMER DATA READ-BACK : PASS"

                   ELSE

                       DISPLAY "CUSTOMER DATA READ-BACK : FAIL"

                   END-IF
           END-READ

           CLOSE CUSTOMER-FILE

           DISPLAY "========================================"

           GOBACK.
