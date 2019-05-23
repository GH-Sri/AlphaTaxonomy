import { Component, OnInit } from '@angular/core';
import { TreemapService } from './treemap.service';
import { SectorIndustryWeight } from './sector-industry-weight';

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit {

    title='Classification Map';
    type='TreeMap';
//   data = [
//      ["Sectors",null,0],
//      ["Sector 1","Sectors",0],
//      ["Sector 2","Sectors",0],
//      ["Sector 3","Sectors",0],
//
//      ["Industry 1","Sector 1",52],
//      ["Industry 2","Sector 1",24],
//      ["Industry 3","Sector 1",16],
//
//      ["Industry 4","Sector 2",42],
//      ["Industry 5","Sector 2",31],
//      ["Industry 6","Sector 2",22],
//
//      ["Industry 7","Sector 3",36],
//      ["Industry 8","Sector 3",20],
//      ["Industry 9","Sector 3",40],
//          
//   ];
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
   
   sectorIndustryWeights: SectorIndustryWeight[];

   constructor(private treemapService: TreemapService) {}
   
  ngOnInit() {
      this.treemapService.getData().then(sectorIndustryWeights => {
          this.sectorIndustryWeights = sectorIndustryWeights;
          let sectorKeys = [];
          let industryKeys = [];
          let companyArray = [];
          for(let sectorIndustryWeight of this.sectorIndustryWeights){
              if(!sectorKeys.includes(sectorIndustryWeight.sector)){
                  sectorKeys.push(sectorIndustryWeight.sector);
                  this.data.push([sectorIndustryWeight.sector, "Sectors", sectorIndustryWeight.sectorweight, 0]);
              }
              if(!industryKeys.includes(sectorIndustryWeight.industry)){
                  industryKeys.push(sectorIndustryWeight.industry);
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

  onSelect(){
      
  }
}
