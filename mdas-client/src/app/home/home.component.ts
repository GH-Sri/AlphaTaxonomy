import { Component, OnInit, HostListener, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { CompanyOverview } from '../company-overview/company-overview';
import { SectorIndustryWeight } from './sector-industry-weight';
import { TreemapService } from './treemap.service';


@Component({
    selector: 'app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

    //treemap fields
    title = 'SECTOR / INDUSTRY';
    type = 'TreeMap';
    windowOffset = 1;
    // width = window.innerWidth * this.windowOffset;
    // height = 600;
    sectorKeys: string[];

    //columnNames = ["Industry", "Sector", "Market trade volume (size)", "Market increase/decrease (color)"];
    options = {
        headerHeight: 30,
        highlightOnMouseOver: true,
        maxDepth: 1,
        maxPostDepth: 1,
        maxColor: '#676767',
        midColor: '#296b7d',
        minColor: '#46b6d5',
        // colors: ['#676767', '#296b7d', '#33869d', '#41abc8'],
        // maxHighlightColor: '#edf8fb',
        // midHighlightColor: '#9ebcda',
        // minHighlightColor: '#8c6bb1',
        showScale: false,
        showTooltips: true,
        textStyle: {
            color: '#000',
            fontName: 'Verdana',
            fontSize: '20px',
            bold: true,
            italic: false
        },
        titleTextStyle: {
            color: '#32f5de',
            fontName: 'Times New Roman',
            fontSize: '50px',
            bold: true,
            italic: false
        },
        useWeightedAverageForAggregation: true,
        width: window.innerWidth * this.windowOffset, // Google Chart Variable
        height: 600,
    };

    sectorIndustryWeights: SectorIndustryWeight[];

    selections: any[] = [];

    constructor(private treemapService: TreemapService,
                private router: Router) {
    }

    ngOnInit() {

        //initialize treemap
        this.treemapService.getData().then(sectorIndustryWeight => {
            this.data = [
                ["Sectors", "Industry", 0, 0]
            ];
           this.sectorIndustryWeights = sectorIndustryWeights;
             this.sectorKeys = [];
            // this.industryKeys = [];
            // let companyArray = [];
            // for (let sectorIndustryWeight of this.sectorIndustryWeights) {
            //     if (!this.sectorKeys.includes(sectorIndustryWeight.sector)) {
            //         this.sectorKeys.push(sectorIndustryWeight.sector);
            //         this.data.push([sectorIndustryWeight.sector, "Sectors", sectorIndustryWeight.sectorweight, 0]);
            //     }
            //     if (!this.industryKeys.includes(sectorIndustryWeight.industry)) {
            //         this.industryKeys.push(sectorIndustryWeight.industry);
            //         this.data.push([sectorIndustryWeight.industry, sectorIndustryWeight.sector, sectorIndustryWeight.industryweight, 0]);
            //     }
            //     let marketcap = sectorIndustryWeight.marketcap;
            //     marketcap = marketcap.replace(/[$,]+/g, "");
            //     marketcap = parseInt(marketcap);
            //     this.data.push([sectorIndustryWeight.company, sectorIndustryWeight.industry, marketcap, 0]);
            // }

            console.log("API Call");
            console.log(this.sectorIndustryWeights);
            var dataNew = [];
            var uniqueArray = []

            for (let count in this.sectorIndustryWeights) {
                var marketcap = Number(this.sectorIndustryWeights[count].marketcap.replace(/[^0-9.-]+/g, ""));
                let sector = this.sectorIndustryWeights[count].sector;
                let industry = this.sectorIndustryWeights[count].industry;
                dataNew[count] = [
                   industry,
                    sector,
                    marketcap,
                    this.sectorIndustryWeights[count].companycount
                ];
               if(!this.sectorKeys.includes(sector)){
                    this.sectorKeys.push(sector);
                }
            }
            for(let index in this.sectorKeys){
                dataNew.unshift([this.sectorKeys[index], "Sectors", 0, 0]);
            }
            dataNew.unshift(["Sectors", null, 0, 0]);

            this.data = dataNew;
            console.log("Formatted Data");
            console.log(this.data);
        });

      


    }

//    // Responsive Treemap - Not yet functional
//    @HostListener('window:resize', ['$event'])
//    onResize(event, options) {
//        if (event) {
//            options.width = window.innerWidth * this.windowOffset;
//        }
//    }



    //Treemap methods

    //event[0].row = the node number. Get the company name from here
    onSelect(event) {
        let rowIndex = event[0].row;
        console.log('selectedRow');
        console.log(rowIndex);

        //need to add an element to selections if we left-clicked, remove one if right-clicked
        //We right-clicked if this.selections already includes the event row
        if (this.selections.includes(this.data[rowIndex][0]) || this.data[rowIndex][0] == 'Sectors') {
            let x = this.selections.pop();
            console.log('pop ' + x)
        }
        else {
            this.selections.push(this.data[rowIndex][0]);
            console.log('push ' + rowIndex);
        }
        console.log('selections');
        console.log(this.selections);
        // filter and display table
        let sectorFilter = this.selections[0] == null? '' : this.selections[0];
        let industryFilter = this.selections[1] == null? '' : this.selections[1];

        console.log('sectorFilter = ' + sectorFilter);
        console.log('industryFilter = ' + industryFilter);

       this.router.navigate(['', { outlets: { companylist: ['companies'] } }], { queryParams: { sector: sectorFilter,
                                                                                                 industry: industryFilter} });

           

    }


}
