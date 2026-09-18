import { Injectable } from '@angular/core';

export interface Customer {
  id: string;
  firstName: string;
  lastName: string;
  customerType: string;
  title: string;
  gender: string;
  dateOfBirth: string;
  mobile: string;
  email: string;
  addressLine1: string;
  addressLine2: string;
  city: string;
  state: string;
  pinCode: string;
  country: string;
  homeBranch: string;
  status: string;
  createdDate: string;
  createdBy: string;
  lastUpdatedDate: string;
  lastUpdatedBy: string;
}

@Injectable({
  providedIn: 'root',
})
export class CustomerService {
  private readonly storagePrefix = 'vrut-customer-';

  private readonly baseCustomers: Customer[] = [
    {
      id: '0000000005',
      firstName: 'Arun',
      lastName: 'Kumar',
      customerType: 'IN',
      title: 'MR',
      gender: 'M',
      dateOfBirth: '1990-01-15',
      mobile: '9876543210',
      email: 'arun.kumar@example.com',
      addressLine1: '12 Anna Nagar Main Road',
      addressLine2: 'Near Central Library',
      city: 'Chennai',
      state: 'TN',
      pinCode: '600040',
      country: 'India',
      homeBranch: '1001',
      status: 'Active',
      createdDate: '2026-08-10',
      createdBy: 'SYSTEM',
      lastUpdatedDate: '2026-08-11',
      lastUpdatedBy: 'SYSTEM',
    },
    {
      id: '0000000006',
      firstName: 'Nandan',
      lastName: 'Test',
      customerType: 'IN',
      title: 'MR',
      gender: 'M',
      dateOfBirth: '1992-05-20',
      mobile: '9000000006',
      email: 'nandan.test@example.com',
      addressLine1: '10 Mount Road',
      addressLine2: '',
      city: 'Chennai',
      state: 'TN',
      pinCode: '600002',
      country: 'India',
      homeBranch: '1001',
      status: 'Active',
      createdDate: '2026-08-10',
      createdBy: 'SYSTEM',
      lastUpdatedDate: '2026-08-10',
      lastUpdatedBy: 'SYSTEM',
    },
    {
      id: '0000000007',
      firstName: 'Priya',
      lastName: 'Sharma',
      customerType: 'IN',
      title: 'MS',
      gender: 'F',
      dateOfBirth: '1993-08-12',
      mobile: '9000000007',
      email: 'priya.sharma@example.com',
      addressLine1: '22 MG Road',
      addressLine2: '',
      city: 'Bengaluru',
      state: 'KA',
      pinCode: '560001',
      country: 'India',
      homeBranch: '1002',
      status: 'Active',
      createdDate: '2026-08-09',
      createdBy: 'SYSTEM',
      lastUpdatedDate: '2026-08-09',
      lastUpdatedBy: 'SYSTEM',
    },
    {
      id: '0000000008',
      firstName: 'Rahul',
      lastName: 'Menon',
      customerType: 'IN',
      title: 'MR',
      gender: 'M',
      dateOfBirth: '1988-11-03',
      mobile: '9000000008',
      email: 'rahul.menon@example.com',
      addressLine1: '8 Marine Drive',
      addressLine2: '',
      city: 'Kochi',
      state: 'KL',
      pinCode: '682011',
      country: 'India',
      homeBranch: '1003',
      status: 'Inactive',
      createdDate: '2026-08-08',
      createdBy: 'SYSTEM',
      lastUpdatedDate: '2026-08-08',
      lastUpdatedBy: 'SYSTEM',
    },
  ];

  getCustomers(): Customer[] {
    const customers = this.baseCustomers.map(customer => {
      const saved = localStorage.getItem(
        `${this.storagePrefix}${customer.id}`,
      );

      return saved
        ? (JSON.parse(saved) as Customer)
        : { ...customer };
    });

    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i);

      if (!key?.startsWith(this.storagePrefix)) {
        continue;
      }

      const id = key.substring(this.storagePrefix.length);

      if (customers.some(customer => customer.id === id)) {
        continue;
      }

      const saved = localStorage.getItem(key);

      if (saved) {
        customers.push(JSON.parse(saved) as Customer);
      }
    }

    return customers;
  }

  getCustomer(customerId: string): Customer | undefined {
    return this.getCustomers().find(
      customer => customer.id === customerId,
    );
  }

  saveCustomer(customer: Customer): void {
    localStorage.setItem(
      `${this.storagePrefix}${customer.id}`,
      JSON.stringify(customer),
    );
  }

  createCustomer(customer: Customer): Customer {
    const newCustomer = {
      ...customer,
      id: this.generateCustomerId(),
      createdDate: this.today(),
      createdBy: 'OPERATOR',
      lastUpdatedDate: this.today(),
      lastUpdatedBy: 'OPERATOR',
    };

    this.saveCustomer(newCustomer);

    return newCustomer;
  }

  updateCustomer(customer: Customer): void {
    const updatedCustomer = {
      ...customer,
      lastUpdatedDate: this.today(),
      lastUpdatedBy: 'OPERATOR',
    };

    this.saveCustomer(updatedCustomer);
  }

  getRecentCustomers(limit = 4): Customer[] {
    return this.getCustomers()
      .sort((a, b) => {
        const dateA = `${a.lastUpdatedDate} ${a.id}`;
        const dateB = `${b.lastUpdatedDate} ${b.id}`;

        return dateB.localeCompare(dateA);
      })
      .slice(0, limit);
  }

  private generateCustomerId(): string {
    let highest = 0;

    for (const customer of this.getCustomers()) {
      highest = Math.max(highest, Number(customer.id));
    }

    return String(highest + 1).padStart(10, '0');
  }

  private today(): string {
    return new Date().toISOString().slice(0, 10);
  }
}
