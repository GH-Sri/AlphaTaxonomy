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
    let params = new HttpParams().set('companyName', companyName);
    return this.http.get('http://localhost:8080/overview', { params: params })
                    .toPromise()
                    .then(res => {console.log(res.json()); return <CompanyOverview> res.json(); });
  }

}
