import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyCompetitor} from './company-competitor';

@Injectable()
export class CompetitorService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let params = new HttpParams().set('companyName', companyName);
    
    let array = new Array<CompanyCompetitor>();
    let competitor1 = {name: 'A',
                   ticker: 'A',
                   marketCap: '$500',
                   tenYrPerformance: '',
                   tenYrPerformanceVsSector: '',
                   closenessToCompany: 1};
    let competitor2 = {name: 'B',
        ticker: 'B',
        marketCap: '$400',
        tenYrPerformance: '',
        tenYrPerformanceVsSector: '',
        closenessToCompany: 2};
    let competitor3 = {name: 'C',
        ticker: 'C',
        marketCap: '$200',
        tenYrPerformance: '',
        tenYrPerformanceVsSector: '',
        closenessToCompany: 3};
    let competitor4 = {name: 'D',
        ticker: 'D',
        marketCap: '$100',
        tenYrPerformance: '',
        tenYrPerformanceVsSector: '',
        closenessToCompany: 4};
    array.push(competitor1);
    array.push(competitor2);
    array.push(competitor3);
    array.push(competitor4);
    
    return array;
//    return this.http.get('http://localhost:8080/companyCompetitors', { params: params })
//                    .toPromise()
//                    .then(res => {console.log(res); return <CompanyCompetitor[]> res; });
  }

}
