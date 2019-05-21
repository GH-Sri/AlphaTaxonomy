import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CompanyCreateComponent } from './company-create/company-create.component';
import { CompanyDetailsComponent } from './company-details/company-details.component';
import { CompanyUpdateComponent } from './company-update/company-update.component';
import { CompanyListComponent } from './company-list/company-list.component';

const routes: Routes = [
	{ path: '', pathMatch: 'full', redirectTo: 'create-company' },
	{ path: 'create-company', component: CompanyCreateComponent },
	{ path: 'company-details/:id', component: CompanyDetailsComponent },
	{ path: 'update-company', component: CompanyUpdateComponent },
	{ path: 'company-list', component: CompanyListComponent }  
];

@NgModule({
	imports: [RouterModule.forRoot(routes)],
	exports: [RouterModule]
})

export class AppRoutingModule { }