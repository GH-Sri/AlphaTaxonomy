import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {IndustryWeight} from './industry-weight';

@Injectable()
export class IndustryWeightService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let params = new HttpParams().set('companyName', companyName);
    let array = new Array<IndustryWeight>();
    let weight1 = {industry: 'Industry 4', weight: '87'};
    let weight2 = {industry: 'Industry 5', weight: '13'}
    array.push(weight1);
    array.push(weight2);
    return array;
//    return this.http.get('http://localhost:8080/industryWeights', { params: params })
//                    .toPromise()
//                    .then(res => {console.log(res); return <IndustryWeight[]> res; });
  }

}
