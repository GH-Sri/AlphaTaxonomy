import { Component, OnInit } from '@angular/core';

@Component({
    selector: 'app-company-competitors',
    templateUrl: './company-competitors.component.html',
    styleUrls: ['./company-competitors.component.css']
})
export class CompanyCompetitorsComponent implements OnInit {

    competitors: CompanyCompetitor[];

    sortOptions: SelectItem[];

    sortKey: string;
    sortField: string;
    sortOrder: number; //ascending (1) or descending (-1)

    constructor(private competitorService: CompetitorService) { }

    ngOnInit() {
        this.competitors = competitorService.getData(this.companyName);
        
        this.sortOptions= [
            {label: 'Competitor Rank', value: 'closeness'},
            {label: 'Market Cap', value: 'marketCap'},
            {label: '10-Year Performance', value: 'tenYearPerformance'},
            {label: '10-Year Performance vs Sector', value: 'tenYearPerformanceVsSector'}
        ]
    }
    
    onSortChange(event) {
        let value = event.value;

        if (value.indexOf('!') === 0) {
            this.sortOrder = -1;
            this.sortField = value.substring(1, value.length);
        }
        else {
            this.sortOrder = 1;
            this.sortField = value;
        }
    }

}
