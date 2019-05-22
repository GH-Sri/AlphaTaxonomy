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
      ["Sectors",null,0,0],
      ["Sector 1","Sectors",0,0],
      ["Sector 2","Sectors",0,0],
      ["Sector 3","Sectors",0,0],

      ["Industry 1","Sector 1",52,31],
      ["Industry 2","Sector 1",24,12],
      ["Industry 3","Sector 1",16,-23],

      ["Industry 4","Sector 2",42,-11],
      ["Industry 5","Sector 2",31,-2],
      ["Industry 6","Sector 2",22,-13],

      ["Industry 7","Sector 3",36,4],
      ["Industry 8","Sector 3",20,-12],
      ["Industry 9","Sector 3",40,63],
          
   ];
   columnNames = ["Sector", "Industry","Market trade volume (size)","Market increase/decrease (color)"];
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
      showScale: true,
      height: 500,
      useWeightedAverageForAggregation: true
   };
   width = 950;
   height = 600;

  ngOnInit() {}

}
