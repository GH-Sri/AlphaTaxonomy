import { Component, OnInit, Input } from '@angular/core';
import { CompanyOverviewService } from './company-overview.service';
import { CompanyOverview } from './company-overview';

@Component({
  selector: 'company-overview',
  templateUrl: './company-overview.component.html',
  styleUrls: ['./company-overview.component.css']
})
export class CompanyOverviewComponent implements OnInit {

  @Input() companyName: string;

  companyData: CompanyOverview;

  constructor(private companyService: CompanyOverviewService) {
    this.companyData = {
      name: '',
      ticker: '',
      sector: '',
      legacysector: '',
      industry: '',
      legacyindustry: '',
      marketcap: '',
      perf10yr: '',
      perfvssector10yr: ''
    };
  }

  public reinit(companyName: string){
      this.companyName = companyName;
      this.ngOnInit();
  }
  
  ngOnInit() {
    this.companyService.getData(this.companyName).then(companies => {
      this.companyData = companies[0];
    });
  }

}
