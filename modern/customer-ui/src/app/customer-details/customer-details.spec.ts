import { provideHttpClient } from '@angular/common/http';
import {
  HttpTestingController,
  provideHttpClientTesting,
} from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { ActivatedRoute, provideRouter } from '@angular/router';
import { CustomerDetails } from './customer-details';

describe('CustomerDetails', () => {
  let httpTesting: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CustomerDetails],
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        provideRouter([]),
        {
          provide: ActivatedRoute,
          useValue: {
            snapshot: {
              paramMap: {
                get: (key: string) => key === 'id' ? 'CUST0002' : null,
              },
            },
          },
        },
      ],
    }).compileComponents();

    httpTesting = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpTesting.verify();
  });

  it('renders the API customer after the request completes', () => {
    const fixture = TestBed.createComponent(CustomerDetails);
    fixture.detectChanges();

    const request = httpTesting.expectOne('/api/v1/customers/CUST0002');
    expect(request.request.method).toBe('GET');
    request.flush({
      customerId: 'CUST0002',
      firstName: 'Automated Test',
      lastName: 'Phoenix',
      address: 'Phoenix Street',
      city: 'Chennai',
      state: 'TN',
      zipCode: '600001',
    });

    fixture.detectChanges();

    const rendered = fixture.nativeElement as HTMLElement;
    expect(rendered.textContent).toContain('Automated Test Phoenix');
    expect(rendered.textContent).toContain('Phoenix Street');
    expect(rendered.textContent).not.toContain('Loading Customer');
  });
});
