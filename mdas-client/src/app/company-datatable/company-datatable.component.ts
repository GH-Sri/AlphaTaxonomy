import { Component, OnInit, OnDestroy, ViewChild, ViewChildren, QueryList, AfterViewChecked } from '@angular/core';
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

    @ViewChildren('hiddenfilter')
    hiddenfilters: QueryList<any>;

    @ViewChildren('filter')
    filters: QueryList<any>;

    hiddenSectorFilter: string = '';
    previousHiddenIndustryFilter: string = '';
    hiddenIndustryFilter: string = '';
    sectorParam: string = '';
    industryParam: string = '';

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
                console.log('Clicked Parameters', params);
                this.previousHiddenIndustryFilter = this.hiddenIndustryFilter;
                this.hiddenSectorFilter = this.sectorParam = params['sector'];
                this.hiddenIndustryFilter = this.industryParam = params['industry'];
            });

        //initialize table
        this.companies = [];
        this.companyService.getCompanyList().then(companies => {
            console.log("Datatable data", companies);
            this.companies = companies;
            this.totalRecords = 10000;
        });
        this.cols = [
            { field: 'name', header: 'Name' },
            { field: 'atsector', header: 'Sector' },
            { field: 'atindustry', header: 'Industry' },
            { field: 'symbol', header: 'Symbol' },
            { field: 'legacysector', header: 'Legacy Sector' },
            { field: 'legacyindustry', header: 'Legacy Industry' },
            { field: 'marketcap', header: 'Market Cap' }
        ];
    }

    ngOnDestroy() {
        this.sub.unsubscribe();
    }

    onRowSelect(event) {
        this.router.navigate(['', { outlets: { details: ['company', this.selectedCompany.name] } }]);
    }


    filter() {
        if (this.hiddenfilters != null && this.hiddenfilters.toArray().length > 0) {
            this.hiddenfilters.toArray()[1].nativeElement.value = this.hiddenSectorFilter;
            this.hiddenfilters.toArray()[2].nativeElement.value = this.hiddenIndustryFilter;

            //        Industry filtering always yields a subset of a particular sector,
            //        so we only need to filter on industry if we have one

            //          if(this.hiddenIndustryFilter || (this.previousHiddenIndustryFilter && !this.hiddenIndustryFilter)){
            //              this.table.filter(this.hiddenIndustryFilter, 'atindustry', 'contains');
            //          }
            //          else{
            //              this.table.filter(this.hiddenSectorFilter, 'atsector', 'contains');
            //          }
            this.table.filter(this.hiddenSectorFilter, 'atsector', 'contains');
            this.table.filter(this.hiddenIndustryFilter, 'atindustry', 'contains');
        }
    }

    ngAfterViewChecked() {
        if (this.filters == null || this.filters.toArray().length == 0) {
            this.filter();
        } else if (this.filters.toArray()[1].nativeElement.value ||
            this.filters.toArray()[2].nativeElement.value) {

            this.hiddenSectorFilter = this.filters.toArray()[1].nativeElement.value;
            this.hiddenIndustryFilter = this.filters.toArray()[2].nativeElement.value;

            this.filter();
        } else {

            this.hiddenIndustryFilter = this.industryParam;
            this.hiddenSectorFilter = this.sectorParam;

            this.filter();
        }
    }

    loadCompaniesLazy(event: LazyLoadEvent) {
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

    clear(item: any) {
        console.log(item);
    }
}
