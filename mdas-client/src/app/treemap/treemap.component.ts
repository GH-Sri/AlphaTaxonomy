import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit {

  constructor() { }

   title = 'Alpha Taxonomy Navigation Map';
   type='TreeMap';
   data = [
      ["Global",null,0,0],
      ["America","Global",0,0],
      ["Europe","Global",0,0],
      ["Asia","Global",0,0],
      ["Australia","Global",0,0],
      ["Africa","Global",0,0],

      ["USA","America",52,31],
      ["Mexico","America",24,12],
      ["Canada","America",16,-23],

      ["France","Europe",42,-11],
      ["Germany","Europe",31,-2],
      ["Sweden","Europe",22,-13],

      ["China","Asia",36,4],
      ["Japan","Asia",20,-12],
      ["India","Asia",40,63],

      ["Egypt","Africa",21,0],
      ["Congo","Africa",10,12],
      ["Zaire","Africa",8,10],
          
   ];
   columnNames = ["Location", "Parent","Market trade volume (size)","Market increase/decrease (color)"];
   options = { 
      minColor:"#ff7777",
      midColor:'#ffff77',
      maxColor:'#77ff77',
      headerHeight:15,
      showScale:true
   };
   width = 550;
   height = 400;

  ngOnInit() {
  }

}
