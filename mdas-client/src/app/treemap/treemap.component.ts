import { Component, OnInit, ViewChild} from '@angular/core';
import { TreemapService } from './treemap.service';
import { SectorIndustryWeight } from './sector-industry-weight';
import { GoogleChartComponent } from 'angular-google-charts';
import { Router } from '@angular/router';

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit {

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
   
   @ViewChild('chart')
   chart: GoogleChartComponent
   
   sectorIndustryWeights: SectorIndustryWeight[];
   
   sectorKeys: any[] = [];
   industryKeys: any[] = [];

   constructor(private treemapService: TreemapService,
               private router: Router) {
   }
   
  ngOnInit() {
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
  }

  //event[0].row = the node number. Get the company name from here
  onSelect(event){
      let rowIndex = event[0].row;
      let nameIndex = 0;
      let parentIndex = 1;
      console.log(this.data[rowIndex][nameIndex] + " = " + this.data[rowIndex][parentIndex]);
      if(this.industryKeys.includes(this.data[rowIndex][parentIndex])){
          let companyName = this.data[rowIndex][nameIndex];
          this.router.navigate(['company', companyName]);
      }
  }
}
