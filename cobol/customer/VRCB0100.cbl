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

       01 WS-SEQUENCE-TYPE            PIC X(10).
       01 WS-GENERATED-NUMBER         PIC 9(10).

       COPY VRCP9002.

       LINKAGE SECTION.

       COPY VRCP0101
           REPLACING CUSTOMER-RECORD
           BY LK-CUSTOMER-RECORD.

       PROCEDURE DIVISION
           USING LK-CUSTOMER-RECORD.

       1000-MAIN.

           MOVE LK-CUSTOMER-RECORD
             TO CUSTOMER-RECORD

           PERFORM 2000-INITIALIZE

           PERFORM 3000-VALIDATE-CUSTOMER

             IF VALIDATION-RETURN-CODE = ZERO

              PERFORM 4000-GENERATE-CUSTOMER-ID

              PERFORM 5000-CHECK-DUPLICATE

              PERFORM 6000-WRITE-CUSTOMER

           END-IF
           
           PERFORM 9000-TERMINATE

               MOVE CUSTOMER-RECORD
                 TO LK-CUSTOMER-RECORD

           GOBACK.

       2000-INITIALIZE.

           MOVE "CUSTOMER"
             TO WS-SEQUENCE-TYPE

           OPEN I-O CUSTOMER-FILE.

       3000-VALIDATE-CUSTOMER.

           CALL "VRCB0110"
                USING CUSTOMER-RECORD
                      VALIDATION-RESULT.

      * Customer ID Generation - Next Version
      * Duplicate Check        - Next Version
      * Customer Write         - Next Version
       
       4000-GENERATE-CUSTOMER-ID.

           CALL "VRCB0120"
                USING WS-SEQUENCE-TYPE
                      WS-GENERATED-NUMBER

           MOVE WS-GENERATED-NUMBER
             TO CUSTOMER-ID IN CUSTOMER-RECORD.

       5000-CHECK-DUPLICATE.

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
      * Duplicate Customer ID
                   CONTINUE
           END-READ.

       6000-WRITE-CUSTOMER.

           WRITE CUSTOMER-RECORD
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-WRITE.

       9000-TERMINATE.

           CLOSE CUSTOMER-FILE.
