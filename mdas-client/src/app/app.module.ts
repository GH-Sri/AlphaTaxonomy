import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CompanyCreateComponent } from './company-create/company-create.component';
import { CompanyDetailsComponent } from './company-details/company-details.component';
import { CompanyUpdateComponent } from './company-update/company-update.component';
import { CompanyListComponent } from './company-list/company-list.component';
import { HttpClientModule } from '@angular/common/http';
import { CompanyOverviewComponent } from './company-overview/company-overview.component';
import { CompanyOverviewService } from './company-overview/company-overview.service';
import { CompanyIndustriesComponent } from './company-industries/company-industries.component';
import { IndustryWeightService } from './company-industries/industry-weight.service';
import { CompanyCompetitorsComponent } from './company-competitors/company-competitors.component';
import { CardModule } from 'primeng/card';
import { ChartModule } from 'primeng/chart';
import { DataViewModule } from 'primeng/dataview';
import { PanelModule } from 'primeng/panel';


@NgModule({
  declarations: [
    AppComponent,
    CompanyCreateComponent,
    CompanyDetailsComponent,
    CompanyUpdateComponent,
    CompanyListComponent,
    CompanyOverviewComponent,
    CompanyIndustriesComponent,
    CompanyCompetitorsComponent,
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
  providers: [CompanyOverviewService, IndustryWeightService],
  bootstrap: [AppComponent]
})
export class AppModule { }
