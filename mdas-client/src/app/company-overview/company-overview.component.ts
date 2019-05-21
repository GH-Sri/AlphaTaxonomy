import { Component, OnInit } from '@angular/core';
import { CompanyOverviewService } from './company-overview.service';
import { CompanyOverview } from './company-overview';

@Component({
  selector: 'app-company-overview',
  templateUrl: './company-overview.component.html',
  styleUrls: ['./company-overview.component.css']
})
export class CompanyOverviewComponent implements OnInit {
    
    @Input() companyName: string;

  companyData: CompanyOverview;
    
  constructor(private companyService: CompanyOverviewService) { }

  ngOnInit() {
      this.companyData = companyService.getData(this.companyName);
  }

}
