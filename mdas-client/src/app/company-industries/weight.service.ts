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
      let uriSafeCompanyName = encodeURIComponent(companyName);

    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/industryweights-by-company/' + uriSafeCompanyName
    return this.http.get(endpointUrl)
                    .toPromise()
                    .then(res => <Weight[]> res)
                      .then(data => {return data;});
  }
  
  getSectorData(companyName) {
      let uriSafeCompanyName = encodeURIComponent(companyName);

      let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/sectorweights-by-company/' + uriSafeCompanyName
      return this.http.get(endpointUrl)
                      .toPromise()
                      .then(res => <Weight[]> res)
                      .then(data => {return data;});
    }

}
