// Angular 
import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
// Google Charts
import { GoogleChartsModule } from 'angular-google-charts';
// PrimeNG Components
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { DialogModule } from 'primeng/dialog';
import { DropdownModule } from 'primeng/dropdown';
import { PanelModule } from 'primeng/panel';
import { TableModule } from 'primeng/table';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
// Angular Components
import { AppComponent } from './app.component';
import { CompanyComponent } from './company/company.component';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CompanyDatatableComponent } from './company-datatable/company-datatable.component';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyPerformanceComponent } from './company-performance/company-performance.component';
import { HomeComponent } from './home/home.component';
// Angular Modules
import { AppRoutingModule } from './app-routing.module';
// Angular Services
import { CompanyListService } from './company-datatable/company-list.service';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyPerformanceService } from './company-performance/performance.service';
import { CompetitorService } from './company-competitors/competitor.service';
import { TreemapService } from './home/treemap.service';
import { WeightService } from './company-industries/weight.service';

@NgModule({
  declarations: [
    AppComponent,
    CompanyComponent,
    CompanyCompetitorsComponent,
    CompanyDatatableComponent,
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
    ProgressSpinnerModule,
  ],
  providers: [
    CompanyListService,
    CompanyOverviewService,
    CompanyPerformanceService,
    CompetitorService,
    TreemapService,
    WeightService,
  ],
  bootstrap: [
    AppComponent,
  ]
})
export class AppModule { }
