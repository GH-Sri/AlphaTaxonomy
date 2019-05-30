import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {Weight} from './weight';
import {environment} from '../../environments/environment';

@Injectable()
export class WeightService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getIndustryData(companyName) {
    let uriSafeCompanyName = encodeURIComponent(companyName);

    let host = environment.endpointHost;
    let endpointUrl = 'https://' + host + '/DEV/industryweights-by-company/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <Weight[]> res)
                      .then(data => {return data;});
  }
  
  getSectorData(companyName) {
      let uriSafeCompanyName = encodeURIComponent(companyName);

      let host = environment.endpointHost;
      let endpointUrl = 'https://' + host + '/DEV/sectorweights-by-company/' + uriSafeCompanyName
      return this.http.get(endpointUrl)
                      .toPromise()
                      .then(res => <Weight[]> res)
                      .then(data => {return data;});
    }

}
