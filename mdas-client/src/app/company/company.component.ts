import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CompanyCompetitorsComponent } from '../company-competitors/company-competitors.component';
import { CompanyIndustriesComponent } from '../company-industries/company-industries.component';
import { CompanyOverviewComponent } from '../company-overview/company-overview.component';

@Component({
  selector: 'app-company',
  templateUrl: './company.component.html',
  styleUrls: ['./company.component.css']
})
export class CompanyComponent implements OnInit, OnDestroy {

    companyName: string;
    private sub: any;

    @ViewChild('overview')
    overview: CompanyOverviewComponent;
    
    @ViewChild('industries')
    industries: CompanyIndustriesComponent;
    
    @ViewChild('competitors')
    competitors: CompanyCompetitorsComponent;
    
    constructor(private route: ActivatedRoute) { }

    ngOnInit() {
        this.companyName = '';
        this.sub = this.route.params.subscribe(params => {
            let reinit = false;
            if(this.companyName != ''){
                reinit = true;
            }
            this.companyName = params['name'];
            if(reinit){
                this.overview.reinit(this.companyName);
                this.industries.reinit(this.companyName);
                this.competitors.reinit(this.companyName);
            }
         });
        document.getElementById("companydetails").scrollIntoView();
    }
    
    ngOnDestroy(){
        this.sub.unsubscribe();
    }

}
