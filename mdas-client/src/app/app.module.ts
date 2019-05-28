import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { GoogleChartsModule } from 'angular-google-charts';

import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { WeightService } from './company-industries/weight.service';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CompetitorService } from './company-competitors/competitor.service';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { DropdownModule } from 'primeng/dropdown';
import { PanelModule } from 'primeng/panel';
import { HomeComponent } from './home/home.component';
import { CompanyComponent } from './company/company.component';
import { CompanyPerformanceComponent } from './company-performance/company-performance.component';
import { CompanyPerformanceService } from './company-performance/performance.service';


import { DialogModule } from 'primeng/dialog';
import { TableModule } from 'primeng/table';
import { CompanyListService } from './company-datatable/company-list.service';
import { TreemapService } from './home/treemap.service';
import { CompanyDatatableComponent } from './company-datatable/company-datatable.component';

@NgModule({
  declarations: [
    AppComponent,
    CompanyOverviewComponent,
    CompanyIndustriesComponent,
    CompanyCompetitorsComponent,
    HomeComponent,
    CompanyComponent,
    CompanyPerformanceComponent,
    CompanyDatatableComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    CardModule,
    ChartModule,
    DataViewModule,
    DropdownModule,
    PanelModule,
    GoogleChartsModule,
    DialogModule,
    TableModule
  ],
  providers: [CompetitorService, CompanyOverviewService, WeightService, CompanyListService, TreemapService, CompanyPerformanceService],
  bootstrap: [AppComponent]
})
export class AppModule { }
