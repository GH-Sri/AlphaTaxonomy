import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyOverview} from './company-overview';

@Injectable()
export class CompanyOverviewService {
  http: HttpClient;
  testData: CompanyOverview;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let uriSafeCompanyName = encodeURIComponent(companyName)
    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companyinfo/' + uriSafeCompanyName

    return this.http.get(endpointUrl)
                .toPromise()
                .then(res => <CompanyOverview[]> res)
                .then(data => {return data;});
    
  }

}
