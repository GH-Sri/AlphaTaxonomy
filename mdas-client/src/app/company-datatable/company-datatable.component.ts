import { Component, OnInit } from '@angular/core';
import { CompanyListService } from './company-list.service';
import { CompanyOverview } from '../company-overview/company-overview';
import { Router } from '@angular/router';

@Component({
  selector: 'app-company-datatable',
  templateUrl: './company-datatable.component.html',
  styleUrls: ['./company-datatable.component.css']
})
export class CompanyDatatableComponent implements OnInit {

    companies: CompanyOverview[];
    cols: any[];

    selectedCompany: CompanyOverview;

  constructor(private companyService: CompanyListService,
              private router: Router) { 
  }

  ngOnInit() { 
      this.companies = this.companyService.getCompanyList();
      
      this.cols = [
          { field: 'name', header: 'Name' },
          { field: 'sector', header: 'Sector' },
          { field: 'industry', header: 'Industry' },
          { field: 'marketcap', header: 'Market Cap' }
      ];
  }
  
  onRowSelect(event) {
      this.router.navigate(['company', this.selectedCompany.name]);
  }

}
