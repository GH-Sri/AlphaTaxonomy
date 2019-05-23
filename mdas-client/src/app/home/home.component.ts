import { Component, OnInit, ViewChild } from '@angular/core';
import { CompanyListService } from './company-list.service';
import { CompanyOverview } from '../company-overview/company-overview';
import { Router } from '@angular/router';
import { TreemapService } from './treemap.service';
import { SectorIndustryWeight } from './sector-industry-weight';

@Component({
    selector: 'app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

    //glue fields
    displayCompanyList: boolean = false;
    displayTreeMap: boolean = false;

    //datatable fields
    companies: CompanyOverview[];
    cols: any[];

    selectedCompany: CompanyOverview;

    //treemap fields
    title='Classification Map';
    type='TreeMap';
    data = [
        ["Sectors", null, 0, 0]
    ];
    columnNames = ["Node", "Parent", "Weight (size)", "Price Change (color)"];
    options = {
            highlightOnMouseOver: true,
            maxDepth: 1,
            maxPostDepth: 2,
            minHighlightColor: '#8c6bb1',
            midHighlightColor: '#9ebcda',
            maxHighlightColor: '#edf8fb',
            minColor: '#009688',
            midColor: '#f7f7f7',
            maxColor: '#ee8100',
            headerHeight: 15,
            showScale: false,
            height: 500,
            useWeightedAverageForAggregation: true
    };

    @ViewChild('companyTable')
    table: any;

    sectorIndustryWeights: SectorIndustryWeight[];

    sectorKeys: any[] = [];
    industryKeys: any[] = [];

    selections: any[] = [0];
    lastSelection: any;

    constructor(private companyService: CompanyListService,
                private treemapService: TreemapService,
                private router: Router) { 
    }   

    ngOnInit() {
        //initialize treemap
        this.treemapService.getData().then(sectorIndustryWeights => {
            this.data = [
                ["Sectors", null, 0, 0]
            ];
            this.sectorIndustryWeights = sectorIndustryWeights;
            this.sectorKeys = [];
            this.industryKeys = [];
            let companyArray = [];
            for(let sectorIndustryWeight of this.sectorIndustryWeights){
                if(!this.sectorKeys.includes(sectorIndustryWeight.sector)){
                    this.sectorKeys.push(sectorIndustryWeight.sector);
                    this.data.push([sectorIndustryWeight.sector, "Sectors", sectorIndustryWeight.sectorweight, 0]);
                }
                if(!this.industryKeys.includes(sectorIndustryWeight.industry)){
                    this.industryKeys.push(sectorIndustryWeight.industry);
                    this.data.push([sectorIndustryWeight.industry, sectorIndustryWeight.sector, sectorIndustryWeight.industryweight, 0]);
                }
                let marketcap = sectorIndustryWeight.marketcap;
                marketcap = marketcap.replace(/[$,]+/g, "");
                marketcap = parseInt(marketcap);
                this.data.push([sectorIndustryWeight.company, sectorIndustryWeight.industry, marketcap, 0]);
            }
            console.log(this.data);
        });
        
        //initialize table
        this.companies = [];
        this.companyService.getCompanyList().then(companies =>{
            console.log(companies);
            this.companies = companies;
            this.cols = [
                { field: 'name', header: 'Name' },
                { field: 'sector', header: 'Sector' },
                { field: 'industry', header: 'Industry' },
                { field: 'marketcap', header: 'Market Cap' }
                ];
            console.log(this.companies);
        });
        
       

    }
    
    onRowSelect(event) {
        this.router.navigate(['company', this.selectedCompany.name]);
    }
    
    //Treemap methods

  //event[0].row = the node number. Get the company name from here
  onSelect(event){
      let rowIndex = event[0].row;
      if(this.lastSelection == rowIndex){
          // go to table
          let filterField = '';
          if(this.selections.length == 1){
              filterField = 'sector';
          }
          else if(this.selections.length == 2){
              filterField = 'industry';
          }
          if(filterField != ''){
              let value = this.data[rowIndex][0]
              console.log(this.table);
              this.displayCompanyList = true;
          }
      }
      else{
          //need to add an element to selections if we left-clicked, remove one if right-clicked
          if(this.selections.includes(rowIndex)){
              let x = this.selections.pop();
              console.log('pop ' + x)
          }
          else{
              this.selections.push(rowIndex);
              this.lastSelection = rowIndex;
              console.log('push ' + rowIndex);
          }
          let nameIndex = 0;
          let parentIndex = 1;
          console.log(this.data[rowIndex][nameIndex] + " = " + this.data[rowIndex][parentIndex]);
          if(this.industryKeys.includes(this.data[rowIndex][parentIndex])){
              let companyName = this.data[rowIndex][nameIndex];
              this.router.navigate(['company', companyName]);
          }
      }
  }
    
    
    showDialog() {
        this.displayCompanyList = true;
    }

    showTreeMap(){
        this.displayTreeMap = true;
    }


   

}
