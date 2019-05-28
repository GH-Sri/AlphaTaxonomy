import { Component, OnInit,  OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { CompanyOverview } from '../company-overview/company-overview';
import { CompanyListService } from './company-list.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-company-datatable',
  templateUrl: './company-datatable.component.html',
  styleUrls: ['./company-datatable.component.css']
})
export class CompanyDatatableComponent implements OnInit, OnDestroy {

  //datatable fields
  companies: CompanyOverview[];
  cols: any[];
  selectedCompany: CompanyOverview;

  @ViewChild('sector-filter')
  sectorFilter: ElementRef;
  
  @ViewChild('industry-filter')
  industryFilter: ElementRef;

    sub: any;

    @ViewChild('companyTable')
    table: any;
    
  constructor(private companyService: CompanyListService,
              private route: ActivatedRoute,
              private router: Router) { 
      //initialize table
      this.companies = [];
      this.companyService.getCompanyList().then(companies => {
          console.log(companies);
          this.companies = companies;
          this.cols = [
              { field: 'name', header: 'Name', inputId: 'name-filter'},
              { field: 'sector', header: 'Sector', inputId: 'sector-filter' },
              { field: 'industry', header: 'Industry', inputId: 'industry-filter' },
              { field: 'marketcap', header: 'Market Cap', inputId: 'marketcap-filter' }
          ];
          this.filter();
          console.log(this.companies);
      });
  }

  ngOnInit() {
      this.sub = this.route
                      .queryParams
                      .subscribe(params => {
                          // Defaults to 0 if no query param provided.
                          console.log('params');
                          console.log(params);
//                          this.sectorFilter = params['sector'];
//                          this.industryFilter = params['industry'];
                          this.filter();
                      });
  }
  
  ngOnDestroy(){
      this.sub.unsubscribe();
  }

  onRowSelect(event) {
      this.router.navigate(['', { outlets: { details: ['company', this.selectedCompany.name] } }]);
  }
  
  filter(){
      console.log('filter-ref')
      console.log(this.industryFilter);
    //Industry filtering always yields a subset of a particular sector,
      //so we only need to filter on industry if we have one
//      if(this.industryFilter != ''){
//          console.log('filtering industry');
////          this.industryFilter.
////          this.table.filter(this.industryFilter, 'industry', 'contains');
//      }
//      else{
//          console.log('filtering sector');
////          this.table.filter(this.sectorFilter, 'sector', 'contains');
//      }
  }
}
