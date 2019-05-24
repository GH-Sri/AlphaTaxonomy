import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit {

  constructor() { }

  title = 'SECTOR / INDUSTRY';
  type = 'TreeMap';
  data = [
    ["Sectors", null, 0, 0],
    ["Unreported Data", "Sectors", 0, 0],
    ["Medicare", "Sectors", 0, 0],
    ["Social Security", "Sectors", 0, 0],
    ["Health", "Sectors", 0, 0],
    ["Net Interest", "Sectors", 0, 0],
    ["General Government", "Sectors", 0, 0],
    ["Income Security", "Sectors", 0, 0],
    ["Veterans", "Sectors", 0, 0],
    ["Education", "Sectors", 0, 0],
    ["Trust", "Sectors", 0, 0],
    ["Advanced", "Sectors", 0, 0],
    ["One", "Sectors", 0, 0],
    ["Two", "Sectors", 0, 0],
    ["Three", "Sectors", 0, 0],
    ["Four", "Sectors", 0, 0],
    ["Five", "Sectors", 0, 0],
    ["Six", "Sectors", 0, 0],
    ["Seven", "Sectors", 0, 0],
    ["Eight", "Sectors", 0, 0],
    ["Industry_1", "Unreported Data", 50, 50],
    ["Industry_2", "Unreported Data", 20, 20],
    ["Industry_3", "Unreported Data", 10, 10],
    ["Industry_4", "Medicare", 16.3, 16.3],
    ["Industry_5", "Medicare", 16.3, 1.3],
    ["Industry_6", "Medicare", 16.3, 7.3],
    ["Industry_7", "Social Security", 16, 16],
    ["Industry_8", "Social Security", 16, 16],
    ["Industry_9", "Social Security", 16, 16],
    ["Industry_10", "Health", 10.7, 10.7],
    ["Industry_11", "Health", 10.7, 10.7],
    ["Industry_12", "Health", 10.7, 10.7],
    ["Industry_43", "Net Interest", 7.8, 7.8],
    ["Industry_44", "Net Interest", 7.8, 7.8],
    ["Industry_45", "Net Interest", 7.8, 7.8],
    ["Industry_13", "General Government", 6.6, 6.6],
    ["Industry_14", "General Government", 6.6, 6.6],
    ["Industry_15", "General Government", 6.6, 6.6],
    ["Industry_16", "Income Security", 8.7, 8.7],
    ["Industry_17", "Income Security", 8.7, 8.7],
    ["Industry_18", "Income Security", 8.7, 8.7],
    ["Industry_19", "Veterans", 3.2, 3.2],
    ["Industry_20", "Veterans", 3.2, 3.2],
    ["Industry_21", "Veterans", 3.2, 3.2],
    ["Industry_22", "Education", 1.5, 1.5],
    ["Industry_23", "Education", 1.5, 1.5],
    ["Industry_24", "Education", 1.5, 1.5],
    ["Industry_25", "Trust", 1.3, 1.3],
    ["Industry_26", "Trust", 1.3, 1.3],
    ["Industry_27", "Trust", 1.3, 1.3],
    ["Industry_28", "Advanced", 1, 1],
    ["Industry_29", "Advanced", 1, 1],
    ["Industry_30", "Advanced", 1, 1],
    ["Industry_31", "One", 0.8, 0.8],
    ["Industry_32", "One", 0.8, 0.8],
    ["Industry_33", "Two", 0.8, 0.8],
    ["Industry_34", "Two", 0.8, 0.8],
    ["Industry_35", "Three", 0.6, 0.6],
    ["Industry_36", "Three", 0.6, 0.6],
    ["Industry_37", "Four", 0.6, 0.6],
    ["Industry_38", "Four", 0.6, 0.6],
    ["Industry_39", "Five", 0.3, 0.3],
    ["Industry_40", "Six", 0.3, 0.3],
    ["Industry_41", "Seven", 0.2, 0.2],
    ["Industry_42", "Eight", 0.2, 0.2],

  ];
  columnNames = ["Sector", "Industry", "Market trade volume (size)", "Market increase/decrease (color)"];
  options = {
    headerHeight: 30,
    highlightOnMouseOver: true,
    maxDepth: 2,
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
    useWeightedAverageForAggregation: true
  };
  width = 950;
  height = 600;

  ngOnInit() { }

}
