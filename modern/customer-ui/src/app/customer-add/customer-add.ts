import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Customer } from '../services/customer.service';
import { CustomerApiService } from '../services/customer-api.service';

@Component({
  selector: 'app-customer-add',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './customer-add.html',
  styleUrl: './customer-add.scss',
})
export class CustomerAdd {
  customer: Customer = {
    id: '',
    firstName: '',
    lastName: '',
    customerType: 'IN',
    title: 'MR',
    gender: 'M',
    dateOfBirth: '',
    mobile: '',
    email: '',
    addressLine1: '',
    addressLine2: '',
    city: '',
    state: '',
    pinCode: '',
    country: 'India',
    homeBranch: '1001',
    status: 'Active',
    createdDate: '',
    createdBy: '',
    lastUpdatedDate: '',
    lastUpdatedBy: '',
  };

  submitted = false;
  saving = false;
  errorMessage = '';

  constructor(
    private readonly router: Router,
    private readonly customerApiService: CustomerApiService,
  ) {}

  cancel(): void {
    this.router.navigate(['/customers']);
  }

  createCustomer(): void {
    if (this.saving || this.submitted) {
      return;
    }

    this.saving = true;
    this.errorMessage = '';

    this.customerApiService.createCustomer({
      firstName: this.customer.firstName,
      lastName: this.customer.lastName,
      address: this.customer.addressLine1,
      city: this.customer.city,
      state: this.customer.state,
      zipCode: this.customer.pinCode,
    }).subscribe({
      next: (createdCustomer) => {
        this.customer = {
          ...this.customer,
          id: createdCustomer.customerId,
          firstName: createdCustomer.firstName,
          lastName: createdCustomer.lastName,
          addressLine1: createdCustomer.address,
          city: createdCustomer.city,
          state: createdCustomer.state,
          pinCode: createdCustomer.zipCode,
        };
        this.submitted = true;
        this.saving = false;
      },
      error: (error) => {
        this.saving = false;
        this.errorMessage = error.status === 409
          ? 'A customer with these details already exists.'
          : error.status === 400
            ? 'Please provide valid customer information.'
            : 'Unable to create the customer. Please try again.';
      },
    });
  }

  viewCustomer(): void {
    if (this.customer.id) {
      this.router.navigate(['/customers', this.customer.id]);
    }
  }
}
