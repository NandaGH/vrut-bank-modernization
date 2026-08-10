Let's establish Version 1.0 of our reference data.
VRUT Bank - Project Reference Data v1.0
Category
Value
Bank Name
VRUT Bank
Project Name
Legacy Core Banking Modernization Platform (LCBMP)
Project Code Name
Project Phoenix
Headquarters
Chennai, Tamil Nadu
Bank Type
Private Commercial Bank
Established
1998
Core Banking System
COBOL + DB2 (Legacy)
Modern Platform
Java Microservices + REST APIs + PostgreSQL + Docker + AWS Ready
Currency
INR (₹)
Time Zone
IST (UTC+5:30)


Branches
Branch Code
Branch Name
City
State
CHN001
Chennai Central
Chennai
Tamil Nadu
CBE001
Coimbatore Main
Coimbatore
Tamil Nadu
BLR001
Bengaluru MG Road
Bengaluru
Karnataka
HYD001
Hyderabad Central
Hyderabad
Telangana
MDU001
Madurai Branch
Madurai
Tamil Nadu


Sample Customers
Customer ID
Name
City
Occupation
CUST100001
Arjun Kumar
Chennai
Software Engineer
CUST100002
Priya Sharma
Bengaluru
Doctor
CUST100003
Meera Iyer
Coimbatore
Chartered Accountant
CUST100004
Ravi Narayanan
Hyderabad
Business Owner
CUST100005
Kavya Nair
Chennai
Teacher
CUST100006
Sanjay Patel
Coimbatore
Manufacturing Manager
CUST100007
Neha Reddy
Hyderabad
Data Analyst
CUST100008
Vikram Singh
Bengaluru
Architect


Bank Employees
Employee ID
Name
Role
EMP1001
Rahul Menon
Branch Manager
EMP1002
Anitha Krishnan
Customer Service Officer
EMP1003
Deepak Rao
Operations Manager
EMP1004
Sneha Iyer
Loan Officer
EMP1005
Karthik Raman
IT Administrator


Account Types
Code
Type
SAV
Savings Account
CUR
Current Account
FD
Fixed Deposit
RD
Recurring Deposit
LN
Loan Account


Loan Types
Code
Loan
PL
Personal Loan
HL
Home Loan
AL
Auto Loan
EL
Education Loan


Transaction Types
Code
Description
DEP
Cash Deposit
WDL
Cash Withdrawal
TRF
Fund Transfer
INT
Interest Credit
EMI
EMI Debit
CHG
Service Charge


Sample Account Number Format
Item
Format
Customer ID
CUST100001
Account Number
VR1000000001
Loan Number
LN100000001
Transaction ID
TXN202600000001
Batch Job
VRBT001
API Version
/api/v1

Future API Modules
Module
Status
Customer API
Planned
Account API
Planned
Transaction API
Planned
Loan API
Future Phase
Authentication API
Future Phase
Notification API
Future Phase


Technology Naming
Component
Name
Legacy COBOL Programs
VRCBxxxx
Copybooks
VRCPxxxx
JCL Members
VRJLxxxx
Batch Jobs
VRBTxxxx
REST Services
vrut-bank-api
Database
vrutbankdb