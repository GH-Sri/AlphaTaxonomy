import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {Weight} from './weight';

@Injectable()
export class WeightService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getIndustryData(companyName) {
    let params = new HttpParams().set('companyName', companyName);
    let array = new Array<Weight>();
    let weight1 = {name: 'Industry 4', weight: '87'};
    let weight2 = {name: 'Industry 5', weight: '13'}
    array.push(weight1);
    array.push(weight2);
    return array;
//    return this.http.get('http://localhost:8080/industryWeights', { params: params })
//                    .toPromise()
//                    .then(res => {console.log(res); return <IndustryWeight[]> res; });
  }
  
  getSectorData(companyName) {
      let params = new HttpParams().set('companyName', companyName);
      let array = new Array<Weight>();
      let weight1 = {name: 'Sector 1', weight: '45'};
      let weight2 = {name: 'Sector 2', weight: '56'}
      array.push(weight1);
      array.push(weight2);
      return array;
//      return this.http.get('http://localhost:8080/industryWeights', { params: params })
//                      .toPromise()
//                      .then(res => {console.log(res); return <IndustryWeight[]> res; });
    }

}
