import { Injectable } from '@angular/core';
import { HttpClient, HttpParams, HttpResponse, HttpHeaders } from '@angular/common/http';
import { CompanyOverview } from '../company-overview/company-overview';

@Injectable()
export class CompanyListService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getCompanyList() {

    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companylist'
    return this.http.get(endpointUrl)
      .toPromise()
      .then(res => <CompanyOverview[]>res)
      .then(data => { return data; });
  }


}