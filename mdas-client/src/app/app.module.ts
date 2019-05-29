import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import { GoogleChartsModule } from 'angular-google-charts';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { DialogModule } from 'primeng/dialog';
import { DropdownModule } from 'primeng/dropdown';
import { PanelModule } from 'primeng/panel';
import { TableModule } from 'primeng/table';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { CompanyComponent } from './company/company.component';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CompetitorService } from './company-competitors/competitor.service';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { WeightService } from './company-industries/weight.service';
import { CompanyListService } from './home/company-list.service';
import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyPerformanceComponent } from './company-performance/company-performance.component';
import { CompanyPerformanceService } from './company-performance/performance.service';
import { HomeComponent } from './home/home.component';
import { TreemapService } from './home/treemap.service';

@NgModule({
  declarations: [
    AppComponent,
    CompanyComponent,
    CompanyCompetitorsComponent,
    CompanyIndustriesComponent,
    CompanyOverviewComponent,
    CompanyPerformanceComponent,
    HomeComponent,
  ],
  imports: [
    AppRoutingModule,
    BrowserAnimationsModule,
    BrowserModule,
    CardModule,
    ChartModule,
    DataViewModule,
    DialogModule,
    DropdownModule,
    FormsModule,
    GoogleChartsModule,
    HttpClientModule,
    PanelModule,
    TableModule,
  ],
  providers: [
    CompanyListService,
    CompanyOverviewService,
    CompanyPerformanceService,
    CompetitorService,
    TreemapService,
    WeightService,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
