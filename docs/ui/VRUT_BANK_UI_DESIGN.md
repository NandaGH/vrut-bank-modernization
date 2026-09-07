VRUT Bank UI Design
1. Purpose

Create a recruiter-facing banking customer-management interface for Project Phoenix.

The UI should communicate a real banking application rather than a technical demonstration screen.

2. Visual Direction

Brand:

VRUT BANK

Style:

professional banking interface
clean modern layout
strong information hierarchy
restrained use of colour
responsive desktop-first design
clear status indicators
accessible forms and controls

The interface should look credible in a recruiter demonstration.

3. Main Navigation
VRUT BANK
│
├── Dashboard
│
└── Customers

Customer management is the primary application capability.

4. Dashboard

Display:

total customers
active customers
recent customer activity
quick action to add a customer
quick action to search customers

The dashboard is primarily a presentation layer and should remain lightweight.

5. Customer Management
Customer Search

Provide:

customer ID search
search action
clear/reset action
customer result/details area
not-found state
Customer Details

Display:

customer ID
first name
last name
address
city
state
ZIP/postal code

Provide an Update action.

Add Customer

Form fields:

first name
last name
address
city
state
ZIP/postal code

Actions:

Save
Cancel

Show validation and API errors clearly.

Update Customer

Allow editing of customer information.

Actions:

Save Changes
Cancel

Show success and error states.

6. API Integration

The UI will initially be developed independently from the backend.

Development sequence:

UI
 ↓
Mock/local data
 ↓
REST service
 ↓
FastAPI
 ↓
Modern backend
 ↓
Legacy backend

The UI must ultimately consume only the REST API.

7. Backend Independence

The UI must not contain logic for:

PostgreSQL
COBOL
CICS
z/OS Connect

Those concerns remain behind the backend API boundary.

8. Demonstration Flow

The preferred recruiter demonstration is:

Open VRUT Bank dashboard.
Search for a customer.
Display customer details.
Update the customer.
Add a customer.
Explain that the same UI consumes a stable REST API.
Switch backend configuration.
Demonstrate the modern PostgreSQL path.
Demonstrate the legacy z/OS Connect path where the required CICS environment is available.
9. Future Enhancements

Potential later additions:

authentication
role-based UI
customer list/pagination
audit activity
backend status indicator
OpenTelemetry trace visualization
optional 3270/BMS demonstration