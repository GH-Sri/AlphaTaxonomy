import { Component, OnInit, Input } from '@angular/core';
import { PerformanceData } from './performance';
import { CompanyPerformanceService } from './performance.service';

@Component({
  selector: 'performance',
  templateUrl: './company-performance.component.html',
  styleUrls: ['./company-performance.component.css']
})
export class CompanyPerformanceComponent implements OnInit {

    @Input()
    companyName: string;
    
    performanceData: PerformanceData[] = [];
    
  constructor(private performanceService: CompanyPerformanceService) { }

  ngOnInit() {
      this.performanceService.getData(this.companyName).then(performanceData => {
          console.log(performanceData);
          this.performanceData = performanceData;
      });
  }

}
