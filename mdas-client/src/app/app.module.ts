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
import { TreemapComponent } from './treemap/treemap.component';
import { CompanyDatatableComponent } from './company-datatable/company-datatable.component';
import { DialogModule } from 'primeng/dialog';

import { MatInputModule, MatPaginatorModule, MatProgressSpinnerModule, 
  MatSortModule, MatTableModule } from "@angular/material";

@NgModule({
  declarations: [
    AppComponent,
    CompanyOverviewComponent,
    CompanyIndustriesComponent,
    CompanyCompetitorsComponent,
    HomeComponent,
    CompanyComponent,
    CompanyPerformanceComponent,
    TreemapComponent,
    CompanyDatatableComponent,
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
    MatInputModule,
    MatTableModule,
    MatPaginatorModule,
    MatSortModule,
    MatProgressSpinnerModule
  ],
  providers: [CompetitorService, CompanyOverviewService, WeightService],
  bootstrap: [AppComponent]
})
export class AppModule { }
