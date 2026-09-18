import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import {
  Customer,
  CustomerService,
} from '../services/customer.service';

@Component({
  selector: 'app-customer-update',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './customer-update.html',
  styleUrl: './customer-update.scss',
})
export class CustomerUpdate {
  customer: Customer | undefined;
  saved = false;

  constructor(
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly customerService: CustomerService,
  ) {
    const customerId = this.route.snapshot.paramMap.get('id');

    if (customerId) {
      const found = this.customerService.getCustomer(customerId);

      if (found) {
        this.customer = { ...found };
      }
    }
  }

  cancel(): void {
    if (this.customer) {
      this.router.navigate(['/customers', this.customer.id]);
    } else {
      this.router.navigate(['/customers']);
    }
  }

  backToDetails(): void {
    if (this.customer) {
      this.router.navigate(['/customers', this.customer.id]);
    } else {
      this.router.navigate(['/customers']);
    }
  }

  saveChanges(): void {
    if (!this.customer) {
      return;
    }

    this.customerService.updateCustomer(this.customer);
    this.customer = this.customerService.getCustomer(this.customer.id);
    this.saved = true;
  }
}
