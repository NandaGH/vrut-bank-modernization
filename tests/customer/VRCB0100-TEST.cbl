       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB0100-TEST.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT CUSTOMER-FILE
               ASSIGN TO "test-data/VRCUSTM.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS READBACK-CUSTOMER-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD CUSTOMER-FILE.

       COPY VRCP0101
           REPLACING CUSTOMER-RECORD
           BY READBACK-CUSTOMER-RECORD.

       WORKING-STORAGE SECTION.

       COPY VRCP0101.

       01 WS-FILE-STATUS              PIC XX.

       01 WS-EXPECTED-ID              PIC X(10).

       PROCEDURE DIVISION.

       1000-MAIN.

           MOVE SPACES
             TO CUSTOMER-RECORD

           MOVE "IN"
             TO CUSTOMER-TYPE

           MOVE "MR"
             TO CUSTOMER-TITLE

           MOVE "ARUN"
             TO CUSTOMER-FIRST-NAME

           MOVE "KUMAR"
             TO CUSTOMER-LAST-NAME

           MOVE "M"
             TO CUSTOMER-GENDER

           MOVE "1990-01-15"
             TO CUSTOMER-DATE-OF-BIRTH

           MOVE "9876543210"
             TO CUSTOMER-MOBILE-NUMBER

           MOVE "arun.kumar@example.com"
             TO CUSTOMER-EMAIL-ID

           MOVE "1001"
             TO CUSTOMER-HOME-BRANCH

           MOVE "A"
             TO CUSTOMER-STATUS

           DISPLAY "========================================"
           DISPLAY " VRCB0100 CUSTOMER CREATION TEST"
           DISPLAY "========================================"

           DISPLAY "Input First Name : "
                   CUSTOMER-FIRST-NAME

           DISPLAY "Input Last Name  : "
                   CUSTOMER-LAST-NAME

           CALL "VRCB0100"
                USING CUSTOMER-RECORD

           MOVE CUSTOMER-ID
             TO WS-EXPECTED-ID

           DISPLAY "Generated ID     : "
                   CUSTOMER-ID

           IF CUSTOMER-ID NOT = SPACES
               DISPLAY "CUSTOMER ID GENERATION : PASS"
           ELSE
               DISPLAY "CUSTOMER ID GENERATION : FAIL"
           END-IF

           PERFORM 2000-VERIFY-PERSISTENCE

           DISPLAY "========================================"

           GOBACK.

       2000-VERIFY-PERSISTENCE.

           OPEN INPUT CUSTOMER-FILE

           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "CUSTOMER FILE OPEN : FAIL"
               GOBACK
           END-IF

           MOVE WS-EXPECTED-ID
             TO READBACK-CUSTOMER-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   DISPLAY "CUSTOMER PERSISTENCE : FAIL"

               NOT INVALID KEY
                   DISPLAY "CUSTOMER PERSISTENCE : PASS"

                   IF READBACK-CUSTOMER-FIRST-NAME
                         = CUSTOMER-FIRST-NAME
                       AND READBACK-CUSTOMER-LAST-NAME
                         = CUSTOMER-LAST-NAME

                       DISPLAY "CUSTOMER DATA READ-BACK : PASS"

                   ELSE

                       DISPLAY "CUSTOMER DATA READ-BACK : FAIL"

                   END-IF
           END-READ

           CLOSE CUSTOMER-FILE.