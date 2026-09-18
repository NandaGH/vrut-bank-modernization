import { Router } from '@angular/router';
import { Component, ViewEncapsulation } from '@angular/core';
import { CustomerService } from '../services/customer.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.html',
  styleUrl: '../app.scss',
  encapsulation: ViewEncapsulation.None,
})
export class Dashboard {
  constructor(
    private readonly router: Router,
    private readonly customerService: CustomerService,
  ) {}

  addCustomer(): void {
    this.router.navigate(['/customers/add']);
  }

  activeSection = 'Dashboard';

  stats = [
    { label: 'Total Customers', value: '1,284', detail: '+12 this month' },
    { label: 'Active Customers', value: '1,146', detail: '89.3% of total' },
    { label: 'Recent Updates', value: '38', detail: 'Last 7 days' },
  ];

  get recentCustomers() {
    return this.customerService.getRecentCustomers();
  }

}
