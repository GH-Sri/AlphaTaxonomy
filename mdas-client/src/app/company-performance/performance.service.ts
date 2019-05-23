import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {PerformanceData} from './performance';

@Injectable()
export class CompanyPerformanceService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
      let uriSafeCompanyName = encodeURIComponent(companyName);

    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/performanceinfo-by-company/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <PerformanceData[]> res)
                    .then(data => {return data;});
  }

}
