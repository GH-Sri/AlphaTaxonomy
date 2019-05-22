import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { IndustryWeightService } from './company-industries/industry-weight.service';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CompanyCompetitorService } from './company-competitors/company-competitor.service';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { PanelModule } from 'primeng/panel';
import { HomeComponent } from './home/home.component';
import { CompanyComponent } from './company/company.component';


@NgModule({
  declarations: [
    AppComponent,
    CompanyOverviewComponent,
    CompanyIndustriesComponent,
    CompanyCompetitorsComponent,
    HomeComponent,
    CompanyComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    CardModule,
    ChartModule,
    DataViewModule,
    PanelModule
  ],
  providers: [CompanyCompetitorService, CompanyOverviewService, IndustryWeightService],
  bootstrap: [AppComponent]
})
export class AppModule { }
