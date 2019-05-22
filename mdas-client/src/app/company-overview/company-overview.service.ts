import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, Response, Headers, RequestOptions} from '@angular/common/http';
import {CompanyOverview} from './company-overview';
import 'rxjs/add/operator/toPromise';

@Injectable()
export class CompanyOverviewService {
  http: Http;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let uriSafeCompanyName = encodeURIComponent(companyName)
    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companyinfo/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => {console.log(res.json()); return <CompanyOverview> res.json(); });
  }

}
