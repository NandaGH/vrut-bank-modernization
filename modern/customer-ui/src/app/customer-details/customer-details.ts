import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Customer, CustomerService } from '../services/customer.service';
import { CustomerApiService } from '../services/customer-api.service';

@Component({
  selector: 'app-customer-details',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './customer-details.html',
  styleUrl: './customer-details.scss',
})
export class CustomerDetails {
  customer: Customer | undefined;
  loading = true;
  errorMessage = '';

  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly customerApiService = inject(CustomerApiService);
  private readonly changeDetectorRef = inject(ChangeDetectorRef);

  constructor() {
    const customerId = this.route.snapshot.paramMap.get('id');

    if (!customerId) {
      this.loading = false;
      this.errorMessage = 'Customer ID is missing.';
      return;
    }

    this.loadCustomer(customerId);
  }

  private loadCustomer(customerId: string): void {
    this.loading = true;
    this.errorMessage = '';

    this.customerApiService.getCustomer(customerId).subscribe({
      next: (apiCustomer) => {
        console.log('Customer API response:', apiCustomer);

        this.customer = {
          id: apiCustomer.customerId,
          firstName: apiCustomer.firstName,
          lastName: apiCustomer.lastName,
          customerType: 'IN',
          title: 'MR',
          gender: '',
          dateOfBirth: '',
          mobile: '',
          email: '',
          addressLine1: apiCustomer.address,
          addressLine2: '',
          city: apiCustomer.city,
          state: apiCustomer.state,
          pinCode: apiCustomer.zipCode,
          country: 'India',
          homeBranch: '',
          status: 'Active',
          createdDate: '',
          createdBy: '',
          lastUpdatedDate: '',
          lastUpdatedBy: '',
        };

        this.loading = false;
        this.changeDetectorRef.markForCheck();
      },
      error: (error) => {
        console.error('Customer API error:', error);

        this.customer = undefined;
        this.loading = false;

        if (error.status === 404) {
          this.errorMessage = 'Customer not found.';
        } else {
          this.errorMessage = 'Unable to load customer details.';
        }

        this.changeDetectorRef.markForCheck();
      },
    });
  }

  updateCustomer(): void {
    if (this.customer) {
      this.router.navigate(['/customers', this.customer.id, 'edit']);
    }
  }

  goBack(): void {
    this.router.navigate(['/customers']);
  }
}
