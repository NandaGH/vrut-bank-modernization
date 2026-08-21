       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRCB9005.

      *****************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * PROGRAM      : VRCB9005
      * DESCRIPTION  : Enterprise Message Lookup
      *
      * PURPOSE
      * Retrieve a standard enterprise message by message code.
      *****************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT MESSAGE-FILE
               ASSIGN TO "test-data/VRMESSG.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS MESSAGE-CODE
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD MESSAGE-FILE.

       COPY VRCP9005.

       WORKING-STORAGE SECTION.

       01 WS-FILE-STATUS              PIC XX.

       LINKAGE SECTION.

       01 LK-MESSAGE-CODE             PIC X(12).

       COPY VRCP9003
           REPLACING OPERATION-RESULT
           BY LK-OPERATION-RESULT.

       PROCEDURE DIVISION
           USING LK-MESSAGE-CODE
                 LK-OPERATION-RESULT.

       1000-MAIN.

           MOVE ZERO
             TO OPERATION-RETURN-CODE

           MOVE "S"
             TO OPERATION-SEVERITY

           MOVE SPACES
             TO OPERATION-ERROR-CODE
                OPERATION-RETURN-MESSAGE

           OPEN INPUT MESSAGE-FILE

           IF WS-FILE-STATUS NOT = "00"
               MOVE 99
                 TO OPERATION-RETURN-CODE
               MOVE "E"
                 TO OPERATION-SEVERITY
               MOVE "VR-COM-001"
                 TO OPERATION-ERROR-CODE
               MOVE SPACES
                 TO OPERATION-RETURN-MESSAGE
               GOBACK
           END-IF

           MOVE LK-MESSAGE-CODE
             TO MESSAGE-CODE

           READ MESSAGE-FILE
                   INVALID KEY
                   MOVE 01
                     TO OPERATION-RETURN-CODE
                   MOVE "E"
                     TO OPERATION-SEVERITY
                   MOVE "VR-COM-002"
                     TO OPERATION-ERROR-CODE

                   MOVE "VR-COM-002"
                     TO MESSAGE-CODE

                   READ MESSAGE-FILE
                       INVALID KEY
                           MOVE SPACES
                             TO OPERATION-RETURN-MESSAGE

                       NOT INVALID KEY
                           MOVE MESSAGE-TEXT
                             TO OPERATION-RETURN-MESSAGE
                   END-READ

               NOT INVALID KEY
                   MOVE 00
                     TO OPERATION-RETURN-CODE
                   MOVE MESSAGE-SEVERITY
                     TO OPERATION-SEVERITY
                   MOVE MESSAGE-CODE
                     TO OPERATION-ERROR-CODE
                   MOVE MESSAGE-TEXT
                     TO OPERATION-RETURN-MESSAGE
           END-READ

           CLOSE MESSAGE-FILE

           GOBACK.
