import { provideHttpClient } from '@angular/common/http';
import {
  HttpTestingController,
  provideHttpClientTesting,
} from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { CustomerAdd } from './customer-add';

describe('CustomerAdd', () => {
  let httpTesting: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CustomerAdd],
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        provideRouter([]),
      ],
    }).compileComponents();

    httpTesting = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpTesting.verify();
  });

  it('creates a customer through the REST API and shows the returned ID', () => {
    const fixture = TestBed.createComponent(CustomerAdd);
    const component = fixture.componentInstance;
    component.customer.firstName = 'Automated';
    component.customer.lastName = 'Customer';
    component.customer.addressLine1 = 'Phoenix Street';
    component.customer.city = 'Chennai';
    component.customer.state = 'TN';
    component.customer.pinCode = '600001';

    component.createCustomer();

    const request = httpTesting.expectOne('/api/v1/customers');
    expect(request.request.method).toBe('POST');
    expect(request.request.body).toEqual({
      firstName: 'Automated',
      lastName: 'Customer',
      address: 'Phoenix Street',
      city: 'Chennai',
      state: 'TN',
      zipCode: '600001',
    });
    request.flush({
      customerId: 'CUST0003',
      firstName: 'Automated',
      lastName: 'Customer',
      address: 'Phoenix Street',
      city: 'Chennai',
      state: 'TN',
      zipCode: '600001',
    });

    fixture.detectChanges();

    expect(component.submitted).toBe(true);
    expect(component.customer.id).toBe('CUST0003');
    expect(fixture.nativeElement.textContent).toContain('Customer ID CUST0003');
  });
});
