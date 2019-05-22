import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { IndustryWeightService } from './company-industries/industry-weight.service';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CompetitorService } from './company-competitors/competitor.service';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { DropdownModule } from 'primeng/dropdown';
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
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    CardModule,
    ChartModule,
    DataViewModule,
    DropdownModule,
    PanelModule
  ],
  providers: [CompetitorService, CompanyOverviewService, IndustryWeightService],
  bootstrap: [AppComponent]
})
export class AppModule { }
