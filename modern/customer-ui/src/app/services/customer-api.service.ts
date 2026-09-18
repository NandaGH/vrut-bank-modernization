import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CustomerApi {
  customerId: string;
  firstName: string;
  lastName: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
}

export interface CustomerCreateRequest {
  firstName: string;
  lastName: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
}

export interface CustomerUpdateRequest {
  firstName?: string;
  lastName?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
}

@Injectable({
  providedIn: 'root',
})
export class CustomerApiService {
  private readonly http = inject(HttpClient);

  private readonly baseUrl = '/api/v1/customers';

  getCustomer(customerId: string): Observable<CustomerApi> {
    return this.http.get<CustomerApi>(
      `${this.baseUrl}/${customerId}`,
    );
  }

  createCustomer(
    request: CustomerCreateRequest,
  ): Observable<CustomerApi> {
    return this.http.post<CustomerApi>(
      this.baseUrl,
      request,
    );
  }

  updateCustomer(
    customerId: string,
    request: CustomerUpdateRequest,
  ): Observable<CustomerApi> {
    return this.http.put<CustomerApi>(
      `${this.baseUrl}/${customerId}`,
      request,
    );
  }
}
