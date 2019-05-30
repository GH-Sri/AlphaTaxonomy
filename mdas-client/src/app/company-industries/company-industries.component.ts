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
  
  options: any;

  constructor(private weightService: WeightService) { }
  
  public reinit(companyName: string){
      this.companyName = companyName;
      this.ngOnInit();
  }

  ngOnInit() {
      this.weightService.getIndustryData(this.companyName).then(industryWeights => {
          this.industryWeights = industryWeights;
          let industryChartLabels = [];
          let industryChartWeights = [];
          for(let industryWeight of this.industryWeights) {
              industryChartLabels.push(industryWeight.industry);
              industryChartWeights.push(industryWeight.similarity);
          }                
      
          this.industryChartData = {
              labels: industryChartLabels,
              legend:{
                  display: false
              },
              datasets: [
                  {
                      label: 'Industry Similarity Weights',
                      data: industryChartWeights,
                      backgroundColor: "#36A2EB",
                      hoverBackgroundColor: "#36A2EB"
                  }],
              };
      });

      
      this.weightService.getSectorData(this.companyName).then(sectorWeights => {
          this.sectorWeights = sectorWeights
          let sectorChartLabels = [];
          let sectorChartWeights = [];
          for(let sectorWeight of this.sectorWeights) {
              sectorChartLabels.push(sectorWeight.sector);
              sectorChartWeights.push(sectorWeight.similarity);
          }                
      
          this.sectorChartData = {
              labels: sectorChartLabels,
              legend:{
                  display: false
              },
              datasets: [
                  {
                      label: 'Sector Similarity Weights',
                      data: sectorChartWeights,
                      backgroundColor: "#36A2EB",
                      hoverBackgroundColor: "#36A2EB"
                  }]
          };
      });
      
      this.options = {
          scales: {
              yAxes: [{
                  ticks: {
                      display: false
                  }
              }]
          }
      };
  }  
}
