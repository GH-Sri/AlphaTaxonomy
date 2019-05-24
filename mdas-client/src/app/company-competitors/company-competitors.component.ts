import { Component, OnInit, Input } from '@angular/core';
import { CompanyCompetitor } from './company-competitor';
import { CompetitorService } from './competitor.service';
import { SelectItem } from 'primeng/api';

@Component({
    selector: 'company-competitors',
    templateUrl: './company-competitors.component.html',
    styleUrls: ['./company-competitors.component.css']
})
export class CompanyCompetitorsComponent implements OnInit {

    @Input() companyName: string;

    competitors: CompanyCompetitor[];

    sortOptions: SelectItem[];

    sortKey: string;
    sortField: string;
    sortOrder: number; //ascending (1) or descending (-1)

    constructor(private competitorService: CompetitorService) { 
        this.competitors = [];
    }

    ngOnInit() {
        this.competitorService.getData(this.companyName).then(competitors => {
            console.log(competitors);
            this.competitors = competitors;
        });
        
        this.sortOptions= [
            {label: 'Competitor Rank', value: '!closeness'},
            {label: 'Market Cap', value: 'marketcap'}
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
