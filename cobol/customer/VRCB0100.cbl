       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB0100.

      *****************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * PROGRAM      : VRCB0100
      * TRANSACTION  : CUSTADD
      * DESCRIPTION  : Customer Maintenance
      *
      * PURPOSE
      * Create a new customer in Customer Master File.
      *****************************************************************

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

       COPY VRCP9002.

       PROCEDURE DIVISION.

       1000-MAIN.

           PERFORM 2000-INITIALIZE

           PERFORM 3000-VALIDATE-CUSTOMER

             IF VALIDATION-RETURN-CODE = ZERO

              PERFORM 4000-GENERATE-CUSTOMER-ID

              PERFORM 5000-CHECK-DUPLICATE

           END-IF
           
           PERFORM 9000-TERMINATE

           GOBACK.

       2000-INITIALIZE.

           OPEN I-O CUSTOMER-FILE.

       3000-VALIDATE-CUSTOMER.

           CALL "VRCB0110"
                USING CUSTOMER-RECORD
                      VALIDATION-RESULT.

      * Customer ID Generation - Next Version
      * Duplicate Check        - Next Version
      * Customer Write         - Next Version
       
       4000-GENERATE-CUSTOMER-ID.

      * Read sequence file (next iteration)

      * Generate next customer number

      * Move generated number to CUSTOMER-ID


       5000-CHECK-DUPLICATE.

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
      * Duplicate Customer ID
           END-READ.

       9000-TERMINATE.

           CLOSE CUSTOMER-FILE.