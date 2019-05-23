import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit {

  constructor() { }

   title = 'Classification Map';
   type='TreeMap';
   data = [
      ["Sectors",null,0],
      ["Sector 1","Sectors",0],
      ["Sector 2","Sectors",0],
      ["Sector 3","Sectors",0],

      ["Industry 1","Sector 1",52],
      ["Industry 2","Sector 1",24],
      ["Industry 3","Sector 1",16],

      ["Industry 4","Sector 2",42],
      ["Industry 5","Sector 2",31],
      ["Industry 6","Sector 2",22],

      ["Industry 7","Sector 3",36],
      ["Industry 8","Sector 3",20],
      ["Industry 9","Sector 3",40],
          
   ];
   columnNames = ["Sector", "Industry","Market Cap"];
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
   width = 950;
   height = 600;

  ngOnInit() {}

  onSelect(){
      
  }
}
