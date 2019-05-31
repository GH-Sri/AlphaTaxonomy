import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {PerformanceData} from './performance';
import {environment} from '../../environments/environment';

@Injectable()
export class CompanyPerformanceService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
      let uriSafeCompanyName = encodeURIComponent(companyName);

      let host = environment.endpointHost;
      let endpointUrl = 'https://' + host + '/DEV/performanceinfo-by-company/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <PerformanceData[]> res)
                    .then(data => {return data;});
  }

}
