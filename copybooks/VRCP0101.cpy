      ******************************************************************
      * PROJECT      : Project Phoenix
      * CLIENT       : VRUT Bank
      * COMPONENT    : Customer Master Record
      * COPYBOOK     : VRCP0101
      *
      * PURPOSE
      * Defines the CUSTOMER.DAT physical record layout.
      * Shared by all online and batch customer programs.
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

       01 CP-CUSTOMER-RECORD.

      **************************************************************
      * CUSTOMER IDENTITY
      **************************************************************

          05 CP-CUSTOMER-IDENTITY.

             10 CP-CUSTOMER-ID                 PIC X(10).

             10 CP-CUSTOMER-TYPE               PIC X(02).

             10 CP-CUSTOMER-TITLE              PIC X(05).

             10 CP-CUSTOMER-FIRST-NAME         PIC X(30).

             10 CP-CUSTOMER-MIDDLE-NAME        PIC X(30).

             10 CP-CUSTOMER-LAST-NAME          PIC X(30).

             10 CP-CUSTOMER-GENDER             PIC X(01).

             10 CP-CUSTOMER-DATE-OF-BIRTH      PIC X(10).

      **************************************************************
      * CONTACT INFORMATION
      **************************************************************

          05 CP-CUSTOMER-CONTACT.

             10 CP-CUSTOMER-MOBILE-NUMBER      PIC X(10).

             10 CP-CUSTOMER-EMAIL-ID           PIC X(60).

      **************************************************************
      * ADDRESS INFORMATION
      **************************************************************

          05 CP-CUSTOMER-ADDRESS.

             10 CP-CUSTOMER-ADDRESS-LINE-1     PIC X(50).

             10 CP-CUSTOMER-ADDRESS-LINE-2     PIC X(50).

             10 CP-CUSTOMER-CITY               PIC X(30).

             10 CP-CUSTOMER-STATE              PIC X(30).

             10 CP-CUSTOMER-PINCODE            PIC X(06).

             10 CP-CUSTOMER-COUNTRY            PIC X(30).

      **************************************************************
      * BANK INFORMATION
      **************************************************************

          05 CP-CUSTOMER-BANK.

             10 CP-CUSTOMER-HOME-BRANCH        PIC X(04).

             10 CP-CUSTOMER-STATUS             PIC X(01).

                88 CP-CUSTOMER-ACTIVE          VALUE 'A'.

                88 CP-CUSTOMER-INACTIVE        VALUE 'I'.

                88 CP-CUSTOMER-DORMANT         VALUE 'D'.

                88 CP-CUSTOMER-BLOCKED         VALUE 'B'.

                88 CP-CUSTOMER-CLOSED          VALUE 'C'.

      **************************************************************
      * AUDIT INFORMATION
      **************************************************************

          05 CP-CUSTOMER-AUDIT.

             10 CP-CUSTOMER-CREATED-DATE       PIC X(10).

             10 CP-CUSTOMER-CREATED-BY         PIC X(08).

             10 CP-CUSTOMER-LAST-UPD-DATE      PIC X(10).

             10 CP-CUSTOMER-LAST-UPD-BY        PIC X(08).
