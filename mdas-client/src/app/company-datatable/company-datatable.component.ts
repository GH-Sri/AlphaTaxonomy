import { Component, OnInit,  OnDestroy, ViewChild, ViewChildren, QueryList, AfterViewChecked} from '@angular/core';
import { CompanyOverview } from '../company-overview/company-overview';
import { CompanyListService } from './company-list.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { LazyLoadEvent } from 'primeng/api';

@Component({
  selector: 'app-company-datatable',
  templateUrl: './company-datatable.component.html',
  styleUrls: ['./company-datatable.component.css']
})
export class CompanyDatatableComponent implements OnInit, OnDestroy {

  //datatable fields
    allCompanies: CompanyOverview[];
  companies: CompanyOverview[];
  totalRecords: number;
  cols: any[];
  selectedCompany: CompanyOverview;

  @ViewChildren('filter')
  filters: QueryList<any>;
  
  sectorFilter: string = '';
  previousIndustryFilter: string = '';
  industryFilter: string = '';

    sub: any;

    @ViewChild('companyTable')
    table: any;
    
  constructor(private companyService: CompanyListService,
              private route: ActivatedRoute,
              private router: Router) { 
      
  }

  ngOnInit() {
      this.sub = this.route
                      .queryParams
                      .subscribe(params => {
                          // Defaults to 0 if no query param provided.
                          console.log('params');
                          console.log(params);
                          this.previousIndustryFilter = this.industryFilter;
                          this.sectorFilter = params['sector'];
                          this.industryFilter = params['industry'];
                      });
      
    //initialize table
      this.companies = [];
      this.companyService.getCompanyList().then(companies => {
          console.log(companies);
          this.companies = companies;
          this.totalRecords = 10000;
      });
      this.cols = [
          { field: 'name', header: 'Name'},
          { field: 'atsector', header: 'Sector' },
          { field: 'atindustry', header: 'Industry' },
          { field: 'marketcap', header: 'Market Cap'}
      ];
  }
  
  ngOnDestroy(){
      this.sub.unsubscribe();
  }

  onRowSelect(event) {
      this.router.navigate(['', { outlets: { details: ['company', this.selectedCompany.name] } }]);
  }
  
  filter(){
      if(this.filters != null && this.filters.toArray().length > 0){
          this.filters.toArray()[1].nativeElement.value = this.sectorFilter;
          this.filters.toArray()[2].nativeElement.value = this.industryFilter;

//        Industry filtering always yields a subset of a particular sector,
//        so we only need to filter on industry if we have one
          if(this.industryFilter || (this.previousIndustryFilter && !this.industryFilter)){
              this.table.filter(this.industryFilter, 'atindustry', 'contains');
          }
          else{
              this.table.filter(this.sectorFilter, 'atsector', 'contains');
          }
      }
  }
  
  ngAfterViewChecked(){
      this.filter();
  }
  
  loadCompaniesLazy(event: LazyLoadEvent){
      console.log('lazyload');
      console.log(event);
      setTimeout(() => {
          if (this.allCompanies) {
              this.companies = this.allCompanies.slice(event.first, (event.first + event.rows));
              console.log('company slice');
              console.log(this.companies);
          }
      }, 250);
      
  }
}
