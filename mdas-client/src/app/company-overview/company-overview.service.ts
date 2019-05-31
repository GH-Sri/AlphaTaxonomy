import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyOverview} from './company-overview';
import {environment} from '../../environments/environment';

@Injectable()
export class CompanyOverviewService {
  http: HttpClient;
  testData: CompanyOverview;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let uriSafeCompanyName = encodeURIComponent(companyName);
    let host = environment.endpointHost;
    let endpointUrl = 'https://' + host + '/DEV/companyinfo/' + uriSafeCompanyName

    return this.http.get(endpointUrl)
                .toPromise()
                .then(res => <CompanyOverview[]> res)
                .then(data => {return data;});
    
  }

}
