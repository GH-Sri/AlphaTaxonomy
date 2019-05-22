import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, Response, Headers, RequestOptions} from '@angular/common/http';
import {CompanyCompetitor} from './company-competitor';
import 'rxjs/add/operator/toPromise';

@Injectable()
export class CompetitorService {
  http: Http;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
    let params = new HttpParams().set('companyName', companyName);
    return this.http.get('http://localhost:8080/companyCompetitors', { params: params })
                    .toPromise()
                    .then(res => {console.log(res.json()); return <CompanyCompetitor[]> res.json(); });
  }

}
