      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COPYBOOK     : VRCP9003
      * DESCRIPTION  : Enterprise Operation Result Interface
      *
      * PURPOSE
      * Standard operation result returned by COBOL business
      * programs for cross-platform integration.
      ******************************************************************

       01 OPERATION-RESULT.

          05 OPERATION-RETURN-CODE      PIC 9(02).

          05 OPERATION-SEVERITY         PIC X(01).

          05 OPERATION-ERROR-CODE       PIC X(12).

          05 OPERATION-RETURN-MESSAGE   PIC X(50).
