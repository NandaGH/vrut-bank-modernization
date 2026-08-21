       IDENTIFICATION DIVISION.
       PROGRAM-ID. VRMESSG-INIT.

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

       PROCEDURE DIVISION.

       1000-MAIN.

           OPEN OUTPUT MESSAGE-FILE

           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "MESSAGE FILE OPEN : FAIL"
               GOBACK
           END-IF

           MOVE "VR-CUST-001"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Customer already exists"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-CUST-002"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Invalid branch"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-CUST-003"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Invalid mobile number"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-CUST-004"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Mandatory field missing"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-COM-001"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Message repository unavailable"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-COM-002"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Message code not found"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           MOVE "VR-CUST-999"
             TO MESSAGE-CODE
           MOVE "E"
             TO MESSAGE-SEVERITY
           MOVE "Unexpected customer processing error"
             TO MESSAGE-TEXT
           WRITE MESSAGE-RECORD

           CLOSE MESSAGE-FILE

           DISPLAY "MESSAGE REPOSITORY INITIALIZED"

           GOBACK.
