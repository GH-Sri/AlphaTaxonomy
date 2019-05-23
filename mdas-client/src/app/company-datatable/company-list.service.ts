import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyOverview} from '../company-overview/company-overview';

@Injectable()
export class CompanyListService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getCompanyList() {
    
    let testData =  {
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
    let testData2 =  {
            'name': 'Majesco',
            'ticker': 'MACO',
            'sector': 'Industrials',
            'legacysector': 'Books',
            'industry': 'Chemical Manufacturing',
            'legacyindustry': 'Paper',
            'marketcap': '$1,187,580',
            'perf10yr': null,
            'perfvssector10yr': null     
          }
    let array = [];
    array.push(testData);
    array.push(testData2);
    
  return array;
      
//    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/companyInfo'
//    return this.http.get(endpointUrl)
//                    .toPromise()
//                    .then(res => <CompanyOverview[]> res)
//                      .then(data => {return data;});
  }
  

}
