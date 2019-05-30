import {Injectable} from '@angular/core';
import {HttpClient, HttpParams, HttpResponse, HttpHeaders} from '@angular/common/http';
import {SectorIndustryWeight} from './sector-industry-weight';
import {environment} from '../../environments/environment';

@Injectable()
export class TreemapService {
  http: HttpClient;

  constructor(http: HttpClient) {
    this.http = http;
  }

  getData() {
    let host = environment.endpointHost;
    let endpointUrl = 'https://' + host + '/DEV/sectorindustryweights/';

    return this.http.get(endpointUrl)
                .toPromise()
                .then(res => <SectorIndustryWeight[]> res)
                .then(data => {return data;});
    
  }

}
