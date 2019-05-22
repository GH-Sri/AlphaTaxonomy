import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-company-datatable',
  templateUrl: './company-datatable.component.html',
  styleUrls: ['./company-datatable.component.css']
})
export class CompanyDatatableComponent implements OnInit {

  display: boolean = false;

  constructor() { }

  showDialog() {
     this.display = true;
  }

  ngOnInit() { }

}
