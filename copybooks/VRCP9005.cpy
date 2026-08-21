      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COPYBOOK     : VRCP9005
      * DESCRIPTION  : Enterprise Message Repository Record
      *
      * PURPOSE
      * Defines the physical record layout used by the local
      * enterprise message repository.
      *
      * The logical message contract is independent of the
      * physical repository implementation.
      ******************************************************************

       01 MESSAGE-RECORD.

          05 MESSAGE-CODE             PIC X(12).

          05 MESSAGE-SEVERITY         PIC X(01).

          05 MESSAGE-TEXT             PIC X(50).
