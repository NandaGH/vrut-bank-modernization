       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB0120.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

              SELECT SEQUENCE-FILE
               ASSIGN TO "test-data/VRSEQM.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS SEQUENCE-TYPE
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD  SEQUENCE-FILE.

           COPY VRCP9004.

       WORKING-STORAGE SECTION.

       01 WS-FILE-STATUS              PIC XX.

       LINKAGE SECTION.

       01 LK-SEQUENCE-TYPE            PIC X(10).

       01 LK-GENERATED-NUMBER         PIC 9(10).

       PROCEDURE DIVISION
           USING LK-SEQUENCE-TYPE
                 LK-GENERATED-NUMBER.

       1000-MAIN.

           OPEN I-O SEQUENCE-FILE
           IF WS-FILE-STATUS = "35"
              PERFORM 1100-CREATE-SEQUENCE-FILE
           END-IF

           IF WS-FILE-STATUS NOT = "00"
              GO TO 9000-TERMINATE
           END-IF

           PERFORM 2000-READ-SEQUENCE

           PERFORM 3000-INCREMENT-SEQUENCE

           PERFORM 4000-UPDATE-SEQUENCE

           CLOSE SEQUENCE-FILE

       GOBACK.

       1100-CREATE-SEQUENCE-FILE.

           CLOSE SEQUENCE-FILE

           OPEN OUTPUT SEQUENCE-FILE

           IF WS-FILE-STATUS NOT = "00"
              GO TO 9000-TERMINATE
           END-IF

              MOVE LK-SEQUENCE-TYPE
                TO SEQUENCE-TYPE

              MOVE 1
                TO NEXT-NUMBER

           WRITE VRSEQM-REC

           CLOSE SEQUENCE-FILE

           OPEN I-O SEQUENCE-FILE.

       2000-READ-SEQUENCE.

           MOVE LK-SEQUENCE-TYPE
             TO SEQUENCE-TYPE

           READ SEQUENCE-FILE
                INVALID KEY
                CONTINUE
           END-READ.


       3000-INCREMENT-SEQUENCE.

           IF WS-FILE-STATUS = "23"
              MOVE 1
                TO NEXT-NUMBER
           END-IF

           MOVE NEXT-NUMBER
             TO LK-GENERATED-NUMBER

           ADD 1
           TO NEXT-NUMBER.


       4000-UPDATE-SEQUENCE.

           IF WS-FILE-STATUS = "23"
               WRITE VRSEQM-REC
                INVALID KEY
                    CONTINUE
               END-WRITE
           ELSE
               REWRITE VRSEQM-REC
                       INVALID KEY
                       CONTINUE
               END-REWRITE
           END-IF.

       9000-TERMINATE.

           IF WS-FILE-STATUS = "00"
              CLOSE SEQUENCE-FILE
           END-IF

           GOBACK.
