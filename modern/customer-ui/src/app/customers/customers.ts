import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import {
  Customer,
  CustomerService,
} from '../services/customer.service';

@Component({
  selector: 'app-customers',
  imports: [FormsModule],
  templateUrl: './customers.html',
  styleUrl: './customers.scss',
})
export class Customers {
  searchId = '';

  constructor(
    private readonly router: Router,
    private readonly customerService: CustomerService,
  ) {}

  get customers(): Customer[] {
    return this.customerService.getCustomers();
  }

  viewCustomer(customerId: string): void {
    this.router.navigate(['/customers', customerId]);
  }

  addCustomer(): void {
    this.router.navigate(['/customers/add']);
  }

  filteredCustomers(): Customer[] {
    const value = this.searchId.trim().toLowerCase();

    if (!value) {
      return this.customers;
    }

    return this.customers.filter(
      customer =>
        customer.id.toLowerCase().includes(value) ||
        `${customer.firstName} ${customer.lastName}`
          .toLowerCase()
          .includes(value),
    );
  }
}
