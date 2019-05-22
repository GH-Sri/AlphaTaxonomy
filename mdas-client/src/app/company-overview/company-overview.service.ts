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
      let httpOptions = {
              headers: new HttpHeaders({
//                  'Access-Control-Allow-Origin': '*'
              })
      };

    let uriSafeCompanyName = encodeURIComponent(companyName)
    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companyinfo/' + uriSafeCompanyName

     this.http.get(endpointUrl, httpOptions)
                    .toPromise()
                    .then(res => {console.log(res); });
    
  this.testData =  {
  'name': 'Ericsson',
  'ticker': 'ERIC',
  'sector': 'Hardware',
  'legacysector': 'IT',
  'industry': 'Nails',
  'legacyindustry': 'Software',
  'marketcap': '$2,987,580',
  'perf10yr': null,
  'perfvssector10yr': null     
}
return this.testData;
  }

}
