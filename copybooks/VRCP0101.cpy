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

       01 CUSTOMER-RECORD.

          **************************************************************
          * CUSTOMER IDENTITY
          **************************************************************

          05 CUSTOMER-IDENTITY.

             10 CUSTOMER-ID                 PIC X(10).

             10 CUSTOMER-TYPE               PIC X(02).

             10 CUSTOMER-TITLE              PIC X(05).

             10 CUSTOMER-FIRST-NAME         PIC X(30).

             10 CUSTOMER-MIDDLE-NAME        PIC X(30).

             10 CUSTOMER-LAST-NAME          PIC X(30).

             10 CUSTOMER-GENDER             PIC X(01).

             10 CUSTOMER-DATE-OF-BIRTH      PIC X(10).

          **************************************************************
          * CONTACT INFORMATION
          **************************************************************

          05 CUSTOMER-CONTACT.

             10 CUSTOMER-MOBILE-NUMBER      PIC X(10).

             10 CUSTOMER-EMAIL-ID           PIC X(60).

          **************************************************************
          * ADDRESS INFORMATION
          **************************************************************

          05 CUSTOMER-ADDRESS.

             10 CUSTOMER-ADDRESS-LINE-1     PIC X(50).

             10 CUSTOMER-ADDRESS-LINE-2     PIC X(50).

             10 CUSTOMER-CITY               PIC X(30).

             10 CUSTOMER-STATE              PIC X(30).

             10 CUSTOMER-PINCODE            PIC X(06).

             10 CUSTOMER-COUNTRY            PIC X(30).

          **************************************************************
          * BANK INFORMATION
          **************************************************************

          05 CUSTOMER-BANK.

             10 CUSTOMER-HOME-BRANCH        PIC X(04).

             10 CUSTOMER-STATUS             PIC X(01).

                88 CUSTOMER-ACTIVE          VALUE 'A'.

                88 CUSTOMER-INACTIVE        VALUE 'I'.

                88 CUSTOMER-DORMANT         VALUE 'D'.

                88 CUSTOMER-BLOCKED         VALUE 'B'.

                88 CUSTOMER-CLOSED          VALUE 'C'.

          **************************************************************
          * AUDIT INFORMATION
          **************************************************************

          05 CUSTOMER-AUDIT.

             10 CUSTOMER-CREATED-DATE       PIC X(10).

             10 CUSTOMER-CREATED-BY         PIC X(08).

             10 CUSTOMER-LAST-UPD-DATE      PIC X(10).

             10 CUSTOMER-LAST-UPD-BY        PIC X(08).