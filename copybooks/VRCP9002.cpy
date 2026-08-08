      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COPYBOOK     : VRCP9002
      * DESCRIPTION  : Validation Result Interface
      *
      * PURPOSE
      * Standard validation result returned by business validation
      * programs.
      ******************************************************************

       01 VALIDATION-RESULT.

          05 VALIDATION-RETURN-CODE      PIC 9(02).

          05 VALIDATION-RETURN-MESSAGE   PIC X(50).