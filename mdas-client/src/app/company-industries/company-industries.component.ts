import { Component, OnInit, Input } from '@angular/core';
import { WeightService } from './weight.service';
import { Weight } from './weight';

@Component({
  selector: 'company-industries',
  templateUrl: './company-industries.component.html',
  styleUrls: ['./company-industries.component.css']
})
export class CompanyIndustriesComponent implements OnInit {

  @Input() companyName: string;

  industryWeights: Weight[];
  sectorWeights: Weight[];
  
  industryChartData: any;
  sectorChartData: any;

  constructor(private weightService: WeightService) { }

  ngOnInit() {
      this.weightService.getIndustryData(this.companyName).then(industryWeights => {
          this.industryWeights = industryWeights;
          let industryChartLabels = [];
          let industryChartWeights = [];
          for(let industryWeight of this.industryWeights) {
              industryChartLabels.push(industryWeight.industry);
              industryChartWeights.push(industryWeight.weight);
          }                
      
          this.industryChartData = {
              labels: industryChartLabels,
              datasets: [
                  {
                      data: industryChartWeights,
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
      });

      
      this.weightService.getSectorData(this.companyName).then(sectorWeights => {
          this.sectorWeights = sectorWeights
          let sectorChartLabels = [];
          let sectorChartWeights = [];
          for(let sectorWeight of this.sectorWeights) {
              sectorChartLabels.push(sectorWeight.sector);
              sectorChartWeights.push(sectorWeight.weight);
          }                
      
          this.sectorChartData = {
              labels: sectorChartLabels,
              datasets: [
                  {
                      data: sectorChartWeights,
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
      });
      
      
  }

}
