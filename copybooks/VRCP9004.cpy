      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COPYBOOK     : VRCP9004
      * DESCRIPTION  : Sequence Master Record Layout
      *
      * PURPOSE
      * Defines the record layout for the enterprise sequence master.
      ******************************************************************

       01 VRSEQM-REC.

          05 SEQUENCE-TYPE              PIC X(10).

          05 NEXT-NUMBER                PIC 9(10).