import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'dashboard' },

  {
    path: 'dashboard',
    loadComponent: () =>
      import('./dashboard/dashboard').then(m => m.Dashboard),
  },

  // Specific static route MUST come before /customers/:id
  {
    path: 'customers/add',
    loadComponent: () =>
      import('./customer-add/customer-add').then(
        m => m.CustomerAdd
      ),
  },

  {
    path: 'customers/:id/edit',
    loadComponent: () =>
      import('./customer-update/customer-update').then(
        m => m.CustomerUpdate
      ),
  },

  {
    path: 'customers/:id',
    loadComponent: () =>
      import('./customer-details/customer-details').then(
        m => m.CustomerDetails
      ),
  },

  {
    path: 'customers',
    loadComponent: () =>
      import('./customers/customers').then(m => m.Customers),
  },

  { path: '**', redirectTo: 'dashboard' },
];
