import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {CompanyCompetitor} from './company-competitor';
import {environment} from '../../environments/environment';

@Injectable()
export class CompetitorService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData(companyName) {
      let uriSafeCompanyName = encodeURIComponent(companyName);

    let host = environment.endpointHost;
    let endpointUrl = 'https://' + host + '/DEV/competitorinfo-by-company/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <CompanyCompetitor[]> res)
                    .then(data => {return data;});
  }

}
