import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {SectorIndustryWeight} from './sector-industry-weight';

@Injectable()
export class TreemapService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData() {
    let endpointUrl = 'https://2wdm1205e1.execute-api.us-east-1.amazonaws.com/DEV/sectorindustryweights/'

    return this.http.get(endpointUrl)
                .toPromise()
                .then(res => <SectorIndustryWeight[]> res)
                .then(data => {return data;});
    
  }

}
