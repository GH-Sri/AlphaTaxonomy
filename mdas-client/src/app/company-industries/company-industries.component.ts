import { Component, OnInit } from '@angular/core';
import { IndustryWeightService } from './industry-weight.service';
import { IndustryWeight } from './industry-weight';

@Component({
  selector: 'app-company-industries',
  templateUrl: './company-industries.component.html',
  styleUrls: ['./company-industries.component.css']
})
export class CompanyIndustriesComponent implements OnInit {

    @Input() companyName: string;

  industryWeights: IndustryWeight[];
  
  chartData: any;

  constructor(private weightService: IndustryWeightService) { }

  ngOnInit() {
      this.industryWeights = weightService.getData(this.companyName);
      
      let chartLabels = [];
      let chartWeights = [];
      for(let industryWeight of this.industryWeights) {
          chartLabels.push(weight.industryName);
          chartWeights.push(weight.weight);
      }                
      
      this.chartData = {
              labels: chartLabels,
              datasets: [
                  {
                      data: chartWeights,
                      backgroundColor: [
                          "#FF6384",
                          "#36A2EB",
                          "#FFCE56"
                      ],
                      hoverBackgroundColor: [
                          "#FF6384",
                          "#36A2EB",
                          "#FFCE56"
                      ]
                  }]    
              };
  }

}
