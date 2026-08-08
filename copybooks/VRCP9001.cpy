      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COMPONENT    : Enterprise Constants
      * COPYBOOK     : VRCP9001
      *
      * PURPOSE
      * Defines enterprise-wide business constants shared across
      * COBOL applications.
      *
      * AUTHOR       : Nandakumar
      * VERSION      : 1.0
      *
      * CHANGE HISTORY
      * ---------------------------------------------------------------
      * VER  DATE         AUTHOR        DESCRIPTION
      * ---------------------------------------------------------------
      * 1.0  2026-08-03   Nandakumar    Initial Version
      ******************************************************************

       01 VRUT-ENTERPRISE-CONSTANTS.

      *---------------------------------------------------------------*
      * CUSTOMER TYPES
      *---------------------------------------------------------------*

          05 CUSTOMER-TYPE-INDIVIDUAL      PIC X(02) VALUE 'IN'.
          05 CUSTOMER-TYPE-NRI             PIC X(02) VALUE 'NR'.
          05 CUSTOMER-TYPE-CORPORATE       PIC X(02) VALUE 'CO'.

      *---------------------------------------------------------------*
      * GENDER
      *---------------------------------------------------------------*

          05 GENDER-MALE                   PIC X(01) VALUE 'M'.
          05 GENDER-FEMALE                 PIC X(01) VALUE 'F'.
          05 GENDER-OTHER                  PIC X(01) VALUE 'O'.

      *---------------------------------------------------------------*
      * CUSTOMER STATUS
      *---------------------------------------------------------------*

          05 STATUS-ACTIVE                 PIC X(01) VALUE 'A'.
          05 STATUS-INACTIVE               PIC X(01) VALUE 'I'.
          05 STATUS-DORMANT                PIC X(01) VALUE 'D'.
          05 STATUS-BLOCKED                PIC X(01) VALUE 'B'.
          05 STATUS-CLOSED                 PIC X(01) VALUE 'C'.