import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyOverview} from '../company-overview/company-overview';
import {environment} from '../../environments/environment';

@Injectable()
export class CompanyListService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getCompanyList() {

    let host = environment.endpointHost;
    let endpointUrl = 'https://' + host + '/DEV/companylist'
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <CompanyOverview[]> res)
                      .then(data => {return data;});
  }
  

}
